# 0.0.8

## Array

### Renamed

- `Array.fold` - renamed from `Array.foldLeft`

### Changed

`Array.reverse` - Now works in-place:

- Previously: `val reverse : 'a array -> 'a array`
- Currently: `val reverse : 'a t -> unit`

`Array.sum` - now supports `int` and `float`

- Previously: `val sum : int array -> int`
- Currently: `val sum : 'a t -> (module TableclothContainer.Sum with type t = 'a) -> 'a`

### New

- `Array.join`
- `Array.clone`
- `Array.last`
- `Array.sort`
- `Array.count`
- `Array.includes`
- `Array.minimum`
- `Array.maximum`
- `Array.extent`
- `Array.filterMap`
- `Array.flatten`
- `Array.zip`
- `Array.partition`
- `Array.splitAt`
- `Array.splitWhen`
- `Array.unzip`
- `Array.forEachWithIndex`
- `Array.values`
- `Array.chunksOf`
- `Array.groupBy`
- `Array.equal`
- `Array.compare`

### Removed

- `Array.empty`

## Bool

### New

- `Bool.fromInt`
- `Bool.fromString`
- `( && )`
- `( || )`
- `Bool.xor`
- `Bool.not`
- `Bool.toString`
- `Bool.toInt`
- `Bool.equal`
- `Bool.compare`

## Char

### New

- `Char.equal`
- `Char.compare`

## Float

### Changed

The functions now use a new type `Radians`:

- `Float.fromPolar`
- `Float.from_polar`
- `Float.cos`
- `Float.acos`
- `Float.sin`
- `Float.asin`
- `Float.tan`
- `Float.atan`
- `Float.atan2`

These functions now return `Radians`:

- `Float.degrees`
- `Float.radians`
- `Float.turns`
- `Float.toPolar`
- `Float.to_polar`

### New

- type `Radians`
- `Float.epsilon`
- `Float.largestValue`
- `Float.smallestValue`
- `Float.maximumSafeInteger`
- `Float.minimumSafeInteger`
- `Float.fromString`
- `Float.isInteger`
- `Float.isSafeInteger`
- `Float.toString`
- `Float.equal`
- `Float.compare`

## Fun

### Renamed

- `Fun.curry` - renamed from `Tuple2.curry`
- `Fun.uncurry` - renamed from `Tuple2.uncurry`
- `Fun.curry3` - renamed from `Tuple3.curry`
- `Fun.uncurry3` - renamed from `Tuple3.uncurry`

### New

- `Fun.negate`
- `Fun.forever`
- `Fun.times`

## Int

### Renamed

- `( /. )` - floating point division; renamed from `( // )`

### New

- `mod`
- `equal`
- `compare`

## List

### Renamed

- `List.initial` - renamed from `List.init`
- `List.sort` - renamed from `List.sortWith`
- `List.includes` - renamed from `List.member`
- `List.fold` - renamed from `List.foldLeft`
- `List.partition` - renamed from `List.span`
- `List.forEach` - renamed from `List.iter`
- `List.join` - renamed from `List.concat`
- `List.mapWithIndex` - renamed from `List.indexedMap`, `List.mapi`
- `List.sum` - renamed from `List.floatSum`, see change below

### Changed

`List.repeat` - slight signature change

- Previously: `val repeat : count:int -> 'a -> 'a list`
- Currently: `val repeat : 'a -> times:int -> 'a t`

`List.includes` - takes explicit `equal` function; renamed from `List.concat`

- Previously: `val member : value:'a -> 'a list -> bool`
- Currently: `val includes : 'a t -> 'a -> equal:('a -> 'a -> bool) -> bool`

`List.minimum` - takes explicit `compare` function

- Previously: `val minimum : 'comparable list -> 'comparable option`
- Currently: `val minimum : 'a t -> compare:('a -> 'a -> int) -> 'a option`

`List.maximum` - takes explicit `compare` function

- Previously: `val maximum : 'comparable list -> 'comparable option`
- Currently: `val maximum : 'a t -> compare:('a -> 'a -> int) -> 'a option`

`List.sum` - takes module type argument; now includes `float`

