---
title: "Contributing"
order: "4"
---

## Contributing

Tablecloth is an ideal library to contribute to, even if you're new to OCaml / Reason.

The maintainers are warm and friendly, and the project abides by a [Code of Conduct](../.github/CODE_OF_CONDUCT.md).

There are many small tasks to be done and even a small change to a single function's documentation is extremely helpful.

Here are some ways to contribute:

- Fix a typo or gramatical error
- Point out a way in which the library or any of its parts are confusing
- Point out inconsistencies between different functions in the library
- Report an edge-case or performance problem in one of the functions
- Add test cases for a function
- Add examples for a function
- Add documentation to a function
- Improve a function's documentation by discussing an edge-case
- Check a function cannot throw exceptions (and add a note to the function documentation to that effect)
- Propose a strategy for benchmarking
- Suggest a new function or module by [creating an issue](https://github.com/darklang/tablecloth/issues/new). 
- Improve the [documentation site](https://github.com/darklang/tablecloth/tree/master/website)
- Optimize a function

If you'd like to contribute but don't know where to start [open an
issue](https://github.com/darklang/tablecloth/issues/new) with your thoughts
or reach out on [Twitter](https://twitter.com/Dean177) or by
[email](mailto:deanmerchant@gmail.com).

## Guiding principles

### Over-communicate 

Create an issue first!

If you are planning on removing, changing or adding new features to `Tablecloth`, please open an issue first.

### Small pull requests

Many small PR's are better than one big one.

Don't save up small changes for one big PR if you can avoid it.

Small PR's are less likely to cause conflicts, easier to review and take less effort.

### Design for a concrete use case

Struggling to provide a good example for your function / module? Maybe it shouldn't be in Tablecloth (although writing good examples *is hard*).

Completeness isn't a goal, just because one module has a function doesn't mean all the modules that *can* have that function *should* have it too. 

## Names

### Don't use abbreviations

Use human readable names.

Having an API that is clear is more important than saving three or four characters by dropping letters from a name.

Abbreviations impose additional mental overhead when reading code:
- You have to translate them back to the 'real' word in your head
- You have to disambiguate them, does `init` mean `initial` or `initialize` (`List` has both!)

If it's a super common abbreviation, it needs to be justified and explained in the documentation or in [Conventions](./conventions).

### Don't be cute

A name that doesn't help you understand what a function does isn't a very good name. 

Needing to understand the function to understand the name is the opposite of how things should work, [naming things backwards](https://stackoverflow.com/questions/7674277/in-functionaljava-list-what-does-snoc-mean) is [for vampires](https://en.wikipedia.org/wiki/Count_Alucard_(character)).


### Prefer long names for functions that do something ill-advised or dangerous

You want to give the reader the opportunity to realise something is up. 

A good way to do this is by including `Unsafe` or `Dangerously` in the name.

### Try to use names that Javascripters / OCamlers already know

If one ecosystem already has a name for something, that's going to be the one to
go for unless there is a good reason not to.

### Module names should not be repeated in function names

A function called `State.runState` is not only redundant but encourages `open`ing modules which does not scale well. 

In files with many unqualified dependencies it is really hard to figure out where functions are coming from.

This can make code difficult to understand, especially if custom infix operators are used as well. 

## Documentation

### Avoid 'simple', 'easy' and 'just'

They don't help anyone understand how anything works, but they can make someone who is struggling with a new concept or module feel inadequate.

### Try not to assume any background knowledge

Everyone has gaps in their knowledge, try to remove roadblocks. External links are really useful here.

### Avoid this style of documentation

> `lfindi ?pos t ~f` returns the smallest `i >= pos` such that `f i t.[i]`, if there is such an `i`. By default, `pos = 0`.

It's incredibly dense, the names are short to the point of basically being symbols and it is self referential. 

Either a longer explanation using real words or an example using real data would have been better.

In Tablecloth we do both.
