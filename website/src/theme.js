import styled, {
  createGlobalStyle,
  ThemeProvider as StyledThemeProvider,
} from 'styled-components';
import React, { useEffect, useState } from 'react';

let hsl = (h, s, l) => ({
  lightest: `hsl(${h}, ${s}%, ${l + (100 - l) * 0.95}%)`,
  lighter: `hsl(${h}, ${s}%, ${l + (100 - l) * 0.6}%)`,
  light: `hsl(${h}, ${s}%, ${l + (100 - l) * 0.2}%)`,
  base: `hsl(${h}, ${s}%, ${l}%)`,
  dark: `hsl(${h}, ${s}%, ${l - l * 0.4}%)`,
  darker: `hsl(${h}, ${s}%, ${l - l * 0.6}%)`,
  darkest: `hsl(${h}, ${s}%, ${l - l * 0.85}%)`,
});

export let colors = {
  purple: hsl(253.9, 53.2, 30.2),
  blue: hsl(197.2, 100, 43.1),
  red: hsl(8.2, 58.16, 53.14),
  orange: {
    ocaml: {
      start: '#f29100',
      end: '#ec670f',
    },
  },
  black: 'hsl(212.3, 15.3%, 16.7%)',
  grey: hsl(0, 10, 91.1),
  white: '#FFFFFF',
  yellow: hsl(50.3, 94.2, 72.9),
};

export let fonts = {
  body: 'Roboto, Helvetica, Arial, sans-serif',
  monospace: `Menlo, "Lucida Console", Monaco, monospace`,
};

export let spacing = {
  smallest: 4,
  smaller: 8,
  small: 12,
  medium: 16,
  large: 20,
  larger: 24,
  pageMargin: {
    mobile: 24,
    desktop: 36,
  },
};

export let dimensions = {
  navbar: 56,
  maxContentWidth: 740,
  leftSideBar: 240,
  rightSideBar: 224,
};

export let breakpoints = {
  desktop: 720,
};

export let themes = {
  light: {
    favicon: {
      appleTouchIcon: require('./assets/favicon_light/apple-touch-icon.png'),
      icon32: require('./assets/favicon_light/favicon-32x32.png'),
      icon16: require('./assets/favicon_light/favicon-16x16.png'),
    },
    body: colors.white,
    text: colors.black,
    link: colors.red.dark,
    navbar: {
      background: colors.red.base,
      backgroundHover: colors.red.dark,
      text: colors.white,
    },
    sidebar: {
      background: colors.white,
      text: colors.red.base,
      activeBackground: colors.red.base,
      activeText: colors.white,
      hover: colors.red.dark,
    },
    card: {
      background: colors.grey.lighter,
      border: colors.grey.light,
      text: colors.black,
    },
    code: {
      background: colors.grey.lighter,
      border: colors.grey.light,
      text: colors.black,
    },
    toggle: {
      background: colors.grey.lightest,
      border: colors.purple.base,
    },
    githubEditButton: {
      background: 'rgb(255, 255, 255)',
      backgroundHover: 'rgb(245, 247, 249)',
      border: 'rgb(211, 220, 228)',
      text: '#555',
      shadow: 'rgba(116, 129, 141, 0.1)',
    },
  },
  dark: {
    favicon: {
      appleTouchIcon: require('./assets/favicon_dark/apple-touch-icon.png'),
      icon32: require('./assets/favicon_dark/favicon-32x32.png'),
      icon16: require('./assets/favicon_dark/favicon-16x16.png'),
    },
    body: colors.black,
    text: colors.white,
    link: colors.red.base,
    navbar: {
      background: colors.purple.base,
      backgroundHover: colors.purple.dark,
      text: colors.white,
    },
    sidebar: {
      background: colors.black,
      text: colors.white,
      activeBackground: colors.purple.base,
      activeText: colors.white,
      hover: colors.purple.dark,
    },
    card: {
      background: colors.grey.darkest,
      border: colors.grey.dark,
      text: colors.white,
    },
    code: {
      background: colors.grey.darkest,
      border: colors.grey.dark,
      text: colors.white,
    },
    toggle: {
      background: colors.grey.darkest,
      border: colors.red.dark,
    },
    githubEditButton: {
      background: colors.black,
      backgroundHover: 'rgb(36, 42, 49)',
      border: colors.grey.base,
      text: colors.white,
      shadow: colors.grey.darkest,
    },
  },
};

let ThemeContext = React.createContext(['light', () => {}]);

export const ThemeProvider = ({ children }) => {
  let [themeName, setTheme] = useState(() => {
    if (typeof window === `undefined`) {
      // We are server side renderding
      return 'light';
    }
    return (
      window.localStorage.getItem('theme') ||
      (window.matchMedia &&
        window.matchMedia('(prefers-color-scheme: dark)').matches &&
        'dark') ||
      'light'
    );
  });

  let toggleTheme = () => {
    setTheme(current => {
      return current === 'light' ? 'dark' : 'light';
    });
  };

  useEffect(() => {
    window.localStorage.setItem('theme', themeName);
  }, [themeName]);

  return (
    <StyledThemeProvider
      theme={themeName === 'light' ? themes.light : themes.dark}
    >
      <ThemeContext.Provider value={[themeName, toggleTheme]}>
        {children}
      </ThemeContext.Provider>
    </StyledThemeProvider>
  );
};

export let useTheme = () => {
  let [themeName, toggleTheme] = React.useContext(ThemeContext);
  return [themeName, toggleTheme, themes[themeName]];
};

const ToggleContainer = styled.button`
  align-items: center;
  background: ${({ theme }) => theme.toggle.background};
  border: 2px solid ${({ theme }) => theme.toggle.border};
  border-radius: 30px;
  cursor: pointer;
  display: flex;
  font-size: 0.5rem;
  justify-content: space-between;
  margin: 0 auto;
  overflow: hidden;
  outline: none;
  padding: 0 0.4rem;
  position: relative;
  width: 4rem;
  height: 2rem;

  span {
    font-size: 1rem;
    width: 2.5rem;
    transition: all 0.3s ease;

    // sun icon
    &:first-child {
      transform: ${({ isLight }) =>
        isLight ? 'translateY(0)' : 'translateY(60px)'};
    }

    // moon icon
    &:nth-child(2) {
      transform: ${({ isLight }) =>
        isLight ? 'translateY(-60px)' : 'translateY(0)'};
    }
  }
`;

export const ThemeToggle = ({ theme, toggleTheme }) => {
  let isLight = theme === 'light';
  return (
    <ToggleContainer onClick={toggleTheme} isLight={isLight}>
      <span>🌞</span>
      <span>🌛</span>
    </ToggleContainer>
  );
};

export const GlobalStyles = createGlobalStyle`
  *,
  *::after,
  *::before {
    box-sizing: border-box;
  }

  * {
    margin: 0;
    padding: 0;
  }

  html, body {
    background-color: ${({ theme }) => theme.body};
    color: ${({ theme }) => theme.text};
    font-family: BlinkMacSystemFont, -apple-system, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    font-size: 15px;
  }

  a  {
    color: ${({ theme }) => theme.link};
    text-decoration: none;
  }
  a:hover {
    text-decoration: none;
  }
`;
