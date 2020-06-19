# Tablecloth

[![CircleCI](https://circleci.com/gh/darklang/tablecloth.svg?style=shield)](https://circleci.com/gh/darklang/tablecloth)
[![Npm](https://badge.fury.io/js/tablecloth.svg)](https://www.npmjs.com/package/tablecloth-bucklescript)
[![Opam](https://img.shields.io/badge/opam_package-0.7.0-brightgreen)](https://opam.ocaml.org/packages/tablecloth-native)

Tablecloth is an ergonomic, cross-platform, standard library for use with OCaml
and ReasonML. It provides an easy-to-use, comprehensive and performant standard
library, that has the same API on all OCaml/ReasonML/Bucklescript platforms.

**Tablecloth is alpha-quality software, and is pre-1.0. The API will change
over time as we get more users. Caveat emptor.**

See the [website](TODO) for the documentation.

## Installation

### Bucklescript

Install via npm by:

`npm install tablecloth-bucklescript`

Then add to your `bsconfig.json` file:

`"bs-dependencies" : ["tablecloth-bucklescript"]`

### OCaml native

Install via opam:

`opam install tablecloth-native`

Then add to your dune file:

`(libraries (tablecloth-native ...))`

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

## Design of Tablecloth

[Dark](https://darklang.com) uses multiple versions of OCaml on the frontend
and backend:

- Our backend is written in OCaml native, using [Jane Street Core](https://github.com/janestreet/core) as a standard
  library
- Our frontend is written in [Bucklescript](https://bucklescript.github.io/) (dba [ReasonML](https://reasonml.github.io/))
- Parts of our backend are shared with the frontend by compiling them using
  js_of_ocaml, and running them in a web worker.

We discovered that it was impossible to share code between the Bucklescript
frontend and the native OCaml backend, as the types and standard libraries were
very different:

- Bucklescript uses camelCase by default, while most native libraries,
  including Core and the OCaml standard library, use snake_case.
- The libraries in [Belt](https://bucklescript.github.io/bucklescript/api/index.html) have different names and function signatures than native OCaml and Base/Core.
- Many OCaml libraries have APIs optimized for pipelast (`|>`), while Belt aims
  for pipefirst (`|.`).
- Core does not work with Bucklescript, while Belt is optimized for the JS
  platform.
- Belt does not work in native OCaml, while Core is optimized for the native
  OCaml runtime.
- Belt is incomplete relative to Core, or to other languages' standard libraries

### Tablecloth's solution

Tablecloth solves this by providing an identical API for Bucklescript and
OCaml. It wraps existing standard libraries on those platforms, and so is fast
and memory efficient. It is draws inspiration from [Elm's standard library](https://package.elm-lang.org/packages/elm/core/1.0.2/), which is extremely
well-designed and ergonomic.

Tablecloth provides separate libraries for OCaml native/js_of_ocaml and
Bucklescript. The libraries have the same API, but different implementations,
and are installed as different packages.

The APIs:

- have both snake_case and camelCase versions of all functions and types
- are backed by [Jane Street Base](https://opensource.janestreet.com/base/) for native OCaml
- are backed by Belt and the `Js` library for Bucklescript/ReasonML
- use labelled arguments so that can be used with both pipefirst (`->`) and pipelast (`|>`)
- are well documented, and reasonably-well tested

We also have design goals that are not yet achieved in the current version:

- Many of the functions could be much more efficient
- Tablecloth functions should not throw any exceptions
- All functions should have well-known and consistent edge-case behaviour

## Contributing

Tablecloth is an ideal library to contribute to, even if you're new to OCaml or Reason. 

The maintainers are warm and friendly, and the project abides by a [Code of Conduct](./CODE_OF_CONDUCT.md). 

There are many small tasks to be done - a small change to a single function can be extremely
helpful.

Check out the [dedicated guide](./documentation/contributing.md) on contributing for more.

## Developing

If you are new to [OCaml](https://ocaml.org) there are a few prerequisites you will
need to get started:

- Install OCaml and OPAM [based on your OS](https://ocaml.org/docs/install.html)
- You may need to run `opam init`
- For Bucklescript install a current version of [Node](https://nodejs.org/en/)

Please refer to the `Makefile` for a complete list of supported actions. Here is
a handful of useful, supported commands:

- `make deps-native`: Install native dependencies.
- `make deps-bs`: Install bs dependencies.
- `make build`: Build the project.
- `make test`: Run the test suite. You may need to `make build` first.
- `make documentation`: Build the documentation to browse offline.

## License

Tablecloth uses the [MIT](./LICENSE) license. Some functions are based on
Elm/core ([BSD](https://github.com/elm/core/blob/1.0.0/LICENSE)), and from the
\*.Extra packages in elm-community, which use a
[BSD](https://github.com/elm-community/string-extra/blob/master/LICENSE)
license.

## Authors

Written with the help of [Dark](https://darklang.com). We may be [hiring](https://darklang.com/careers).
