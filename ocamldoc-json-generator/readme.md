# Ocamldoc Json Generator

JsonGenerator.ml is responsible for taking the `/native` and `/rescript` source files and turning them into json files (`website/model.json` and `website/model-rescript.json`) which the website project then turns into the `/api` page.

## Setup
To generate both native and rescript versions we'll need (esy)[https://esy.sh/docs/en/getting-started.html]. 
Since esy can't link local npm projects (`tablecloth-bucklescript`) we should copy the files ourselves.

```
mkdir ocamldoc-json-generator/node_modules
mkdir ocamldoc-json-generator/node_modules/tablecloth-bucklescript
cp package.json ocamldoc-json-generator/node_modules/tablecloth-bucklescript
cp bsconfig.json ocamldoc-json-generator/node_modules/tablecloth-bucklescript
cp -r ./rescript ocamldoc-json-generator/node_modules/tablecloth-bucklescript/rescript
```

Next, install dependancies
```
esy
```

Then build the project files

```sh
make deps
```

## Usage

After making any changes to interface files run `make doc` to regenerate `website/model.json` and `website/model-rescript.json`.