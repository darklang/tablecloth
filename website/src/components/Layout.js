import { useStaticQuery, graphql } from 'gatsby';
import React from 'react';
import styled from 'styled-components';
import {
  breakpoints,
  dimensions,
  colors,
  spacing,
  useTheme,
  ThemeToggle,
} from '../theme';
import { Link } from './Link';
import { GitHub } from './Icon';

export const AppWrapper = styled.div`
  position: relative;
`;

export const ContentContainer = styled.div`
  display: flex;
  flex-direction: row;
  justify-content: space-around;
  width: 100%;
  flex-direction: column;
  align-items: center;
  @media (min-width: ${dimensions.maxContentWidth + dimensions.leftSideBar}px) {
    justify-content: center;
  }
`;

export const SidebarContainer = ({ children, isOpen }) => {
  return (
    <aside
      className="SidebarContainer"
      css={css`

        display: flex;
        flex-direction: column;
        transition: all 0.2s ease;
        width: 260px;
        z-index: 1;

        @media (min-width: ${dimensions.maxContentWidth +
            dimensions.leftSideBar}px) {
          border-right: 1px solid ${colors.grey.light};
           width: ${dimensions.leftSideBar}px;
          z-index: 1;
          opacity: 1;
        }
        @media (max-width: ${dimensions.maxContentWidth-
          dimensions.leftSideBar}px) {
              display: ${isOpen ? "flex" : "none"};
              
              ${isOpen ? `
              position: absolute;
              top: 0;
              left: 0;
              bottom: 0;
              right: 0;
              width: 100%;
              ` : ``};
        }
      `}
    >
      {children}
    </aside>
  );
};

export const Main = styled.main`
  align-items: center;
  display: flex;
  flex: 1;
  flex-direction: column;
  padding: 5rem 0;
  width: 100%;
  max-width: 1200px;
`;

export const Container = styled.div`
  display: flex;
  flex-direction: column;
 padding: 0 ${spacing.pageMargin.mobile}px;
  width:  100%;
  @media (min-width: ${breakpoints.desktop}px) {
    padding: 0 ${spacing.pageMargin.desktop}px;
  }
  scroll-padding-top: 64px;
`;

export const NavBarContainer = styled.div`
  position: sticky;
  top: 0;
  z-index: 5;
  width: 100%;
`;

export const NavBar = () => {
  let [themeName, toggleTheme] = useTheme();
  let {
    site: {
      siteMetadata: { githubUrl },
    },
  } = useStaticQuery(graphql`
    query {
      site {
        siteMetadata {
          githubUrl
        }
      }
    }
  `);

  return (
    <nav
      css={css`
        background-color: ${({ theme }) => theme.navbar.background};
        display: flex;
        flex-direction: column;
        justify-content: center;
        height: ${dimensions.navbar}px;
        width: 100%;
      `}
    >
      <div
        css={css`
          align-items: center;
          align-self: center;
          display: flex;
          flex-direction: row;
          flex-shrink: 0;
          justify-content: space-between;
          padding-left: ${spacing.pageMargin.mobile}px;
          padding-right: ${spacing.pageMargin.mobile}px;
          width: 100%;
          z-index: 1;
          max-width: 1200px;

          .navBarHeader {
            align-items: center;
            display: flex;
            color: ${({ theme }) => theme.navbar.text};
            font-size: 22px;
            font-weight: 400;
            line-height: 1.5;
            font-weight: bold;
            &:hover {
              text-decoration: none;
              opacity: 0.8;
            }
            @media (max-width: ${breakpoints.desktop-dimensions.leftSideBar}px) {
              font-size: 16px;
            }
          }

          .navLinks {
            align-items: center;
            display: flex;
            flex-direction: row;
           
            .navLink {
              margin-left: ${spacing.small}px;
              font-size: 16px;
             
              a {
                color: ${({ theme }) => theme.navbar.text};
                font-weight: 500;
                line-height: 1em;
                opacity: 1;
                padding-bottom: ${spacing.medium}px;
                padding-top: ${spacing.medium}px;

                &:hover {
                  opacity: 0.7;
                }
              }
              @media (max-width: ${breakpoints.desktop-dimensions.leftSideBar}px) {
                font-size: 12px;
                button {
                  width: 3rem; 
                 }
              }
            }
          }

          @media (min-width: ${breakpoints.desktop}px) {
            padding-left: ${spacing.pageMargin.desktop}px;
            padding-right: ${spacing.pageMargin.desktop}px;
            .navLinks {
              .navLink {
                margin-left: ${spacing.medium}px;
              }
            }
          }
        `}
      >
        <span  css={css`
                display: flex;
                
              `}>
        <Link to={'/'} className="navBarHeader">
          Tablecloth
        </Link>
        </span>
        <div className="navLinks">
          <div className="navLink">
            <ThemeToggle theme={themeName} toggleTheme={toggleTheme} />
          </div>
          <div className="navLink">
            <Link to="/documentation">Get Started</Link>
          </div>
          <div className="navLink">
            <Link to="/docs/rescript">Docs</Link>
          </div>
          <div className="navLink">
            <Link
              to={githubUrl}
              css={css`
                display: flex;
                align-items: center;

                svg {
                  fill: ${({ theme }) => theme.navbar.text};
                  width: 15px;
                  margin-right: 5px;
                }
              `}
            >
              <GitHub />
              <span>Github</span>
            </Link>
          </div>
        </div>
      </div>
    </nav>
  );
};

export let PageTitle = ({ children }) => {
  return (
    <div
      css={css`
        display: flex;
        align-items: center;
        padding-bottom: 40px;

        h1 {
          border-left: 2px solid ${colors.red.base};
          flex: 1;
          font-size: 32px;
          font-weight: 500;
          line-height: 1.5;
          margin-top: 0;
          padding: 0 16px;
        }
      `}
    >
      <h1>{children}</h1>
    </div>
  );
};

export const MenuButtonContainer = styled.div`
  bottom: 24px;
  position: fixed;
  right: 24px;
  z-index: 3;

  @media (min-width: ${dimensions.maxContentWidth - dimensions.leftSideBar}px) {
    display: none;
  }
`;

let Bar = styled.div`
  background-color: ${colors.white};
  height: 2px;
  width: 20px;
`;

let Bars = () => (
  <div
    css={css`
      display: flex;
      flex-direction: column;
      height: 100%;
      justify-content: space-between;
    `}
  >
    <Bar />
    <Bar />
    <Bar />
  </div>
);

export const MenuButton = ({ onClick, isOpen }) => {
  return (
    <div
      onClick={onClick}
      css={css`
        align-items: center;
        background-color: ${colors.red.base};
        border: 1px solid ${colors.white};
        border-radius: 4px;
        color: ${colors.white};
        display: flex;
        flex-direction: column;
        width: 38px;
        height: 38px;
        padding: 9px 6px;

        &:focus,
        &:hover {
          background-color: ${colors.red.dark};
        }
      `}
    >
      {isOpen ? <span>╳</span> : <Bars />}
    </div>
  );
};
