---
title: "Installation"
metaTitle: "Installation"
metaDescription: "Installing Tablecloth"
order: "0"
---

## Bucklescript

Install via npm by

```sh 11
npm install tablecloth-bucklescript --save
```

Then add to your `bsconfig.json` file:

```json
  "bs-dependencies" : ["tablecloth-bucklescript"]
```

## OCaml native

### Using Opam

```sh
opam install tablecloth-native
```

Then update the libraries section in your `dune` file:

```clj
(libraries (standard))
```

### Using Esy

```sh
esy add @opam/tablecloth-native
```

Then update the libraries section in your `dune` file:

```clj
(libraries (standard))
```
