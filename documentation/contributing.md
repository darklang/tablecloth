---
title: "Contributing"
order: "4"
---

Tablecloth is an ideal library to contribute to, even if you're new to the languages.

The maintainers are warm and friendly, and each project abides by a [Code of Conduct](../CODE_OF_CONDUCT.md).

There are many small tasks to be done and small changes can be valuable.

Here are some ways to contribute:

- Check out the issues marked [help
  wanted](https://github.com/darklang/tablecloth/labels/help%20wanted), especially
  those marked [good first
  issue](https://github.com/darklang/tablecloth/labels/good%20first%20issue)
- Fix a typo or grammatical error
- Add test cases
- Add examples
- Add documentation
- Point out a way in which the library or any of its parts are confusing
- Point out inconsistencies between different functions in the library
- Report an edge-case or performance problem in one of the functions
- Improve a function's documentation by discussing an edge-case
- Check a function cannot throw exceptions (and add a note to the function documentation to that effect)
- Suggest a new function or module by [creating an issue](https://github.com/darklang/tablecloth/issues/new).
- Improve the [documentation site](https://github.com/darklang/tablecloth/tree/master/website)
- Optimize a function

If you'd like to contribute but don't know where to start [open an
issue](https://github.com/darklang/tablecloth/issues/new) with your thoughts
or stop by the *#tablecloth* channel in the [Darklang discord](https://darklang.com/discord-invite).

## Guiding principles

### Over-communicate

Create an issue first!

If you are planning on removing, changing or adding new features to `Tablecloth`, please open an issue first.

### Small Pull Requests

Many small PR's are better than one big one.

Small PR's cause fewer conflicts, and are easier to review.

## Names

### Use human readable names

Having an API that is clear is more important than saving three or four characters by dropping letters from a name.

Avoid abbreviations, unless it's super common, as they impose additional mental overhead when reading code

### Don't be cute

A name should help a developer understand what a function does.

### Prefer long names for functions that do something ill-advised or dangerous

You want to give the reader the opportunity to realise something is up.

A good way to do this is by including `Unsafe` in the name.

### Try to use names that Javascripters / OCamlers already know

If one ecosystem already has a name for something, that's going to be the one to
go for unless there is a good reason not to.

### Module names should not be repeated in function names

A function called `State.runState` is not only redundant but encourages `open`ing modules which does not scale well.

In files with many unqualified dependencies it is really hard to figure out where functions are coming from.

This can make code difficult to understand, especially if custom infix operators are used as well.

## Documentation

### Assume little background knowledge

Everyone has gaps in their knowledge, try to remove roadblocks. External links are really useful here.

### Use longer explanations with examples and real-world data

Rather than concise documentation, we prefer more descriptive prose with examples and explanations. Real world data is preferred over contrived examples.
