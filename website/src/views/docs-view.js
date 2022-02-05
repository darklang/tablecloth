import React, { Component, useEffect, useRef, useMemo } from 'react';
import { Helmet } from 'react-helmet';
import {
  AutoSizer,
  CellMeasurer,
  CellMeasurerCache,
  List,
  WindowScroller,
} from 'react-virtualized';
import { graphql, navigate, Link } from 'gatsby';
import styled, { css } from 'styled-components';
import _ from 'lodash';
import {
  breakpoints,
  dimensions,
  colors,
  fonts,
  GlobalStyles,
  ThemeProvider,
  spacing,
  useTheme,
} from '../theme';
import {
  AppWrapper,
  ContentContainer,
  Container,
  Main,
  MenuButton,
  MenuButtonContainer,
  NavBar,
  NavBarContainer,
  PageTitle,
  SidebarContainer,
} from '../components/Layout';
import { CodeBlock } from '../components/CodeBlock';
import LanguageIcon from '../components/LanguageLogos';
import * as lzString from 'lz-string';

let stripTableclothPrefix = path => path.replace(/Tablecloth/g, '');

function deDupeIncludedModules(moduleElements, modulesByName) {
  let flattenedModuleElements = [];
  moduleElements.forEach(moduleElement => {
    if (moduleElement.tag === 'IncludedModule') {
      let includedModule = modulesByName[moduleElement.value.name];
      includedModule.value.kind.value.forEach(includedModuleElement => {
        flattenedModuleElements.push(includedModuleElement);
      });
    } else {
      flattenedModuleElements.push(moduleElement);
    }
  });
  let seen = {};
  let deDupedModuleElements = [];
  flattenedModuleElements.forEach(moduleElement => {
    if (moduleElement.tag === 'Module') {
      if (seen[moduleElement.value.name]) {
        deDupedModuleElements[seen[moduleElement.value.name]] = moduleElement;
        return;
      } else {
        seen[moduleElement.value.name] = deDupedModuleElements.length;
      }
    }
    deDupedModuleElements.push(moduleElement);
  });
  return deDupedModuleElements;
}

let scrollToIdGlobal = null;

let Json = ({ value }) => (
  <pre
    className="DebugJsonValue"
    css={css`
      width: 100%;
      border: 3px dashed green;
      background-color: black;
      color: green;
      padding: 10px;
      overflow: auto;
    `}
  >
    <code>{JSON.stringify(value, null, 2)}</code>
  </pre>
);

let UnhandledCase = props => {
  if (process.env.NODE_ENV === 'production') {
    throw new Error(`Unhandled case: ${props.case}`);
  }
  return (
    <div
      className="UnhandledCase"
      css={css`
        border: 5px dotted red;
      `}
    >
      <h1>Unhandled Case</h1>
      <Json value={props}/>
    </div>
  );
};

const compress = lzString.compressToEncodedURIComponent;

let idFor = (path, tag, name) => {
  // The names of values and types may not be unique within a module
  // (for example float.radians refers to a function and a type)
  // We need to be able to distinguish between them.
  let prefix = tag === 'Type' ? 'type_' : '';
  return `${path.join('.')}${path.length > 0 ? '.' : ''}${prefix}${name}`;
};

