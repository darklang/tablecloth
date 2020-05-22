---
title: "Motivation & Goals"
order: "3"
---

# Why another standard library?

OCaml already has a standard library, Bucklescript ships with [Belt](https://bucklescript.github.io/bucklescript/api/Belt.html) and on the native side we have [Base](https://opensource.janestreet.com/base/). 

So why create another standard library?

## Where are all the functions?

OCaml's standard library is sparse and moves very slowly to avoid causing churn for its long time users.

This means that some relics are around and it doesn't take advantage of language features like [labelled arguments](https://caml.inria.fr/pub/docs/manual-ocaml/lablexamples.html#s%3Alabels), [index operators](https://caml.inria.fr/pub/docs/manual-ocaml/indexops.html) or [binding operators](https://caml.inria.fr/pub/docs/manual-ocaml/bindingops.html).

Tablecloth embraces these features and provides a much more capable baseline.

## Safety first

OCaml's standard library throws lots of exceptions.

Part of the reason for this is on the native side exceptions use some [clever tricks](https://stackoverflow.com/questions/8564025/ocaml-internals-exceptions#answer-8567429) which makes them extremely fast.

The other part of the reason is that Option and Result have only recently managed to get their own modules.

In Tablecloth, functions that can raise exceptions are not the default.

The functions which do are well documented with an "Exceptions" section in their documentation and the name almost always has "Unsafe".

## Modules, Modules, Modules

OCaml has a great module system, but the standard library doesn't make great use of it.

Functions like `string_of_int` and `fst` live in the top level, meaning they have to encode extra information in their name (like `string_of_int`) or be generally confusing (what does `fst` operate on?).

Almost everything in Tablecloth lives in module, which means functions like
`string_of_int` or `fst` are now available in `Int.toString` or `Tuple.first` respectively.

## How does it work?

The standard library, Belt and Base all suffer in the documentation department.

Examples are few and far between and the one-line docstrings often require a pen and paper to decode.

Tablecloth aims to be much easier to learn with thorough documentation and plenty of examples. Plus, being able to [search the api](/api) makes finding this information much easier.

- High quality documentation and examples
- Well-documented and consistent edge-case behaviour

## Portability

We discovered that it was impossible to share code between the Bucklescript
frontend and the native OCaml backend, as the types and API the standard libraries provide are very different.

Tablecloth aims to reduce the friction encountered by providing a common API with compiler specific implementations that take advantage of each platform's strengths.

It utilises existing libraries for each platform. 

The native side is backed by [Base](https://opensource.janestreet.com/base/) and Bucklescript is backed by its bundled Belt and `Js` modules which means Tablecloth is fast and memory efficient.
