# tablecloth

Tablecloth is an ergonomic, cross-platform, standard library for use with OCaml
and ReasonML. It provides an easy-to-use, comprehensive and performant standard
library, that has the same API on all OCaml/ReasonML/Bucklescript platforms.

**Tablecloth is alpha-quality software, and is pre-1.0. The API will change
over time as we get more users. Caveat emptor.**

See the [mli](https://github.com/darklang/tablecloth/blob/master/bs/src/tablecloth.mli) for documentation.

## Installation

### Bucklescript

Install via npm by:

`npm install tablecloth-bucklescript`

Then add to your bsconfig.json file:

`"bs-dependencies" : ["tablecloth-bucklescript"]`

### OCaml native

Install via opam:

`opam install tablecloth-native`

Then add to your dune file:

`(libraries (tablecloth-native ...))`

### js_of_ocaml

We have not built a js_of_ocaml specific version yet. However, the native version should work perfectly with js_of_ocaml.

## Usage

By design, the usage of the libraries is the same on all platforms:

Either open the module, and replace the builtin modules

```
open Tablecloth

let () =
  "somestring"
  |> String.toList
  |> List.map ~f:Char.toCode
  |> List.map ~f:(fun x -> x+1)
  |> List.map ~f:Char.fromCode
  |> String.fromList
```

Or use the fully qualified names:

```
let () =
  "somestring"
  |> Tablecloth.String.toList
  |> Tablecloth.List.map ~f:Char.toCode
  |> Tablecloth.List.map ~f:(fun x -> x+1)
  |> Tablecloth.List.map ~f:Char.fromCode
  |> Tablecloth.String.fromList
```

As tablecloth is still in the early stages, you might find it useful to create
a module wrapping tablecloth, that allows you make changes to it before
upstreaming them. We have [an
example](https://github.com/darklang/tablecloth/blob/master/examples/tc.ml)
that you can copy from.

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
- Belt is incomplete relative to Core, or to other languages' standard
  libraries (such as [Elm's](https://package.elm-lang.org/packages/elm/core/1.0.2/)).
- Belt makes it challenging to use [PPXes](https://github.com/ocaml-ppx).

### Tablecloth's solution

Tablecloth solves this by providing an identical API for Bucklescript and
OCaml. It wraps existing standard libraries on those platforms, and so is fast
and memory efficient. It is based off the Elm standard library, which is extremely
well-designed and ergonomic.

Tablecloth provides separate libraries for OCaml native/js_of_ocaml and
Bucklescript. The libraries have the same API, but different implementations,
and are installed as different packages.

The APIs:

- are taken from [Elm's standard library](https://package.elm-lang.org/packages/elm/core/1.0.2/), which is extremely complete and well-designed.
- include support for strings, lists, numbers, maps, options, and results,
- have both snake_case and camelCase versions of all functions and types,
- are backed by [Jane Street Base](https://opensource.janestreet.com/base/) for native OCaml
- are backed by Belt and the `Js` library for Bucklescript/ReasonML,
- use labelled arguments so that can be used with both pipefirst and pipelast,
- are well documented, and reasonably-well tested.

We also have design goals that are not yet achieved in the current version:

- Many of the functions in the Bucklescript version were written hastily, and could be much more efficient
- Tablecloth libraries should support PPX derivers,
- Tablecloth functions should not throw any exceptions,
- All functions should have well-known and consistent edge-case behaviour,
- There should versions optimized for other standard libraries or runtimes, such as a js_of_ocaml, [Batteries](https://github.com/ocaml-batteries-team/batteries-included) or [Containers](https://github.com/c-cube/ocaml-containers).

## Contributing

Tablecloth is an ideal library to contribute to, even if you're new to OCaml or
new to writing algorithms. The maintainers are warm and friendly, and the
project abides by a [Code of Conduct](./CODE_OF_CONDUCT.md). There are many
small tasks to be done - a small change to a single function can be extremely
helpful.

Here are some ways to contribute:

- point out inconsistencies between different functions in the library,
- point out an inelegant function signature which could be improved,
- point out a way in which the library or any of its parts are confusing,
- report an edge-case or performance problem in one of the functions,
- add a small test for an edge-case of one of the functions,
- copy test cases for a function from another language's standard library,
- add documentation to a function,
- improve a function's documentation by discussing an edge-case,
- check that a function cannot throw exceptions (and add a note to the function
  documentation to that effect),
- optimize a function (the Bucklescript functions in particular),
- write a benchmark for a function, or a set of functions,
- make a plan for the addition (or not) of U-suffixed functions like in Belt,
- make a plan for adding polymorphic Maps and Sets,
- design a Regex module,
- design escape hatches, where the user could convert a `t` into a
  platform-specific type, to allow them create functions we do not currently
  support,
- add more functions from any of Elm's core library: String, List, Result,
  Maybe, Array, Dict, Set, Tuple, or Basics, or from any of the Extras
  libraries.

If you'd like to contribute but don't know where to start, [open an
issue](https://github.com/darklang/tablecloth/issues/new) with your thoughts,
or contact us on [Twitter](https://twitter.com/paulbiggar) or by
[email](mailto:paul.biggar@gmail.com).

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

Written by [Dark](https://darklang.com). We may be [hiring](https://darklang.com/careers).
