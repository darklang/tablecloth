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
import { OCaml, Reason } from '../components/Icon';
import { SyntaxProvider } from '../components/Syntax';
import { ArtificialInteligence, BookLover } from '../components/Illustration';

let AnimatedOCaml = animated(OCaml);
let AnimatedReason = animated(Reason);

let logoSize = 180;

let sellingPointPadding = 40;
const Section = ({ tell, show, flip }) => {
  return (
    <section
      flip={flip}
      css={css`
        align-items: center;
        background-color: ${({ flip, theme }) =>
          flip ? theme.card.background : theme.body};
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
                flex: 4;
                padding-left: ${flip ? spacing.largere : 0}px;
                padding-right: ${flip ? 0 : spacing.largere}px;
              }
              .show {
                max-width: 50%;
                flex: 5;
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
          max-width: ${dimensions.maxContentWidth}px;

          a {
            background-color: ${({ theme }) => theme.navbar.background};
            border: 1px solid ${({ theme }) => theme.navbar.text};
            border-radius: 3px;
            color: ${({ theme }) => theme.navbar.text};
            padding: 12px 16px;
            letter-spacing: 1px;
            font-size: 16px;
            /* font-weight: bold; */
            text-transform: uppercase;
          }
        `}
      >
        <div>
          <Link to="/documentation">Get started</Link>
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
      <meta name="title" content={title} />
      <meta property="og:title" content={title} />
      <meta property="twitter:title" content={title} />
      <meta name="description" content={description} />
      <meta property="og:description" content={description} />
      <meta property="twitter:description" content={description} />
    </Helmet>
  );
};

export default () => {
  let [logo, setLogo] = React.useState('reason');
  useEffect(() => {
    let toggleLogo = setInterval(() => {
      setLogo(current => (current === 'reason' ? 'ocaml' : 'reason'));
    }, 3000);
    return () => {
      clearInterval(toggleLogo);
    };
  });

  const logoStyles = useSpring(
    logo === 'reason'
      ? {
          // Using hsl colors with useSpring throws an exception during interpolation
          background: `linear-gradient(#d44f3a, #d44f3a)`,
          borderRadius: 0,
          reTransform: `translate3d(${logoSize / 7}px,${-logoSize / 2.25}px,0)`,
          camlTransform: `translate3d(-${logoSize}px, ${-logoSize /
            1.12}px, 0)`,
        }
      : {
          background: `linear-gradient(${colors.orange.ocaml.start}, ${colors.orange.ocaml.end})`,
          borderRadius: 40,
          reTransform: `translate3d(${logoSize}px, ${-logoSize / 2.25}px, 0)`,
          camlTransform: `translate3d(${0}px, ${-logoSize / 1.12}px,0)`,
        },
  );
  return (
    <ThemeProvider>
      <SyntaxProvider>
        <GlobalStyles />
        <Header />
        <AppWrapper>
          <ContentContainer>
            <NavBarContainer>
              <NavBar />
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
/* "Tuboebse" */
                `}
                    />
                  </div>
                </Container>
                <CallToAction />
                <Section
                  show={() => (
                    <animated.div
                      onClick={() =>
                        setLogo(current =>
                          current === 'ocaml' ? 'reason' : 'ocaml',
                        )
                      }
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
                      <AnimatedReason
                        style={{
                          transform: logoStyles.reTransform,
                          position: 'absolute',
                          fill: 'white',
                        }}
                        height={logoSize * 2}
                        width={logoSize * 2}
                      />
                      <AnimatedOCaml
                        style={{
                          transform: logoStyles.camlTransform,
                          position: 'absolute',
                          fill: 'white',
                        }}
                        height={logoSize * 3}
                        width={logoSize * 3}
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
                  flip={true}
                  show={() => (
                    <ArtificialInteligence className="illustration" />
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
                  flip={false}
                  show={() => (
                    <div
                      css={css`
                        margin-top: -${sellingPointPadding}px;
                        margin-left: -${sellingPointPadding}px;
                        margin-right: -${sellingPointPadding}px;
                        margin-bottom: -${sellingPointPadding}px;
                        pre {
                          padding-top: ${sellingPointPadding}px;
                          padding-left: ${spacing.larger}px;
                          padding-right: ${sellingPointPadding}px;
                          padding-bottom: ${sellingPointPadding}px;
                        }
                        @media (min-width: ${breakpoints.desktop}px) {
                          margin-left: 0;
                          margin-right: -1000px;
                        }
                      `}
                    >
                      <CodeBlock
                        language="ocaml"
                        code={`
                    open Tablecloth

                    let nameToSpecies = Map.String.fromList [
                      ("Alan", "Ant"); 
                      ("Bertie", "Badger");                         
                    ] in
                    let nameToSpecies = 
                      nameToSpecies.Map.?{"Delilah"} <- "Duck" in

                    let hybrid = Option.(
                      let+ delilahSpecies =
                        nameToSpecies.Map.?{"Delilah"} in
                      and+ frankSpecies =
                        nameToSpecies.Map.?{"Frank"} |? "Cat" in
                      delilahSpecies ^ frankSpecies 
                    ) in

                    hybrid = Some "DuckCat"                    
                  `}
                      />
                    </div>
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
                <Section
                  flip={true}
                  show={() => <BookLover className="illustration" />}
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
                <CallToAction />
              </div>
            </Main>
          </ContentContainer>
        </AppWrapper>
      </SyntaxProvider>
    </ThemeProvider>
  );
};
