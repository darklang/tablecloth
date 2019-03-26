## `<|`

```ocaml
val ( <| ) : ('a -> 'b) -> 'a -> 'b
```

```reason
let (<|): ('a => 'b, 'a) => 'b;
```

This operator applies a function to an argument. It is equivalent to the `@@` operator, and its main use is to avoid needing extra parentheses.

### Example

```ocaml
let sqr x = x * x
let result = sqr |< 25 (* 625 *)
```

```reason
let sqr = (x) => {x * x};
let result = sqr |< 25  /* 625 */
```

## >>

```ocaml
val ( >> ) : ('a -> 'b) -> ('b -> 'c) -> 'a -> 'c
```

```reason
let (>>): ('a => 'b, 'b => 'c, 'a) => 'c;
```

This operator returns a function that is the equivalent of the composition of its function arguments. The main use of `>>` is to avoid writing parentheses.

`(f >> g) x`{:.ocaml} `(f >> g)(x)`{:.reason} is the equivalent of
`f (g x)`{:.ocaml} `f(g(x))`{:.reason}

### Example

```ocaml
let sqr x = x * x
let half x = x / 2

let square_half = sqr >> half 
let result = square_half 50 (* 1250 *)
```

```reason
let sqr = (x) => {x * x};
let half = (x) => {x / 2};

let square_then_half = sqr >> half;
let result= square_then_half(50); /* 1250 */
```

## <<

```ocaml
val ( << ) : ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c
```

```reason
let (<<): ('b => 'c, 'a => 'b, 'a) => 'c;
```

This operator returns a function that is the equivalent of the reverse composition of its function arguments.

`(f << g) x`{:.ocaml} `(f << g)(x)`{:.reason} is the equivalent of `g (f x)`{:.ocaml} `g(f(x))`{:.reason}


### Example

```ocaml
let half x = x / 2
let odd x = x mod 2 == 1

let half_then_odd = odd << half 
let result = half_then_odd 50 (* true *)
```

```reason
let half = (x) => {x / 2};
let odd = (x) => {x mod 2 == 0};

let half_then_odd = odd << half;
let result= half_then_odd(50); /* true */
```
## identity

```ocaml
val identity : 'a -> 'a
```

```reason
let identity: 'a => 'a
```

`identity` returns its argument, unchanged. It is useful in circumstances when you need a placeholder function that does not alter the results of a computation.

# List

## flatten

```ocaml
val flatten : 'a list list -> 'a list
```

```reason
let flatten: list(list('a)) => list('a);
```

`flatten` returns the list obtained by concatenating in order all the sub-lists in a given list.

### Example

```ocaml
flatten [[1; 2]; [3; 4; 5]; []; [6]] = [1; 2; 3; 4; 5; 6]
```

```reason
flatten([[1, 2], [3, 4, 5], [], [6]]) == [1, 2, 3, 4, 5, 6]
```

## sum

```ocaml
 val sum : int list -> int
```

```reason
let sum: list(int) => int;
```

`sum xs`{:.ocaml} `sum(xs)`{:.reason} returns the sum of the items in the given list of integers.

### Example

```ocaml
sum [1; 3; 5; 7] = 16
```

```reason
sum([1, 3, 5, 7]) == 16
```

## floatSum
## float_sum

```ocaml
val floatSum : float list -> float
val float_sum : float list -> float
```

```reason
let floatSum = list(float) => float;
let float_sum = list(float) => float;
```

`float_sum xs`{:.ocaml} `floatSum(xs)`{:.reason} returns the sum of the given list of floats. These are equivalent functions; choose the one that best fits your naming conventions.

### Example

```ocaml
float_sum [1.3; 5.75; 9.2] = 16.25
```

```reason
floatSum([1.3, 5.75, 9.2]) == 16.25
```

## map

```ocaml
val map : f:('a -> 'b) -> 'a list -> 'b list
```

```reason
let map: (~f: 'a => 'b, list('a)) => list('b);
```

`map ~f:fcn xs`{:.ocaml} `map(~f=fcn, xs)`{:.reason} returns a new list that it is the result of applying function `fcn` to each item in the list `xs`.

### Example

```ocaml
let cube_root (x : int) =
  ((float_of_int x) ** (1.0 /. 3.0) : float)
  
map ~f:cube_root [8; 1000; 1728] (* [2; 9.999..; 11.999..] *)
```

```reason
let cube_root = (x:int): float => { float_of_int(x) ** (1.0 /. 3.0); }
map(~f=cube_root, [8, 1000, 1728]) /* [2, 9.999.., 11.999..] */
```

## indexedMap
## indexed_map
## mapi

```ocaml
val indexedMap : f:(int -> 'a -> 'b) -> 'a list -> 'b list
val indexed_map : f:(int -> 'a -> 'b) -> 'a list -> 'b list
val mapi : f:(int -> 'a -> 'b) -> 'a list -> 'b list
```

```reasonml
let indexedMap: (~f: (int, 'a) => 'b, list('a)) => list('b);
let indexed_map: (~f: (int, 'a) => 'b, list('a)) => list('b);
let mapi: (~f: (int, 'a) => 'b, list('a)) => list('b);
```
 
`indexed_map ~f:fcn xs`{:.ocaml} `indexedMap(~f=fcn, xs)`{:.reason} returns a new list that it is the result of applying function `fcn` to each item in the list `xs`. The function has two parameters: the index number of the item in the list, and the item being processed. Item numbers start with zero. These are equivalent functions; choose the one that best fits your naming conventions.

```ocaml
let numbered (idx: int) (item: string) =
  ((string_of_int idx) ^ ": " ^ item : string)

indexed_map ~f:numbered ["zero"; "one"; "two"] =
  ["0: zero"; "1: one"; "2: two"]
```

```reason
let numbered = (idx: int, item: string): string =>
  string_of_int(idx) ++ ": " ++ item;
  
indexedMap(~f=numbered, ["zero", "one", "two"]) ==
  ["0: zero", "1: one", "2: two"]
```

## map2

```ocaml
val map2 : f:('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list
```

```reason
let map2: (~f: ('a, 'b) => 'c, list('a), list('b)) => list('c);
```

`map2 ~f: fcn xs ys`{:.ocaml} `map2(~f=fcn, xs, ys)`{:.reason} returns a new list whose items are `fcn x y`{:.ocaml} `fcn(x,y)`{:.reason} where `x` and `y` are the items from the given lists.

```ocaml
let discount (price: float) (percentage: float) =
  (price *. (1.0 -. (percentage /. 100.0)) : float)
  
map2 ~f:discount [100.0; 85.0; 30.0] [10.0; 20.0; 30.0] =
  [90.0; 68.0; 21.0]
```

```reason
let discount = (price: float, percentage: float): float =>
  price *. (1.0 -. (percentage /. 100.0));
  
map2(~f=discount, [100.0, 85.0, 30.0], [10.0, 20.0, 30.0]) ==
  [90.0, 68.0, 21.0]
```

## getBy
## get_by
## find

```ocaml
val getBy : f:('a -> bool) -> 'a list -> 'a option
val get_by : f:('a -> bool) -> 'a list -> 'a option
val find: f:('a -> bool) -> 'a list -> 'a option
```

```reason
let getBy: (~f: 'a => bool, list('a)) => option('a);
let get_by: (~f: 'a => bool, list('a)) => option('a);
let find: (~f: 'a => bool, list('a)) => option('a);
```

`getBy ~f: predicate xs`{:.ocaml} `getBy(~f=predicate, xs)`{:.reason} returns `Some value`{:.ocaml} `Some(value)`{:.reason} for the first value in `xs` that satisifies the `predicate` function; returns `None` if no element satisifies the function. These are equivalent functions; choose the one that best fits your naming conventions.

### Example

```ocaml
let even (x: int) = (x mod 2 = 0 : bool)
get_by ~f:even [1;4;3;2]) = Some 4
get_by ~f:even [15;13;11]) = None
```

