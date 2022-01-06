import { graphql, Link } from 'gatsby';
import React, { useEffect } from 'react';
import { Helmet } from 'react-helmet';
import { useSpring, animated } from 'react-spring';
import { css } from 'styled-components';
import {
  breakpoints,
  colors,
  spacing,
  useTheme,
  GlobalStyles,
  ThemeProvider,
  dimensions,
} from '../theme';
import {
  NavBar,
  ContentContainer,
  Container,
  AppWrapper,
  Main,
  NavBarContainer,
} from '../components/Layout';
import { CodeBlock } from '../components/CodeBlock';
import { OCaml, Rescript, FSharp } from '../components/Icon';
import { SyntaxProvider } from '../components/Syntax';
import { BookLover } from '../components/Illustration';

let AnimatedOCaml = animated(OCaml);
let AnimatedRescript = animated(Rescript);
let AnimatedFSharp = animated(FSharp);

let logoSize = 300;

let sellingPointPadding = 40;
const Section = ({ tell, show, flip }) => {
  return (
    <section
      flip={flip}
      css={css`
        align-items: center;
        background-color: ${({ flip, theme }) =>
        flip ? theme.body : theme.card.background};
        border-top: 1px solid ${({ theme }) => theme.card.border};
        display: flex;
        flex-direction: column;
        overflow: hidden;
        width: 100%;

        /* Give the last section a border */
        border-bottom: 1px solid ${({ theme }) => theme.card.border};
        padding-bottom: 1px;
        margin-bottom: -1px;
      `}
    >
      <Container>
        <div
          flip={flip}
          css={css`
            display: flex;
            flex-direction: column;
            width: 100%;

            .tell {
              padding-top: ${sellingPointPadding}px;
              padding-bottom: ${sellingPointPadding}px;
              display: flex;
              flex: 1;
              flex-direction: column;
              font-size: 18px;
              line-height: 1.4;

              h2 {
                font-size: 25px;
                margin-bottom: ${spacing.medium}px;
              }
            }
            .show {
              padding-top: ${sellingPointPadding}px;
              padding-bottom: ${sellingPointPadding}px;
              display: flex;
              flex: 1;
              flex-direction: column;
              position: relative;
            }

            @media (min-width: ${breakpoints.desktop}px) {
              flex-direction: ${flip ? 'row-reverse' : 'row'};
              .tell {
                flex: 8;
                padding-left: ${flip ? spacing.larger : 0}px;
                padding-right: ${flip ? 0 : spacing.larger}px;
              }
              .show {
                max-width: 50%;
                flex: 10;
              }
            }
          `}
        >
          <div className="tell">{tell()}</div>
          <div className="show">{show()}</div>
        </div>
      </Container>
    </section>
  );
};

let CodeSample = ({ language, code }) => {
  return <div
    css={css`
      margin-top: -${sellingPointPadding + 1}px;
      margin-left: -${sellingPointPadding}px;
      margin-right: -${sellingPointPadding}px;
      margin-bottom: -${sellingPointPadding + 2}px;
      position: relative;
      
      .language-label {
        position: absolute;
        top: 0;
        left: 0;
        text-transform: uppercase;
        font-weight: bold;
        font-size: 12px;
        padding: 6px;
        color: ${colors.grey.base};
      }
      pre {
        padding-top: ${sellingPointPadding}px;
        padding-left: ${spacing.larger}px;
        padding-right: ${sellingPointPadding}px;
        padding-bottom: ${sellingPointPadding}px;
      }
      
      
      @media (min-width: ${breakpoints.desktop}px) {
        margin-left: 0px;
        margin-right: -1000px;
      }
    `}
  >
    <span className="language-label">{language}</span>
    <CodeBlock
      language={language}
      code={code}
    />
  </div>;
};

