import React from 'react';
import { graphql } from 'gatsby';
import { useSpring, animated } from 'react-spring';
import styled, { css } from 'styled-components';
import { breakpoints, colors, GlobalStyles, ThemeProvider } from '../theme';
import {
  MenuButton,
  NavBar,
  ContentContainer,
  AppWrapper,
  PageTitle,
} from '../components/Layout';

import {
  WorkInProgress,
} from '../components/Illustration';

export const pageQuery = graphql`
  query {
    site {
      siteMetadata {
        githubUrl
        docsLocation
      }
    }
  }
`;

export default props => {
  const {
    site: {
      siteMetadata: { githubUrl },
    },
  } = props.data;
  return (
    <ThemeProvider>
      <GlobalStyles />
      <AppWrapper>
        <ContentContainer>
          <NavBar githubUrl={githubUrl} />
          <main
            css={css`
              align-items: center;
              display: flex;
              flex: 1;
              flex-direction: column;
              max-width: 970px;
              width: 100%;
              overflow: auto;
              padding: 0px 22px;
              padding-top: 3rem;
              padding-bottom: 3rem;
            `}
          >
            <div
              css={css`
                align-items: center;
                display: flex;
                flex-direction: column;
                max-width: 750px;
              `}
            >
              <h1
                css={css`
                  padding: 20px;
                `}
              >
                Page not found
              </h1>
              <p
                css={css`
                  padding-top: 20px;
                  padding-bottom: 40px;
                `}
              >
                If you were expecting something to be here, please{' '}
                <a href={githubUrl + '/issues'}>file an issue</a> on GitHub
              </p>
              <WorkInProgress
                css={css`
                  width: 100%;
                `}
              />
            </div>
          </main>
        </ContentContainer>
      </AppWrapper>
    </ThemeProvider>
  );
}