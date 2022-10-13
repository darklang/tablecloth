# Website

The documentation site run [gatsby]() and sources its content from:

- `src/index.js` for the landing page
- The markdown files in `/documentation`, which have their order determined by the metadata at the top of each file
- `src/api.js` generates the documentation via `/website/model.json`

## Developing

- `npm install`
- `npm start`

## Deployment

Deployment happens automatically when pushing to the `main` branch
