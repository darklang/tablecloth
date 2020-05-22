import React from 'react';
import { css } from 'styled-components';
import { Link } from './Link';
import { GitHub } from './Icon';

export const GithubEditButton = ({ link }) => {
  return (
    <Link
      to={link}
      css={css`
        align-items: center;
        background-color: ${({ theme }) => theme.githubEditButton.background};
        border: 1px solid ${({ theme }) => theme.githubEditButton.border};
        border-radius: 3px;
        box-shadow: ${({ theme }) => theme.githubEditButton.shadow} 0px 1px 1px
          0px;
        color: ${({ theme }) => theme.githubEditButton.text};
        cursor: pointer;
        display: flex;
        flex-direction: row;
        font-size: 14px;
        font-weight: 500;
        height: 30px;
        line-height: 1em;
        min-height: 30px;
        padding: 5px 16px;
        text-align: right;
        text-decoration: none;
        transition: all 0.2s ease-out 0s;

        svg {
          height: 15px;
          width: 15px;
          display: inline-block;
          margin-right: 5px;
        }

        &:hover {
          background-color: ${({ theme }) => theme.sidebar.backgroundHover};
        }
      `}
    >
      <GitHub alt={'Github logo'} />
      <span>Edit on GitHub</span>
    </Link>
  );
};
