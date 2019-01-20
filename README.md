# tablecloth

Tablecloth is an ergonomic, cross-platform, standard library for use with OCaml
and ReasonML. It aims to provide an easy-to-use, comprehensive and performant
standard library, that has the same API on all OCaml/ReasonML/Bucklescript
platforms.

## Tablecloth's goals

[Dark](https://darklang.com) uses multiple versions of OCaml on the frontend and backend:
- Our backend is written in OCaml native, using Jane Street Core as a standard
  library
- Our frontend is written in Bucklescript (dba ReasonML)
- Parts of our backend are shared with the frontend by compiling them using
  js\_of\_ocaml, and running them in a web worker.

We discovered that it was impossible to share code between the frontend and the
backend, as the types and standard libraries were very different.

The differences in the standard libraries and coding experience include:
- Bucklescript uses camelCase by default, while most native libraries,
  including Core and the OCaml standard library, use snake\_case.
- The libraries in Belt have different names and function signatures than
  native OCaml and Base/Core.
- Many OCaml libraries have APIs optimized for pipelast (`|>`), while Belt aims
  for pipefirst (`|.`). 
- Core does not work with Bucklescript, while Belt is optimized for the JS
  platform.
- Belt does not work in native OCaml, while Core is optimized for the
  native OCaml runtime.
- Belt is incomplete relative to Core, or to other languages' standard
  libraries (such as Elm).
- Belt makes it challenging to use PPXes.

Tablecloth aims to solve this by providing an API that can be used to write the
same code on the frontend and the backend. It also aims to be fast, and
ergonomic.

## Tablecloth's solution

(As Tablecloth is very early software, this describes the eventual solution.
Entries with a `*` will not be solved on first release). 

Tablecloth provides separate libraries for OCaml native, js\_of\_ocaml, and
bucklescript. The libraries have the same API, but different implementations,
and are installed as different packages.

The APIs:
- include support for strings, lists, numbers, maps, options,
- have both snake\_case and camelCase versions of all functions and types,
- is backed by Jane Street Base (the slimmed down version of Core) for native
  OCaml, and by Belt and the `Js` library for Bucklescript/ReasonML,
- use labelled arguments and can be used with both pipefirst and pipelast,
- \*have efficient algorithms tuned for the platform,
- \*support PPXes
- are copied from Elm, whose standard library is extremely complete and
  well-designed.


## Early compromises

The first version of Tablecloth is translated from Elm using
[philip2](https://github.com/darklang/philip2). As such, I would not expect it
to be particularly fast. Once the initial capability exists, it will be
optimized (contributions welcome).


## How you can help

- Optimize the libraries, preferably by calling out to other well-optimized
  libraries on each platform
- Increase the test coverage by copying suites of tests from other libraries
- Find edge cases, and supply tests and fixes
- Find slow code, and poor memory usage. Add benchmarks (microbenchmarks are
  fine).


