import styled, { css } from 'styled-components';
import React from 'react';
import { Reason, OCaml } from './Icon';
import { colors, spacing } from '../theme';

export let keywords = {
  reason: {
    val: 'let',
    typesig: ': ',
    arrow: '=>',
    module: {
      open: '{',
      close: '}',
    },
    moduleSignature: {
      open: '{',
      close: '}',
    },
  },
  ocaml: {
    val: 'val',
    typesig: ' : ',
    arrow: '->',
    module: {
      open: 'struct',
      close: 'end',
    },
    moduleSignature: {
      open: 'sig',
      close: 'end',
    },
  },
};

let SyntaxContext = React.createContext([keywords.reason, () => {}]);

export let SyntaxProvider = ({ children }) => {
  let [syntax, setSyntax] = React.useState('reason');
  let toggle = () =>
    setSyntax(current => (current === 'reason' ? 'ocaml' : 'reason'));
  return (
    <SyntaxContext.Provider children={children} value={[syntax, toggle]} />
  );
};

export let useSyntax = () => React.useContext(SyntaxContext);

let logoSize = 35;
const ToggleContainer = styled.button`
  background: ${({ isReason }) =>
    isReason
      ? `linear-gradient(${colors.red.base}, ${colors.red.base})`
      : `linear-gradient(${colors.orange.ocaml.start}, ${colors.orange.ocaml.end})`};
  border: 2px solid
    ${({ isReason }) =>
      isReason ? colors.red.base : colors.orange.ocaml.start};
  border-radius: 30px;
  cursor: pointer;
  margin: 0;
  outline: none;
  overflow: hidden;
  padding: 0.4rem;
  position: relative;
  width: ${logoSize * 2}px;
  height: ${logoSize}px;

  svg {
    position: absolute;
    top: 0;
    bottom: 0;
    flex-shrink: 0;
    fill: white;
    transition: transform 0.3s ease;

    // reason logo
    &:first-child {
      transform: ${({ isReason }) =>
        isReason
          ? `translate3d(${-logoSize / 4}px, ${-logoSize / 1.025}px,0)`
          : `translate3d(${-logoSize * 2}px, ${-logoSize / 1.025}px, 0)`};
    }

    // ocaml logo
    &:nth-child(2) {
      transform: ${({ isReason }) =>
        isReason
          ? `translate3d(${logoSize * 2}px, ${-logoSize / 0.9}px, 0)`
          : `translate3d(${-logoSize / 1.1}px, ${-logoSize / 0.9}px,0)`};
    }
  }
`;

export const SyntaxToggle = () => {
  let [syntax, toggleSyntax] = useSyntax();
  return (
    <div
      css={css`
        align-items: flex-end;
        display: flex;
        flex-direction: column;
        margin-top: -${spacing.smaller}px;
        span {
          color: ${colors.grey.dark};
          font-size: 10px;
          font-weight: 500;
          letter-spacing: 1.1px;
          margin-bottom: ${spacing.smaller}px;
          text-transform: uppercase;
        }
      `}
    >
      <span>Switch syntax</span>
      <ToggleContainer onClick={toggleSyntax} isReason={syntax === 'reason'}>
        <Reason height={logoSize * 2.5} width={logoSize * 2.5} />
        <OCaml height={logoSize * 3.25} width={logoSize * 3.25} />
      </ToggleContainer>
    </div>
  );
};
