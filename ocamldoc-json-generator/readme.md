# Ocamldoc Json Generator

JsonGenerator.ml is responsible for taking the `/native` source files and turning them into a single json file (`website/model.json`) which the website project then turns into the `/api` page.

## Usage

After making any changes to interface files run `make doc` to regenerate `model.json` 