- Previously: `val sum : int list -> int`
- Currently: `val sum : 'a t -> (module TableclothContainer.Sum with type t = 'a) -> 'a`

`List.intersperse` - `sep` now a named parameter

- Previously: `val intersperse : 'a -> 'a list -> 'a list`
- Currently: `val intersperse : 'a t -> sep:'a -> 'a t`

`List.join` - renamed from `List.concat`, `sep` is now a named parameter

- Previously: `val concat : string list -> string`
- Currently: `val join : string t -> sep:string -> string`

### New

- `List.empty`
- `List.singleton`
- `List.range`
- `List.updateAt`
- `List.count`
- `List.extent`
- `List.filterWithIndex`
- `List.flatMap`
- `List.flatten`
- `List.zip`
- `List.map3`
- `List.unzip`
- `List.forEachWithIndex`
- `List.chunksOf`
- `List.groupBy`
- `List.toArray`
- `List.equal`
- `List.compare`

### Removed

- `List.getBy` - was the same as `List.find`
- `List.elemIndex` - use `List.findIndex` instead

## Option

### Renamed

- `Option.unwrap` - renamed from `Option.withDefault`
- `Option.unwrapUnsafe` - renamed from `Option.getExn`

### New

- `Option.and_`
- `Option.both`
- `Option.flatten`
- `Option.map2`
- `Option.isNone`
- `Option.tap`
- `Option.toArray`
- `Option.equal`
- `Option.compare`
- `( |? )` - `Option.get`
- `( >>| )` - `Option.map`
- `( >>| )` - `Option.andThen`

## Result

### Renamed

- `Result.ok` - renamed from `Result.succeed`
- `Result.error` - renamed from `Result.fail`
- `Result.unwrap` - renamed from `Result.withDefault`

### Changed

- `type (‘ok, ‘error) t` - changed from `type (‘err, ‘ok) t`

`Result.fromOption `

- Previously: `val fromOption : error:'err -> 'ok option -> ('err, 'ok) t`
- Currently: `val fromOption : 'ok option -> error:'error -> ('ok, 'error) t`

`Result.map`

- Previously: `val map : f:('ok -> 'value) -> ('err, 'ok) t -> ('err, 'value) t`
- Currently: `val map : ('a, 'error) t -> f:('a -> 'b) -> ('b, 'error) t`

`Result.andThen`

- Previously: `val andThen : f:('ok -> ('err, 'value) t) -> ('err, 'ok) t -> ('err, 'value) t`
- Currently: `val andThen : ('a, 'error) t -> f:('a -> ('b, 'error) t) -> ('b, 'error) t`

`Result.toOption`

- Previously: `val toOption : ('err, 'ok) t -> 'ok option`
- Currently: `val toOption : ('ok, \_) t -> 'ok option`

`Result.combine`
- Previously: `val combine : ('x, 'a) t list -> ('x, 'a list) t`
- Currently: `val combine : ('ok, 'error) result list -> ('ok list, 'error) result`

### New

- `Result.attempt`
- `Result.isOk`
- `Result.is_ok`
- `Result.is_error`
- `Result.and_`
- `Result.or_`
- `Result.orElse`
- `Result.both`
- `Result.flatten`
- `Result.unwrapLazy`
- `Result.unwrapUnsafe`
- `Result.unwrap_unsafe`
- `Result.unwrapError`
- `Result.unwrap_error`
- `Result.values`
- `Result.mapError`
- `Result.map_error`
- `Result.tap`
- `Result.equal`
- `Result.compare`
- `( |? )` - operator version of `Result.unwrap`
- `( >>= )` - operator version of `Result.andThen`
- `( >>| )` - operator version of `Result.map`

### Removed

- `Result.pp`

## Map

Renamed from IntDict and StrDict

### Changed:

- All functions are part of the `Map` module, instead of `IntDict` and `StrDict`.
- These functions now take a module parameter to pass the comparator. You can use the versions in the `Map.Poly`, `Map.Int` or `Map.String` modules which have an implicit comparator:

- `Map.empty`
- `Map.singleton`
- `Map.fromArray`
- `Map.fromList`

### Renamed

- `Map.add` - renamed from `IntDict.insert`, `StrDict.insert`

### New

