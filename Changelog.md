# 0.0.7

Summary:
- new Fun modules
- new functions in List, Array, Int, Float, Option and Result
- support latest bs-platform (7.3.2)
- there is now a makefile with common commands
- code is all formatted with ocamlformat

Build:
- add a `Makefile` with common commands (#68, #69, @wpcarro)
- `Makefile` improvements (#73, #82, #85, @dmnd, @Dean177, @joesiewert)
- switch to `ocamlformat` (#70, @wpcarro)
- expand CI coverage (#80, #84, @Dean177, @joesiewert)
- support latest bs-platform (#104 @Coobaha)


Documentation:
- fix typos (#50 @tcoopman, #51 @ostera)
- imrpove String docs (#52, @jdeisenberg)
- switch to OCaml documentation format only (#53, @jdeisenberg)

Fun:
- new module (@Dean177)

Massively expanded Int and Float (#47, @Dean177):
- All operators also get a named function equivalent
- The `clamp`, `hypotenuse` and `inRange` functions are introduced
- `round`, `floor`, `ceiling` and `truncate` return a `float` instead of an `int` with `Float.toInt` serving as the only way to convert to an integer.
- `round` has been expanded to cover (most of) the many possible ways to go about rounding floating point numbers. The documentation for this one might be a little over the top, I wasn't sure about the clearest way to demonstrate the behaviour.
- `logBase` becomes `log ~base:`
- `min`, `max`, `mod`, `sqrt` and `abs` get non-abbreviated names
- `remainderBy` and `modBy` drop the 'By' and get a labelled argument
- `clamp` and `inRange` can throw an exception if the `upper` argument is less than the `lower` argument.

Float:
- fix tests on OSX (#60, @kuy)

List:
- add `sliding` (#81, @Dean177)
- add `repeat` (#90 @msvbg)

Array:
- fix signature of `flatMap` (#55, @figitaki)
- add `findIndex` (#78, @Dean177)
- add `swap` (#76, @Dean177)
- add `sliding` (#81, @Dean177)
- add `get` and `set` (#74, @dmnd)
- change `empty` to be a function (requirement in latest bs-platform) (#104 @Coobaha)

Option:
- add `getExn` (#65, dmnd)

Result:
- add `fromOption` (#66, wpcarro)
- use `~f` in `Result.map` (#115 @joefiorini)

String:
- remove deprecation warnings (#88 @msvbg)


# 0.0.6

Summary:
- significant documentation across entire codebase
- new functions in List, Tuple2, Result, Option, and String
- new modules: Tuple3, Char, Array (mutable arrays)
- remove Regex module

CircleCI:
- Add CI (#15, #19, @Dean177)

Toplevel functions:
- Add documentation (#16, @jdeisenberg)

Array:
- Add module (#14, #27, @j-m-hoffmann, @Dean177)

List:
- Add reverse (#9, @j-m-hoffmann)
- Add tests (#9, #13, #28, @j-m-hoffmann, @jdeisenberg)
- Convert bucklescript files to use Belt more (#9, #11, #12 @j-m-hoffmann)
- Add minimum (#21, #28, @jdeisenberg)
- (Breaking) Make splitWhen consistent with splitAt (removed option return type) (#25, @jdeisenberg)
- Add significant documentation (#16, @jdeisenberg)

Result:
- Fix pp() output for Error (#29, @jdeisenberg)
- Add significant documentation (#30, @jdeisenberg)
- Add functions for constructors: succeed, fail (#40, @bkase)

Option:
- Add significant documentation (#32, #41, @jdeisenberg)
- (Breaking) Remove foldrValues (#33, @jdeisenberg)
- Add function for constructor: some (#40, @bkase)

Char:
- Add module (#14, #17, @Dean177)
- Add significant documentation (#42, @jdeisenberg)

Int:
- Add significant documentation (#43, @jdeisenberg)

Tuple2:
- Add create, first, second, mapFirst, mapSecond, mapEach (#4, @Dean177)
- Add mapEach, mapAll, swap, toList (#6, @Dean177)
- Add curry, uncurry (#10, @Dean177)
- Add significant documentation (#44, @jdeisenberg)

Tuple3:
- Add module (#5, #6, #10, @Dean177)

String:
- Add reverse (#3, @Dean177)

Regex:
- Remove module (#1, #38, @bkase)

# 0.0.5

Fix types of elemIndex

# 0.0.4

Unify the module `t`s with the native `t`s uses to implement them.

# 0.0.3

Add a lot of new functions:
- Result.andThen
- List.elemIndex
- Option.toOption
- {StrStr,IntSet}.remove
- {StrStr,IntSet}.add
- {StrStr,IntSet}.set
- {StrStr,IntSet}.has
- {StrDict,IntDict}.merge

Add regex module to Bucklescript. The contract will probably change in future
versions because native regex uses an API that can't easily be made match.


Add pp functions for show derivers

Use individual mlis for each library - there are some minor differences we want to allow.

# 0.0.2

First release
