import * as React from 'react';

import { OCaml, Rescript, Reason, FSharp } from './Icon';
import {
  breakpoints,
  dimensions

} from '../theme';

const icons = [
  {
    icon: OCaml,
    name: 'ocaml',
  },
  { icon: Rescript, name: 'rescript' },
  { icon: Reason, name: 'reason' },
  { icon: FSharp, name: 'fsharp' },
];

const Icon = ({ icon }) => {
  return (
    <div
      css={css`
        height: 25vh;
        width: 25vh;
        path,
        circle {
          opacity: 30%;
          fill: ${({ theme }) => theme.syntaxLogo.background};

        }
      `}
    >
      {icon()}
    </div>
  );
};

const LanguageIcon = ({ language }) => {
  const selectedLanguage = icons.find(({ name }) => name === language) || icons[0];

  return (
    <div
      css={css`
          display: flex;
          margin-right: 36px;
          @media (max-width: ${breakpoints.desktop + dimensions.leftSideBar}px) {
            display: none;
          }
        `}
    >
      <Icon icon={selectedLanguage.icon} />
    </div>
  );
};

export default LanguageIcon;