```reason
let even = (x: int): bool => {x mod 2 == 0};
getBy(~f=even, [1, 4, 3, 2]) == Some(4);
getBy(~f=even, [15, 13, 11]) == None;
```

## elemIndex
## elem_index

```ocaml
val elemIndex : value:'a -> 'a list -> int option
val elem_index : value:'a -> 'a list -> int option
```

```reason
let elemIndex: (~value: 'a, list('a)) => option('a)
let elem_index: (~value: 'a, list('a)) => option('a)
```

`elem_index ~value:v xs`{:.ocaml} `elemIndex(~value: v, xs)`{:.reason} finds the first occurrence of `v` in `xs` and returns its position as `Some index`{:.ocaml} `Some(index)`{:.reason} (with zero being the first element), or `None` if the value is not found. These are equivalent functions; choose the one that best fits your naming conventions.

### Example

```ocaml
elem_index ~value: 5 [7; 6; 5; 4; 5] = Some(2)
elem_index ~value: 8 [7; 6; 5; 4; 5] = None
```

```reason
elemIndex(~value = 5, [7, 6, 5, 4, 5]) == Some(2);
elemIndex(~value = 8, [7, 6, 5, 4, 5]) == None;
```

## last

```ocaml
val last : 'a list -> 'a option
```

```reason
let last = (list('a)) => option('a)
```

`last xs`{:.ocaml} `last(xs)`{:.reason} returns the last element in the list as `Some value`{:.ocaml} `Some(value)`{:.reason} unless the list is empty, in which case it returns `None`.

### Example

```ocaml
last ["this"; "is"; "the"; "end"] = Some("end")
last [] = None
```

```reason
last(["this", "is", "the", "end"]) == Some("end");
last([]) == None;
```


## member
```ocaml
val member: value:'a -> 'a list -> bool
```

```reason
let member = (~value: 'a, list('a)) => bool
```

`member ~value: v xs`{:.ocaml} `member(~value=v, xs)`{:.reason} returns `true` if the given value `v` is found in thelist `xs`, `false` otherwise.

## Example

```ocaml
member ~value:3 [1;3;5;7] = true
member ~value:4 [1;3;5;7] = false
member ~value:5 [] = false
```

```reason
member(~value = 3, [1, 3, 5, 7]) == true;
member(~value = 4, [1, 3, 5, 7]) == false;
member(~value = 5, []) == false;
```

## uniqueBy
## unique_by

```ocaml
val uniqueBy : f:('a -> string) -> 'a list -> 'a list
val unique_by : f:('a -> string) -> 'a list -> 'a list
```

```reason
let uniqueBy = (~f: 'a => string, list('a)) => list('a);
let unique_by = (~f: 'a => string, list('a)) => list('a);
```

`unique_by ~f: fcn xs`{:.ocaml} `uniqueBy(~f=fcn, xs)`{:.reason} returns a new list containing only those elements from `xs` that have a unique value when `fcn` is applied to them. The function `fcn` takes as its single parameter an item from the list and returns a `string`. If the function generates the same string for two or more list items, only the first of them is retained. These are equivalent functions; choose the one that best fits your naming conventions.

### Example
```ocaml
unique_by ~f: string_of_int [1; 3; 4; 3; 7; 7; 6] = [1; 3; 4; 7; 6]

let abs_str x = string_of_int (abs x)
unique_by ~f: abs_str [1; 3; 4; -3; -7; 7; 6] = [1; 3; 4; -7; 6]
```

```reason
uniqueBy(~f = string_of_int, [1, 3, 4, 3, 7, 7, 6]) == [1, 3, 4, 7, 6];

let absStr= (x) => string_of_int(abs(x));
uniqueBy(~f=absStr, [1, 3, 4, -3, -7, 7, 6]) == [1, 3, 4, -7, 6];
```

## getAt
## get_at

```ocaml
val getAt : index:int -> 'a list -> 'a option
val get_at : index:int -> 'a list -> 'a option
```

```reason
let getAt(~index: int, list('a)) -> option('a);
let get_at(~index: int, list('a)) -> option('a);
```

`get_at ~index: n xs`{:.ocaml} `getAt(~index=n, xs)`{:.reason} retrieves the value of the `n`th item in `xs` (with zero as the starting index) as `Some value`{:.ocaml} `Some(value)`{:.reason}, or `None` if `n` is less than zero or greater than the length of `xs`. These are equivalent functions; choose the one that best fits your naming conventions.

### Example

```ocaml
get_at ~index: 3 [100; 101; 102; 103] == Some 103
get_at ~index: 4 [100; 101; 102; 103] == None
get_at ~index: (-1) [100; 101; 102; 103] == None
get_at ~index: 0 [] == None
```

```reason
getAt(~index = 3, [100, 101, 102, 103]) == Some(103);
getAt(~index = 4, [100, 101, 102, 103]) == None;
getAt(~index = -1, [100, 101, 102, 103]) == None;
getAt(~index = 0, []) == None;
```


## any

```ocaml
val any : f:('a->bool) -> 'a list -> bool
```

```reason
let any(~f: 'a => bool, list('a)) => bool;
```

`any ~f:fcn xs`{:.ocaml} `any(~f=fcn, xs)`{:.reason} returns `true` if the predicate function `fcn x`{:.ocaml} `fcn(x)`{:.reason} returns `true` for any item in `x` in `xs`.

```ocaml
let even x = (x mod 2) = 0
any ~f: even [1; 3; 4; 5] = true
any ~f: even [1; 3; 5; 7] = false
any ~f: even [] = false
```

```reason
let even = (x) => {(x mod 2) == 0};
any(~f = even, [1, 3, 4, 5]) == true;
any(~f = even, [1, 3, 5, 7]) == false;
any(~f = even, []) == false;
```
## head

```ocaml
val head : 'a list -> 'a option
```

```reason
let head(list('a)) => option('a);
```

`head xs`{:.ocaml} `head(xs)`{:ocaml} returns the first item in `xs` as `Some value`{:.ocaml} `Some(value)`{:.reason}, unless it is given an empty list, in which case it returns `None`.

### Example

```ocaml
head ["first"; "second"; "third"] = Some "first"
head [] = None
```

```reason
head(["first", "second", "third"]) == Some("first");
head([]) == None;
```

## drop

```ocaml
val drop : count:int -> 'a list -> 'a list
```

```reason
let drop: (~count: int, list('a)) => list('a)
```

`drop ~count:n xs`{:.ocaml} `drop(~count=n, xs)`{:.reason} returns a list without the first `n` elements of `xs`. If `n` negative or greater than the length of `xs`, it returns an empty list.

### Example

```ocaml
drop ~count: 3 [1;2;3;4;5;6] = [4;5;6]
drop ~count: 9 [1;2;3;4;5;6] = []
drop ~count: (-2) [1;2;3;4;5;6] = []
```

```reason
drop(~count=3, [1, 2, 3, 4, 5, 6]) == [4, 5, 6];
drop(~count=9, [1, 2, 3, 4, 5, 6]) == [];
drop(~count=-2, [1, 2, 3, 4, 5, 6]) == [];
```

## init

```ocaml
val init : 'a list -> 'a list option
```

```reason
let init: list('a) => option(list('a));
```

For non-empty lists, `init xs`{:.ocaml} `init(xs)`{:.reason} returns a new list consisting of all but the last list item as a `Some` value. If `xs` is an empty list, `init` returns `None`.

### Example

```ocaml
init ["ant";"bee";"cat";"extra"] = Some ["ant";"bee";"cat"]
init [1] = Some []
init [] = None
```

```reason
init(["ant", "bee", "cat", "extra"]) == Some(["ant", "bee", "cat"]);
init([1]) == Some([]);
init([]) == None;
```

## filterMap
## filter_map

