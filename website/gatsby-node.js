const chokidar = require('chokidar');
const crypto = require('crypto');
const fs = require('fs');
const path = require("path");

exports.createPages = ({ graphql, actions }) => {
  const { createPage, createRedirect } = actions;

  createRedirect({
    fromPath: '/get-started',
    toPath: '/get-started/installation',
    redirectInBrowser: true,
  })
  createRedirect({
    fromPath: '/docs',
    toPath: '/docs/rescript',
    redirectInBrowser: true,
  })

  return new Promise((resolve, reject) => {
    resolve(
      graphql(
        `
          {
            allMdx {
              edges {
                node {
                  fields {
                    id
                  }
                  tableOfContents
                  fields {
                    url
                  }
                }
              }
            }
          }
        `
      ).then(result => {
        if (result.errors) {
          reject(result.errors);
        }

        result.data.allMdx.edges.forEach(({ node }) => {
          createPage({
            path: node.fields.url,
            component: path.resolve("./src/templates/get-started.js"),
            context: {
              id: node.fields.id
            }
          });
        });
      })
    );
  });
};

exports.onCreateNode = ({ node, getNode, actions }) => {
  const { createNodeField } = actions;

  if (node.internal.type === `Mdx`) {
    const parent = getNode(node.parent);
    createNodeField({
      name: `url`,
      node,
      value: `/get-started/${parent.relativePath.replace(parent.ext, "")}`
    });

    createNodeField({
      name: "id",
      node,
      value: node.id
    });

    createNodeField({
      name: "title",
      node,
      value: node.frontmatter.title || (parent.name)
    });

    createNodeField({
      name: 'order',
      node,
      value: node.frontmatter.order || '999',
    });
  }
};

// refmt does a `require('fs')` but doesn't actually use the module,
// prevent this from causing an error by mocking the module
// https://www.npmjs.com/package/reason#javascript-api
exports.onCreateWebpackConfig = ({ actions }) => {
  actions.setWebpackConfig({
    node: {
      fs: 'empty',
    },
  });
};


let log = {
  info: (...rest) => console.info('[odoc]', ...rest),
};

let createNodeFromModel = (id, model) => ({
  id,
  internal: {
    type: 'OdocModel',
    contentDigest: crypto
      .createHash(`md5`)
      .update((model))
      .digest(`hex`),
    mediaType: `application/json`,
    content: (model),
  },
});

const inDevelopMode = process.env.gatsby_executing_command === 'develop';

exports.sourceNodes = ({ actions }) => {
  const { createNode } = actions;
  let nativeModelPath = path.resolve(__dirname, `./model.json`);
  let rescriptModelPath = path.resolve(__dirname, `./model-rescript.json`);
  if (nativeModelPath == null || rescriptModelPath == null) {
    throw new Error(`Invalid model path`);
  }
  log.info('nativeModelPath', nativeModelPath);
  log.info('rescriptModelPath', rescriptModelPath);

  let removeSpacesFromJSON = (string) => JSON.stringify(JSON.parse(string))
  let readModel = (name) =>  removeSpacesFromJSON(fs.readFileSync(name).toString());
  

  let nativeNode = () => createNodeFromModel("odoc-model-native", readModel(nativeModelPath));
  let resciptNode = () => createNodeFromModel("odoc-model-rescript", readModel(rescriptModelPath));

  createNode(nativeNode());
  createNode(resciptNode());

  if (inDevelopMode) {
    log.info('watch mode enabled, listening for changes');
    chokidar.watch(nativeModelPath).on('all', (event, path) => {
      log.info(event);
      if (event == 'unlink') {
        return
      }
      createNode(nativeNode());
      createNode(resciptNode());
    });
  }

  return Promise.resolve();
};