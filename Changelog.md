# 0.0.8

**Array**
Renamed:
- fold - renamed from Array.foldLeft

Changed:
reverse - signature rewritten
- Previously: val reverse : 'a array -> 'a array 
- Currently: val reverse : 'a t -> unit

sum - signature rewritten; now includes float
- Previously: val sum : int array -> int
- Currently: val sum : 'a t -> (module TableclothContainer.Sum with type t = 'a) -> 'a

join - signature rewritten; renamed from Array.concatenate
- Previously: val concatenate : 'a array array -> 'a array
- Currently: val join : string t -> sep:string -> string

New:
- clone
- last
- sort
- count 
- includes 
- minimum 
- maximum 
- extent 
- filterMap 
- flatten
- zip
- partition 
- splitAt 
- splitWhen 
- unzip
- forEachWithIndex
- values
- chunksOf 
- groupBy
- equal
- compare

Removed:
- Array.empty
- Array.floatSum - floats now part of sum


**Bool**
New:
- type t bool
- fromInt
- fromString
- ( && )
- ( || )
- xor
- not
- toString
- toInt
- equal
- compare


**Char**
New:
- equal
- compare


**Float**
Changed:
Use new type Radians:
- fromPolar
- from_polar
- cos
- acos
- sin
- asin
- tan
- atan
- atan2

Result in new type Radians:
- degrees
- radians
- turns
- toPolar
- to_polar

New:
- type radians
- epsilon
- largestValue
- smallestValue
- maximumSafeInteger
- minimumSafeInteger
- fromString
- isInteger
- isSafeInteger
- toString
- equal
- compare


**Fun**
Renamed:
- curry - renamed from Tuple2.curry
- uncurry -  renamed from Tuple2.uncurry
- curry3 - renamed from Tuple3.curry
- uncurry3 - renamed from Tuple3.uncurry

New:
- negate
- forever
- times


**Int**
Renamed:
- ( /. ) - floating point division; renamed from ( // )

New:
- mod
- equal
- compare


**List**
Renamed:
- initial - renamed from List.init
- sort - renamed from List.sortWith
- includes - renamed from List.member
- findIndex - replaces List.elemIndex
- fold - renamed from List.foldLeft
- partition - renamed from List.span
- forEach - renamed from List.iter
- join -  renamed from List.concat
- mapWithIndex - renamed from List.indexedMap, List.mapi

Changed:
repeat - signature parameter rewritten
- Previously: val repeat : count:int -> 'a -> 'a list
- Currently: val repeat : 'a -> times:int -> 'a t

includes - signature rewritten; renamed from List.concat
- Previously: val member : value:'a -> 'a list -> bool
- Currently: val includes : 'a t -> 'a -> equal:('a -> 'a -> bool) -> bool

minimum - signature rewritten
- Previously: al minimum : 'comparable list -> 'comparable option
- Currently: val minimum : 'a t -> compare:('a -> 'a -> int) -> 'a option

maximum - signature rewritten
- Previously: al maximum : 'comparable list -> 'comparable option
- Currently: val maximum : 'a t -> compare:('a -> 'a -> int) -> 'a option

sum - signature rewritten; now includes float
- Previously:  val sum : int list -> int
- Currently: val sum : 'a t -> (module TableclothContainer.Sum with type t = 'a) -> 'a

intersperse - signature rewritten
- Previously: val intersperse : 'a -> 'a list -> 'a list
- Currently: val intersperse : 'a t -> sep:'a -> 'a t

join - signature rewritten; renamed from List. concat; 
- Previously: val concat : string list -> string
- Currently: val join : string t -> sep:string -> string

New:
- empty
- singleton
- range
- updateAt 
- count
- extent 
- filterWithIndex
- flatMap 
- flatten 
- zip
- map3 
- unzip 
- forEachWithIndex 
- chunksOf 
- groupBy 
- toArray
- equal
- compare

Removed:
- List.floatSum - now part of sum
- List.getBy - was the same as List.find
- List.elemIndex

TODO:
- sortBy - needs to be added
- minimumBy - needs to be added
- maximumBy - needs to be added
- maximum_by - needs to be added
- List.uniqueBy 


**Map - Renamed from IntDict and StrDict, has a new type**
Renamed:
- add - renamed from IntDict.insert, StrDict.insert
- get - renamed from IntDict.get, StrDict.get
- update - renamed from IntDict.update, StrDict.update
- merge - renamed from IntDict.merge, StrDict.merge
- map - renamed from IntDict.map, StrDict.map
- keys - renamed from IntDict.keys, StrDict.keys
- toList - renamed from IntDict.toList; StrDict.toList
**Add note of Map to Dict change**

