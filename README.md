# Tablecloth

[![CircleCI](https://circleci.com/gh/darklang/tablecloth.svg?style=shield)](https://circleci.com/gh/darklang/tablecloth)

Tablecloth is a set of libraries for different functional languages, which each have
the same function names, making it easier to move between languages.

There are currently implementations for:
- [Rescript](https://github.com/darklang/tablecloth-rescript)
- [OCaml](https://github.com/darklang/tablecloth-ocaml-base)
- [F#](https://github.com/darklang/tablecloth-fsharp)
- Elm - the API is extremely similar to the Elm standard library

Each implementation:
- supports the same function and module names
  - names are adapted for `camelCase` or `snake_case`, as appropriate
- is idiomatic to the language it's in
  - uses standard types
  - follows language best practices (eg the OCaml version uses labels, but the Rescript version does not)
  - uses standard tooling and packaging
- is licensed in the normal way
- has a [code of conduct](./CODE_OF_CONDUCT.md)
- has friendly maintainers

**Tablecloth is alpha-quality software, and is pre-1.0. Some of the changes listed
above are still in progress. Caveat emptor.**

Check out the [website](https://www.tablecloth.dev) for our interactive API
documentation, or join the community in the [Tablecloth
Discord](https://www.tablecloth.dev/discord-invite).


## Design goals

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
ported the backend from OCaml to F#, we added an F# version. At this point we
realized the real value was not in having portable code, but rather in having the
same function names everywhere.

## Contributions

The maintainers are warm and friendly, and the project abides by a [Code of
Conduct](./CODE_OF_CONDUCT.md).

Check out the [dedicated guide](./documentation/contributing.md) on contributing for more.

## License

Tablecloth uses the [MIT](./LICENSE) license. Implementations of Tablecloth should
use the standard licenses used by libraries in their language's ecosystem.

## Authors

Initially written by [Darklang](https://darklang.com).