function renderSidebarElements(
  moduleElements,
  modulesByModulePath,
  search,
  collapsed,
  toggleModule,
  scrollToId,
  path = [],
) {
  let moduleSearchPath =
    search.length > 1 ? search.slice(0, search.length - 1) : [];
  let valueSearch = search.length === 0 ? '' : search[search.length - 1];
  let hasSearch = valueSearch.length > 0;
  let includesCaseInsensitive = (a, b) => a.toLowerCase().includes(b.toLowerCase());

  return deDupeIncludedModules(moduleElements, modulesByModulePath).map(
    (moduleElement, index) => {
      switch (moduleElement.tag) {
        case 'Type':
          let typeId = idFor(path, moduleElement.tag, moduleElement.value.name);
          if (
            hasSearch &&
            !(
              moduleSearchPath.length === 0 &&
              includesCaseInsensitive(moduleElement.value.name, valueSearch)
            )
          ) {
            return null;
          }
          return (
            <div key={typeId}>
              <a
                onClick={() => scrollToId(typeId)}
                href={`#${typeId}`}
              >
                type {moduleElement.value.name}
              </a>
            </div>
          );
        case 'Value':
          let valueLink = idFor(
            path,
            moduleElement.tag,
            moduleElement.value.name,
          );
          if (
            hasSearch &&
            !(
              moduleSearchPath.length === 0 &&
              includesCaseInsensitive(moduleElement.value.name, valueSearch)  
            )
          ) {
            return null;
          }
          return (
            <div key={valueLink}>
              <a
                href={`#${valueLink}`}
                onClick={() => scrollToId(valueLink)}>
                {moduleElement.value.name}
              </a>
            </div>
          );
        case 'ModuleType':
          let moduleTypeId = idFor(
            path,
            moduleElement.tag,
            moduleElement.value.name,
          );
          if (hasSearch &&
            !includesCaseInsensitive(moduleElement.value.name, valueSearch)
              ) {
            return null;
          }
          return (
            <a
              href={`#${moduleTypeId}`}
              onClick={() => scrollToId(moduleTypeId)} key={moduleTypeId}>
              module type {moduleElement.value.name}
            </a>
          );
        case 'Module':
          switch (moduleElement.value.kind.tag) {
            case 'ModuleFunctor':
              let moduleFunctorId = idFor(
                path,
                moduleElement.value.kind.tag,
                moduleElement.value.name,
              );
              if (
                hasSearch &&
                !includesCaseInsensitive(moduleElement.value.name, valueSearch)
              ) {
                return null;
              }
              return (
                <a
                  href={`#${moduleFunctorId}`}
                  onClick={() => scrollToId(moduleFunctorId)}
                  key={moduleFunctorId}
                >
                  {moduleElement.value.name}
                </a>
              );
            case 'ModuleStruct':
              return renderSidebarModule(
                moduleElement,
                modulesByModulePath,
                search,
                collapsed,
                toggleModule,
                scrollToId,
                path,
              );
            case 'ModuleAlias':
              let aliasedModule =
                modulesByModulePath[moduleElement.value.kind.value.name];
              if (aliasedModule == null) {
                throw new Error(
                  `The module '${moduleElement.value.kind.value.name} (aliased to ${moduleElement.value.name}) is missing`,
                );
              }
              if (aliasedModule.value.kind.tag !== 'ModuleStruct') {
                throw new Error(
                  'Unmapped case for ' +
                  kind.value.name +
                  aliasedModule.value.kind,
                );
              }
              return renderSidebarModule(
                aliasedModule,
                modulesByModulePath,
                search,
                collapsed,
                toggleModule,
                scrollToId,
                path,
              );
            default:
              return (
                <UnhandledCase
                  key={'DefaultSidebarModule' + index}
                  moduleElement={moduleElement}
                />
              );
          }
        case 'IncludedModule':
          let includedModule = modulesByModulePath[moduleElement.value.name];
          if (includedModule == null) {
            throw new Error(
              `The included module '${moduleElement.value.name}' is missing`,
            );
          }
          if (includedModule.value.kind.tag !== 'ModuleStruct') {
            throw new Error(
              `Unmapped case for ${moduleElement.kind.value.name} ${includedModule.value.kind}`,
            );
          }
          return renderSidebarElements(
            includedModule.value.kind.value,
            modulesByModulePath,
            search,
            collapsed,
            toggleModule,
            scrollToId,
            path,
          );
        case 'Text':
          return null;
        default:
          return (
            <UnhandledCase
              key={'DefaultSidebarModule' + index}
              moduleElement={moduleElement}
            />
          );
      }
    },
  );
}