Changed:
Int.fromList - signature rewritten; renamed from IntDict.fromList
- Previously: val fromList : (key * 'value) list -> 'value t
- Currently: val fromList : (int * 'value) list -> 'value t

Str.fromList - signature rewritten; renamed from StrDict.fromList
- Previously: val fromList : (key * 'value) list -> 'value t
- Currently: val fromList : (string * 'value) list -> 'value t

New:
- Of()
- empty - unique from Poly.empty, Int.empty, String.empty 
- singleton
- fromArray
- fromList - unique from Poly.fromList, Int.fromList, String.fromList 
- (  .?{}<-  ) - Map.add
- remove
- (  .?{}  ) - Map.get
- isEmpty
- length
- any
- all
- find
- includes
- minimum
- maximum
- extent
- mapWithIndex
- filter
- partition
- fold
- forEach
- forEachWithIndex
- values
- toArray
- Poly.empty
- Poly.singleton
- Poly.fromArray
- Poly.fromList
- Int.singleton
- Int.fromArray
- String.singleton
- String.fromArray

Removed:
- IntDict.toString
- IntDict.pp
- StrDict.toString
- StrDict.pp


**Option**
Renamed:
unwrap - renamed from Option.withDefault

New:
- and_
- both
- flatten
- map2
- unwrapUnsafe
- isNone
- tap
- toArray
- equal
- compare
- ( |? ) - get
- ( >>| ) - map
- ( >>| ) - andThen

**Removed**
Option.getExn


**Result**
Renamed:
- ok - renamed from Result.succeed
- error - renamed from Result.fail

Changed:
- type (‘ok, ‘error) t - changed from type (‘err, ‘ok) t

fromOption - signature rewritten
- Previously: val fromOption : error:'err -> 'ok option -> ('err, 'ok) t
- Currently: val fromOption : 'ok option -> error:'error -> ('ok, 'error) t
map - signature rewritten
- Previously: val map : f:('ok -> 'value) -> ('err, 'ok) t -> ('err, 'value) t
- Currently: val map : ('a, 'error) t -> f:('a -> 'b) -> ('b, 'error) t
andThen - signature rewritten
- Previously: val andThen : f:('ok -> ('err, 'value) t) -> ('err, 'ok) t -> ('err, 'value) t
- Currently: val andThen : ('a, 'error) t -> f:('a -> ('b, 'error) t) -> ('b, 'error) t
toOption - signature rewritten
- Previously: val toOption : ('err, 'ok) t -> 'ok option
- Currently: val toOption : ('ok, _) t -> 'ok option

New:
- attempt
- isOk
- is_ok
- is_error
- and_
- or_
- both
- flatten
- unwrap
- unwrapUnsafe
- unwrap_unsafe
- unwrapError
- unwrap_error
- values
- mapError
- map_error
- tap
- equal
- compare
- ( |? ) - operator version of unwrap
- ( >>= ) - operator version of andThen
- ( >>| ) - operator version of map

Removed:
- Result.withDefault
- Result.combine
- Result.ppv


**Set - renamed from IntSet and StrSet**
Renamed:
- includes - renamed from IntSet.member, StrSet.member, IntSet.has, StrSet.has
- difference - renamed from IntSet.diff, StrSet.diff

New:
- type (‘a, ‘id) 
- type identity
- empty - unique from Poly.empty, Int.empty, String.empty
- singleton
- fromArray
- length
- find
- any
- all
- intersection
- filter
- partition
- fold
- forEach
- toArray
- toList 
- Poly.empty
- Poly.singleton
- Poly.fromArray
- Poly.fromList
- Int.empty
- Int.singleton
- Int.fromArray
- Int.fromList
- String.empty 
- String.singleton
- String.fromArray
- String.fromList 

Removed:
- IntSet.has
- StrSet.has
- IntSet.set
- StrSet.set
- IntSet.ofList
- StrSet.ofList
- IntSet.pp
- StrSet.pp


**String**
Renamed:
- toLowercase - renamed from String.toLower
- toUppercase - renamed from String.toUpper

New:
- fromArray
- initialize
- get
- getAt
- ( .?[] ) - getAt
- isEmpty
- includes
- indexOf
- indexOfRight
- trimLeft
- trimRight
- padLeft
- padRight
- forEach
- fold
- toArray
- toList
- equal
- compare


**Tuple2**
Renamed:
- make - renamed from Tuple2.create

New:
- type (‘a, ‘b) t = ‘a * ‘b
- fromArray
- fromList
- equal
- compare


**Tuple3**
Renamed:
- make - renamed from Tuple3.create
- initial - renamed from Tuple3.init
- Tuple3.curry - renamed curry3 and now in Fun
- Tuple3.uncurry - renamed uncurry3 and now in Fun

New:
- type (‘a, ‘b, ‘c) t = ‘a * ‘b * ‘c
- fromArray *no snake case version
- fromList *no snake case version
- toArray *no snake case version
- equal
- compare

TODO:
- from_array - add snake case version
- from_list - add snake case version
- to_array - add snake case version
- Tuple3.rotate_left - add snake case version
- Tuple3.roate_right - add snake case version
- Tuple3.map_first - add snake case version
- Tuple3.map_second - add snake case version
- Tuple3.map_third - add snake case version
- Tuple3.map_each - add snake case version
- Tuple3.map_all - add snake case version
- Tuple3.to_list - add snake case version


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
