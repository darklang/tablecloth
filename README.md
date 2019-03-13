# tablecloth

Tablecloth is an ergonomic, cross-platform, standard library for use with OCaml
and ReasonML. It provides an easy-to-use, comprehensive and performant standard
library, that has the same API on all OCaml/ReasonML/Bucklescript platforms.

**Tablecloth is alpha-quality software, and is pre-1.0. The API will change
over time as we get more users. Caveat emptor.**

## Installation

### Bucklescript

Install via npm by:

`npm install --save-dev tablecloth-bucklescript`

Then add to your bsconfig.json file:

`  "bs-dependencies" : ["tablecloth-bucklescript"]`

### OCaml native

Install via opam:

`opam install tablecloth-native`

Then add to your dune file:

`  (libraries (tablecloth-native ...))`

### js_of_ocaml

We have not built a js\_of\_ocaml specific version yet. However, the native version should work perfectly with js\_of\_ocaml.

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


## Design of Tablecloth

[Dark](https://darklang.com) uses multiple versions of OCaml on the frontend
and backend:
- Our backend is written in OCaml native, using Jane Street Core as a standard
  library
- Our frontend is written in Bucklescript (dba ReasonML)
- Parts of our backend are shared with the frontend by compiling them using
  js\_of\_ocaml, and running them in a web worker.

We discovered that it was impossible to share code between the Bucklescript
frontend and the OCaml backend, as the types and standard libraries were very
different:
- Bucklescript uses camelCase by default, while most native libraries,
  including Core and the OCaml standard library, use snake\_case.
- The libraries in Belt have different names and function signatures than
  native OCaml and Base/Core.
- Many OCaml libraries have APIs optimized for pipelast (`|>`), while Belt aims
  for pipefirst (`|.`). 
- Core does not work with Bucklescript, while Belt is optimized for the JS
  platform.
- Belt does not work in native OCaml, while Core is optimized for the native
  OCaml runtime.
- Belt is incomplete relative to Core, or to other languages' standard
  libraries (such as Elm).
- Belt makes it challenging to use PPXes.


### Tablecloth's solution

Tablecloth solves this by providing an identical API for Bucklescript and
OCaml. It wraps existing standard libraries on those platforms, and so is fast
and memory efficient. It is based off Elm standard library, which is extremely
well-designed and ergonomic.

Tablecloth provides separate libraries for OCaml native, js\_of\_ocaml, and
Bucklescript. The libraries have the same API, but different implementations,
and are installed as different packages.

The APIs:
- are taken from Elm's standard library, which is extremely complete and
  well-designed.
- include support for strings, lists, numbers, maps, options, and results,
- have both snake\_case and camelCase versions of all functions and types,
- are backed by Jane Street Base (the slimmed down version of Core) for native
  OCaml
- are backed by Belt and the `Js` library for Bucklescript/ReasonML,
- use labelled arguments so that can be used with both pipefirst and pipelast,

We also have design goals that are not yet achieved in the current version. The APIs:
- should have efficient algorithms tuned for the platform,
- should support PPX derivers,
- should not throw any exceptions,
- should be well documented, with well-known and consistent edge-case behaviour,
- should be well tested,
- should have a js\_of\_ocaml optimized version.


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
- design an Array module,
- design escape hatches, where the user could convert a `t` into a
  platform-specific type, to allow them create functions we do not currently
  support,
- add a js\_of\_ocaml-optimized version,
- add a Caml namespace to allow users to access the builtin OCaml library
  functions
- add a Tuple3 module
- add more functions from any of Elm's core library: String, List, Result,
  Maybe, Array, Dict, Set, Tuple, or Basics, or from any of the Extras
  libraries.

If you'd like to contribute but don't know where to start, [open an
issue](https://github.com/darklang/tablecloth/issues/new) with your thoughts,
or contact us on [Twitter](https://twitter.com/paulbiggar) or by
[email](mailto:paul.biggar@gmail.com).

## License

Tablecloth uses the [MIT](./LICENSE) license. Some functions are based on
Elm/core ([BSD](https://github.com/elm/core/blob/1.0.0/LICENSE)), and from the
\*.Extra packages in elm-community, which use a
[BSD](https://github.com/elm-community/string-extra/blob/master/LICENSE)
license.

## Authors

Written by [Dark](https://darklang.com). We may be [hiring](https://darklang.com/careers).

