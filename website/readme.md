# Website

The documentation site run [gatsby]() and sources its content from  :
- `src/index.js` for the landing page
- The markdown files in `/documentation`, which have their order determined by the metadata at the top of each file
- `src/api.js` generates the documentation via `/website/model.json` (see [ocamldoc-json-generator/readme.md](ocamldoc-json-generator/readme.md) for how this file is created)  

## Developing

- `npm install`
- `npm start`

## Deployment

Deployment happens automatically when pushing to the `master` branch