```ocaml
val filter_map : f:('a -> 'b option) -> 'a list -> 'b list
```

```reason
let filterMap: (~f: 'a => option('b), list('a)) => list('b);
```

`filter_map ~f:fcn xs`{:.ocaml} `filterMap(~f=fcn, xs)`{:.reason} applies `fcn` to each element of `xs`. If `fcn xi`{:.ocaml} `fcn(xi)`{:.reason} is `Some value`{:.ocaml} `Some(value)`{:.reason}, then `value` is kept in the resulting list. If the result is `None`, the element is not retained in the result. These are equivalent functions; choose the one that best fits your naming conventions.

### Example

```ocaml
filter_map ~f: (fun x -> if x mod 2 = 0 then Some (-x) else None)
  [1;2;3;4] = [-2;-4]
```

```reason
filterMap(~f = (x) => if (x mod 2 == 0) {Some(- x)} else {None}, 
  [1, 2, 3, 4]) == [-2, -4]
```

## filter

```ocaml
val filter : f:('a -> bool) -> 'a list -> 'a list
```

```reason
let filter: (~f: 'a => bool, list('a)) => list('a);
```

`filter ~f:predicate xs`{:.ocaml} `filter(~f=predicate, xs)`{:.reason} returns a list of all elements in `xs` which satisfy the predicate function `predicate`.

### Example

```ocaml
filter ~f: (fun x -> x mod 2 = 0) [1;2;3;4] = [2;4]
```

```reason
filter(~f=((x) => x mod 2 == 0), [1, 2, 3, 4]) == [2, 4];
```

## concat

```ocaml
val concat : 'a list list -> 'a list
```

```reason
let concat: list(list('a)) => list('a);
```

`concat xs`{:.ocaml} `concat(xs)`{:.reason} returns the list obtained by concatenating all the lists in the list `xs`

### Example

```ocaml
concat [[1;2;3]; []; [4;5]; [6]] = [1;2;3;4;5;6]
```

```reason
concat([[1, 2, 3], [], [4, 5], [6]]) == [1, 2, 3, 4, 5, 6];
```

## partition

```ocaml
val partition : f:('a -> bool) -> 'a list -> 'a list * 'a list
```

```reason
let partition: (~f: 'a => bool, list('a)) => (list('a), list('a));
```

`partition ~f:predicate`{:.ocaml} `partition(~f=predicate, xs)`{:.reason} returns a tuple of two lists. The first element is a list of all the elements of `xs` for which `predicate` returned `true`. The second element of the tuple is a list of all the elements in `xs` for which `predicate` returned `false`.

### Example

```ocaml
let positive x = (x > 0)
partition ~f:positive [1;-2;-3;4;5] = ([1;4;5], [-2;-3])
```

```reason
let positive = (x) => (x > 0);
partition(~f = positive, [1, -2, -3, 4, 5]) == ([1, 4, 5], [-2, -3]);
```

## foldr

```ocaml
val foldr : f:('a -> 'b -> 'b) -> init:'b -> 'a list -> 'b
```

```reason
let foldr: (~f: ('a, 'b) => 'b, ~init: 'b, list('a)) => 'b;
```

`foldr ~f:fcn ~init:value xs`{:.ocaml} `foldr(~f=fcn, ~init=value, xs)`{:.reason} applies `fcn` to each element of `xs` from end to beginning.  Function `fcn` has two parameters: the item from the list and an “accumulator”, which starts with the `value` specified by `~init`. `foldr` returns the final value of the accumulator.

### Example

```ocaml
let subtract item acc = acc - item
foldr ~f: subtract 0 [1;2;3] = -6
```

```reason
let subtract = (item, acc) => acc - item;
foldr(~f = subtract, 0, [1, 2, 3]) == -6;
```

## foldl

```ocaml
val foldl : f:('a -> 'b -> 'b) -> init:'b -> 'a list -> 'b
```

```reason
let foldl: (~f: ('a, 'b) => 'b, ~init: 'b, list('a)) => 'b;
```

`foldl ~f:fcn ~init:value xs`{:.ocaml} `foldl(~f=fcn, ~init=value, xs)`{:.reason} applies `fcn` to each element of `xs` from beginning to end.  Function `fcn` has two parameters: the item from the list and an “accumulator”, which starts with the `value` specified by `~init`. `foldl` returns the final value of the accumulator.

### Example

```ocaml
let subtract item acc = acc - item
foldl ~f: subtract 0 [1;2;3] = -6
```

