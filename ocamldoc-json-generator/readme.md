# Ocamldoc Json Generator

JsonGenerator.ml is responsible for taking the `/native` and `/rescript` source files and turning them into json files (`website/model.json` and `website/model-rescript.json`) which the website project then turns into the `/api` page.

## Setup
To generate both native and rescript versions we'll need (esy)[https://esy.sh/docs/en/getting-started.html]. 
Since esy can't link local npm projects (our `rescript` folder with `tablecloth-bucklescript` lib) we should copy the files ourselves. To do this, run:

```
make init-node
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