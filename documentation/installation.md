---
title: "Installation"
metaTitle: "Installation"
metaDescription: "Installing Tablecloth"
order: "0"
---

## Rescript

Install via npm by

```sh 11
npm install tablecloth-rescript --save
```

Then add to your `bsconfig.json` file:

```json
  "bs-dependencies" : ["tablecloth-rescript"]
```

## OCaml

### Using Opam

```sh
opam install tablecloth-ocaml-base
```

Then update the libraries section in your `dune` file:

```clj
(libraries (tablecloth-ocaml-base))
```

### Using Esy

```sh
esy add @opam/tablecloth-ocaml-base
```

Then update the libraries section in your `dune` file:

```clj
(libraries (tablecloth-ocaml-base))
```