- `Map.Of()`
- `Map.empty`
- `Map.singleton`
- `Map.fromArray`
- `Map.fromList`
- `( .?{}<- )` - `Map.add`
- `Map.remove`
- `( .?{} )` - `Map.get`
- `Map.isEmpty`
- `Map.length`
- `Map.any`
- `Map.all`
- `Map.find`
- `Map.includes`
- `Map.minimum`
- `Map.maximum`
- `Map.extent`
- `Map.mapWithIndex`
- `Map.filter`
- `Map.partition`
- `Map.fold`
- `Map.forEach`
- `Map.forEachWithIndex`
- `Map.values`
- `Map.toArray`
- `Map.Poly.empty`
- `Map.Poly.singleton`
- `Map.Poly.fromArray`
- `Map.Poly.fromList`
- `Map.Int.singleton`
- `Map.Int.fromArray`
- `Map.String.singleton`
- `Map.String.fromArray`

### Removed

- `IntDict.toString`
- `IntDict.pp`
- `StrDict.toString`
- `StrDict.pp`

## Set

Renamed from IntSet and StrSet.

### Changed

- All functions are part of the `Set` module, instead of `IntSet` and `StrSet`.
- These functions now take a module parameter to pass the comparator. You can use the
  versions in the `Set.Poly`, `Set.Int` or `Set.String` modules which have an implicit
  comparator:

### Renamed

- `Set.add` - renamed from `IntSet.set`, `StrSet.set`
- `Set.includes` - renamed from `IntSet.member`, `StrSet.member`, `IntSet.has`, `StrSet.has`
- `Set.difference` - renamed from `IntSet.diff`, `StrSet.diff`
- `Set.fromList` - renamed from `IntSet.ofList`, `StrSet.ofList`

### New

- `type (‘a, ‘id)`
- `type identity`
- `Set.empty`
- `Set.singleton`
- `Set.fromArray`
- `Set.length`
- `Set.find`
- `Set.any`
- `Set.all`
- `Set.intersection`
- `Set.filter`
- `Set.partition`
- `Set.fold`
- `Set.forEach`
- `Set.toArray`
- `Set.toList `
- `Set.Poly.empty`
- `Set.Poly.singleton`
- `Set.Poly.fromArray`
- `Set.Poly.fromList`
- `Set.Int.empty`
- `Set.Int.singleton`
- `Set.Int.fromArray`
- `Set.Int.fromList`
- `Set.String.empty`
- `Set.String.singleton`
- `Set.String.fromArray`
- `Set.String.fromList`

### Removed

- `IntSet.pp`
- `StrSet.pp`

## String

### Renamed

- `String.toLowercase` - renamed from `String.toLower`
- `String.toUppercase` - renamed from `String.toUpper`

### New

- `String.fromArray`
- `String.initialize`
- `String.get`
- `String.getAt`
- `( .?[] )` - `String.getAt`
- `String.isEmpty`
- `String.includes`
- `String.indexOf`
- `String.indexOfRight`
- `String.trimLeft`
- `String.trimRight`
- `String.padLeft`
- `String.padRight`
- `String.forEach`
- `String.fold`
- `String.toArray`
- `String.toList`
- `String.equal`
- `String.compare`

## Tuple2

### Renamed

- `Tuple2.make` - renamed from `Tuple2.create`

### New

- `type ('a, 'b) t = 'a * 'b`
- `Tuple2.fromArray`
- `Tuple2.fromList`
- `Tuple2.equal`
- `Tuple2.compare`

## Tuple3

### Renamed

- `Tuple3.make` - renamed from `Tuple3.create`
- `Tuple3.initial` - renamed from `Tuple3.init`

### New

- `type ('a, 'b, 'c) t = 'a * 'b * 'c`
- `Tuple3.fromArray`
- `Tuple3.fromList`
- `Tuple3.toArray`
- `Tuple3.equal`
- `Tuple3.compare`

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
- Convert rescript files to use Belt more (#9, #11, #12 @j-m-hoffmann)
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

Add regex module to rescript. The contract will probably change in future
versions because native regex uses an API that can't easily be made match.

Add pp functions for show derivers

Use individual mlis for each library - there are some minor differences we want to allow.

# 0.0.2

First release
