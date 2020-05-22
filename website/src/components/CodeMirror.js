import React, { useEffect, useRef } from 'react';
let codemirror = null;
if (typeof window !== `undefined`) {
  // We are server side renderding
  codemirror = require('codemirror');
}

export class CodeMirror extends React.Component {
  componentDidMount() {
    this.editor = codemirror(this.div, this.props.options);
    this.editor.setValue(this.props.value);
    this.editor.on('change', (cm, metadata) => {
      const value = this.editor.getValue();
      if (value !== this.props.value && this.props.onChange) {
        this.props.onChange(value);
      }
    });
  }

  componentWillReceiveProps(nextProps) {
    if (
      this.props.value !== nextProps.value &&
      nextProps.value !== this.editor.getValue()
    ) {
      this.editor.setValue(nextProps.value);
    }
  }

  render() {
    if (codemirror == null) {
      return null;
    }
    return (
      <div
        className={this.props.className}
        ref={div => {
          this.div = div;
        }}
      />
    );
  }
}

// let CodeMirror = (props) => {
//   let div = useRef()
//   let editor = useRef(null);
//   useEffect(() => {
//     let editor = codemirror(div.current, props.options)
//     editor.setValue(props.value);
//     editor.on('change', (cm, metadata) => {
//       const value = editor.getValue();
//       if (value !== props.value && props.onChange) {
//         props.onChange(value);
//       }
//     });
//     editor.current = editor

//   }, [props.onChange, props.options])
//   useEffect(() => {
//     if (
//       editor.current != null &&
//       props.value !== this.editor.getValue()
//     ) {
//       editor.current.setValue(props.value);
//     }
//   }, [props.value])

//   return (
//     <div className={props.className} ref={div} />
//   );
// }