function renderSidebarModule(
  moduleElement,
  modulesByModulePath,
  search,
  collapsed,
  toggleModule,
  scrollToId,
  path,
) {
  let moduleName = stripTableclothPrefix(moduleElement.value.name);
  let moduleSearchPath =
    search.length > 1 ? search.slice(0, search.length - 1) : [];
  let valueSearch = search.length === 0 ? '' : search[search.length - 1];
  let hasSearch = valueSearch.length > 0;
  let qualifiedModuleName =
    path.length > 0
      ? [...path, moduleName].join('.')
      : moduleName;

  let isCollapsed = !!collapsed[qualifiedModuleName];
  let moduleId = idFor(path, moduleElement.tag, moduleName);

  let moduleNameMatchesValueSearch = moduleName.includes(valueSearch);

  let subSearch;
  if (moduleSearchPath.length === 0) {
    if (moduleNameMatchesValueSearch) {
      subSearch = [];
    } else {
      subSearch = search;
    }
  } else {
    if (moduleElement.value.name.includes(moduleSearchPath[0])) {
      subSearch = [
        ...moduleSearchPath.slice(1, moduleSearchPath.length),
        valueSearch,
      ];
    } else {
      subSearch = search;
    }
  }

  let content = renderSidebarElements(
    moduleElement.value.kind.value,
    modulesByModulePath,
    subSearch,
    collapsed,
    toggleModule,
    scrollToId,
    [...path, moduleName],
  );

  let hasElementsMatchingSearch = content.filter(e => e != null).length > 0;

  if (
    hasSearch &&
    !(
      (moduleSearchPath.length === 0 && moduleNameMatchesValueSearch) ||
      hasElementsMatchingSearch
    )
  ) {
    return null;
  }
  return (
    <div
      key={moduleId}
      css={css`
        margin-top: -5px;

        .name {
          display: flex;
          flex-direction: row;
          font-weight: bold;
          font-size: 1.2em;
          padding-bottom: 8px;
          padding-top: 6px;

          .expansion-indicator {
            margin-right: 8px;
            cursor: pointer;
          }
        }
        .elements {
          border-left: 1px solid grey;
          margin-left: 8px;
          padding-left: 12px;
          > * {
            padding-bottom: 4px;
            padding-top: 4px;
          }
        }
      `}
    >
      <div className="name">
        <div
          className="expansion-indicator"
          onClick={() => toggleModule(qualifiedModuleName)}
        >
          {isCollapsed ? '▷' : '▽'}
        </div>

        <a
          href={`#${moduleId}`}
          onClick={() => scrollToId(moduleId)}
        >module {qualifiedModuleName}</a>
      </div>
      {isCollapsed ? null : <div className="elements">{content}</div>}
    </div>
  );
}

const Sidebar = ({ moduleElements, moduleByModulePath, scrollToId }) => {
  let [searchString, setSearch] = React.useState('');
  let search = searchString
    .split('.')
    .filter(identifier => identifier.length > 0);
  let [collapsed, setCollapsed] = React.useState({});
  let toggleModule = qualifiedModuleName =>
    setCollapsed(collapsed => ({
      ...collapsed,
      [qualifiedModuleName]: !collapsed[qualifiedModuleName],
    }));
  return (
    <div
      css={css`
        background-color: ${({ theme }) => theme.block.background};
        display: flex;
        flex-direction: column;
        height: 100vh;
        width: 100%;
        position: sticky;
        top: 56px;
        left: 0;
      `}
    >
      <input
        value={searchString}
        placeholder="Search"
        onChange={e => setSearch(e.target.value)}
        css={css`
          background-color: ${colors.grey.light};
          border-color: ${colors.grey.light};
          border: none;
          border-radius: 8px;
          font-size: 16px;
          margin: 8px;
          padding: 10px;
        `}
      />
      <div
        className="SidebarItems"
        css={css`
          display: flex;
          flex: 1;
          flex-direction: column;
          overflow-y: auto;
          padding-left: 15px;
          padding-top: 15px;
          padding-right: 15px;
          padding-bottom: ${15 + dimensions.navbar}px;

          a {
            color: ${({ theme }) => theme.sidebar.text};
            cursor: pointer;
          }
        `}
      >
        {renderSidebarElements(
          moduleElements,
          moduleByModulePath,
          search,
          collapsed,
          toggleModule,
          scrollToId,
        )}
      </div>
    </div>
  );
};

