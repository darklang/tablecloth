---
title: "Developing"
order: "6"
---

There are a few prerequisites you will need to get started:

Install a current version of:

- [node](https://nodejs.org/en/)
- [esy](http://esy.sh)

Then what you need to do depends on the component you will be working on.

## bucklescript

In the repository root run 

```sh
npm install
```

Then see `scripts` in `package.json`

## native

In the repository root directory run 

```sh
esy install
```

Then see `scripts` in `esy.json`

## website

In the `website` directory run 

```sh
npm install
```

Then see `scripts` in `website/package.json`


## Running tests

The tests files are located in `bucklescript/test` and **run against both platforms**.

They are run against the native codebase via some dune rules in `native/test/dune`.

