# CHANGELOG for Tablecloth v0.0.7-0.0.8


## Array
### Renamed
fold - renamed from Array.foldLeft<br>
join - renamed from Array.concatenate<br>
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
clone<br>
last<br>
sort<br>
count <br>
includes <br>
minimum <br>
maximum <br>
extent <br>
filterMap <br>
flatten<br>
zip<br>
partition <br>
splitAt <br>
splitWhen <br>
unzip<br>
forEachWithIndex<br>
values<br>
chunksOf <br>
groupBy<br>
equal<br>
compare<br>
### Removed
Array.empty<br>
Array.floatSum - floats now part of sum<br>
### TODO
--

## Bool
### Renamed
--
### Changed
--
### New
type t bool<br>
fromInt<br>
fromString<br>
( && )<br>
( || )<br>
xor<br>
not<br>
toString<br>
toInt<br>
equal<br>
compare<br>
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
equal<br>
compare<br>
### Removed
--
### TODO
--

## Float
### Renamed
--
### Changed
**Changed to use new type Radians:**
fromPolar<br>
from_polar<br>
cos<br>
acos<br>
sin<br>
asin<br>
tan<br>
atan<br>
atan2<br>

**Changed to result in new type Radians:**
degrees<br>
radians<br>
turns<br>
toPolar<br>
to_polar<br>
### New
type radians<br>
epsilon<br>
largestValue<br>
smallestValue<br>
maximumSafeInteger<br>
minimumSafeInteger<br>
fromString<br>
isInteger<br>
isSafeInteger<br>
toString<br>
equal<br>
compare<br>
### Removed
--
### TODO
--

## Fun
### Renamed
curry - renamed from Tuple2.curry<br>
uncurry -  renamed from Tuple2.uncurry<br>
curry3 - renamed from Tuple3.curry<br>
uncurry3 - renamed from Tuple3.uncurry<br>
### Changed
--
### New
negate<br>
forever<br>
times<br>
### Removed
--
### TODO
--