const PageAnchor = ({ id, children }) => {
  return (
    <div
      id={id}
      css={css`
        align-items: center;
        display: inline-flex;
        flex-shrink: 0;
        flex-direction: row;
        margin-left: -${spacing.pageMargin.desktop*1.5}px;
        width: calc(100% + 70px);

        .link {
          display: none;
          opacity: 0.3;
          &:hover {
            opacity: 1;
          }
        }
        &:hover {
          .link {
            opacity: 1;
          }
        }

        .link {
          display: none;
          flex-shrink: 0;
          font-size: 15px;
          height: 100%;
          text-align: center;
          user-select: none;
          width: ${spacing.pageMargin.desktop}px;
          display: flex;
          justify-content: center;

          span {
            width: 7px;
          }
        }
        .content {
          width: calc(100% + ${spacing.pageMargin.desktop}px);
          overflow: hidden;
        }

        @media (min-width: ${breakpoints.desktop}px) {
          margin-left: -${spacing.pageMargin.desktop*1.5}px;
          width: calc(100% + 70px);
          .link {
            width: ${spacing.pageMargin.desktop}px;
          }

          .content {
            width: calc(100% + ${spacing.pageMargin.desktop}px);
          }
          .link span {
            width: 17px;
          }
        }
      `}
    >
      <a href={`#${id}`} className="link">
        <span className="linkIcon">🔗</span>
      </a>
      <div className="content">{children}</div>
    </div>
  );
};

let Identifiers = {
  module: ({ name }) => (
    <span
      css={css`
        align-items: flex-end;
        display: flex;
        flex-direction: row;

        .keyword {
          font-family: ${fonts.monospace};
          margin-right: 10px;
          line-height: 30px;
        }
        .name {
          color: ${colors.red.base};
          line-height: 42px;
        }
      `}
    >
      <span className="keyword">
        <h2>module</h2>
      </span>
      <span className="name">
        <h1>{name}</h1>
      </span>
    </span>
  ),
  moduleType: ({ name }) => (
    <span
      css={css`
        align-items: flex-end;
        display: flex;
        flex-direction: row;

        .keyword {
          font-family: ${fonts.monospace};
          margin-right: 10px;
          line-height: 30px;
        }
        .name {
          color: ${colors.red.base};
          line-height: 42px;
        }
      `}
    >
      <span className="keyword">
        <h2>module type</h2>
      </span>
      <span className="name">
        <h1>{name}</h1>
      </span>
    </span>
  ),
};

let renderTextElements = (elements = [], parentPath = []) => {
  return elements.map(({ tag, value }, index) => {
    switch (tag) {
      case 'Raw':
        return <span key={index}>{value}</span>;
      case 'Newline':
        return <pre key={index}>{'\n'}</pre>;
      case 'Emphasize':
        return <em key={index}>{renderTextElements(value, parentPath)}</em>;
      case 'Bold':
        return <b key={index}>{renderTextElements(value, parentPath)}</b>;
      case 'Link':
        return (
          <a key={index} href={value.target}>
            {renderTextElements(value.content, parentPath)}
          </a>
        );
      case 'Code':
        return (
          <code
            key={index}
            css={css`
              background: ${({ theme }) => theme.code.background};
              border: 1px solid ${({ theme }) => theme.code.border};
              color: ${({ theme }) => theme.code.text};
              font-family: ${fonts.monospace};
              padding: 2px;
              border-radius: 1px;
              overflow: auto;
            `}
          >
            {value}
          </code>
        );
      case 'List':
        return (
          <ul
            key={index}
            css={css`
              padding-left: 30px;
              padding-bottom: 10px;
              li {
                padding-bottom: 8px;
              }
            `}
          >
            {value.map((listElement, subIndex) => (
              <li key={subIndex}>
                {renderTextElements(listElement, parentPath)}
              </li>
            ))}
          </ul>
        );
      case 'Ref':
        if (value.reference.content == null) {
          console.error('Empty reference', value);
          throw new Error('Empty reference');
        }
        let content =
          value.reference.content.length === 1 &&
            value.reference.content[0].tag === 'Code'
            ? stripTableclothPrefix(value.reference.content[0].value)
            : renderTextElements(value.reference.content, parentPath);
        let hashId = stripTableclothPrefix(value.reference.target);
        return (
          <a
            key={index}
            href={`#${hashId}`}
            onClick={()=> scrollToIdGlobal(hashId)}
          >
            {content}
          </a>
        );

      case 'Title':
        return React.createElement(`h${value.size + 1}`, {
          key: index,
          id: value.label,
          children: renderTextElements(value.content, parentPath),
        });

      case 'CodePre':
        return (
          <div
            key={index}
            className="CodePre"
            css={css`
              font-family: ${fonts.monospace};
              overflow: auto;
              position: relative;
              width: 100%;

              .try {
                border: none;
                bottom: 0;
                cursor: pointer;
                font-size: 14px;
                padding: 4px;
                position: absolute;
                right: 0;
                opacity: 0.8;

                &:hover {
                  opacity: 1;
                }
              }
            `}
          >
            <CodeBlock code={value}/>
            {/* TODO get the playground working */}
            {/* <button
              className="try"
              onClick={() => {
                navigate(`/try?ocaml=${compress(value)}`);
              }}
            >
              Try
            </button> */}
          </div>
        );
      case 'Enum':
        return (
          <ul
            key={index}
            css={css`
              padding-left: 30px;
              padding-bottom: 10px;
              li {
                padding-bottom: 8px;
              }
            `}
          >
            {value.map((enumItem, enumIndex) => (
              <li key={enumIndex}>
                {renderTextElements(enumItem, parentPath)}
              </li>
            ))}
          </ul>
        );
      default:
        return (
          <UnhandledCase
            key={'DefaultTextElement' + index}
            element={{ tag, value }}
          />
        );
    }
  });
};

