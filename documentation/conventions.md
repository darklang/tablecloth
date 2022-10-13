---
title: "Conventions"
order: "2"
---

## t is the main type of a module

In Rescript, OCaml and F#, it is a convention for the primary type of a module to be named `t`.

This means that when you want to refer to a type without `open`ing a module you don't end up repeating yourself:

```rescript
let food: String.string = /* ... */

/* compared to */

let email: String.t = /* ... */
```

## Function suffixes

Some functions come in multiple flavors.

Some of these flavors are so common they are distinguished by a really short suffix.

### ___2 is an alternative behaviour

When a function could behave in slightly different ways, but we want to provide the functionality of both, one of the implementations gets a two stuck on the end.

The best example of this is [`Float.atan2`](/api#Float.atan2)

### ___Unsafe means "could raise an exception"

Some functions have 'unsafe' versions which instead of returning an [`Option`](/api#Option) or a [`Result`](/api#Result) could raise an exception.

Sometimes this can be for performance, and sometimes you just need an escape hatch.

See [`Option.get`](/api#Option.get) and [`Option.getUnsafe`](/api#Option.getUnsafe)
