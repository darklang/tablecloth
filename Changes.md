# CHANGELOG for Tablecloth v0.0.7-0.0.8


## Array
### Renamed
fold - renamed from Array.foldLeft
join - renamed from Array.concatenate
### Changed
reverse - signature rewritten<br>
- Previously: val reverse : 'a array -> 'a array<br>
- Currently: val reverse : 'a t -> unit<br>

sum - signature rewritten; now includes float<br>
- Previously: val sum : int array -> int<br>
- Currently: val sum : 'a t -> (module TableclothContainer.Sum with type t = 'a) -> 'a<br>

join - signature rewritten; renamed from Array.concatenate<br>
- Previously: val concatenate : 'a array array -> 'a array<br>
- Currently: val join : string t -> sep:string -> string<br>
### New
clone
last
sort
count 
includes 
minimum 
maximum 
extent 
filterMap 
flatten
zip
partition 
splitAt 
splitWhen 
unzip
forEachWithIndex
values
chunksOf 
groupBy
equal
compare
### Removed
Array.empty
Array.floatSum - floats now part of sum
### TODO
   --

## Bool
### Renamed
   --
### Changed
   --
### New
type t bool
fromInt
fromString
( && )
( || )
xor
not
toString
toInt
equal
compare
### Removed
   --
### TODO
   --

## Char
### Renamed
   --
### Changed
   --
### New
equal
compare
### Removed
   --
### TODO
   --

## Float
### Renamed
   --
### Changed
**Changed to use new type Radians:**
fromPolar
from_polar
cos
acos
sin
asin
tan
atan
atan2

**Changed to result in new type Radians:**
degrees
radians
turns
toPolar
to_polar
### New
type radians
epsilon
largestValue
smallestValue
maximumSafeInteger
minimumSafeInteger
fromString
isInteger
isSafeInteger
toString
equal
compare
### Removed
   --
### TODO
   --

## Fun
### Renamed
   	curry - renamed from Tuple2.curry
uncurry -  renamed from Tuple2.uncurry
curry3 - renamed from Tuple3.curry
uncurry3 - renamed from Tuple3.uncurry
### Changed
   --
### New
negate
forever
times
### Removed
   --
### TODO
   --

## Int
### Renamed
( /. ) - floating point division; renamed from ( // )
### Changed
   --
### New
mod
equal
compare
### Removed
   --
### TODO
   --

## List
### Renamed
initial - renamed from List.init
sort - renamed from List.sortWith
includes - renamed from List.member
findIndex - replaces List.elemIndex
fold - renamed from List.foldLeft
partition - renamed from List.span
forEach - renamed from List.iter
join -  renamed from List.concat
mapWithIndex - renamed from List.indexedMap, List.mapi
### Changed
repeat - signature parameter rewritten<br>
- Previously: val repeat : count:int -> 'a -> 'a list<br>
- Currently: val repeat : 'a -> times:int -> 'a t<br>

includes - signature rewritten; renamed from List.concat<br>
- Previously: val member : value:'a -> 'a list -> bool<br>
- Currently: val includes : 'a t -> 'a -> equal:('a -> 'a -> bool) -> bool<br>

minimum - signature rewritten<br>
- Previously: al minimum : 'comparable list -> 'comparable option<br>
- Currently: val minimum : 'a t -> compare:('a -> 'a -> int) -> 'a option<br>

maximum - signature rewritten<br>
- Previously: al maximum : 'comparable list -> 'comparable option<br>
- Currently: val maximum : 'a t -> compare:('a -> 'a -> int) -> 'a option<br>

sum - signature rewritten; now includes float<br>
- Previously:  val sum : int list -> int<br>
- Currently: val sum : 'a t -> (module TableclothContainer.Sum with type t = 'a) -> 'a<br>

intersperse - signature rewritten<br>
- Previously: val intersperse : 'a -> 'a list -> 'a list<br>
- Currently: val intersperse : 'a t -> sep:'a -> 'a t<br>

join - signature rewritten; renamed from List. concat; <br>
- Previously: val concat : string list -> string<br>
- Currently: val join : string t -> sep:string -> string<br>
### New
empty
singleton
range
fromArray
updateAt 
count
extent 
###filterWithIndex
flatMap 
flatten 
zip
map3 
unzip 
forEachWithIndex 
chunksOf 
groupBy 
toArray
equal
compare
### Removed
List.floatSum - now part of sum
List.getBy - was the same as List.find
List.elemIndex
### TODO
sortBy - needs to be added
minimumBy - needs to be added
maximumBy - needs to be added
maximum_by - needs to be added
List.uniqueBy 

## Map - Renamed from IntDict and StrDict, has a new type 
### Renamed
add - renamed from IntDict.insert, StrDict.insert
get - renamed from IntDict.get, StrDict.get
update - renamed from IntDict.update, StrDict.update
merge - renamed from IntDict.merge, StrDict.merge
map - renamed from IntDict.map, StrDict.map
keys - renamed from IntDict.keys, StrDict.keys
toList - renamed from IntDict.toList; StrDict.toList
**Add note of Map to Dict change**

