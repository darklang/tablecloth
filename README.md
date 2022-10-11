# Tablecloth

[![CircleCI](https://circleci.com/gh/darklang/tablecloth.svg?style=shield)](https://circleci.com/gh/darklang/tablecloth)
[![Npm](https://badge.fury.io/js/tablecloth-rescript.svg)](https://www.npmjs.com/package/tablecloth-rescript)
[![Opam](https://img.shields.io/badge/opam_package-0.7.0-brightgreen)](https://opam.ocaml.org/packages/tablecloth-ocaml-base)

Tablecloth is a library that shims over various standard libraries so they have the same function and module names, which using idiomatic types and patterns in each language.

Supports:
- OCaml (using Base, pipe-last, labels, and snake_case)
- Rescript (uses Belt, pipe-first, and camelCase)
- F# (in development - uses FSharp.Core, pipe-last, and camelCase)
- Elm (just in the sense that it is extremely similar to Elm's standard libraries)

**Tablecloth is alpha-quality software, and is pre-1.0. It is currently undergoing
some significant shifts and some libraries listed below are not available yet. 
Caveat emptor.**

Check out the [website](https://tablecloth.dev) for our interactive API documentation.

## Installation

**Note: these instructions are for the upcoming new version of tablecloth**

### Rescript

Install via npm by:

`npm install tablecloth-rescript`

Then add to your `bsconfig.json` file:

`"bs-dependencies" : ["tablecloth-rescript"]`

### OCaml native

Install via opam:

`opam install tablecloth-ocaml-base`

Then add to your dune file:

`(libraries (tablecloth-ocaml-base ...))`

## Usage

The recommended way to use Tablecloth is with a top-level open at the beginning of a file.

This will ensure that all the built-in modules are replaced.

```
open Tablecloth

let () =
  String.toList "somestring"
  |> List.map ~f:Char.toCode
  |> List.map ~f:(fun x -> x+1)
  |> List.filterMap ~f:Char.fromCode
  |> String.fromList
```

## Supported versions

### Rescript

Tablecloth supports Rescript 9. Older versions of Tablecloth supported older versions of bs-platform.

### Native

Tablecloth for native OCaml supports OCaml 4.08-4.10 and Base
v0.12.2/v0.13.2. We are open to supporting other versions:

- OCaml 4.11 is believed to work but is not officially supported as there is no
  docker container for it in CI.
- OCaml 4.06 and 4.07 require small tweaks to our build system
- Base v0.9, v0.10, and v0.11 require small code changes
- Base v0.14 require small dependency tweaks

### Development

When developing Tablecloth, you can test it against different versions of
rescript, OCaml (native) and Base, using the following commands:

- `TC_RESCRIPT_VERSION=7.1.1 make deps-rescript`
- `TC_BASE_VERSION=v0.14.0 TC_NATIVE_OCAML_SWITCH=4.11.0 make deps-native`

## Design goals of Tablecloth

When switching between functional languages, it can be frustrating to try to 
remember the names of different functions, which are not standardized and differ
due to history.

At the same time, we recognize that each language has their own idioms, and 
often have mature and optimized standard libraries that we do not wish to replace.
As such, each version of tablecloth is simple a set of functions which call existing
standard libraries, and uses idiomatic patterns for the language in question.

Tablecloth was originally written to help port the Darklang frontend from Elm to
ReasonML. As we used OCaml on the backend, we tried to reuse some libraries by adding
OCaml versions of the ReasonML functions. However, code reuse was difficult and never
took off, and we ended up splitting the two libraries when the ReasonML community
moved to Rescript, which did not have the goal to be compatible with OCaml. When we
ported the backend from OCaml to F#, we added an F# version.

## Contributions

The maintainers are warm and friendly, and the project abides by a [Code of Conduct](./CODE_OF_CONDUCT.md).

There are many small tasks to be done - a small change to a single function can be extremely
helpful. We also welcome new versions of tablecloth for other languages, or even for the same
language but based on other libraries.

Check out the [dedicated guide](./documentation/contributing.md) on contributing for more.

## Developing

If you are new to [OCaml](https://ocaml.org) there are a few prerequisites you will
need to get started:

- Install OCaml and OPAM [based on your OS](https://ocaml.org/docs/install.html)
- You may need to run `opam init`
- For Rescript install a current version of [Node](https://nodejs.org/en/)

Please refer to the `Makefile` for a complete list of supported actions. Here is
a handful of useful, supported commands:

- `make deps-native`: Install OCaml dependencies.
- `make deps-rescript`: Install Rescript dependencies.
- `make build`: Build the project.
- `make test`: Run the test suite. You may need to `make build` first.
- `make check-format`: Check your code is formatted correctly.
- `make format`: Format code.
- `cd ocamldoc-json-generator && make deps && make doc`: Build model.json for the website (needs to be updated and checked in whenever the APIs change.)

## License

Tablecloth uses the [MIT](./LICENSE) license.

## Authors

Initially written by [Darklang](https://darklang.com).
