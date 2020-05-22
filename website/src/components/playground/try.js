import AnsiUp from 'ansi_up';
import { debounce } from 'lodash';
import React, { useEffect } from 'react';
import * as lzString from 'lz-string';
import {CodeMirror} from '../../CodeMirror';
import refmt from 'reason';

import 'codemirror/mode/javascript/javascript';
import 'codemirror/mode/mllike/mllike';
import 'codemirror/mode/rust/rust';

const compress = lzString.compressToEncodedURIComponent;
const decompress = lzString.decompressFromEncodedURIComponent;

let ansiUp = new AnsiUp();

function getUrlParameter(name) {
  name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
  var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
  var results = regex.exec(location.search);
  return results === null
    ? ''
    : decodeURIComponent(results[1].replace(/\+/g, ' '));
}

const retrieve = () => {
  function fromLocalStorage() {
    try {
      const json = localStorage.getItem('try-tablecloth');
      let result = json && JSON.parse(json);
      result.code = result.code || '';
      return result;
    } catch (e) {
      console.error('retrieve', e);
      return '';
    }
  }

  const fallbackDefault = {
    language: 'reason',
    code: '',
  };

  const isReason = !!getUrlParameter('reason');
  const isOCaml = !!getUrlParameter('ocaml');

  if (isReason) {
    const compressedCode = getUrlParameter('reason');
    return {
      language: 'reason',
      code: decompress(compressedCode),
    };
  } else if (isOCaml) {
    const compressedCode = getUrlParameter('ocaml');
    return {
      language: 'ocaml',
      code: decompress(compressedCode),
    };
  } else {
    return fromLocalStorage() || fallbackDefault;
  }
};

const persist = debounce((language, code) => {
  try {
    localStorage.setItem(
      'try-tablecloth',
      JSON.stringify({ language, code }),
    );
  } catch (e) {
    console.error('persistence error', e);
  }

  // avoid a refresh of the page; we also don't want every few keystrokes to
  // create a new history for the back button, so replace the current one
  window.history.replaceState(null, '', generateShareableUrl(language, code));
}, 100);

const generateShareableUrl = (language, code) => {
  let result =
    window.location.origin +
    window.location.pathname +
    '?' +
    language +
    '=' +
    compress(code);

  return result;
};

const errorTimeout = 500;

let ShareButton = props => {
  let confirmationTimeout = React.useRef(null);
  let [showConfirmation, setShowConfirmation] = React.useState(false);
  useEffect(() => {
    return () => {
      if (confirmationTimeout.current != null) {
        clearTimeout(confirmationTimeout.current);
      }
    };
  });

  let onClick = () => {
    props.onClick();
    setShowConfirmation(true);
    confirmationTimeout.current = setTimeout(
      () => setShowConfirmation(false),
      2000,
    );
  };

  return (
    <div className={props.className}>
      <input id="shareableUrl" value={props.url} readOnly />
      <div onClick={onClick}>Share</div>
      <span className="try-tooltip">
        <span className="arrow"></span>
        {showConfirmation ? 'Copied' : 'Click to copy to clipboard'}
      </span>
    </div>
  );
};

const formatErrorLocation = prop => {
  if (prop == null) {
    throw new Error('Formatting null error');
  }
  console.error('BEAR', prop);
  let { startLine, startLineStartChar, endLine, endLineEndChar } = prop;
  if (startLine === endLine) {
    if (startLineStartChar === endLineEndChar) {
      return `Line ${startLine}:${startLineStartChar}`;
    } else {
      return `Line ${startLine}:${startLineStartChar}-${endLineEndChar}`;
    }
  } else {
    return `Line ${startLine}:${startLineStartChar}-Line ${endLine}:${endLineEndChar}`;
  }
};

const stripErrorNumberFromReasonSyntaxError = error => {
  return error.replace(/\d+: /, '');
};

const capitalizeFirstChar = str => {
  if (str.length === 0) return '';
  return str[0].toUpperCase() + str.slice(1);
};

const wrapInExports = code => `(function(exports) {${code}})({})`;

export class Try extends React.Component {
  state = {
    reason: '/* loading */',
    reasonSyntaxError: null,
    ocaml: '(* loading *)',
    js: '// loading',
    jsIsLatest: false,
    output: [],
    shareableUrl: '',
    errorsFromCompilation: null,
  };

  _output = item => {
    this.setState(state => ({
      output: state.output.concat(item),
    }));
  };

  output = item => {
    if (this.outputOverloaded) {
      return;
    }
    if (this.state.output.length > 100) {
      this.outputOverloaded = true;
      this._output({
        type: 'error',
        contents: ['[Too much output!]'],
      });
      return;
    }

    this._output(item);
  };

