---
title: "Installation"
metaTitle: "Installation"
metaDescription: "Installing Tablecloth"
order: "0"
---

## Rescript

Install via npm by

```sh 11
npm install tablecloth-bucklescript --save
```

Then add to your `bsconfig.json` file:

```json
  "bs-dependencies" : ["tablecloth-bucklescript"]
```

## OCaml

### Using Opam

```sh
opam install tablecloth-native
```

Then update the libraries section in your `dune` file:

```clj
(libraries (tablecloth))
```

### Using Esy

```sh
esy add @opam/tablecloth-native
```

Then update the libraries section in your `dune` file:

```clj
(libraries (tablecloth))
```
