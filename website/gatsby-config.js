const path = require('path')

module.exports = {
  pathPrefix: "/",
  assetPrefix: "https://DARK_STATIC_ASSETS_BASE_URL",
  siteMetadata: {
    title: 'Tablecloth',
    description: 'A standard library enhancement for Bucklescript and Native',
    docsLocation: 'https://github.com/darklang/tablecloth/tree/master/documentation',
    githubUrl: 'https://github.com/darklang/tablecloth',
    siteUrl: 'https://tablecloth.github.io',
  },
  plugins: [
    {
      resolve: 'gatsby-plugin-sentry',
      options: {
        dsn: 'https://702b0527aa914b4197bbd3eefa1eb460@sentry.io/2461811',
        environment: process.env.NODE_ENV,
        enabled: ['production', 'stage'].indexOf(process.env.NODE_ENV) !== -1,
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