let TextElement = ({ elements, path }) => {
  return (
    <div
      css={css`
        padding-top: 12px;
        padding-bottom: 12px;
        line-height: 26px;
      `}
    >
      {renderTextElements(elements, path)}
    </div>
  );
};

let TypeSignature = ({ signature }) => {
  return (
      <React.Fragment children={stripTableclothPrefix(signature.rendered)}/>
  );
};

let TypeDefinition = ({ name, type }) => {
  return (
    <pre
    css={css`
    display: inline;
    font-weight: bold;
    display: inline-flex;
    background-color: ${({ theme }) => theme.typeDefinition.background};
    color: ${({ theme }) => theme.typeDefinition.text};
    border-left: 4px solid ${({ theme }) => theme.typeDefinition.borderLeft};
    padding: 8px;
    margin:${spacing.small}px 0;
  `}
    >

 
let {name}: <TypeSignature signature={type}/>
    </pre>
  );
};

let ValueContainer = props => (
  <div
    className="ValueContainer"
    css={css`
      margin-bottom: 25px;
      margin-top: 15px;
      padding: 0 15px;
      background: ${({ theme }) => theme.block.background};
      border-bottom: 1px solid ${({ theme }) => theme.block.outline};
      border-right: 1px solid ${({ theme }) => theme.block.outline};
      border-left: 1px solid ${({ theme }) => theme.block.outline};

    `}
    {...props}
  />
);

let ValueWrapper = styled.div`
  align-items: flex-start;
  display: flex;
  background-color: ${colors.blue.lightest};
  background-color: ${({ theme }) => theme.blockHeader.background};
  color: ${({ theme }) => theme.blockHeader.text};
  border-radius: 3px;
  border-left: 4px solid ${({ theme }) => theme.blockHeader.borderLeft};
  flex: 1;
  flex-direction: row;
  padding-top: ${spacing.small}px;
  padding-bottom: ${spacing.small}px;
  padding-left: ${spacing.medium}px;
  padding-right: ${spacing.medium}px;
  width: 100%;
  overflow-x: auto;
  border-top: 1px solid ${({ theme }) => theme.typeDefinition.outline};
  border-right: 1px solid ${({ theme }) => theme.typeDefinition.outline};
 
`;

let Value = ({ id, path, name, type, info, parameters, ...value }) => {
  return (
    <ValueContainer>
      <PageAnchor id={id}>
        <ValueWrapper>
        <h2>{id}</h2>
        </ValueWrapper>
      </PageAnchor>
      <TypeDefinition name={name} type={type} />
       
      {info && (
        <div
      
        >
          <TextElement
            elements={info.description.value}
            path={[...path, name]}
          />
        </div>
      )}
    </ValueContainer>
  );
};

let ModuleSpacer = () => (
  <div
    className="ModuleSpacer"
    css={css`
      margin-bottom: 3rem;
    `}
  />
);

let registerId = (state, id) => {
  let nextElementIndex = state.elements.length;
  // console.info(id, nextElementIndex)
  state.idToIndex[stripTableclothPrefix(id)] = nextElementIndex;
};

