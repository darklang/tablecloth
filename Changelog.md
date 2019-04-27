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
