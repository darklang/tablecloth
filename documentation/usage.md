---
title: "Usage"
order: "1"
---

The recommended way to use Tablecloth is with a top-level open at the beginning of a file.

This will ensure all the built-in modules are replaced.

```reason
open Tablecloth;

String.toList("Tablecloth")
->List.filterMap(~f=character =>
  Char.toCode(character)->Int.add(1)->Char.fromCode
)
->String.fromList
```

## Automatic opening

To avoid having to write `open Tablecloth` at the top of every file, you can pass a compiler flag to do this automatically for you.
How this is configured depends on your build system.

### With Rescript

In `bsconfig.json` edit the `bsc-flags` array to look like the following:

```json
"bsc-flags": [
  "-open",
  "Tablecloth",
  // ...
]
```

### With OCaml + Esy

In `package.json` / `esy.json` edit the `esy.flags` array to look like the following:

```json
"esy": {
  "flags": [
    "-open",
    "Tablecloth"
  ],
}
```

### With OCaml + Dune

https://dune.readthedocs.io/en/stable/concepts.html#ocaml-flags

```
(library
 (name example-library)
 (libraries tablecloth-native)
 (flags (:open Tablecloth)))
 ```