let initialState = {
  path: [],
  elements: [],
  idToIndex: {},
};

function generateModuleElements(
  moduleElements,
  modulesByName,
  state = initialState,
) {
  deDupeIncludedModules(moduleElements, modulesByName).forEach(
    moduleElement => {
      switch (moduleElement.tag) {
        case 'Text':
          state.elements.push(
            <div
              css={css`
                padding: 10px 0px;
              `}
            >
              <TextElement elements={moduleElement.value} path={state.path}/>
            </div>,
          );
          return;
        case 'Type':
          let typeId = idFor(
            state.path,
            moduleElement.tag,
            moduleElement.value.name,
          );
          registerId(state, typeId);
          state.elements.push(
            <ValueContainer>
              <PageAnchor id={typeId}>
                <ValueWrapper>
                  <pre>
                    <code>
                      type {moduleElement.value.name}
                      {moduleElement.value.parameters.length > 0 &&
                        `(${moduleElement.value.parameters})`}
                      {moduleElement.value.manifest ? ' = ' : ''}
                    </code>
                    {moduleElement.value.manifest && (
                    <TypeSignature
                      signature={moduleElement.value.manifest.value}
                    />
                  )}
                  </pre>
                </ValueWrapper>
              </PageAnchor>
              {moduleElement.value.info && (
                <TextElement
                  elements={moduleElement.value.info.description.value}
                />
              )}
            </ValueContainer>,
          );
          return;
        case 'Value':
          let valueId = idFor(
            state.path,
            moduleElement.tag,
            moduleElement.value.name,
          );
          registerId(state, valueId);
          state.elements.push(
            <Value id={valueId} path={state.path} {...moduleElement.value} />,
          );
          return;
        case 'ModuleType':
          let moduleTypeId = idFor(
            state.path,
            moduleElement.tag,
            moduleElement.value.name,
          );
          registerId(state, moduleTypeId);
          state.elements.push(
            <div css={css`
            padding: 0px 15px;
          `}>
            <PageAnchor id={moduleTypeId}>
              <Identifiers.moduleType name={moduleTypeId}/>
            </PageAnchor>
            </div>,
          );
          generateModuleElements(moduleElement.value.elements, modulesByName, {
            ...state,
            path: [...state.path, moduleElement.value.name],
          });
          return;
        case 'Module':
          switch (moduleElement.value.kind.tag) {
            case 'ModuleStruct':
              let moduleName = stripTableclothPrefix(moduleElement.value.name);
              let moduleStructId = idFor(
                state.path,
                moduleElement.tag,
                moduleName,
              );
              let path = [...state.path, moduleElement.value.name];
              registerId(state, moduleStructId);
              state.elements.push(
                <div css={css`
                          padding: 0px 15px;
                        `}>
                <PageAnchor id={moduleStructId}>
                  <Identifiers.module name={moduleStructId}/>
                </PageAnchor></div>,
              );
              generateModuleElements(
                moduleElement.value.kind.value,
                modulesByName,
                { ...state, path },
              );
              return;
            case 'ModuleAlias':
              let module = modulesByName[moduleElement.value.kind.value.name];
              if (module == null) {
                throw new Error(
                  `The module '${moduleElement.value.name} (aliased to ${moduleElement.value.name}) is missing`,
                );
              }
              if (module.value.kind.tag !== 'ModuleStruct') {
                throw new Error(
                  'Unmapped case for ' + kind.value.name + module.value.kind,
                );
              }
              let id = idFor(state.path, 'ModuleStruct', stripTableclothPrefix(module.value.name));
              registerId(state, id);
              state.elements.push(
                <div css={css`
                padding: 0px 15px;
              `}>
                <PageAnchor id={id}>
                  <Identifiers.module
                    name={stripTableclothPrefix(moduleElement.value.kind.value.name)}
                  />
                </PageAnchor></div>,
              );
              generateModuleElements(module.value.kind.value, modulesByName, {
                ...state,
                path: [...state.path, moduleElement.value.name],
              });
              state.elements.push(<ModuleSpacer/>);
              return;
            case 'ModuleFunctor':
              let functor = moduleElement.value;
              let { parameter, result } = functor.kind.value;
              let moduleFunctorId = idFor(
                state.path,
                functor.kind.tag,
                functor.name,
              );
              let signature;
              switch (result.tag) {
                case 'ModuleStruct':
                  // This only gets used for Set.Of / Map.Of
                  // Who wants to to a full implementation when this is all we need?
                  // Sorry
                  signature = `sig type t = ${result.value[0].value.manifest.value.rendered} end`;
                  break;
                case 'ModuleWith':
                  signature = stripTableclothPrefix(result.value.kind.value);
                  break;
                default:
                  throw new Error('UNHANDLED CASE ' + result.tag);
              }

              registerId(state, moduleFunctorId);
              state.elements.push(
                <ValueContainer>
                  <PageAnchor id={moduleFunctorId}>
                    <ValueWrapper>
                      <pre>
                        <code>
                          module {functor.name} : functor({parameter.value.name}{' '}
                          : {stripTableclothPrefix(parameter.value.kind.value)}) ->{' '}
                          {signature}
                        </code>
                      </pre>
                    </ValueWrapper>
                  </PageAnchor>
                  {functor.info && (
                    <TextElement elements={functor.info.description.value}/>
                  )}
                </ValueContainer>,
              );
              return;
            default:
              state.elements.push(
                <UnhandledCase
                  key={'DefaultModule' + index}
                  el={moduleElement}
                />,
              );
              return;
          }
        default:
          state.elements.push(<UnhandledCase el={moduleElement}/>);
          return;
      }
    },
  );
  return state;
}