## Int
### Renamed
( /. ) - floating point division; renamed from ( // )<br>
### Changed
--
### New
mod<br>
equal<br>
compare<br>
### Removed
--
### TODO
--

## List
### Renamed
initial - renamed from List.init<br>
sort - renamed from List.sortWith<br>
includes - renamed from List.member<br>
findIndex - replaces List.elemIndex<br>
fold - renamed from List.foldLeft<br>
partition - renamed from List.span<br>
forEach - renamed from List.iter<br>
join -  renamed from List.concat<br>
mapWithIndex - renamed from List.indexedMap, List.mapi<br>
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
empty<br>
singleton<br>
range<br>
updateAt <br>
count<br>
extent <br>
filterWithIndex<br>
flatMap <br>
flatten <br>
zip<br>
map3 <br>
unzip <br>
forEachWithIndex <br>
chunksOf <br>
groupBy <br>
toArray<br>
equal<br>
compare<br>
### Removed
List.floatSum - now part of sum<br>
List.getBy - was the same as List.find<br>
List.elemIndex<br>
### TODO
sortBy - needs to be added<br>
minimumBy - needs to be added<br>
maximumBy - needs to be added<br>
maximum_by - needs to be added<br>
List.uniqueBy <br>

## Map - Renamed from IntDict and StrDict, has a new type 
### Renamed
add - renamed from IntDict.insert, StrDict.insert<br>
get - renamed from IntDict.get, StrDict.get<br>
update - renamed from IntDict.update, StrDict.update<br>
merge - renamed from IntDict.merge, StrDict.merge<br>
map - renamed from IntDict.map, StrDict.map<br>
keys - renamed from IntDict.keys, StrDict.keys<br>
toList - renamed from IntDict.toList; StrDict.toList<br>
**Add note of Map to Dict change**

### Changed
Int.fromList - signature rewritten; renamed from IntDict.fromList<br>
- Previously: val fromList : (key * 'value) list -> 'value t<br>
- Currently: val fromList : (int * 'value) list -> 'value t<br>

Str.fromList - signature rewritten; renamed from StrDict.fromList<br>
- Previously: val fromList : (key * 'value) list -> 'value t<br>
- Currently: val fromList : (string * 'value) list -> 'value t<br>
### New
Of()<br>
empty - unique from Poly.empty, Int.empty, String.empty <br>
singleton<br>
fromArray<br>
fromList - unique from Poly.fromList, Int.fromList, String.fromList <br>
(  .?{}<-  ) - Map.add<br>
remove<br>
(  .?{}  ) - Map.get<br>
isEmpty<br>
length<br>
any<br>
all<br>
find<br>
includes<br>
minimum<br>
maximum<br>
extent<br>
mapWithIndex<br>
filter<br>
partition<br>
fold<br>
forEach<br>
forEachWithIndex<br>
values<br>
toArray<br>
Poly.empty<br>
Poly.singleton<br>
Poly.fromArray<br>
Poly.fromList<br>
Int.singleton<br>
Int.fromArray<br>
String.singleton<br>
String.fromArray<br>
### Removed
IntDict.toString<br>
IntDict.pp<br>
StrDict.toString<br>
StrDict.pp<br>
### TODO
--

## Option
### Renamed
unwrap - renamed from Option.withDefault<br>
### Changed
--
### New
and_<br>
both<br>
flatten<br>
map2<br>
unwrapUnsafe<br>
isNone<br>
tap<br>
toArray<br>
equal<br>
compare<br>
( |? ) - get<br>
( >>| ) - map<br>
( >>| ) - andThen<br>
### Removed
Option.getExn<br>
### TODO
--

## Result
### Renamed
ok - renamed from Result.succeed<br>
error - renamed from Result.fail<br>
### Changed
type (‘ok, ‘error) t - changed from type (‘err, ‘ok) t<br>

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
attempt<br>
isOk<br>
is_ok<br>
is_error<br>
and_<br>
or_<br>
both<br>
flatten<br>
unwrap<br>
unwrapUnsafe<br>
unwrap_unsafe<br>
unwrapError<br>
unwrap_error<br>
values<br>
mapError<br>
map_error<br>
tap<br>
equal<br>
compare<br>
( |? ) - operator version of unwrap<br>
( >>= ) - operator version of andThen<br>
( >>| ) - operator version of map<br>
### Removed
Result.withDefault<br>
Result.combine<br>
Result.ppv
### TODO
--

## Set - renamed from IntSet and StrSet
### Renamed
includes - renamed from IntSet.member, StrSet.member, IntSet.has, StrSet.has<br>
difference - renamed from IntSet.diff, StrSet.diff<br>
### Changed
--
### New
type (‘a, ‘id) <br>
type identity<br>
empty - unique from Poly.empty, Int.empty, String.empty<br>
singleton<br>
fromArray<br>
length<br>
find<br>
any<br>
all<br>
intersection<br>
filter<br>
partition<br>
fold<br>
forEach<br>
toArray<br>
toList - renamed, changed from IntSet.toList, StrSet.toList<br>
Poly.empty<br>
Poly.singleton<br>
Poly.fromArray<br>
Poly.fromList<br>
Int.empty - renamed from IntSet.empty<br>
Int.singleton<br>
Int.fromArray<br>
Int.fromList - renamed from IntSet.fromList<br>
String.empty - renamed from StrSet.empty<br>
String.singleton<br>
String.fromArray<br>
String.fromList - renamed from StrSet.fromList<br>

### Removed
IntSet.has<br>
StrSet.has<br>
IntSet.set<br>
StrSet.set<br>
IntSet.ofList<br>
StrSet.ofList<br>
IntSet.pp<br>
StrSet.pp<br>
### TODO
--

## String
### Renamed
toLowercase - renamed from String.toLower<br>
toUppercase - renamed from String.toUpper<br>
### Changed
--
### New
fromArray<br>
initialize<br>
get<br>
getAt<br>
( .?[] ) - getAt<br>
isEmpty<br>
includes<br>
indexOf<br>
indexOfRight<br>
trimLeft<br>
trimRight<br>
padLeft<br>
padRight<br>
forEach<br>
fold<br>
toArray<br>
toList<br>
equal<br>
compare<br>
### Removed
--
### TODO
--

## Tuple2
### Renamed
make - renamed from Tuple2.create<br>
### Changed
--
### New
type (‘a, ‘b) t = ‘a * ‘b<br>
fromArray<br>
fromList<br>
equal<br>
compare<br>
### Removed
--
### TODO
--

## Tuple3
### Renamed
make - renamed from Tuple3.create<br>
initial - renamed from Tuple3.init<br>
Tuple3.curry - renamed curry3 and now in Fun<br>
Tuple3.uncurry - renamed uncurry3 and now in Fun<br>
### Changed
--
### New
type (‘a, ‘b, ‘c) t = ‘a * ‘b * ‘c<br>
fromArray *no snake case version<br>
fromList *no snake case version<br>
toArray *no snake case version<br>
equal<br>
compare<br>
### Removed
--
### TODO
from_array - add snake case version<br>
from_list - add snake case version<br>
to_array - add snake case version<br>
Tuple3.rotate_left - add snake case version<br>
Tuple3.roate_right - add snake case version<br>
Tuple3.map_first - add snake case version<br>
Tuple3.map_second - add snake case version<br>
Tuple3.map_third - add snake case version<br>
Tuple3.map_each - add snake case version<br>
Tuple3.map_all - add snake case version<br>
Tuple3.to_list - add snake case version<br>