### Changed
Int.fromList - signature rewritten; renamed from IntDict.fromList
- Previously: val fromList : (key * 'value) list -> 'value t
- Currently: val fromList : (int * 'value) list -> 'value t

Str.fromList - signature rewritten; renamed from StrDict.fromList
- Previously: val fromList : (key * 'value) list -> 'value t
- Currently: val fromList : (string * 'value) list -> 'value t
### New
Of()
empty - unique from Poly.empty, Int.empty, String.empty 
singleton
fromArray
fromList - unique from Poly.fromList, Int.fromList, String.fromList 
(  .?{}<-  ) - Map.add
remove
(  .?{}  ) - Map.get
isEmpty
length
any
all
find
includes
minimum
maximum
extent
mapWithIndex
filter
partition
fold
forEach
forEachWithIndex
values
toArray
Poly.empty
Poly.singleton
Poly.fromArray
Poly.fromList
Int.singleton
Int.fromArray
String.singleton
String.fromArray
### Removed
IntDict.toString
IntDict.pp
StrDict.toString
StrDict.pp
### TODO
   --

## Option
### Renamed
unwrap - renamed from Option.withDefault
### Changed
   --
### New
and_
both
flatten
map2
unwrapUnsafe
isNone
tap
toArray
equal
compare
( |? ) - get
( >>| ) - map
( >>| ) - andThen
### Removed
Option.getExn
### TODO
   --

## Result
### Renamed
ok - renamed from Result.succeed
error - renamed from Result.fail
### Changed
type (‘ok, ‘error) t - changed from type (‘err, ‘ok) t

fromOption - signature rewritten<br>
- Previously: val fromOption : error:'err -> 'ok option -> ('err, 'ok) t<br>
- Currently: val fromOption : 'ok option -> error:'error -> ('ok, 'error) t<br>
map - signature rewritten<br>
- Previously: val map : f:('ok -> 'value) -> ('err, 'ok) t -> ('err, 'value) t<br>
- Currently: val map : ('a, 'error) t -> f:('a -> 'b) -> ('b, 'error) t<br>
andThen - signature rewritten<br>
- Previously: val andThen : f:('ok -> ('err, 'value) t) -> ('err, 'ok) t -> ('err, 'value) t<br>
- Currently: val andThen : ('a, 'error) t -> f:('a -> ('b, 'error) t) -> ('b, 'error) t<br>
toOption - signature rewritten<br>
- Previously: val toOption : ('err, 'ok) t -> 'ok option<br>
- Currently: val toOption : ('ok, _) t -> 'ok option<br>
### New
attempt
isOk
is_ok
is_error
and_
or_
both
flatten
unwrap
unwrapUnsafe
unwrap_unsafe
unwrapError
unwrap_error
values
mapError
map_error
tap
equal
compare
( |? ) - operator version of unwrap
( >>= ) - operator version of andThen
( >>| ) - operator version of map
### Removed
Result.withDefault
Result.combine
Result.pp
### TODO
   --

## Set - renamed from IntSet and StrSet
### Renamed
includes - renamed from IntSet.member, StrSet.member, IntSet.has, StrSet.has
difference - renamed from IntSet.diff, StrSet.diff
### Changed
   --
### New
type (‘a, ‘id) t
type identity
empty - unique from Poly.empty, Int.empty, String.empty
singleton
fromArray
length
find
any
all
intersection
filter
partition
fold
forEach
toArray
toList - renamed, changed from IntSet.toList, StrSet.toList
Poly.empty
Poly.singleton
Poly.fromArray
Poly.fromList
Int.empty - renamed from IntSet.empty
Int.singleton
Int.fromArray
Int.fromList - renamed from IntSet.fromList
String.empty - renamed from StrSet.empty
String.singleton
String.fromArray
String.fromList - renamed from StrSet.fromList

### Removed
IntSet.has
StrSet.has
IntSet.set
StrSet.set
IntSet.ofList
StrSet.ofList
IntSet.pp
StrSet.pp
### TODO
   --

## String
### Renamed
toLowercase - renamed from String.toLower
toUppercase - renamed from String.toUpper
### Changed
   --
### New
fromArray
initialize
get
getAt
( .?[] ) - getAt
isEmpty
includes
indexOf
indexOfRight
trimLeft
trimRight
padLeft
padRight
forEach
fold
toArray
toList
equal
compare
### Removed
   --
### TODO
   --

## Tuple2
### Renamed
make - renamed from Tuple2.create
### Changed
	   --
### New
type (‘a, ‘b) t = ‘a * ‘b
fromArray
fromList
equal
compare
### Removed
   --
### TODO
   --

## Tuple3
### Renamed
make - renamed from Tuple3.create
initial - renamed from Tuple3.init
Tuple3.curry - renamed curry3 and now in Fun
Tuple3.uncurry - renamed uncurry3 and now in Fun
### Changed
	   --
### New
type (‘a, ‘b, ‘c) t = ‘a * ‘b * ‘c
fromArray *no snake case version
fromList *no snake case version
toArray *no snake case version
equal
compare
### Removed
   --
### TODO
from_array - add snake case version
from_list - add snake case version
to_array - add snake case version
Tuple3.rotate_left - add snake case version
Tuple3.roate_right - add snake case version
Tuple3.map_first - add snake case version
Tuple3.map_second - add snake case version
Tuple3.map_third - add snake case version
Tuple3.map_each - add snake case version
Tuple3.map_all - add snake case version
Tuple3.to_list - add snake case version