```reason
let subtract = (item, acc) => acc - item;
foldl(~f = subtract, 0, [1, 2, 3]) == -6;


## findIndex
## find_index

```ocaml
val findIndex : f:('a -> bool) -> 'a list -> int option
val find_index : f:('a -> bool) -> 'a list -> int option
```

```reason
let findIndex: (~f: 'a => bool, list('a)) => option(int);
let find_index: (~f: 'a => bool, list('a)) => option(int);
```

`find_index`{:.ocaml} `findIndex()`{:.reason}

### Example

```ocaml
```

```reason
```

## take

```ocaml
val take : count:int -> 'a list -> 'a list
```

```reason
let take: (~count: int, list('a)) => list('a);
```

`take`{:.ocaml} `take()`{:.reason}

### Example

```ocaml
```

```reason
```

## updateAt

```ocaml
val updateAt : index:int -> f:('a -> 'a) -> 'a list -> 'a list
```

```reason
let updateAt: (~index: int, ~f: 'a => 'a, list('a)) => list('a);
```

`updateAt`{:.ocaml} `updateAt()`{:.reason}

### Example

```ocaml
```

```reason
```

## update_at

```ocaml
val update_at : index:int -> f:('a -> 'a) -> 'a list -> 'a list
```

```reason
let update_at: (~index: int, ~f: 'a => 'a, list('a)) => list('a);
```

`update_at`{:.ocaml} `update_at()`{:.reason}

### Example

```ocaml
```

```reason
```

## length

```ocaml
val length : 'a list -> int
```

```reason
let length: list('a) => int;
```

`length`{:.ocaml} `length()`{:.reason}

### Example

```ocaml
```

```reason
```

## reverse

```ocaml
val reverse : 'a list -> 'a list
```

```reason
let reverse: list('a) => list('a);
```

`reverse`{:.ocaml} `reverse()`{:.reason}

### Example

```ocaml
```

```reason
```

## dropWhile

```ocaml
val dropWhile : f:('a -> bool) -> 'a list -> 'a list
```

```reason
let dropWhile: (~f: 'a => bool, list('a)) => list('a);
```

`dropWhile`{:.ocaml} `dropWhile()`{:.reason}

### Example

```ocaml
```

```reason
```

## drop_while

```ocaml
val drop_while : f:('a -> bool) -> 'a list -> 'a list
```

```reason
let drop_while: (~f: 'a => bool, list('a)) => list('a);
```

`drop_while`{:.ocaml} `drop_while()`{:.reason}

### Example

```ocaml
```

```reason
```

## isEmpty

```ocaml
val isEmpty : 'a list -> bool
```

```reason
let isEmpty: list('a) => bool;
```

`isEmpty`{:.ocaml} `isEmpty()`{:.reason}

### Example

```ocaml
```

```reason
```

## is_empty

```ocaml
val is_empty : 'a list -> bool
```

```reason
let is_empty: list('a) => bool;
```

`is_empty`{:.ocaml} `is_empty()`{:.reason}

### Example

```ocaml
```

```reason
```

## cons

```ocaml
val cons : 'a -> 'a list -> 'a list
```

```reason
let cons: ('a, list('a)) => list('a);
```

`cons`{:.ocaml} `cons()`{:.reason}

### Example

```ocaml
```

```reason
```

## takeWhile

```ocaml
val takeWhile : f:('a -> bool) -> 'a list -> 'a list
```

```reason
let takeWhile: (~f: 'a => bool, list('a)) => list('a);
```

`takeWhile`{:.ocaml} `takeWhile()`{:.reason}

### Example

```ocaml
```

```reason
```

## take_while

```ocaml
val take_while : f:('a -> bool) -> 'a list -> 'a list
```

```reason
let take_while: (~f: 'a => bool, list('a)) => list('a);
```

`take_while`{:.ocaml} `take_while()`{:.reason}

### Example

```ocaml
```

```reason
```

## all

```ocaml
val all : f:('a -> bool) -> 'a list -> bool
```

```reason
let all: (~f: 'a => bool, list('a)) => bool;
```

`all`{:.ocaml} `all()`{:.reason}

### Example

```ocaml
```

```reason
```

## tail

```ocaml
val tail : 'a list -> 'a list option
```

```reason
let tail: list('a) => option(list('a));
```

`tail`{:.ocaml} `tail()`{:.reason}

### Example

```ocaml
```

```reason
```

## append

```ocaml
val append : 'a list -> 'a list -> 'a list
```

```reason
let append: (list('a), list('a)) => list('a);
```

`append`{:.ocaml} `append()`{:.reason}

### Example

```ocaml
```

```reason
```

## removeAt

```ocaml
val removeAt : index:int -> 'a list -> 'a list
```

```reason
let removeAt: (~index: int, list('a)) => list('a);
```

`removeAt`{:.ocaml} `removeAt()`{:.reason}

### Example

```ocaml
```

```reason
```

## remove_at

```ocaml
val remove_at : index:int -> 'a list -> 'a list
```

```reason
let remove_at: (~index: int, list('a)) => list('a);
```

`remove_at`{:.ocaml} `remove_at()`{:.reason}

### Example

```ocaml
```

```reason
```

## minimumBy

```ocaml
val minimumBy : f:('a -> 'comparable) -> 'a list -> 'a option
```

```reason
let minimumBy: (~f: 'a => 'comparable, list('a)) => option('a);
```

`minimumBy`{:.ocaml} `minimumBy()`{:.reason}

### Example

```ocaml
```

```reason
```

## minimum_by

```ocaml
val minimum_by : f:('a -> 'comparable) -> 'a list -> 'a option
```

```reason
let minimum_by: (~f: 'a => 'comparable, list('a)) => option('a);
```

`minimum_by`{:.ocaml} `minimum_by()`{:.reason}

### Example

```ocaml
```

```reason
```

## maximumBy

```ocaml
val maximumBy : f:('a -> 'comparable) -> 'a list -> 'a option
```

```reason
let maximumBy: (~f: 'a => 'comparable, list('a)) => option('a);
```

`maximumBy`{:.ocaml} `maximumBy()`{:.reason}

### Example

```ocaml
```

```reason
```

## maximum_by

```ocaml
val maximum_by : f:('a -> 'comparable) -> 'a list -> 'a option
```

```reason
let maximum_by: (~f: 'a => 'comparable, list('a)) => option('a);
```

`maximum_by`{:.ocaml} `maximum_by()`{:.reason}

### Example

```ocaml
```

```reason
```

## maximum

```ocaml
val maximum : 'comparable list -> 'comparable option
```

```reason
let maximum: list('comparable) => option('comparable);
```

`maximum`{:.ocaml} `maximum()`{:.reason}

### Example

```ocaml
```

```reason
```

## sortBy

```ocaml
val sortBy : f:('a -> 'b) -> 'a list -> 'a list
```

```reason
let sortBy: (~f: 'a => 'b, list('a)) => list('a);
```

`sortBy`{:.ocaml} `sortBy()`{:.reason}

### Example

```ocaml
```

```reason
```

## sort_by

```ocaml
val sort_by : f:('a -> 'b) -> 'a list -> 'a list
```

```reason
let sort_by: (~f: 'a => 'b, list('a)) => list('a);
```

`sort_by`{:.ocaml} `sort_by()`{:.reason}

### Example

```ocaml
```

```reason
```

## span

```ocaml
val span : f:('a -> bool) -> 'a list -> 'a list * 'a list
```

```reason
let span: (~f: 'a => bool, list('a)) => (list('a), list('a));
```

`span`{:.ocaml} `span()`{:.reason}

### Example

```ocaml
```

```reason
```

## groupWhile

```ocaml
val groupWhile : f:('a -> 'a -> bool) -> 'a list -> 'a list list
```

```reason
let groupWhile: (~f: ('a, 'a) => bool, list('a)) => list(list('a));
```

`groupWhile`{:.ocaml} `groupWhile()`{:.reason}

### Example

```ocaml
```

```reason
```

## group_while

```ocaml
val group_while : f:('a -> 'a -> bool) -> 'a list -> 'a list list
```

```reason
let group_while: (~f: ('a, 'a) => bool, list('a)) => list(list('a));
```

`group_while`{:.ocaml} `group_while()`{:.reason}

### Example

```ocaml
```

```reason
```

## splitAt

```ocaml
val splitAt : index:int -> 'a list -> 'a list * 'a list
```

```reason
let splitAt: (~index: int, list('a)) => (list('a), list('a));
```

`splitAt`{:.ocaml} `splitAt()`{:.reason}

### Example

```ocaml
```

```reason
```

## split_at

```ocaml
val split_at : index:int -> 'a list -> 'a list * 'a list
```

```reason
let split_at: (~index: int, list('a)) => (list('a), list('a));
```

`split_at`{:.ocaml} `split_at()`{:.reason}

### Example

```ocaml
```

```reason
```

## insertAt

```ocaml
val insertAt : index:int -> value:'a -> 'a list -> 'a list
```

```reason
let insertAt: (~index: int, ~value: 'a, list('a)) => list('a);
```

`insertAt`{:.ocaml} `insertAt()`{:.reason}

### Example

```ocaml
```

```reason
```

## insert_at

```ocaml
val insert_at : index:int -> value:'a -> 'a list -> 'a list
```

```reason
let insert_at: (~index: int, ~value: 'a, list('a)) => list('a);
```

`insert_at`{:.ocaml} `insert_at()`{:.reason}

### Example

```ocaml
```

```reason
```

## splitWhen

```ocaml
val splitWhen : f:('a -> bool) -> 'a list -> ('a list * 'a list) option
```

```reason
let splitWhen: (~f: 'a => bool, list('a)) => option((list('a), list('a)));
```

`splitWhen`{:.ocaml} `splitWhen()`{:.reason}

### Example

```ocaml
```

```reason
```

## split_when

```ocaml
val split_when : f:('a -> bool) -> 'a list -> ('a list * 'a list) option
```

```reason
let split_when:
  (~f: 'a => bool, list('a)) => option((list('a), list('a)));
```

`split_when`{:.ocaml} `split_when()`{:.reason}

### Example

```ocaml
```

```reason
```

## intersperse

```ocaml
val intersperse : 'a -> 'a list -> 'a list
```

```reason
let intersperse: ('a, list('a)) => list('a);
```

`intersperse`{:.ocaml} `intersperse()`{:.reason}

### Example

```ocaml
```

```reason
```

## initialize

```ocaml
val initialize : int -> (int -> 'a) -> 'a list
```

```reason
let initialize: (int, int => 'a) => list('a);
```

`initialize`{:.ocaml} `initialize()`{:.reason}

### Example

```ocaml
```

```reason
```

## sortWith

```ocaml
val sortWith : ('a -> 'a -> int) -> 'a list -> 'a list
```

```reason
let sortWith: (('a, 'a) => int, list('a)) => list('a);
```

`sortWith`{:.ocaml} `sortWith()`{:.reason}

### Example

```ocaml
```

```reason
```

## sort_with

```ocaml
val sort_with : ('a -> 'a -> int) -> 'a list -> 'a list
```

```reason
let sort_with: (('a, 'a) => int, list('a)) => list('a);
```

`sort_with`{:.ocaml} `sort_with()`{:.reason}

### Example

```ocaml
```

```reason
```

## iter

```ocaml
val iter : f:('a -> unit) -> 'a list -> unit
```

```reason
let iter: (~f: 'a => unit, list('a)) => unit;
```

`iter`{:.ocaml} `iter()`{:.reason}

### Example

```ocaml
```

```reason
```

# Result
## withDefault

```ocaml
val withDefault : default:'ok -> ('err, 'ok) t -> 'ok
```

```reason
let withDefault: (~default: 'ok, t('err, 'ok)) => 'ok;
```

`withDefault`{:.ocaml} `withDefault()`{:.reason}

### Example

```ocaml
```

```reason
```

## with_default

```ocaml
val with_default : default:'ok -> ('err, 'ok) t -> 'ok
```

```reason
let with_default: (~default: 'ok, t('err, 'ok)) => 'ok;
```

`with_default`{:.ocaml} `with_default()`{:.reason}

### Example

```ocaml
```

```reason
```

## map2

```ocaml
val map2 : f:('a -> 'b -> 'c) -> ('err, 'a) t -> ('err, 'b) t -> ('err, 'c) t
```

```reason
let map2: (~f: ('a, 'b) => 'c, t('err, 'a), t('err, 'b)) => t('err, 'c);
```

`map2`{:.ocaml} `map2()`{:.reason}

### Example

```ocaml
```

```reason
```

## combine

```ocaml
val combine : ('x, 'a) t list -> ('x, 'a list) t
```

```reason
let combine: list(t('x, 'a)) => t('x, list('a));
```

`combine`{:.ocaml} `combine()`{:.reason}

### Example

```ocaml
```

```reason
```

## map

```ocaml
val map : ('ok -> 'value) -> ('err, 'ok) t -> ('err, 'value) t
```

```reason
let map: ('ok => 'value, t('err, 'ok)) => t('err, 'value);
```

`map`{:.ocaml} `map()`{:.reason}

### Example

```ocaml
```

```reason
```

## toOption

```ocaml
val toOption : ('err, 'ok) t -> 'ok option
```

```reason
let toOption: t('err, 'ok) => option('ok);
```

`toOption`{:.ocaml} `toOption()`{:.reason}

### Example

```ocaml
```

```reason
```

## to_option

```ocaml
val to_option : ('err, 'ok) t -> 'ok option
```

```reason
let to_option: t('err, 'ok) => option('ok);
```

`to_option`{:.ocaml} `to_option()`{:.reason}

### Example

```ocaml
```

```reason
```

## andThen
## and_then

```ocaml
val andThen :
  f:('ok -> ('err, 'value) t) -> ('err, 'ok) t -> ('err, 'value) t
val and_then :
  f:('ok -> ('err, 'value) t) -> ('err, 'ok) t -> ('err, 'value) t
```

```reason
let andThen:
  (~f: 'ok => t('err, 'value), t('err, 'ok)) => t('err, 'value);
let and_then:
  (~f: 'ok => t('err, 'value), t('err, 'ok)) => t('err, 'value);

`andThen`{:.ocaml} `andThen()`{:.reason}

### Example

```ocaml
```

```reason
```

## pp

```ocaml
val pp :
  (Format.formatter -> 'err -> unit)
  -> (Format.formatter -> 'ok -> unit)
  -> Format.formatter
  -> ('err, 'ok) t
  -> unit
```

```reason
let pp:
  (
    (Format.formatter, 'err) => unit,
    (Format.formatter, 'ok) => unit,
    Format.formatter,
    t('err, 'ok)
  ) =>
  unit;

`pp`{:.ocaml} `pp()`{:.reason}

### Example

```ocaml
```

```reason
```

# Option
## andThen
## and_then

```ocaml
val andThen : f:('a -> 'b option) -> 'a option -> 'b option
val and_then : f:('a -> 'b option) -> 'a option -> 'b option
```

```reason
let andThen: (~f: 'a => option('b), option('a)) => option('b);
let and_then: (~f: 'a => option('b), option('a)) => option('b);
```

`andThen`{:.ocaml} `andThen()`{:.reason}

### Example

```ocaml
```

```reason
```


## or_

```ocaml
val or_ : 'a option -> 'a option -> 'a option
```

```reason
let or_: (option('a), option('a)) => option('a);
```

`or_`{:.ocaml} `or_()`{:.reason}

### Example

```ocaml
```

```reason
```

## orElse
## or_else

```ocaml
val orElse : 'a option -> 'a option -> 'a option
val or_else : 'a option -> 'a option -> 'a option
```

```reason
let orElse: (option('a), option('a)) => option('a);
let or_else: (option('a), option('a)) => option('a);
```

`orElse`{:.ocaml} `orElse()`{:.reason}

### Example

```ocaml
```

```reason
```


## map

```ocaml
val map : f:('a -> 'b) -> 'a option -> 'b option
```

```reason
let map: (~f: 'a => 'b, option('a)) => option('b);
```

`map`{:.ocaml} `map()`{:.reason}

### Example

```ocaml
```

```reason
```

## withDefault
## with_default

```ocaml
val withDefault : default:'a -> 'a option -> 'a
val with_default : default:'a -> 'a option -> 'a
```

```reason
let withDefault: (~default: 'a, option('a)) => 'a;
let with_default: (~default: 'a, option('a)) => 'a;
```

`withDefault`{:.ocaml} `withDefault()`{:.reason}

### Example

```ocaml
```

```reason
```


## foldrValues
## foldr_values

```ocaml
val foldrValues : 'a option -> 'a list -> 'a list
val foldr_values : 'a option -> 'a list -> 'a list
```

```reason
let foldrValues: (option('a), list('a)) => list('a);
let foldr_values: (option('a), list('a)) => list('a);
```

`foldrValues`{:.ocaml} `foldrValues()`{:.reason}

### Example

```ocaml
```

```reason
```


## values

```ocaml
val values : 'a option list -> 'a list
```

```reason
let values: list(option('a)) => list('a);
```

`values`{:.ocaml} `values()`{:.reason}

### Example

```ocaml
```

```reason
```

## toList
## to_list

```ocaml
val toList : 'a option -> 'a list
val to_list : 'a option -> 'a list
```

```reason
let toList: option('a) => list('a);
let to_list: option('a) => list('a);
```

`toList`{:.ocaml} `toList()`{:.reason}

### Example

```ocaml
```

```reason
```


## isSome
## is_some

```ocaml
val isSome : 'a option -> bool
val is_some : 'a option -> bool
```

```reason
let isSome: option('a) => bool;
let is_some: option('a) => bool;
```

`isSome`{:.ocaml} `isSome()`{:.reason}

### Example

```ocaml
```

```reason
```

## toOption
## to_option

```ocaml
val toOption : sentinel:'a -> 'a -> 'a option
val to_option : sentinel:'a -> 'a -> 'a option
```

```reason
let toOption: (~sentinel: 'a, 'a) => option('a);
let to_option: (~sentinel: 'a, 'a) => option('a);
```

`toOption`{:.ocaml} `toOption()`{:.reason}

### Example

```ocaml
```

```reason
```

# Char
## toCode
## to_code

```ocaml
val toCode : char -> int
val to_code : char -> int
```

```reason
let toCode: char => int;
let to_code: char => int;
```

`toCode`{:.ocaml} `toCode()`{:.reason}

### Example

```ocaml
```

```reason
```

## fromCode
## from_code

```ocaml
val fromCode : int -> char
val from_code : int -> char
```

```reason
let fromCode: int => char;
let from_code: int => char;
```

`fromCode`{:.ocaml} `fromCode()`{:.reason}

### Example

```ocaml
```

```reason
```

# Tuple2
## mapSecond
## map_second

```ocaml
val mapSecond : ('b -> 'c) -> 'a * 'b -> 'a * 'c
val map_second : ('b -> 'c) -> 'a * 'b -> 'a * 'c
```

```reason
let mapSecond: ('b => 'c, ('a, 'b)) => ('a, 'c);
let map_second: ('b => 'c, ('a, 'b)) => ('a, 'c);
```

`mapSecond`{:.ocaml} `mapSecond()`{:.reason}

### Example

```ocaml
```

```reason
```

## second

```ocaml
val second : 'a * 'b -> 'b
```

```reason
let second: (('a, 'b)) => 'b;
```

`second`{:.ocaml} `second()`{:.reason}

### Example

```ocaml
```

```reason
```

## first

```ocaml
val first : 'a * 'b -> 'a
```

```reason
let first: (('a, 'b)) => 'a;
```

`first`{:.ocaml} `first()`{:.reason}

### Example

```ocaml
```

```reason
```

## create

```ocaml
val create : 'a -> 'b -> 'a * 'b
```

```reason
let create: ('a, 'b) => ('a, 'b);
```

`create`{:.ocaml} `create()`{:.reason}

### Example

```ocaml
```

```reason
```

# String
## length

```ocaml
val length : string -> int
```

```reason
let length: string => int;
```

`length`{:.ocaml} `length()`{:.reason}

### Example

```ocaml
```

```reason
```

## toInt
## to_int

```ocaml
val toInt : string -> (string, int) Result.t
val to_int : string -> (string, int) Result.t
```

```reason
let toInt: string => Result.t(string, int);
let to_int: string => Result.t(string, int);
```

`toInt`{:.ocaml} `toInt()`{:.reason}

### Example

```ocaml
```

```reason
```

## toFloat
## to_float

```ocaml
val toFloat : string -> (string, float) Result.t
val to_float : string -> (string, float) Result.t
```

```reason
let toFloat: string => Result.t(string, float);
let to_float: string => Result.t(string, float);
```

`toFloat`{:.ocaml} `toFloat()`{:.reason}

### Example

```ocaml
```

```reason
```

## uncons

```ocaml
val uncons : string -> (char * string) option
```

```reason
let uncons: string => option((char, string));
```

`uncons`{:.ocaml} `uncons()`{:.reason}

### Example

```ocaml
```

```reason
```

## dropLeft
## drop_left

```ocaml
val dropLeft : count:int -> string -> string
val drop_left : count:int -> string -> string
```

```reason
let dropLeft: (~count: int, string) => string;
let drop_left: (~count: int, string) => string;
```

`dropLeft`{:.ocaml} `dropLeft()`{:.reason}

### Example

```ocaml
```

```reason
```

## dropRight
## drop_right

```ocaml
val dropRight : count:int -> string -> string
val drop_right : count:int -> string -> string
```

```reason
let dropRight: (~count: int, string) => string;
let drop_right: (~count: int, string) => string;
```

`dropRight`{:.ocaml} `dropRight()`{:.reason}

### Example

```ocaml
```

```reason
```

## split

```ocaml
val split : on:string -> string -> string list
```

```reason
let split: (~on: string, string) => list(string);
```

`split`{:.ocaml} `split()`{:.reason}

### Example

```ocaml
```

```reason
```

## join

```ocaml
val join : sep:string -> string list -> string
```

```reason
let join: (~sep: string, list(string)) => string;
```

`join`{:.ocaml} `join()`{:.reason}

### Example

```ocaml
```

```reason
```

## endsWith
## ends_with

```ocaml
val endsWith : suffix:string -> string -> bool
val ends_with : suffix:string -> string -> bool
```

```reason
let endsWith: (~suffix: string, string) => bool;
let end_with: (~suffix: string, string) => bool;
```

`endsWith`{:.ocaml} `endsWith()`{:.reason}

### Example

```ocaml
```

```reason
```

## startsWith
## starts_with

```ocaml
val startsWith : prefix:string -> string -> bool
val starts_with : prefix:string -> string -> bool
```

```reason
let startsWith: (~prefix: string, string) => bool;
let starts_with: (~prefix: string, string) => bool;
```

`startsWith`{:.ocaml} `startsWith()`{:.reason}

### Example

```ocaml
```

```reason
```

## toLower
## to_lower

```ocaml
val toLower : string -> string
val to_lower : string -> string
```

```reason
let toLower: string => string;
let to_lower: string => string;
```

`toLower`{:.ocaml} `toLower()`{:.reason}

### Example

```ocaml
```

```reason
```

## toUpper
## to_upper

```ocaml
val toUpper : string -> string
val to_upper : string -> string
```

```reason
let toUpper: string => string;
let to_upper: string => string;
```

`toUpper`{:.ocaml} `toUpper()`{:.reason}

### Example

```ocaml
```

```reason
```

## uncapitalize

```ocaml
val uncapitalize : string -> string
```

```reason
let uncapitalize: string => string;
```

`uncapitalize`{:.ocaml} `uncapitalize()`{:.reason}

### Example

```ocaml
```

```reason
```

## capitalize

```ocaml
val capitalize : string -> string
```

```reason
let capitalize: string => string;
```

`capitalize`{:.ocaml} `capitalize()`{:.reason}

### Example

```ocaml
```

```reason
```

## isCapitalized
## is_capitalized

```ocaml
val isCapitalized : string -> bool
val is_cCapitalized : string -> bool
```

```reason
let isCapitalized: string => bool;
let is_capitalized: string => bool;
```

`isCapitalized`{:.ocaml} `isCapitalized()`{:.reason}

### Example

```ocaml
```

```reason
```

## contains

```ocaml
val contains : substring:string -> string -> bool
```

```reason
let contains: (~substring: string, string) => bool;
```

`contains`{:.ocaml} `contains()`{:.reason}

### Example

```ocaml
```

```reason
```

## repeat

```ocaml
val repeat : count:int -> string -> string
```

```reason
let repeat: (~count: int, string) => string;
```

`repeat`{:.ocaml} `repeat()`{:.reason}

### Example

```ocaml
```

```reason
```

## fromList
## from_list

```ocaml
val fromList : char list -> string
val from_list : char list -> string
```

```reason
let fromList: list(char) => string;
let from_list: list(char) => string;
```

`fromList`{:.ocaml} `fromList()`{:.reason}

### Example

```ocaml
```

```reason
```

## toList
## to_list

```ocaml
val toList : string -> char list
val to_list : string -> char list
```

```reason
let toList: string => list(char);
let to_list: string => list(char);
```

`toList`{:.ocaml} `toList()`{:.reason}

### Example

```ocaml
```

```reason
```

## fromInt
## from_int

```ocaml
val fromInt : int -> string
val from_int : int -> string
```

```reason
let fromInt: int => string;
let from_int: int => string;
```

`fromInt`{:.ocaml} `fromInt()`{:.reason}

### Example

```ocaml
```

```reason
```

## concat

```ocaml
val concat : string list -> string
```

```reason
let concat: list(string) => string;
```

`concat`{:.ocaml} `concat()`{:.reason}

### Example

```ocaml
```

```reason
```

## fromChar
## from_char

```ocaml
val fromChar : char -> string
val from_char : char -> string
```

```reason
let fromChar: char => string;
let from_char: char => string;
```

`fromChar`{:.ocaml} `fromChar()`{:.reason}

### Example

```ocaml
```

```reason
```

## slice

```ocaml
val slice : from:int -> to_:int -> string -> string
```

```reason
let slice: (~from: int, ~to_: int, string) => string;
```

`slice`{:.ocaml} `slice()`{:.reason}

### Example

```ocaml
```

```reason
```

## trim

```ocaml
val trim : string -> string
```

```reason
let trim: string => string;
```

`trim`{:.ocaml} `trim()`{:.reason}

### Example

```ocaml
```

```reason
```

## insertAt
## insert_at

```ocaml
val insertAt : insert:string -> index:int -> string -> string
val insert_at : insert:string -> index:int -> string -> string
```

```reason
let insertAt: (~insert: string, ~index: int, string) => string;
let insert_at: (~insert: string, ~index: int, string) => string;
```

`insertAt`{:.ocaml} `insertAt()`{:.reason}

### Example

```ocaml
```

```reason
```

# IntSet
## t

```ocaml
type t = Belt.Set.Int.t
```

```reason
type t = Belt.Set.Int.t;
```

`t`{:.ocaml} `t()`{:.reason}

### Example

```ocaml
```

```reason
```

## value

```ocaml
type value = int
```

```reason
type value = int;
```

`value`{:.ocaml} `value()`{:.reason}

### Example

```ocaml
```

```reason
```

## fromList
## from_list

```ocaml
val fromList : value list -> t
val from_list : value list -> t
```

```reason
let fromList: list(value) => t;
let from_list: list(value) => t;
```

`fromList`{:.ocaml} `fromList()`{:.reason}

### Example

```ocaml
```

```reason
```

## member

```ocaml
val member : value:value -> t -> bool
```

```reason
let member: (~value: value, t) => bool;
```

`member`{:.ocaml} `member()`{:.reason}

### Example

```ocaml
```

```reason
```

## diff

```ocaml
val diff : t -> t -> t
```

```reason
let diff: (t, t) => t;
```

`diff`{:.ocaml} `diff()`{:.reason}

### Example

```ocaml
```

```reason
```

## isEmpty
## is_empty

```ocaml
val isEmpty : t -> bool
val is_empty : t -> bool
```

```reason
let isEmpty: t => bool;
let is_empty: t => bool;
```

`isEmpty`{:.ocaml} `isEmpty()`{:.reason}

### Example

```ocaml
```

```reason
```

## toList
## to_list

```ocaml
val toList : t -> value list
val to_list : t -> value list
```

```reason
let toList: t => list(value);
let to_list: t => list(value);
```

`toList`{:.ocaml} `toList()`{:.reason}

### Example

```ocaml
```

```reason
```

## ofList
## of_list

```ocaml
val ofList : value list -> t
val of_list : value list -> t
```

```reason
let ofList: list(value) => t;
let of_list: list(value) => t;
```

`ofList`{:.ocaml} `ofList()`{:.reason}

### Example

```ocaml
```

```reason
```

## union

```ocaml
val union : t -> t -> t
```

```reason
let union: (t, t) => t;
```

`union`{:.ocaml} `union()`{:.reason}

### Example

```ocaml
```

```reason
```

## remove

```ocaml
val remove : value:value -> t -> t
```

```reason
let remove: (~value: value, t) => t;
```

`remove`{:.ocaml} `remove()`{:.reason}

### Example

```ocaml
```

```reason
```

## add

```ocaml
val add : value:value -> t -> t
```

```reason
let add: (~value: value, t) => t;
```

`add`{:.ocaml} `add()`{:.reason}

### Example

```ocaml
```

```reason
```

## set

```ocaml
val set : value:value -> t -> t
```

```reason
let set: (~value: value, t) => t;
```

`set`{:.ocaml} `set()`{:.reason}

### Example

```ocaml
```

```reason
```

## has

```ocaml
val has : value:value -> t -> bool
```

```reason
let has: (~value: value, t) => bool;
```

`has`{:.ocaml} `has()`{:.reason}

### Example

```ocaml
```

```reason
```

## empty

```ocaml
val empty : t
```

```reason
let empty: t;
```

`empty`{:.ocaml} `empty()`{:.reason}

### Example

```ocaml
```

```reason
```

## pp

```ocaml
val pp : Format.formatter -> t -> unit
```

```reason
let pp: (Format.formatter, t) => unit;
```

`pp`{:.ocaml} `pp()`{:.reason}

### Example

```ocaml
```

```reason
```

# StrSet
## t

```ocaml
type t = Belt.Set.String.t
```

```reason
type t = Belt.Set.String.t;
```

`t`{:.ocaml} `t()`{:.reason}

### Example

```ocaml
```

```reason
```

## value

```ocaml
type value = string
```

```reason
type value = string;
```

`value`{:.ocaml} `value()`{:.reason}

### Example

```ocaml
```

```reason
```

## fromList
## from_list

```ocaml
val fromList : value list -> t
val from_list : value list -> t
```

```reason
let fromList: list(value) => t;
let from_list: list(value) => t;
```

`fromList`{:.ocaml} `fromList()`{:.reason}

### Example

```ocaml
```

```reason
```

## member

```ocaml
val member : value:value -> t -> bool
```

```reason
let member: (~value: value, t) => bool;
```

`member`{:.ocaml} `member()`{:.reason}

### Example

```ocaml
```

```reason
```

## diff

```ocaml
val diff : t -> t -> t
```

```reason
let diff: (t, t) => t;
```

`diff`{:.ocaml} `diff()`{:.reason}

### Example

```ocaml
```

```reason
```

## isEmpty
## is_empty

```ocaml
val isEmpty : t -> bool
val is_empty : t -> bool
```

```reason
let isEmpty: t => bool;
let is_empty: t => bool;
```

`isEmpty`{:.ocaml} `isEmpty()`{:.reason}

### Example

```ocaml
```

```reason
```

## toList
## to_list

```ocaml
val toList : t -> value list
val to_list : t -> value list
```

```reason
let toList: t => list(value);
let to_list: t => list(value);
```

`toList`{:.ocaml} `toList()`{:.reason}

### Example

```ocaml
```

```reason
```

## ofList
## of_list

```ocaml
val ofList : value list -> t
val of_list : value list -> t
```

```reason
let ofList: list(value) => t;
let of_list: list(value) => t;
```

`ofList`{:.ocaml} `ofList()`{:.reason}

### Example

```ocaml
```

```reason
```

## union

```ocaml
val union : t -> t -> t
```

```reason
let union: (t, t) => t;
```

`union`{:.ocaml} `union()`{:.reason}

### Example

```ocaml
```

```reason
```

## remove

```ocaml
val remove : value:value -> t -> t
```

```reason
let remove: (~value: value, t) => t;
```

`remove`{:.ocaml} `remove()`{:.reason}

### Example

```ocaml
```

```reason
```

## add

```ocaml
val add : value:value -> t -> t
```

```reason
let add: (~value: value, t) => t;
```

`add`{:.ocaml} `add()`{:.reason}

### Example

```ocaml
```

```reason
```

## set

```ocaml
val set : value:value -> t -> t
```

```reason
let set: (~value: value, t) => t;
```

`set`{:.ocaml} `set()`{:.reason}

### Example

```ocaml
```

```reason
```

## has

```ocaml
val has : value:value -> t -> bool
```

```reason
let has: (~value: value, t) => bool;
```

`has`{:.ocaml} `has()`{:.reason}

### Example

```ocaml
```

```reason
```

## empty

```ocaml
val empty : t
```

```reason
let empty: t;
```

`empty`{:.ocaml} `empty()`{:.reason}

### Example

```ocaml
```

```reason
```

## pp

```ocaml
val pp : Format.formatter -> t -> unit
```

```reason
let pp: (Format.formatter, t) => unit;
```

`pp`{:.ocaml} `pp()`{:.reason}

### Example

```ocaml
```

```reason
```

# StrDict
## key

```ocaml
type key = Belt.Map.String.key
```

```reason
type key = Belt.Map.String.key;
```

`key`{:.ocaml} `key()`{:.reason}

### Example

```ocaml
```

```reason
```

## toList
## to_list

```ocaml
val toList : 'a t -> (key * 'a) list
val to_list : 'a t -> (key * 'a) list
```

```reason
let toList: t('a) => list((key, 'a));
let to_list: t('a) => list((key, 'a));
```

`toList`{:.ocaml} `toList()`{:.reason}

### Example

```ocaml
```

```reason
```

## empty

```ocaml
val empty : 'a t
```

```reason
let empty: t('a);
```

`empty`{:.ocaml} `empty()`{:.reason}

### Example

```ocaml
```

```reason
```

## fromList
## from_list

```ocaml
val fromList : (key * 'value) list -> 'value t
val from_list : (key * 'value) list -> 'value t
```

```reason
let fromList: list((key, 'value)) => t('value);
let from_list: list((key, 'value)) => t('value);
```

`fromList`{:.ocaml} `fromList()`{:.reason}

### Example

```ocaml
```

```reason
```

## get

```ocaml
val get : key:key -> 'value t -> 'value option
```

```reason
let get: (~key: key, t('value)) => option('value);
```

`get`{:.ocaml} `get()`{:.reason}

### Example

```ocaml
```

```reason
```

## insert

```ocaml
val insert : key:key -> value:'value -> 'value t -> 'value t
```

```reason
let insert: (~key: key, ~value: 'value, t('value)) => t('value);
```

`insert`{:.ocaml} `insert()`{:.reason}

### Example

```ocaml
```

```reason
```

## keys

```ocaml
val keys : 'a t -> key list
```

```reason
let keys: t('a) => list(key);
```

`keys`{:.ocaml} `keys()`{:.reason}

### Example

```ocaml
```

```reason
```

## update

```ocaml
val update :
  key:key -> f:('value option -> 'value option) -> 'value t -> 'value t
```

```reason
let update:
  (~key: key, ~f: option('value) => option('value), t('value)) =>
  t('value);
```

`update`{:.ocaml} `update()`{:.reason}

### Example

```ocaml
```

```reason
```

## map

```ocaml
val map : 'a t -> f:('a -> 'b) -> 'b t
```

```reason
let map: (t('a), ~f: 'a => 'b) => t('b);
```

`map`{:.ocaml} `map()`{:.reason}

### Example

```ocaml
```

```reason
```

## toString
## to_string

```ocaml
val toString : 'a t -> string
val to_string : 'a t -> string
```

```reason
let toString: t('a) => string;
let to_string: t('a) => string;
```

`toString`{:.ocaml} `toString()`{:.reason}

### Example

```ocaml
```

```reason
```

## pp

```ocaml
val pp :
  (Format.formatter -> 'value -> unit)
  -> Format.formatter
  -> 'value t
  -> unit
```

```reason
  let pp:
    ((Format.formatter, 'value) => unit, Format.formatter, t('value)) => unit;
```

`pp`{:.ocaml} `pp()`{:.reason}

### Example

```ocaml
```

```reason
```

## merge

```ocaml
val merge :
  f:(key -> 'v1 option -> 'v2 option -> 'v3 option)
  -> 'v1 t
  -> 'v2 t
  -> 'v3 t
```

```reason
let merge:
  (
    ~f: (key, option('v1), option('v2)) => option('v3),
    t('v1),
    t('v2)
  ) =>
  t('v3);
```

`merge`{:.ocaml} `merge()`{:.reason}

### Example

```ocaml
```

```reason
```

# IntDict
## key

```ocaml
type key = Belt.Map.Int.key
```

```reason
type key = Belt.Map.Int.key;
```

`key`{:.ocaml} `key()`{:.reason}

### Example

```ocaml
```

```reason
```

## toList
## to_list

```ocaml
val toList : 'a t -> (key * 'a) list
val to_list : 'a t -> (key * 'a) list
```

```reason
let toList: t('a) => list((key, 'a));
let to_list: t('a) => list((key, 'a));
```

`toList`{:.ocaml} `toList()`{:.reason}

### Example

```ocaml
```

```reason
```

## empty

```ocaml
val empty : 'a t
```

```reason
let empty: t('a);
```

`empty`{:.ocaml} `empty()`{:.reason}

### Example

```ocaml
```

```reason
```

## fromList
## from_list

```ocaml
val fromList : (key * 'value) list -> 'value t
```

```reason
let fromList: list((key, 'value)) => t('value);
```

`fromList`{:.ocaml} `fromList()`{:.reason}

### Example

```ocaml
```

```reason
```

## get

```ocaml
val get : key:key -> 'value t -> 'value option
```

```reason
let get: (~key: key, t('value)) => option('value);
```

`get`{:.ocaml} `get()`{:.reason}

### Example

```ocaml
```

```reason
```

## insert

```ocaml
val insert : key:key -> value:'value -> 'value t -> 'value t
```

```reason
let insert: (~key: key, ~value: 'value, t('value)) => t('value);
```

`insert`{:.ocaml} `insert()`{:.reason}

### Example

```ocaml
```

```reason
```

## update

```ocaml
val update :
  key:key -> f:('value option -> 'value option) -> 'value t -> 'value t

```

```reason
let update:
  (~key: key, ~f: option('value) => option('value), t('value)) =>
  t('value);
```

`update`{:.ocaml} `update()`{:.reason}

### Example

```ocaml
```

```reason
```

## keys

```ocaml
val keys : 'a t -> key list
```

```reason
let keys: t('a) => list(key);
```

`keys`{:.ocaml} `keys()`{:.reason}

### Example

```ocaml
```

```reason
```

## map

```ocaml
val map : 'a t -> f:('a -> 'b) -> 'b t
```

```reason
let map: (t('a), ~f: 'a => 'b) => t('b);
```

`map`{:.ocaml} `map()`{:.reason}

### Example

```ocaml
```

```reason
```

## toString
## to_string

```ocaml
val toString : 'a t -> string
val to_string : 'a t -> string
```

```reason
let toString: t('a) => string;
let to_string: t('a) => string;
```

`toString`{:.ocaml} `toString()`{:.reason}

### Example

```ocaml
```

```reason
```


## pp

```ocaml
val pp :
    (Format.formatter -> 'value -> unit)
-> Format.formatter
-> 'value t
-> unit
```

```reason
let pp:
  ((Format.formatter, 'value) => unit,
  Format.formatter,
  t('value)) => unit;
```

`pp`{:.ocaml} `pp()`{:.reason}

### Example

```ocaml
```

```reason
```

## merge

```ocaml
val merge :
    f:(key -> 'v1 option -> 'v2 option -> 'v3 option)
  -> 'v1 t
  -> 'v2 t
  -> 'v3 t
```

```reason
let merge:
  (
    ~f: (key, option('v1), option('v2)) => option('v3),
    t('v1),
    t('v2)
  ) =>
  t('v3);
```

`merge`{:.ocaml} `merge()`{:.reason}

### Example

```ocaml
```

```reason
```

# Regex
## t

```ocaml
type t = Js.Re.t
```

```reason
type t = Js.Re.t;
```

`t`{:.ocaml} `t()`{:.reason}

### Example

```ocaml
```

```reason
```

## result

```ocaml
type result = Js.Re.result
```

```reason
type result = Js.Re.result;
```

`result`{:.ocaml} `result()`{:.reason}

### Example

```ocaml
```

```reason
```

## regex

```ocaml
val regex : string -> t
```

```reason
let regex: string => t;
```

`regex`{:.ocaml} `regex()`{:.reason}

### Example

```ocaml
```

```reason
```

## contains

```ocaml
val contains : re:t -> string -> bool
```

```reason
let contains: (~re: t, string) => bool;
```

`contains`{:.ocaml} `contains()`{:.reason}

### Example

```ocaml
```

```reason
```

## replace

```ocaml
val replace : re:t -> repl:string -> string -> string
```

```reason
let replace: (~re: t, ~repl: string, string) => string;
```

`replace`{:.ocaml} `replace()`{:.reason}

### Example

```ocaml
```

```reason
```

## matches

```ocaml
val matches : re:t -> string -> result option
```

```reason
let matches: (~re: t, string) => option(result);
```

`matches`{:.ocaml} `matches()`{:.reason}

### Example

```ocaml
```

```reason
```

