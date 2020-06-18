# Ocamldoc Json Generator

JsonGenerator.ml is responsible for taking the `/native` source files and turning them into a single json file (`website/model.json`) which the website project then turns into the `/api` page.

## Setup

The generator requires version 4.08 of the ocaml compiler
```
opam switch create 4.08
```

Then install the dependencies

```sh
opan install reason menhir
```

## Usage

After making any changes to interface files run `make doc` to regenerate `website/model.json` 