let title = 'Documentation';

let moduleIndex = (moduleElements, parentPath = []) => {
  return moduleElements
    .filter(
      element =>
        element != null &&
        element.tag === 'Module' &&
        element.value.kind.tag === 'ModuleStruct',
    )
    .flatMap(modu => {
      let path = [...parentPath, modu.value.name];
      return [[path, modu], ...moduleIndex(modu.value.kind.value, path)];
    });
};

let Header = ({ title }) => {
  let [_themeName, _toggle, theme] = useTheme();
  return (
    <Helmet>
      <link
        rel="apple-touch-icon"
        sizes="180x180"
        href={theme.favicon.appleTouchIcon}
      />
      <link
        rel="icon"
        type="image/png"
        sizes="32x32"
        href={theme.favicon.icon32}
      />
      <link
        rel="icon"
        type="image/png"
        sizes="16x16"
        href={theme.favicon.icon16}
      />
      <meta name="title" content={title}/>
      <meta property="og:title" content={title}/>
      <meta property="twitter:title" content={title}/>
    </Helmet>
  );
};




let links = [
  {url: "/docs/rescript", name: "Rescript"},
  {url: "/docs/ocaml", name:"Ocaml"},
  {url: "/docs/fsharp", name: "F#"}
];

const navLink = ({url, name}, location) =>   {
let isCurrentLocation = location.pathname === url;

return <Link key={url} to={url}   css={css`
margin-right: 1rem;
padding-bottom: 0.5rem;

font-weight: ${isCurrentLocation ? "700": "400"};
pointer-events: ${isCurrentLocation ? "none": "all"};
`}>
{name}
</Link>}