  initEvalWorker = () => {
    this.evalWorker = new Worker('/js/eval.worker.js');
    this.evalWorker.onmessage = message => {
      console.info('got message', message);
      let { data } = message;
      if (data.type === 'end') {
        clearTimeout(data.contents);
      } else {
        this.output(data);
      }
    };
    this.evalWorker.onerror = err => {
      console.info('got erro', err);
      this.errorTimerId = setTimeout(
        () =>
          this.setState(_ => ({
            jsError: err,
          })),
        errorTimeout,
      );
    };
  };

  evalJs = code => {
    console.info('evalJs', { code });
    this.outputOverloaded = false;
    this.setState(
      state => ({ ...state, output: [] }),
      () => {
        const timerId = setTimeout(() => {
          this.evalWorker.terminate();
          this.initEvalWorker();
          this._output({
            type: 'error',
            contents: ['[Evaluation timed out!]'],
          });
        }, 1000);
        this.evalWorker.postMessage({
          code: wrapInExports(code),
          timerId,
        });
      },
    );
  };

  updateReason = newReasonCode => {
    if (newReasonCode === this.state.reason) {
      return;
    }
    persist('reason', newReasonCode);
    clearTimeout(this.errorTimerId);

    this.setState((prevState, _) => {
      let newOCamlCode = prevState.ocaml;
      try {
        newOCamlCode = refmt.printML(refmt.parseRE(newReasonCode));

        this.tryCompiling(newReasonCode, newOCamlCode);
      } catch (e) {
        console.error('updateReason', e);
        this.errorTimerId = setTimeout(
          () =>
            this.setState(_ => {
              return {
                reasonSyntaxError: e,
                ocamlSyntaxError: null,
                errorsFromCompilation: null,
                jsError: null,
                js: '',
                ocaml: '',
                output: [],
              };
            }),
          errorTimeout,
        );
      }

      return {
        reason: newReasonCode,
        ocaml: newOCamlCode,
        reasonSyntaxError: null,
        ocamlSyntaxError: null,
        jsError: null,
        shareableUrl: generateShareableUrl('reason', newReasonCode),
      };
    });
  };

  updateOCaml = newOCamlCode => {
    if (newOCamlCode === this.state.ocaml) {
      return;
    }
    persist('ocaml', newOCamlCode);

    clearTimeout(this.errorTimerId);

    this.setState((prevState, _) => {
      let newReasonCode = prevState.reason;
      try {
        newReasonCode = refmt.printRE(refmt.parseML(newOCamlCode));
        this.tryCompiling(newReasonCode, newOCamlCode);
      } catch (e) {
        console.error('updateOCaml code', e);
        this.errorTimerId = setTimeout(
          () =>
            this.setState(_ => {
              return {
                ocamlSyntaxError: e,
                reasonSyntaxError: null,
                jsError: null,
                js: '',
                reason: '',
                output: [],
              };
            }),
          errorTimeout,
        );
      }

      return {
        reason: newReasonCode,
        ocaml: newOCamlCode,
        reasonSyntaxError: null,
        ocamlSyntaxError: null,
        jsError: null,
        shareableUrl: generateShareableUrl('ocaml', newOCamlCode),
      };
    });
  };

  reformat = () => {
    clearTimeout(this.errorTimerId);
    this.setState(prevState => {
      let newReasonCode = prevState.reason;
      try {
        newReasonCode = refmt.printRE(refmt.parseRE(newReasonCode));
      } catch (e) {
        this.errorTimerId = setTimeout(
          () =>
            this.setState(_ => {
              return {
                reasonSyntaxError: e,
              };
            }),
          errorTimeout,
        );
      }

      persist('reason', newReasonCode);
      return {
        reason: newReasonCode,
        reasonSyntaxError: null,
        shareableUrl: generateShareableUrl('reason', newReasonCode),
      };
    });
  };

  compile = code => {
    const _consoleError = console.error;
    let errs = '';
    console.error = (...args) => {
      return args.forEach(argument => {
        // this is a warning we get:
        // WARN: File "js_cmj_load.ml", line 53, characters 23-30 ReactDOMRe.cmj not found
        // TODO: not sure why; investigate into it
        // if (argument.indexOf('WARN: File "js_cmj_load.ml"') < 0) {
        errs += argument + '\n';
        // }
      });
    };
    let res = window.ocaml.compile_super_errors_ppx_v2(code);
    console.error = _consoleError;
    // super-errors pads the line with two spaces. Remove them can't just do
    // it in the above args.forEach, since every console.error msg might
    // contain multiple line breaks
    let startPadding = /^  /gm;
    let noFileName = /\(No file name\)/gm;
    errs = errs.replace(startPadding, '').replace(noFileName, 'OCaml preview');
    return [res, errs];
  };