const CallToAction = () => (
  <div
    css={css`
      align-items: center;
      border-top: 1px solid ${({ theme }) => theme.card.border};
      background-color: ${({ theme }) => theme.card.background};
      display: flex;
      flex-direction: column;
      margin-top: ${sellingPointPadding * 1.5}px;
      padding: ${sellingPointPadding}px 0px;
      width: 100%;

      /* Give the last call to action a border */
      border-bottom: 1px solid ${({ theme }) => theme.card.border};
      margin-bottom: -1px;
    `}
  >
    <Container>
      <div
        css={css`
          align-items: center;
          display: flex;
          flex-direction: column;

          a {
            background-color: ${({ theme }) => theme.navbar.background};
            border: 1px solid ${({ theme }) => theme.navbar.text};
            border-radius: 3px;
            color: ${({ theme }) => theme.navbar.text};
            padding: 12px 16px;
            margin: 0 16px;
            letter-spacing: 1px;
            font-size: 16px;
            text-transform: uppercase;
          }
        `}
      >
        <div>
          <Link to="/get-started">Get started</Link>
          <Link to="/docs">Documentation</Link>
        </div>
      </div>
    </Container>
  </div>
);

export const pageQuery = graphql`
  query {
    site {
      siteMetadata {
        docsLocation
      }
    }
    allMdx {
      edges {
        node {
          frontmatter {
            order
          }
          fields {
            url
            title
          }
        }
      }
    }
  }
`;

let title = 'Tablecloth';
let description = 'A portable standard library enhancement for Reason and OCaml.';

let Header = () => {
  let [_themeName, _toggle, theme] = useTheme();
  return (
    <Helmet>
      <title>{title}</title>
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
      <meta name="description" content={description}/>
      <meta property="og:description" content={description}/>
      <meta property="twitter:description" content={description}/>
    </Helmet>
  );
};