export default ({ data, language, location }) => {
  let [isOpen, setIsOpen] = React.useState(false);


  let cache = React.useRef(
    new CellMeasurerCache({
      fixedWidth: true,
    }),
  );
  let {
    moduleElements,
    moduleByModulePath,
    idToIndex,
    list,
  } = React.useMemo(() => {
    const { odocModel } = data;
    let model = JSON.parse(odocModel.internal.content);

    // reset initial state
    initialState = {
      path: [],
      elements: [],
      idToIndex: {},
    };

    let moduleByModulePath = _.fromPairs(
      _.map(moduleIndex(_.values(model.modules)), ([path, module]) => [
        path.join('.'),
        module,
      ]),
    );

    let { idToIndex, elements } = generateModuleElements(
      model.entry_point.value.kind.value,
      moduleByModulePath,
    );

    // console.info(idToIndex);

    return {
      moduleElements: model.entry_point.value.kind.value,
      moduleByModulePath,
      idToIndex,
      list: elements,
    };

  }, [data]);

  let listScroll = React.useRef();
  let scrollToId = id => {
    // console.info(id);
    setIsOpen(false);
    // react-virtualized's layout calculations aren't accurate for some reason
    // To get the users browser to consistently arrive at the correct scroll, use the id of the element.
    // This may not have rendered after adjusting the virtualized scroll,
    // and if the browser can't find the relevant id it will scroll to the top
    // of the page (very jarring)
    // Give a delay to avoid this, and if we still cant find the element, settle
    // for where we end up from scrollToRow
    listScroll.current.scrollToRow(idToIndex[id]);
    if (document.getElementById(id) != null) {
      window.location.hash = id;
    } else {
      setTimeout(() => {
        listScroll.current.scrollToRow(idToIndex[id]);
        if (document.getElementById(id) != null) {
          window.location.hash = id;
        }
      }, 50);
    }
  };
  scrollToIdGlobal = scrollToId;

  React.useEffect(() => {
    let id = window.location.hash.split('#')[1];
    if (id != null && id !== '') {
      scrollToId(id);
    }
  }, []);

  return (
    <ThemeProvider>
        <GlobalStyles/>
        <Header title={title}/>
        <AppWrapper>
          <div
            css={css`
              display: flex;
              flex-direction: column;
              justify-content: center;
              align-items: center;
            `}
          >
            <NavBarContainer>
              <NavBar/>
            </NavBarContainer>
            <div
              css={css`
                display: flex;
                flex-direction: row;
                max-width: 1200px;
                justify-content: stretch;
                align-items: stretch;
                width: 100%;
    
              `}
            >
              <SidebarContainer isOpen={isOpen}>
                <Sidebar
                  moduleElements={moduleElements}
                  moduleByModulePath={moduleByModulePath}
                  scrollToId={scrollToId}
                />
              </SidebarContainer>
              <Main>
                <Container
                  css={css`
                  background-color: ${({ theme }) => theme.body};

                    @media (min-width: ${breakpoints.desktop}px) {
                      margin-left: -${spacing.pageMargin.desktop}px;
                    }
                  `}
                >
                  <div
                    css={css`
                      display: flex;
                      flex-direction: row;
                      justify-content: space-between;
                      width: 100%;
                      height: 25vh;
                      @media (min-width: ${breakpoints.desktop}px) {
                        margin-left: ${spacing.pageMargin.desktop}px;
                      }
                    `}
                  >
                    <div
                      css={css`
                      display: flex;
                      justify-content: center;
                      align-items: start;
                      flex-direction: column;
                    `}
                    >
                    <PageTitle>{title}</PageTitle>
                    <div>
                      {links.map(link => navLink(link, location))}
                    </div>
                    </div>
                    <LanguageIcon  language={language}/>

                  </div>
                  <WindowScroller>
                    {({ height, onChildScroll, scrollTop }) => (
                      <AutoSizer disableHeight>
                        {({ width }) => {
                          return (
                            <List
                              ref={listScroll}
                              autoHeight
                              deferredMeasurementCache={cache.current}
                              height={height}
                              onScroll={onChildScroll}
                              rowCount={list.length}
                              rowHeight={cache.current.rowHeight}
                              rowRenderer={({ index, key, parent, style }) => {
                                return (
                                  <CellMeasurer
                                    cache={cache.current}
                                    columnIndex={0}
                                    key={key}
                                    parent={parent}
                                    rowIndex={index}
                                  >
                                    <div
                                      style={style}
                                      className="row"
                                      css={css`
                                        padding-left: ${spacing.pageMargin
                                          .mobile}px;
                                        @media (min-width: ${breakpoints.desktop}px) {
                                          padding-left: ${spacing.pageMargin
                                          .desktop}px;
                                        }
                                     
                                      `}
                                    >
                                      {list[index]}
                                    </div>
                                  </CellMeasurer>
                                );
                              }}
                              scrollTop={scrollTop}
                              width={width}
                            />
                          );
                        }}
                      </AutoSizer>
                    )}
                  </WindowScroller>
                </Container>
              </Main>
            </div>
            <MenuButtonContainer>
              <MenuButton
                onClick={() => setIsOpen(open => !open)}
                isOpen={isOpen}
              />
            </MenuButtonContainer>
          </div>
        </AppWrapper>
    </ThemeProvider>
  );
};