  tryCompiling = debounce(ocaml => {
    try {
      const [res, errs] = this.compile(ocaml);
      console.error({ res, errs });
      if (res.js_code) {
        this.setState(state => ({
          ...state,
          js: res.js_code,
          jsIsLatest: true,
          errorsFromCompilation: errs,
        }));
        this.evalJs(res.js_code);
        return;
      } else {
        this.errorTimerId = setTimeout(
          () =>
            this.setState(_ => ({
              errorsFromCompilation: errs,
              js: '',
            })),
          errorTimeout,
        );
      }
    } catch (err) {
      console.error('compiler error', err);
      this.errorTimerId = setTimeout(
        () =>
          this.setState(state => ({
            ...state,
            errorsFromCompilation: err,
            js: '',
          })),
        errorTimeout,
      );
    }
    this.setState(state => {
      return {
        ...state,
        errorsFromCompilation: null,
        jsIsLatest: false,
        output: [],
      };
    });
  }, 100);

  copyShareableUrl = () => {
    let input = document.getElementById('shareableUrl');
    input.select();
    document.execCommand('copy');
  };

  componentDidMount() {
    this.initEvalWorker();
    const { language, code } = retrieve();
    if (language === 'reason') {
      this.updateReason(code);
    } else {
      this.updateOCaml(code);
    }
  }

  componentWillUnmount() {
    this.evalWorker && this.evalWorker.terminate();
  }

  render() {
    let {
      reason,
      ocaml,
      js,
      reasonSyntaxError,
      errorsFromCompilation,
      ocamlSyntaxError,
      jsError,
    } = this.state;

    return (
      <div className="try-inner">
        <div className="try-buttons">
          <div
            className="try-button try-button-note"
            style={{ marginRight: 'auto' }}
          >
            Note on foo##bar
            <div className="try-tooltip">
              <span className="arrow"></span>
              Currently, typing `foo##bar` in the Reason syntax section gives a
              syntax error; the playground translates Reason syntax to OCaml
              syntax first before feeding it into the compiler. But OCaml
              mis-prints `foo##bar` as the syntactically invalid `## foo bar` (a
              fix will be released soon). For now, whenever this happens, please
              manually edit the OCaml section to use `foo##bar` instead. Sorry!
            </div>
          </div>
          <div
            className="try-button try-button-right-border"
            onClick={this.reformat}
          >
            Format code
          </div>
          <ShareButton
            className="try-button try-button-share"
            url={this.state.shareableUrl}
            onClick={this.copyShareableUrl}
          />
        </div>

        <div className="try-grid">
          <div className="try-grid-editor">
            <div className="try-label">Reason</div>
            <CodeMirror
              className="try-codemirror-wrap"
              value={reason}
              options={{
                mode: 'rust',
                lineNumbers: true,
              }}
              onChange={this.updateReason}
            />
            {reasonSyntaxError && (
              <pre className="try-error-warning" style={{ padding: 15 }}>
                {formatErrorLocation(reasonSyntaxError.location)}{' '}
                {capitalizeFirstChar(
                  stripErrorNumberFromReasonSyntaxError(
                    reasonSyntaxError.message,
                  ),
                )}
              </pre>
            )}
          </div>

          <div className="try-grid-editor">
            <div className="try-label">JavaScript</div>
            <CodeMirror
              className="try-codemirror-wrap"
              value={js}
              options={{
                mode: 'javascript',
                lineNumbers: true,
                readOnly: true,
              }}
            />
            {jsError && (
              <pre className="try-error-warning" style={{ padding: 15 }}>
                {jsError.message}
              </pre>
            )}
          </div>

          <div className="try-grid-editor">
            <div className="try-label">OCaml</div>
            <CodeMirror
              className="try-codemirror-wrap"
              value={ocaml}
              options={{
                mode: 'mllike',
                lineNumbers: true,
              }}
              onChange={this.updateOCaml}
            />
            {ocamlSyntaxError && (
              <pre className="try-error-warning" style={{ padding: 15 }}>
                {ocamlSyntaxError.message}
              </pre>
            )}
            {errorsFromCompilation && (
              <pre
                className="try-error-warning"
                dangerouslySetInnerHTML={{
                  __html: ansiUp.ansi_to_html(errorsFromCompilation),
                }}
              ></pre>
            )}
          </div>

          <div className="try-output">
            <div className="try-grid-editor">
              <div className="try-label">Console</div>
              <div style={{ padding: 10 }}>
                {this.state.output.map((item, i) => (
                  <div className="try-output-line" key={i}>
                    {item.contents.join(' ')}
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