let logoTransformations = [

   {
    background: `linear-gradient(${colors.orange.ocaml.start}, ${colors.orange.ocaml.end})`,
    borderRadius: 40,
    resTransform: `translate3d(${logoSize}px,0px,0)`,
    camlTransform: `translate3d(0px, 0px, 0)`,
    fsTransform: `translate3d(${logoSize*2}px, 0px, 0)`,
  },
  {
    // Using hsl colors with useSpring throws an exception during interpolation, so we can't use the ones defined in 'theme'
    background: `linear-gradient(#e74f4f, #c53939)`,
    borderRadius: 60,
    padding: 50,
    resTransform: `translate3d(0px,0px,0)`,
    camlTransform: `translate3d(-${logoSize}px, 0px, 0)`,
    fsTransform: `translate3d(${logoSize}px, 0px, 0)`,
  },
  {
    background: `linear-gradient(#3587b4, #2eb3d4)`,
    borderRadius: 20,
    resTransform: `translate3d(-${logoSize*2}px,0px,0)`,
    camlTransform: `translate3d(-${logoSize}px, 0px, 0)`,
    fsTransform: `translate3d(0px, 0px, 0)`,
  },
]
export default () => {
  let [logo, setLogo] = React.useState(0);
  useEffect(() => {
    let nextLogo = setInterval(() => {
      setLogo(current => (current > 1 ? 0 : current +1 ));
    }, 3000);
    return () => { 
      clearInterval(nextLogo);
    };
  });
  const logoStyles = useSpring(
    logoTransformations[logo]
  );
  return (
    <ThemeProvider>
      <SyntaxProvider>
        <GlobalStyles/>
        <Header/>
        <AppWrapper>
          <ContentContainer>
            <NavBarContainer>
              <NavBar/>
            </NavBarContainer>
            <Main
              css={css`
                align-items: inherit;
              `}
            >
              <div
                css={css`
                  align-items: center;
                  display: flex;
                  flex-direction: column;
                  .illustration {
                    max-height: ${logoSize}px;
                  }
                `}
              >
                <Container>
                  <h1
                    css={css`
                      padding-top: 20px;
                      padding-bottom: 20px;
                      font-size: 50px;
                      font-weight: normal;
                      letter-spacing: 1.1px;
                    `}
                  >
                    Tablecloth
                  </h1>
                  <p>
                    A portable standard library enhancement for Reason and
                    OCaml.
                  </p>
                  <p
                    css={css`
                      padding-top: 30px;
                      padding-bottom: 30px;
                    `}
                  >
                    Tablecloth provides an easy-to-use, comprehensive and safe
                    standard library that has the same API for the OCaml and
                    Bucklescript compilers.
                  </p>
                  <div>
                    <CodeBlock
                      language="reason"
                      code={`
open Tablecloth;

String.toList("Tablecloth")
|> List.filterMap(~f=character => 
  Char.toCode(character)
  |> Int.add(1)
  |> Char.fromCode
)
|> String.fromList
/* "Ubcmfdmpui" */
                `}
                    />
                  </div>
                </Container>
                <CallToAction/>
                <Section
                  flip={true}
                  show={() => <BookLover className="illustration"/>}
                  tell={() => (
                    <>
                      <h2>Easy to learn</h2>
                      <span>
                        Excellent documentation, comprehensive examples and
                        consistent behaviour make Tablecloth efficient to get
                        started with
                      </span>
                    </>
                  )}
                />
                <Section
                  flip={false}
                  show={() => (
                    <CodeSample language="reason" code={`
                      let name = Some("Kubo");
                      let species = Some("dog");
                      let favoriteGame = None;
                      
                      let bio = Option.({
                        let (name, species) = Option.both(name, species);
                        name ++ " the " ++ "'s favorite game is" ++ (favoriteGame |? "fetch");
                      })                                              
                    `}/>
                  )}
                  tell={() => (
                    <>
                      <h2>Safe</h2>
                      <span>
                        Banish runtime errors and work effectively with Options
                        and Results
                      </span>
                    </>
                  )}
                />
                <Section
                  flip={true}
                  show={() => (
                    <animated.div
                      style={{
                        display: 'block',
                        flexShrink: 0,
                        width: logoSize,
                        height: logoSize,
                        background: logoStyles.background,
                        borderRadius: logoStyles.borderRadius,
                        overflow: 'hidden',
                        position: 'relative',
                      }}
                    >
                      <AnimatedRescript
                        style={{
                          padding: "60px",
                          transform: logoStyles.resTransform,
                          position: 'absolute',
                          fill: 'white',
                        }}
                        height={logoSize }
                        width={logoSize }
                      />
                      <AnimatedOCaml
                        style={{
                          transform: logoStyles.camlTransform,
                          position: 'absolute',
                          fill: 'white',
                        }}
                        height={logoSize }
                        width={logoSize }
                      />
                       <AnimatedFSharp
                        style={{
                          padding: "40px",
                          transform: logoStyles.fsTransform,
                          position: 'absolute',
                          fill: 'white',
                        }}
                        height={logoSize }
                        width={logoSize }
                      />
                    </animated.div>
                  )}
                  tell={() => (
                    <>
                      <h2>Portable</h2>
                      <span>
                        Works with either the Reason or OCaml syntax, targeting
                        the Bucklescript, Native or <code>js_of_ocaml</code>{' '}
                        compilers
                      </span>
                    </>
                  )}
                />

                <Section
                  flip={false}
                  show={() => (
                    <CodeSample flip={false} language="ocaml" code={`
                    let nameToSpecies = Map.String.fromList [
                      ("Amy", "Ant");
                      ("Barry", "Badger");
                    ]
                    
                    (* Get a value from a Map by its key *)                     
                    nameToSpecies.Map.?{"Carolyn"} = None
                      
                    (* Extract a Char from a String safely *)
                    "Tablecloth".String.?[1] = Some('a')
                    
                    (* Index into an Array without fear *)
                    [|2;3;5;7|].Array.?(3) = Some(7)
                  `}
                    />
                  )}
                  tell={() => (
                    <>
                      <h2>Advanced</h2>
                      <span>
                        Index operators for Arrays, Maps, Sets and Strings plus
                        binding operators for Options & Results mean your code
                        is concise and expressive
                      </span>
                    </>
                  )}
                />

                <CallToAction/>
              </div>
            </Main>
          </ContentContainer>
        </AppWrapper>
      </SyntaxProvider>
    </ThemeProvider>
  );
};
