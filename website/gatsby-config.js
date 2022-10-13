const path = require('path');

module.exports = {
  pathPrefix: '/',
  assetPrefix: 'https://DARK_STATIC_ASSETS_BASE_URL',
  siteMetadata: {
    title: 'Tablecloth',
    description:
      'An standard library with the same API in F#, Rescript, and OCaml',
    docsLocation:
      'https://github.com/darklang/tablecloth/tree/main/documentation',
    githubUrl: 'https://github.com/darklang/tablecloth',
    siteUrl: 'https://www.tablecloth.dev',
  },
  plugins: [
    {
      resolve: '@sentry/gatsby',
      options: {
        dsn: 'https://18433ba9734949298cdd886562340d24@o4503977192652800.ingest.sentry.io/4503977196519424',
        sampleRate: 0.7,
      },
    },
    'gatsby-plugin-remove-trailing-slashes',
    'gatsby-plugin-styled-components',
    'gatsby-plugin-sitemap',
    'gatsby-plugin-sharp',
    'gatsby-plugin-react-helmet',
    {
      resolve: 'gatsby-source-filesystem',
      options: {
        name: 'documentation',
        path: path.resolve(__dirname, `../documentation`),
      },
    },
    {
      resolve: 'gatsby-plugin-mdx',
      options: {
        gatsbyRemarkPlugins: [
          {
            resolve: 'gatsby-remark-images',
            options: {
              maxWidth: 1035,
              sizeByPixelDensity: true,
            },
          },
          {
            resolve: 'gatsby-remark-copy-linked-files',
          },
        ],
        extensions: ['.mdx', '.md'],
      },
    },
    {
      resolve: `gatsby-plugin-gtag`,
      options: {
        trackingId: 'UA-11024491-3',
        anonymize: false,
      },
    },
  ],
};
