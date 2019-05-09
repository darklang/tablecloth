(** Documentation for tablecloth.mli

Function names that are all lower case have their descriptions and examples in both OCaml and ReasonML format.

Function names that are in snake_case have their documentation written in OCaml format.

Function names that are in camelCase have their documentation written in ReasonML format.
*)

(**
  The `<|` operator applies a function to an argument. It is equivalent to the `@@` operator,
  and its main use is to avoid needing extra parentheses.

  ### Example

  ```ocaml
  let sqr x = x * x
  let result = sqr <| 25 (* 625 *)
  ```

  ```reason
  let sqr = (x) => {x * x};
  let result = sqr <| 25  /* 625 */
  ```
*)
val ( <| ) : ('a -> 'b) -> 'a -> 'b

(**
    The `>>` operator returns a function that is the equivalent of the composition of its function arguments.
    The main use of `>>` is to avoid writing parentheses.

  `(f >> g) x` (`(f >> g)(x)` in ReasonML) is the equivalent of `f (g x)` (`f(g(x))` in ReasonML)

  ### Example

  ```ocaml

  let f = sqrt >> floor
  f 17.0  = 4
  ```

  ```reason
  let f = sqrt >> floor
  f(17.0) == 4.0
  ```
*)
val ( >> ) : ('a -> 'b) -> ('b -> 'c) -> 'a -> 'c

(**
  The `<<` operator returns a function that is the equivalent of the reverse composition of its function arguments.

  `(f << g) x` (`(f << g)(x)` in ReasonML) is the equivalent of `g (f x)` (`g(f(x))` in ReasonML)

  ### Example

  ```ocaml

  let f = floor << sqrt
  f 3.5 = 1.7320508075688772
  ```

  ```reason
  let f = sqrt << floor
  f(3.5) == 1.7320508075688772
  ```

*)
val ( << ) : ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c

(**
  `identity` returns its argument, unchanged. It is useful in circumstances when you need a placeholder
  function that does not alter the results of a computation.
*)
val identity : 'a -> 'a

module Array : sig
  val empty : 'a array

  val singleton : 'a -> 'a array

  val length : 'a array -> int

  val isEmpty : 'a array -> bool

  val is_empty : 'a array -> bool

  val initialize : length:int -> f:(int -> 'a) -> 'a array

  val repeat : length:int -> 'a -> 'a array

  val range : ?from:int -> int -> int array

  val fromList : 'a list -> 'a array

  val from_list : 'a list -> 'a array

  val toList : 'a array -> 'a list

  val to_list : 'a array -> 'a list

  val toIndexedList : 'a array -> (int* 'a) list

  val to_indexed_list : 'a array -> (int* 'a) list

  val get : index:int -> 'a array -> 'a option

  val set : index:int -> value:'a -> 'a array -> unit

  val sum : int array -> int

  val floatSum : float array -> float

  val float_sum : float array -> float

  val filter : f:('a -> bool) -> 'a array -> 'a array

  val map : f:('a -> 'b) -> 'a array -> 'b array

  val mapWithIndex : f:(int -> 'a -> 'b) -> 'a array -> 'b array

  val map_with_index : f:(int -> 'a -> 'b) -> 'a array -> 'b array

  val mapi : f:(int -> 'a -> 'b) -> 'a array -> 'b array

  val map2 : f:('a -> 'b -> 'c) -> 'a array -> 'b array -> 'c array

  val map3 : f:('a -> 'b -> 'c -> 'd) -> 'a array -> 'b array -> 'c array -> 'd array

  val flatMap : f:('a -> 'a array) -> 'a array -> 'a array

  val flat_map : f:('a -> 'a array) -> 'a array -> 'a array

  val find : f:('a -> bool) -> 'a array -> 'a option

  val any : f:('a -> bool) -> 'a array -> bool

  val all : f:('a -> bool) -> 'a array -> bool

  val append : 'a array -> 'a array -> 'a array

  val concatenate : 'a array array -> 'a array

  val intersperse : sep:'a -> 'a array -> 'a array

  val slice : from:int -> ?to_:int -> 'a array -> 'a array

  val foldLeft : f:('a -> 'b -> 'b) -> initial:'b -> 'a array -> 'b

  val fold_left : f:('a -> 'b -> 'b) -> initial:'b -> 'a array -> 'b

  val foldRight : f:('a -> 'b -> 'b) -> initial:'b -> 'a array -> 'b

  val fold_right : f:('a -> 'b -> 'b) -> initial:'b -> 'a array -> 'b

  val reverse : 'a array -> 'a array

  val reverseInPlace : 'a array -> unit

  val reverse_in_place : 'a array -> unit

  val forEach : f:('a -> unit) -> 'a array -> unit

  val for_each : f:('a -> unit) -> 'a array -> unit
end

module List : sig
  (**
    `flatten` returns the list obtained by concatenating in order all the sub-lists in a given list.

    ### Example

    ```ocaml
    flatten [[1; 2]; [3; 4; 5]; []; [6]] = [1; 2; 3; 4; 5; 6]
    ```

    ```reason
    flatten([[1, 2], [3, 4, 5], [], [6]]) == [1, 2, 3, 4, 5, 6]
    ```
  *)
  val flatten : 'a list list -> 'a list

  (**
    `sum xs` (`sum(xs)` in ReasonML) returns the sum of the items in the given list of integers.

    ### Example

    ```ocaml
    sum [1; 3; 5; 7] = 16
    ```

    ```reason
    sum([1, 3, 5, 7]) == 16
    ```
  *)
  val sum : int list -> int

  (**
    `floatSum(xs)` in ReasonML returns the sum of the given list of floats. (Same as `float_sum`.)

    ### Example

    ```reason
    floatSum([1.3, 5.75, 9.2]) == 16.25
    ```
  *)
  val floatSum : float list -> float

  (**
    `float_sum(xs)` returns the sum of the given list of floats. (Same as `floatSum`.)

    ### Example

    ```ocaml
    float_sum [1.3; 5.75; 9.2] = 16.25
    ```
  *)
  val float_sum : float list -> float

  (**
    `map ~f:fcn xs` (`map(~f=fcn, xs)` in ReasonML) returns a new list that it is the result of
    applying function `fcn` to each item in the list `xs`.

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
  *)
  val map : f:('a -> 'b) -> 'a list -> 'b list

  (**
    `indexedMap(~f=fcn, xs)` returns a new list that it is the result of applying
    function `fcn` to each item in the list `xs`. The function has two parameters:
    the index number of the item in the list, and the item being processed.
    Item numbers start with zero. (Same as `indexed_map`.)

    ### Example

    ```reason
    let numbered = (idx: int, item: string): string =>
      string_of_int(idx) ++ ": " ++ item;

    indexedMap(~f=numbered, ["zero", "one", "two"]) ==
      ["0: zero", "1: one", "2: two"]
    ```
  *)
  val indexedMap : f:(int -> 'a -> 'b) -> 'a list -> 'b list

  (**
    `indexed_map ~f:fcn xs` returns a new list that it is the result of applying
    function `fcn` to each item in the list `xs`. The function has two parameters:
    the index number of the item in the list, and the item being processed.
    Item numbers start with zero. (Same as `indexedMap`.)

    ### Example

    ```ocaml
    let numbered (idx: int) (item: string) =
      ((string_of_int idx) ^ ": " ^ item : string)

    indexed_map ~f:numbered ["zero"; "one"; "two"] =
      ["0: zero"; "1: one"; "2: two"]
    ```
  *)
  val indexed_map : f:(int -> 'a -> 'b) -> 'a list -> 'b list

  (**
    Same as `indexedMap` and `indexed_map`
  *)
  val mapi : f:(int -> 'a -> 'b) -> 'a list -> 'b list

  (*
    `map2 ~f:fcn xs ys` (`map2(~f=fcn, xs, ys)` in ReasonML) returns a new list
    whose items are `fcn x y` (`fcn(x,y)` in ReasonML) where `x` and `y` are
    the items from the given lists.

    ### Example
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
  *)
  val map2 : f:('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list

  (**
    `getBy(~f=predicate, xs)` returns `Some(value)` for the first value in `xs`
    that satisifies the `predicate` function; returns `None` if no element
    satisifies the function.  (Same as `get_by`.)

    ### Example

    ```reason
    let even = (x: int): bool => {x mod 2 == 0};
    getBy(~f=even, [1, 4, 3, 2]) == Some(4);
    getBy(~f=even, [15, 13, 11]) == None;
    ```
  *)
  val getBy : f:('a -> bool) -> 'a list -> 'a option

  (**
    `get_by ~f:predicate xs`  returns `Some value` for the first value in `xs`
    that satisifies the `predicate` function; returns `None` if no element
    satisifies the function. (Same as `getBy`.)

    ### Example

    ```ocaml
    let even (x: int) = (x mod 2 = 0 : bool)
    get_by ~f:even [1; 4; 3; 2]) = Some 4
    get_by ~f:even [15; 13; 11]) = None
    ```

  *)
  val get_by : f:('a -> bool) -> 'a list -> 'a option

  (**
    Same as `getBy` and `get_by`
  *)
  val find : f:('a -> bool) -> 'a list -> 'a option

  (**
    `elemIndex(~value: v, xs)` finds the first occurrence of `v` in `xs` and
    returns its position as `Some(index)` (with zero being the first element),
    or `None` if the value is not found.  (Same as `elem_index`.)

    ### Example

    ```reason
    elemIndex(~value = 5, [7, 6, 5, 4, 5]) == Some(2);
    elemIndex(~value = 8, [7, 6, 5, 4, 5]) == None;
    ```
  *)
  val elemIndex : value:'a -> 'a list -> int option

  (**
    `elem_index ~value:v xs` finds the first occurrence of `v` in `xs` and
    returns its position as `Some index` (with zero being the first element),
    or `None` if the value is not found. (Same as `elemIndex`.)

    ### Example

    ```ocaml
    elem_index ~value: 5 [7; 6; 5; 4; 5] = Some(2)
    elem_index ~value: 8 [7; 6; 5; 4; 5] = None
    ```
  *)
  val elem_index : value:'a -> 'a list -> int option

  (**
    `last xs` (`last(xs)` in ReasonML) returns the last element in the list
    as `Some value` (`Some(value)` in ReasonML) unless the list is empty,
    in which case it returns `None`.

    ### Example

    ```ocaml
    last ["this"; "is"; "the"; "end"] = Some("end")
    last [] = None
    ```

    ```reason
    last(["this", "is", "the", "end"]) == Some("end");
    last([]) == None;
    ```
  *)
  val last : 'a list -> 'a option

  (**
    `member ~value: v xs` (`member(~value=v, xs)` in ReasonML) returns `true`
    if the given value `v` is found in thelist `xs`, `false` otherwise.

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
  *)
  val member : value:'a -> 'a list -> bool

  (**
    `uniqueBy ~f:fcn xs` returns a new list containing only those elements from `xs`
    that have a unique value when `fcn` is applied to them.

    The function `fcn` takes as its single parameter an item from the list
    and returns a `string`. If the function generates the same string for two or more
    list items, only the first of them is retained. (Same as 'unique_by'.)

    ### Example
    ```reason
    uniqueBy(~f = string_of_int, [1, 3, 4, 3, 7, 7, 6]) == [1, 3, 4, 7, 6];

    let absStr= (x) => string_of_int(abs(x));
    uniqueBy(~f=absStr, [1, 3, 4, -3, -7, 7, 6]) == [1, 3, 4, -7, 6];
    ```
  *)
  val uniqueBy : f:('a -> string) -> 'a list -> 'a list

  (**
    `unique_by ~f:fcn xs` returns a new list containing only those elements from `xs`
    that have a unique value when `fcn` is applied to them.

    The function `fcn` takes as its single parameter an item from the list
    and returns a `string`. If the function generates the same string for two or more
    list items, only the first of them is retained. (Same as 'uniqueBy'.)

    ### Example
    ```ocaml
    unique_by ~f:string_of_int [1; 3; 4; 3; 7; 7; 6] = [1; 3; 4; 7; 6]

    let abs_str x = string_of_int (abs x)
    unique_by ~f:abs_str [1; 3; 4; -3; -7; 7; 6] = [1; 3; 4; -7; 6]
    ```
  *)
  val unique_by : f:('a -> string) -> 'a list -> 'a list

  (**
    `getAt(~index=n, xs)` retrieves the value of the `n`th item in `xs`
    (with zero as the starting index) as `Some(value)`, or `None`
    if `n` is less than zero or greater than the length of `xs`.

    ### Example

    ```reason
    getAt(~index = 3, [100, 101, 102, 103]) == Some(103);
    getAt(~index = 4, [100, 101, 102, 103]) == None;
    getAt(~index = -1, [100, 101, 102, 103]) == None;
    getAt(~index = 0, []) == None;
    ```
  *)
  val getAt : index:int -> 'a list -> 'a option

  (**
    `get_at ~index: n xs` retrieves the value of the `n`th item in `xs`
    (with zero as the starting index) as `Some value`, or `None`
    if `n` is less than zero or greater than the length of `xs`. (Same as 'getAt'.)

    ### Example

    ```ocaml
    get_at ~index:3 [100; 101; 102; 103] == Some 103
    get_at ~index:4 [100; 101; 102; 103] == None
    get_at ~index:(-1) [100; 101; 102; 103] == None
    get_at ~index:0 [] == None
    ```
  *)
  val get_at : index:int -> 'a list -> 'a option

  (**
    `any ~f:fcn xs` (`any(~f=fcn, xs)` in ReasonML) returns `true` if
    the predicate function `fcn x` (`fcn(x)` in ReasonML) returns `true`
    for any item in `x` in `xs`.

    ### Example

    ```ocaml
    let even x = (x mod 2) = 0
    any ~f:even [1; 3; 4; 5] = true
    any ~f:even [1; 3; 5; 7] = false
    any ~f:even [] = false
    ```

    ```reason
    let even = (x) => {(x mod 2) == 0};
    any(~f=even, [1, 3, 4, 5]) == true;
    any(~f=even, [1, 3, 5, 7]) == false;
    any(~f=even, []) == false;
    ```
  *)
  val any : f:('a -> bool) -> 'a list -> bool

  (**
    `head xs` (`head(xs)` in ReasonML) (returns the first item in `xs` as
    `Some value` (`Some(value)` in ReasonML), unless it is given an empty list,
    in which case it returns `None`.

    ### Example

    ```ocaml
    head ["first"; "second"; "third"] = Some "first"
    head [] = None
    ```

    ```reason
    head(["first", "second", "third"]) == Some("first");
    head([]) == None;
    ```
  *)
  val head : 'a list -> 'a option

  (**
    `drop ~count:n xs` (`drop(~count=n, xs)` in ReasonML) returns a list
    without the first `n` elements of `xs`. If `n` negative or greater
    than the length of `xs`, it returns an empty list.

    ### Example

    ```ocaml
    drop ~count:3 [1;2;3;4;5;6] = [4;5;6]
    drop ~count:9 [1;2;3;4;5;6] = []
    drop ~count:(-2) [1;2;3;4;5;6] = []
    ```

    ```reason
    drop(~count=3, [1, 2, 3, 4, 5, 6]) == [4, 5, 6];
    drop(~count=9, [1, 2, 3, 4, 5, 6]) == [];
    drop(~count=-2, [1, 2, 3, 4, 5, 6]) == [];
    ```
  *)
  val drop : count:int -> 'a list -> 'a list

  (**
    For non-empty lists, `init xs` (`init(xs)` in ReasonML) returns a new list
    consisting of all but the last list item as a `Some` value.
    If `xs` is an empty list, `init` returns `None`.

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
  *)
  val init : 'a list -> 'a list option


  (**
    `filterMap(~f=fcn, xs)` applies `fcn` to each element of `xs`.
    If the function returns `Some(value)`, then `value` is kept in the resulting list.
    If the result is `None`, the element is not retained in the result. (Same as `filter_map`.)

    ### Example

    ```reason
    filterMap(~f = (x) => if (x mod 2 == 0) {Some(- x)} else {None},
      [1, 2, 3, 4]) == [-2, -4]
    ```
  *)
  val filterMap : f:('a -> 'b option) -> 'a list -> 'b list

  (**
    `filter_map ~f:fcn xs` applies `fcn` to each element of `xs`.
    If the function returns `Some value`, then `value` is kept in the resulting list.
    If the result is `None`, the element is not retained in the result. (Same as `filterMap`.)

    ### Example

    ```ocaml
    filter_map ~f:(fun x -> if x mod 2 = 0 then Some (-x) else None)
      [1;2;3;4] = [-2;-4]
    ```
  *)
  val filter_map : f:('a -> 'b option) -> 'a list -> 'b list

  (**
    `filter ~f:predicate xs` (`filter(~f=predicate, xs)` in ReasonML) returns
    a list of all elements in `xs` which satisfy the predicate function `predicate`.

    ### Example

    ```ocaml
    filter ~f:(fun x -> x mod 2 = 0) [1;2;3;4] = [2;4]
    ```

    ```reason
    filter(~f=((x) => x mod 2 == 0), [1, 2, 3, 4]) == [2, 4];
    ```
  *)
  val filter : f:('a -> bool) -> 'a list -> 'a list

  (**
    `concat xs` (`concat(xs)` in ReasonML) returns the list obtained by concatenating
    all the lists in the list `xs`.

    ### Example

    ```ocaml
    concat [[1;2;3]; []; [4;5]; [6]] = [1;2;3;4;5;6]
    ```

    ```reason
    concat([[1, 2, 3], [], [4, 5], [6]]) == [1, 2, 3, 4, 5, 6];
    ```
  *)
  val concat : 'a list list -> 'a list

  (**
    `partition ~f:predicate` (`partition(~f=predicate, xs)` in ReasonML) returns
    a tuple of two lists. The first element is a list of all the elements of `xs`
    for which `predicate` returned `true`. The second element of the tuple is a list
    of all the elements in `xs` for which `predicate` returned `false`.

    ### Example

    ```ocaml
    let positive x = (x > 0)
    partition ~f:positive [1;-2;-3;4;5] = ([1;4;5], [-2;-3])
    ```

    ```reason
    let positive = (x) => {x > 0};
    partition(~f = positive, [1, -2, -3, 4, 5]) == ([1, 4, 5], [-2, -3]);
    ```
  *)
  val partition : f:('a -> bool) -> 'a list -> 'a list * 'a list

  val foldr : f:('a -> 'b -> 'b) -> init:'b -> 'a list -> 'b

  val foldl : f:('a -> 'b -> 'b) -> init:'b -> 'a list -> 'b

  (**
    `findIndex(~f=predicate, xs)` finds the position of the first element in `xs` for which
    `predicate` returns `true`. The position is returned as `Some(index)`.
    If no element satisfies the `predicate`, `findIndex` returns `None`. (Same as `find_index`.)

    ### Example

    ```reason
    let negative = (x) => {x < 0};
    findIndex(~f = negative, [100, 101, -102, 103]) == Some(2);
    findIndex(~f = negative, [100, 101]) == None;
    findIndex(~f = negative, []) == None;
    ```
  *)
  val findIndex : f:('a -> bool) -> 'a list -> int option

  (**
    `find_index ~f:predicate` finds the position of the first element in `xs` for which
    `predicate` returns `true`. The position is returned as `Some index`.
    If no element satisfies the `predicate`, `find_index` returns `None`. (Same as `findIndex`.)

    ### Example

    ```ocaml
    let negative x = (x < 0)
    find_index ~f:negative [100;101;-102;103] = Some 2
    find_index ~f:negative [100;101] = None
    find_index ~f:negative [] = None
    ```
  *)
  val find_index : f:('a -> bool) -> 'a list -> int option

  (**
    `take ~count:n xs` (`take(~count=n, xs)` in ReasonML) returns a list consisting of
    the first `n` elements of `xs`. If `n` is less than or equal to zero or greater than
    the length of `xs`, `take` returns the empty list.

    ### Example

    ```ocaml
    take ~count:3 [1;2;3;4;5;6] = [1;2;3]
    take ~count:9 [1;2;3;4;5;6] = []
    take ~count:(-2) [1;2;3;4;5;6] = []
    ```

    ```reason
    take(~count=3, [1, 2, 3, 4, 5, 6]) == [1, 2, 3];
    take(~count=9, [1, 2, 3, 4, 5, 6]) == [];
    take(~count=-2, [1, 2, 3, 4, 5, 6]) == [];
    ```
  *)
  val take : count:int -> 'a list -> 'a list

  (**
    `updateAt(~index = n, ~f = fcn, xs)` returns a new list with function `fcn` applied
    to the list item at index position `n`. (The first item in a list has index zero.)
    If `n` is less than zero or greater than the number of items in `xs`,
    the new list is the same as the original list. (Same as `update_at`.)

    ### Example

    ```reason
    let double = (x) => {x * 2};
    updateAt(~index = 1, ~f = double, [1, 2, 3]) == [1, 4, 3];
    updateAt(~index = -2, ~f = double, [1, 2, 3]) == [1, 2, 3];
    updateAt(~index = 7, ~f = double, [1, 2, 3]) == [1, 2, 3];
    ```
  *)
  val updateAt : index:int -> f:('a -> 'a) -> 'a list -> 'a list

  (**
    `update_at ~index:n ~f:fcn xs` returns a new list with function `fcn` applied
    to the list item at index position `n`. (The first item in a list has index zero.)
    If `n` is less than zero or greater than the number of items in `xs`,
    the new list is the same as the original list. (Same as `updateAt`.)

    ### Example

    ```ocaml
    let double x = x * 2
    update_at ~index:1 ~f:double [1;2;3]  = [1;4;3]
    update_at ~index:(-2) ~f:double [1;2;3] = [1;2;3]
    update_at ~index:7 ~f:double [1;2;3] = [1;2;3]
    ```
  *)
  val update_at : index:int -> f:('a -> 'a) -> 'a list -> 'a list

  (**
    `length xs` (`length(xs)` in ReasonML)` returns the number of items in the given list.
    An empty list returns zero.
  *)
  val length : 'a list -> int

  (**
    `reverse xs` (`reverse(xs)` in ReasonML)` returns a list whose items are in the
    reverse order of those in `xs`.
  *)
  val reverse : 'a list -> 'a list

  (**
    `dropWhile(~f=predicate, xs)` returns a list without the first elements
    of `xs` for which the `predicate` function returns `true`. (Same as `drop_while`.)

    ### Example

    ```reason
    let even = (x) => {x mod 2 == 0};
    dropWhile(~f=even, [2, 4, 6, 7, 8, 9]) == [7, 8, 9];
    dropWhile(~f=even, [2, 4, 6, 8]) == [];
    dropWhile(~f=even, [1, 2, 3]) == [1, 2, 3];
    ```
  *)
  val dropWhile : f:('a -> bool) -> 'a list -> 'a list

  (**
    `drop_while ~f:predicate xs` returns a list without the first elements
    of `xs` for which the `predicate` function returns `true`. (Same as `dropWhile`.)

    ### Example

    ```ocaml
    let even x = x mod 2 = 0
    drop_while ~f:even [2; 4; 6; 7; 8; 9] = [7; 8; 9]
    drop_while ~f:even [2; 4; 6; 8] = []
    drop_while ~f:even [1; 2; 3] = [1; 2; 3]
    ```

  *)
  val drop_while : f:('a -> bool) -> 'a list -> 'a list

  (**
    `isEmpty(xs)` returns `true` if `xs` is the empty list `[]`; `false` otherwise.
    (Same as `is_empty`.)
  *)
  val isEmpty : 'a list -> bool

  (**
    `is_empty xs`  returns `true` if `xs` is the empty list `[]`; `false` otherwise.
    (Same as `isEmpty`.)
  *)
  val is_empty : 'a list -> bool

  (**
    `cons item xs` (`cons(item, xs)` in ReasonML) prepends the `item` to `xs`.

    ### Example

    ```ocaml
    cons "one" ["two"; "three"] = ["one"; "two"; "three"]
    cons 42 [] = [42]
    ```

    ```reason
    cons("one", ["two", "three"]) == ["one", "two", "three"];
    cons(42, []) == [42];
    ```
  *)
  val cons : 'a -> 'a list -> 'a list

  (**
    `takeWhile(~f=predicate, xs)` returns a list with the first elements
    of `xs` for which the `predicate` function returns `true`. (Same as `take_while`.)

    ### Example

    ```reason
    let even = (x) => {x mod 2 == 0};
    takeWhile(~f=even, [2, 4, 6, 7, 8, 9]) == [2, 4, 6];
    takeWhile(~f=even, [2, 4, 6]) == [2, 4, 6];
    takeWhile(~f=even, [1, 2, 3]) == [];
    ```
  *)
  val takeWhile : f:('a -> bool) -> 'a list -> 'a list

  (**
    `take_while ~f:predicate xs` returns a list with the first elements
    of `xs` for which the `predicate` function returns `true`. (Same as `takeWhile`.)

    ### Example

    ```ocaml
    let even x = x mod 2 = 0
    take_while ~f:even [2; 4; 6; 7; 8; 9] = [2; 4; 6]
    take_while ~f:even [2; 4; 6] = [2; 4; 6]
    take_while ~f:even [1; 2; 3] = []
    ```
  *)
  val take_while : f:('a -> bool) -> 'a list -> 'a list

  (**
    `all ~f:predicate xs` (`all(~f=predicate, xs)` in ReasonML) returns `true`
    if all the elements in `xs` satisfy the `predicate` function, `false` otherwise.
    Note: `all` returns `true` if `xs` is the empty list.

    ### Example

    ```ocaml
    let even x = x mod 2 = 0
    all ~f:even [16; 22; 40] = true
    all ~f:even [16; 21; 40] = false
    all ~f:even [] = true
    ```

    ```reason
    let even = (x) => {x mod 2 == 0};
    all(~f=even, [16, 22, 40]) == true;
    all(~f=even, [16, 21, 40]) == false;
    all(~f=even, []) == true;
    ```
  *)
  val all : f:('a -> bool) -> 'a list -> bool

  (**
    `tail xs` (`tail(xs)` in ReasonML) returns all except the first item in `xs`
    as a `Some` value when `xs` is not empty. If `xs` is the empty list,
    `tail` returns `None`.

    ```ocaml
    tail [3; 4; 5] = Some [4; 5]
    tail [3] = Some []
    tail [] = None
    ```

    ```reason
    tail([3, 4, 5]) == Some([4, 5]);
    tail([3]) == Some([]);
    tail([]) == None;
    ```
  *)
  val tail : 'a list -> 'a list option

  (**
    `append xs ys` (`append(xs, ys)` in ReasonML) returns a new list with
    the elements of `xs` followed by the elements of `ys`.

    ### Example
    ```ocaml
    append [1; 2] [3; 4; 5] = [1; 2; 3; 4; 5]
    append [] [6; 7] = [6; 7]
    append [8; 9] [] = [8; 9]
    ```

    ```reason
    append([1, 2], [3, 4, 5]) == [1, 2, 3, 4, 5];
    append([], [6, 7]) == [6, 7];
    append([8, 9], []) == [8, 9];
    ```
  *)
  val append : 'a list -> 'a list -> 'a list

  (**
    `removeAt(n, xs)` returns a new list with the item at the given index removed.
    If `n` is less than zero or greater than the length of `xs`, the new list is
    the same as the original. (Same as `remove_at`.)

    ### Example

    ```reason
    removeAt(~index=2, ["a", "b", "c", "d"] == ["a", "b", "d"]);
    removeAt(~index=-2, ["a", "b", "c", "d"] == ["a", "b", "c", "d"]);
    removeAt(~index=7, ["a", "b", "c", "d"] == ["a", "b", "c", "d"]);
    ```
  *)
  val removeAt : index:int -> 'a list -> 'a list

  (**
    `remove_at n xs` returns a new list with the item at the given index removed.
    If `n` is less than zero or greater than the length of `xs`, the new list is
    the same as the original. (Same as `removeAt`.)

    ### Example

    ```ocaml
    remove_at ~index:2, ["a"; "b"; "c"; "d"] = ["a"; "b"; "d"]
    remove_at ~index:(-2) ["a"; "b"; "c"; "d"] = ["a"; "b"; "c"; "d"]
    remove_at ~index:7 ["a"; "b"; "c"; "d"] = ["a"; "b"; "c"; "d"]
    ```
  *)
  val remove_at : index:int -> 'a list -> 'a list

  (**
    `minimumBy(~f=fcn, xs)`, when given a non-empty list, returns the item in the list
    for which `fcn(item)` is a minimum. It is returned as `Some(item)`.

    If given an empty list, `minimumBy` returns `None`. If more than one value has a minimum
    value for `fcn item`, the first one is returned.

    The function provided takes a list item as its parameter and must return a value
    that can be compared---for example, a `string` or `int`. (Same as `minimum_by`.)

    ### Example

    ```reason
    let mod12 = (x) => (x mod 12);
    let hours = [7, 9, 15, 10, 3, 22];
    minimumBy(~f=mod12, hours) == Some(15);
    minimumBy(~f=mod12, []) == None;
    ```
   *)
  val minimumBy : f:('a -> 'comparable) -> 'a list -> 'a option

  (**
    `minimum_by ~f:fcn, xs`, when given a non-empty list, returns the item in the list
    for which `fcn item` is a minimum. It is returned as `Some item`.

    If given an empty list, `minimumBy` returns `None`. If more than one value has a minimum
    value for `fcn item`, the first one is returned.

    The function provided takes a list item as its parameter and must return a value
    that can be compared---for example, a `string` or `int`. (Same as `minimumBy`.)

    ### Example

    ```ocaml
    let mod12 x = x mod 12
    let hours = [7; 9; 15; 10; 3; 22]
    minimum_by ~f:mod12 hours = Some 15
    minimum_by ~f:mod12 [] = None
    ```
   *)
  val minimum_by : f:('a -> 'comparable) -> 'a list -> 'a option

  (**
    `minimum xs` (`minimum(xs)` in ReasonML), when given a non-empty list, returns
    the item in the list with the minimum value. It is returned as `Some value`
    (`Some(value) in ReasonML)`. If given an empty list, `maximum` returns `None`.

    The items in the list must be of a type that can be compared---for example, a `string` or `int`.
   *)
  val minimum: 'comparable list -> 'comparable option

  (**
    `maximumBy(~f=fcn, xs)`, when given a non-empty list, returns the item in the list
    for which `fcn(item)` is a maximum. It is returned as `Some(item)`.

    If given an empty list, `maximumBy` returns `None`. If more than one value has a maximum
    value for `fcn item`, the first one is returned.

    The function provided takes a list item as its parameter and must return a value
    that can be compared---for example, a `string` or `int`. (Same as `maximum_by`.)

    ### Example

    ```reason
    let mod12 = (x) => (x mod 12);
    let hours = [7, 9, 15, 10, 3, 22];
    maximumBy(~f=mod12, hours) == Some(10);
    maximumBy(~f=mod12 []) == None;
    ```
   *)
  val maximumBy : f:('a -> 'comparable) -> 'a list -> 'a option

  (**
    `maximum_by ~f:fcn, xs`, when given a non-empty list, returns the item in the list
    for which `fcn item` is a maximum. It is returned as `Some item`.

    If given an empty list, `maximumBy` returns `None`. If more than one value has a maximum
    value for `fcn item`, the first one is returned.

    The function provided takes a list item as its parameter and must return a value
    that can be compared---for example, a `string` or `int`. (Same as `maximumBy`.)

    ### Example

    ```ocaml
    let mod12 x = x mod 12
    let hours = [7;9;15;10;3;22]
    maximum_by ~f:mod12 hours = Some 10
    maximum_by ~f:mod12 [] = None
    ```
   *)
  val maximum_by : f:('a -> 'comparable) -> 'a list -> 'a option

  (**
    `maximum xs` (`maximum(xs)` in ReasonML), when given a non-empty list, returns
    the item in the list with the maximum value. It is returned as `Some value`
    (`Some(value) in ReasonML)`. If given an empty list, `maximum` returns `None`.

    The items in the list must be of a type that can be compared---for example, a `string` or `int`.
   *)
  val maximum : 'comparable list -> 'comparable option

  (**
    `sortBy(~f=fcn, xs)` returns a new list sorted according to the values
    returned by `fcn`. This is a stable sort; if two items have the same value,
    they will appear in the same order that they appeared in the original list.
    (Same as `sort_by`.)

    ### Example

    ```reason
    sortBy(~f = (x) => {x * x}, [3, 2, 5, -2, 4]) == [2, -2, 3, 4, 5];
    ```
  *)
  val sortBy : f:('a -> 'b) -> 'a list -> 'a list

  (**
    `sort_by ~f:fcn xs` returns a new list sorted according to the values
    returned by `fcn`. This is a stable sort; if two items have the same value,
    they will appear in the same order that they appeared in the original list.
    (Same as `sortBy`.)

    ### Example

    ```ocaml
    sort_by ~f:(fun x -> x * x) [3; 2; 5; -2; 4] = [2; -2; 3; 4; 5]
    ```
  *)
  val sort_by : f:('a -> 'b) -> 'a list -> 'a list

  (**
    `span ~f:predicate xs` (`span(~f=fcn, xs)` in ReasonML) splits the list `xs`
    into a tuple of two lists. The first list contains the first elements of `xs`
    that satisfy the predicate; the second list contains the remaining elements of `xs`.

    ```ocaml
    let even x = x mod 2 = 0
    span ~f:even [4; 6; 8; 1; 2; 3] = ([4; 6; 8], [1; 2; 3])
    span ~f:even [1; 2; 3] = ([], [1; 2; 3])
    span ~f:even [20; 40; 60] = ([20; 40; 60], [])
    ```

    ```reason
    let even = (x) => {x mod 2 == 0};
    span(~f=even, [4, 6, 8, 1, 2, 3]) == ([4, 6, 8], [1, 2, 3]);
    span(~f=even, [1, 2, 3]) == ([], [1, 2, 3]);
    span(~f=even, [20, 40, 60]) == ([20, 40, 60], []);
    ```
  *)
  val span : f:('a -> bool) -> 'a list -> 'a list * 'a list

  (**
    `groupWhile(~f=fcn, xs)` produces a list of lists. Each sublist consists of
    consecutive elements of `xs` which belong to the same group according to `fcn`.

    `fcn` takes two parameters and returns a `bool`: `true` if
    the values should be grouped together, `false` if not. (Same as `group_while`.)

    ### Example

    ```reason
    groupWhile(~f = (x, y) => {x mod 2 == y mod 2},
      [2, 4, 6, 5, 3, 1, 8, 7, 9]) == [[2, 4, 6], [5, 3, 1], [8], [7, 9]]
    ```
  *)
  val groupWhile : f:('a -> 'a -> bool) -> 'a list -> 'a list list

  (**
    `group_while ~f:fcn xs` produces a list of lists. Each sublist consists of
    consecutive elements of `xs` which belong to the same group according to `fcn`.

    `fcn` takes two parameters and returns a `bool`: `true` if
    the values should be grouped together, `false` if not. (Same as `groupWhile`.)

    ### Example

    ```ocaml
    groupWhile ~f:(fun x y -> x mod 2 == y mod 2)
      [2; 4; 6; 5; 3; 1; 8; 7; 9] = [[2; 4; 6]; [5; 3; 1]; [8]; [7; 9]]
    ```
  *)
  val group_while : f:('a -> 'a -> bool) -> 'a list -> 'a list list

  (**
    `splitAt(~index=n, xs)` returns a tuple of two lists. The first list has the
    first `n` items of `xs`, the second has the remaining items of `xs`.

    If `n` is less than zero or greater than the length of `xs`, `splitAt`
    returns two empty lists.

    (Same as `split_at`.)

    ### Example

    ```reason
    splitAt(~index=3, [10, 11, 12, 13, 14]) == ([10, 11, 12], [13, 14])
    splitAt(~index=0, [10, 11, 12]) == ([], [10, 11, 12])
    splitAt(~index=4, [10, 11, 12]) == ([10, 11, 12], [])
    splitAt(~index=-1, [10, 11, 12]) == ([], [])
    ```
  *)
  val splitAt : index:int -> 'a list -> 'a list * 'a list

  (**
    `split_at ~index:n xs` returns a tuple of two lists. The first list has the
    first `n` items of `xs`, the second has the remaining items of `xs`.

    If `n` is less than zero or greater than the length of `xs`, `split_at`
    returns two empty lists.

    (Same as `splitAt`.)

    ### Example

    ```ocaml
    split_at ~index:3 [10; 11; 12; 13; 14] = ([10; 11; 12], [13; 14])
    split_at ~index:0 [10; 11; 12] = ([], [10; 11; 12])
    split_at ~index:3 [10; 11; 12] = ([10; 11; 12], [])
    split_at ~index:(-1) [10; 11; 12] = ([], [])
    split_at ~index:4 [10; 11; 12] = ([], [])
    ```
  *)
  val split_at : index:int -> 'a list -> 'a list * 'a list

  (**
    `insertAt(~index=n, ~value=v, xs)` returns a new list with the value `v` inserted
    before position `n` in `xs`. If `n` is less than zero or greater than the length of `xs`,
    returns a list consisting only of the value `v`.

    (Same as `insert_at`.)

    ### Example:

    ```reason
    insertAt(~index=2, ~value=999, [100, 101, 102, 103]) == [100, 101, 999, 102, 103]
    insertAt(~index=0, ~value=999, [100, 101, 102, 103]) == [999, 100 101, 102, 103]
    insertAt(~index=4, ~value=999, [100, 101, 102, 103]) == [100, 101, 102, 103, 999]
    insertAt(~index=-1, ~value=999, [100, 101, 102, 103]) == [999]
    insertAt(~index=5, ~value=999, [100, 101, 102, 103]) == [999]
  *)
  val insertAt : index:int -> value:'a -> 'a list -> 'a list

  (**
    `insert_at ~index:n, ~value:v, xs` returns a new list with the value `v` inserted
    before position `n` in `xs`. If `n` is less than zero or greater than the length of `xs`,
    returns a list consisting only of the value `v`.

    (Same as `insertAt`.)

    ### Example:

    ```ocaml
    insert_at ~index:2 ~value:999 [100; 101; 102; 103] = [100; 101; 999; 102; 103]
    insert_at ~index:0 ~value:999 [100; 101; 102; 103] = [999; 100; 101; 102; 103]
    insert_at ~index:4 ~value:999 [100; 101; 102; 103] = [100; 101; 102; 103; 999]
    insert_at ~index:(-1) ~value:999 [100; 101; 102; 103] = [999]
    insert_at ~index:5 ~value:999 [100; 101; 102; 103] = [999]
    ```
  *)
  val insert_at : index:int -> value:'a -> 'a list -> 'a list

  (**
    `splitWhen(~f=predicate, xs)` returns a tuple of two lists.
    The first element of the tuple is the list of all the elements at the
    beginning of `xs` that  do _not_ satisfy the `predicate` function.
    The second element of the tuple is the list of the remaining items in `xs`.

    (Same as `split_when`.)

    ### Example

    ```reason
    let even = (x) => {x mod 2 == 0};
    splitWhen(~f = even, [5, 1, 2, 6, 3]) == ([5, 1], [2, 6, 3]);
    splitWhen(~f = even, [2, 6, 5]) == ([], [2, 6, 5]);
    splitWhen(~f = even, [1, 5, 3]) == ([1, 5, 3], []);
    splitWhen(~f = even, [2, 6, 4]) == ([], [2, 6, 4]);
    splitWhen(~f = even, []) == ([], [])
    ```
  *)
  val splitWhen : f:('a -> bool) -> 'a list -> 'a list * 'a list

  (**
    `split_when ~f:predicate  xs` returns a tuple of two lists as an `option` value.
    The first element of the tuple is the list of all the elements at the
    beginning of `xs` that  do _not_ satisfy the `predicate` function.
    The second element of the tuple is the list of the remaining items in `xs`.

    (Same as `splitWhen`.)

    ### Example

    ```reason
    let even x = (x mod 2 = 0)
    split_when ~f:even [5; 1; 2; 6; 3] = ([5; 1], [2; 6; 3])
    split_when ~f:even [2; 6; 5] = ([], [2; 6; 5])
    split_when ~f:even [1; 5; 3] = ([1; 5; 3], [])
    split_when ~f:even [2; 6; 4] = ([], [2; 6; 4])
    split_when ~f:even [] = ([], [])
    ```
  *)
  val split_when : f:('a -> bool) -> 'a list -> 'a list * 'a list

  (**
    `intersperse separator xs` (`intersperse(separator, xs)` in ReasonML)
    inserts `separator`  between all the elements in `xs`. If `xs` is empty,
    `intersperse` returns the empty list.

    ### Example

    ```ocaml
    intersperse "/" ["a"; "b"; "c"] = ["a"; "/"; "b"; "/"; "c"]
    intersperse "?" [] = []
    ```

    ```reason
    intersperse("/", ["a", "b", "c"]) == ["a", "/", "b", "/", "c"]
    intersperse("?", [] == [])
    ```
  *)
  val intersperse : 'a -> 'a list -> 'a list

  (**
    `initialize n f` (`initialize(n, f)` in ReasonML) creates a list with values
    `[f 0; f 1; ...f (n - 1)]` (`[f(0), f(1),...f(n - 1)]` in ReasonML. Returns
    the empty list if given a negative value for `n`.

    ### Example
    ```ocaml
    let cube_plus_one x = ((float_of_int x) +. 1.0) ** 3.0
    initialize 3 cube_plus_one = [1.0; 8.0; 27.0]
    initialize 0 cube_plus_ones = []
    initialize (-2) cube_plus_one = []
    ```

    ```reason
    let cube_plus_one = (x) => {(float_of_int(x) +. 1.0) ** 3.0};
    initialize(3, cube_plus_one) == [1.0, 8.0, 27.0];
    initialize(0, cube_plus_one) == [];
    initialize(-2, cube_plus_one) == [];
    ```
  *)
  val initialize : int -> (int -> 'a) -> 'a list

  (**
    `sortWith(compareFcn, xs)` returns a new list with the elements in `xs` sorted according `compareFcn`.
    The `compareFcn` function takes two list items and returns a value less than zero if the first item
    compares less than the second, zero if the items compare equal, and one if the first item compares
    greater than the second.

    This is a stable sort; items with equivalent values according to the `compareFcn`
    appear in the sorted list in the same order as they appeared in the original list.

    (Same as `sort_with`)

    ```reason
    let cmp_mod12 = (a, b) => {
      (a mod 12) - (b mod 12)
    };

    sortWith(cmp_mod12, [15, 3, 22, 10, 16]) == [3, 15, 10, 22, 10]
  *)

  val sortWith : ('a -> 'a -> int) -> 'a list -> 'a list

  (**
    `sort_with compareFcn  xs` returns a new list with the elements in `xs` sorted according `compareFcn`.
    The `compareFcn` function takes two list items and returns a value less than zero if the first item
    compares less than the second, zero if the items compare equal, and one if the first item compares
    greater than the second.

    This is a stable sort; items with equivalent values according to the `compareFcn`
    appear in the sorted list in the same order as they appeared in the original list.

    (Same as `sortWith`)

    ```ocaml
    let cmp_mod12 a b = (
      (a mod 12) - (b mod 12)
    )

    sortWith cmp_mod12 [15; 3; 22; 10; 16] == [3; 15; 10; 22; 10]
    ```
  *)
  val sort_with : ('a -> 'a -> int) -> 'a list -> 'a list

  (**
    `iter ~f: fcn xs` (`iter(~f=fcn, xs)` in ReasonML) applies the given function
    to each element in `xs`. The function you provide must return `unit`, and the
    `iter` call itself also returns `unit`. You use `iter` when you want to process
    a list only for side effects.

    ### Example

    The following code will print the items in the list to the console.

    ```ocaml
    let _ = iter ~f:Js.log ["a"; "b"; "c"]
    ```

    ```reason
    iter(~f=Js.log, ["a", "b", "c"]);
    ```
  *)
  val iter : f:('a -> unit) -> 'a list -> unit
end

(**
  This module implements the `Result` type, which has a variant for 
  successful results (`'ok`), and one for unsuccessful results (`'error`).
*)

module Result : sig

  (**
    `type` is the type constructor for a `Result` type. You specify
    the type of the `Error` and `Ok` variants, in that order.
    
    ### Example
    
    Here is how you would annotate a `Result` variable whose `Ok`
    variant is an integer and whose `Error` variant is a string:
    
    ```ocaml
    let x: (string, int) Tablecloth.Result.t = Ok 3
    let y: (string, int) Tablecloth.Result.t = Error "bad"
    ```
    
    ```reason
    let x: Tablecloth.Result.t(string, int) = Ok(3);
    let y: Tablecloth.Result.t(string, int) = Error("bad");
    ```
  *)
  type ('err, 'ok) t = ('ok, 'err) Belt.Result.t

  (**
    `succeed(value)` returns `Ok(value)`. Use this to construct a successful
    result without having to depend directly on Belt or Base.

    ### Example

    Not only can you use `succeed` whenever you would use the type constructor,
    but you can also use it when you would have wanted to pass the constructor
    itself as a function.

    ```ocaml
    succeed 3 = Ok 3
    List.map [1; 2; 3] ~f:succeed = [Ok 1; Ok 2; Ok 3]
    ```

    ```reason
    succeed(3) == Ok(3);
    Array.initialize(~length=3, ~f=succeed) == [|Ok(0); Ok(1); Ok(2)|];
    ```
  *)
  val succeed : 'ok -> ('err, 'ok) t

  (**
    `fail(value)` returns `Error(value)`. Use this to construct a failing
    result without having to depend directly on Belt or Base.

    (Similar to `succeed`)

    ### Example

    Not only can you use `fail` whenever you would use the type constructor,
    but you can also use it when you would have wanted to pass the constructor
    itself as a function.

    ```ocaml
    fail 3 = Error 3
    List.map [1; 2; 3] ~f:fail = [Error 1; Error 2; Error 3]
    ```

    ```reason
    fail(3) == Error(3);
    Array.initialize(~length=3, ~f=succeed) == [|Ok(0); Ok(1); Ok(2)|];
    ```
  *)
  val fail : 'err -> ('err, 'ok) t

  (**
    `withDefault(~default=defaultValue, result)`, when given an `Ok(value)`, returns
    `value`; if given an `Error(errValue)`, returns `defaultValue`.
    
    (Same as `with_default`)
    
    ### Example
    
    ```reason
    withDefault(~default=0, Ok(12)) == 12;
    withDefault(~default=0, Error("bad")) == 0;
    ```
  *)
  val withDefault : default:'ok -> ('err, 'ok) t -> 'ok

  (**
    `with_default ~default:defaultValue, result`, when given an `Ok value`, returns
    `value`; if given an `Error errValue `, returns `defaultValue`.
    
    (Same as `withDefault`)
    
    ### Example
    
    ```ocaml
    with_default ~default:0 (Ok 12) = 12
    with_default ~default:0 (Error "bad") = 0
    ```
  *)
  val with_default : default:'ok -> ('err, 'ok) t -> 'ok

  (**
    `map2 ~f:fcn result_a result_b` (`map2(~f=fcn, result_a, result_b)` applies
    `fcn`, a function taking two non-`Result` parameters and returning a 
    non-`Result` result to two `Result` arguments `result_a` and `result_b` as follows:
    
    If `result_a` and `result_b` are of the form `Ok a` and `OK b` (`Ok(a)` and `Ok(b)`
    in ReasonML), the return value is `Ok (f a b)` (`Ok(f(a, b)` in ReasonML).
    
    If only one of `result_a` and `result_b` is of the form `Error err` (`Error(err)`
    in ReasonML), that becomes the return result.  If both are `Error` values,
    `map2` returns `result_a`.
    
    ### Example
    
    ```ocaml
    let sum_diff x y = (x + y) * (x - y)
    map2 ~f:sum_diff (Ok 7) (Ok 3) = Ok 40
    map2 ~f:sum_diff (Error "err A") (Ok 3) = Error "err A"
    map2 ~f:sum_diff (Ok 7) (Error "err B") = Error "err B"
    map2 ~f:sum_diff (Error "err A") (Error "err B") = Error ("err A")
    ```
    
    ```reason
    let sumDiff = (x, y) => { (x + y) * (x - y) };
    map2(~f=sumDiff, Ok(7), Ok(3)) == Ok(40);
    map2(~f=sumDiff, Error("err A"), Ok(3)) == Error("err A");
    map2(~f=sumDiff, Ok(7), Error("err B")) == Error("err B");
    map2(~f=sumDiff, Error("err A"), Error("err B")) == Error("err A");
    ```
  *)
  val map2 : f:('a -> 'b -> 'c) -> ('err, 'a) t -> ('err, 'b) t -> ('err, 'c) t

  (**
    `combine results` (`combine(results)` in ReasonML) takes a list of `Result` values. If all
    the elements in `results` are of the form `Ok x` (`Ok(x)` in ReasonML), then `combine`
    creates a list `xs` of all the values extracted from their `Ok`s, and returns 
    `Ok xs` (`Ok(xs)` in ReasonML)
    
    If any of the elements in `results` are of the form `Error err`
    (`Error(err)` in ReasonML), the first of them is returned as
    the result of `combine`.
    
    ### Example
    
    ```ocaml
    combine [Ok 1; Ok 2; Ok 3; Ok 4] = Ok [1; 2; 3; 4]
    combine [Ok 1; Error "two"; Ok 3; Error "four"] = Error "two"
    ```
    
    ```reason
    combine([Ok(1), Ok(2), Ok(3), Ok(4)]) == Ok([1, 2, 3, 4]);
    combine([Ok(1), Error("two"), Ok(3), Error("four")]) == Error("two")
    ```
  *)
  val combine : ('x, 'a) t list -> ('x, 'a list) t

  (**
    `map f r` (`map(f, r)` in ReasonML) applies a function `f`, which
    takes a non-`Result` argument and returns a non-`Result` value, to
    a `Result` variable `r` as follows:
    
    If `r` is of the form `Ok x` (`Ok(x) in ReasonMl), `map` returns
    `Ok (f x)` (`Ok(f(x))` in ReasonML). Otherwise, `r` is an `Error`
    value and is returned unchanged.
    
    ### Example
    ```ocaml
    map (fun x -> x * x) (Ok 3) = Ok 9
    map (fun x -> x * x) (Error "bad") = Error "bad"
    ```
    
    ```reason
    map((x) => {x * x}, Ok(3)) == Ok(9);
    map((x) => {x * x}, Error("bad")) == Error("bad");
    ```
  *)
  val map : ('ok -> 'value) -> ('err, 'ok) t -> ('err, 'value) t

  (**
    `toOption(r)` converts a `Result` value `r` to an `Option` value as follows:
    a value of `Ok(x)` becomes `Some(x)`; a value of `Error(err)` becomes `None`.
    
    (Same as `to_option`.)
    
    ### Example
    
    ```reason
    toOption(Ok(42)) == Some(42);
    toOption(Error("bad")) == None;
    ```
  *)    
  val toOption : ('err, 'ok) t -> 'ok option

  (**
    `to_option r` converts a `Result` value `r` to an `Option` value as follows:
    a value of `Ok x` becomes `Some x`; a value of `Error err` becomes `None`.
    
    (Same as `toOption`.)
    
    ### Example
    
    ```ocaml
    to_option (Ok 42) = Some 42
    to_option (Error "bad") = None
    ```
  *)    
  val to_option : ('err, 'ok) t -> 'ok option

  (**
    `andThen(~f = fcn, r)` applies function `fcn`, which takes a non-`Result`
    parameter and returns a `Result`, to a `Result` variable `r`.
    
    If `r` is of the form `Ok(x)`, `andThen` returns `f(x)`;
    otherwise `r` is an `Error`, and is returned unchanged.
    
    (Same as `and_then`.)
    
    ### Example

    ```reason
    let recip = (x: float):Tablecloth.Result.t(string, float) => {
      if (x == 0.0) {
        Error("Divide by zero");
      } else {
        Ok(1.0 /. x)
      }
    };
    
    andThen(~f = recip, Ok(4.0)) == Ok(0.25);
    andThen(~f = recip, Error("bad")) == Error("bad");
    andThen(~f = recip, Ok(0.0)) == Error("Divide by zero");
    ```
    
    `andThen` is usually used to implement a chain of function
    calls, each of which returns a `Result` value.
    
    ```reason
    let root = (x: float): Tablecloth.Result.t(string, float) => {
      if (x < 0.0) {
        Error("Cannot be negative");
      } else {
        Ok(sqrt(x));
      }
    };
    
    root(4.0) |> andThen(~f = recip) == Ok(0.5);
    root(-2.0) |> andThen(~f = recip) == Error("Cannot be negative");
    root(0.0) |> andThen(~f = recip) == Error("Divide by zero");
    ```
  *)
  val andThen :
    f:('ok -> ('err, 'value) t) -> ('err, 'ok) t -> ('err, 'value) t

  (**
    `and_then ~f:fcn r` applies function `fcn`, which takes a non-`Result`
    parameter and returns a `Result`, to a `Result` variable `r`.
    
    If `r` is of the form `Ok x`, `and_then` returns `f x`;
    otherwise `r` is an `Error`, and is returned unchanged.
    
    (Same as `andThen`.)
    
    ### Example

    ```ocaml
    let recip (x:float) : (string, float) Tablecloth.Result.t = (
      if (x == 0.0)
        Error "Divide by zero"
      else
        Ok (1.0 /. x)
    )
    
    and_then ~f:recip (Ok 4.0) = Ok 0.25
    and_then ~f:recip (Error "bad") = Error "bad"
    and_then ~f:recip (Ok 0.0) = Error "Divide by zero"
    ```
    
    `and_then` is usually used to implement a chain of function
    calls, each of which returns a `Result` value.
    
    ```ocaml
    let root (x:float) : (string, float) Tablecloth.Result.t = (
      if (x < 0.0) then
        Error "Cannot be negative"
      else
        Ok (sqrt x)
    )
    
    root 4.0 |> and_then ~f:recip = Ok 0.5
    root (-2.0) |> and_then ~f:recip = Error "Cannot be negative" 
    root(0.0) |> and_then ~f:recip = Error "Divide by zero"
    ```
  *) 
  val and_then :
    f:('ok -> ('err, 'value) t) -> ('err, 'ok) t -> ('err, 'value) t

  (**
    `pp errFormat okFormat destFormat result`
    (`pp(errFormat, okFormat, destFormat, result)` in ReasonML “pretty-prints”
    the `result`, using `errFormat` if the `result` is an `Error` value or
    `okFormat` if the `result` is an `Ok` value. `destFormat` is a formatter
    that tells where to send the output.
    
    The following example will print `<ok: 42><error: bad>`.
    
    ### Example
    
    ```ocaml
    let good: (string, int) Tablecloth.Result.t = Ok 42
    let not_good: (string, int) Tablecloth.Result.t = Error "bad"
    pp Format.pp_print_string Format.pp_print_int Format.std_formatter good
    pp Format.pp_print_string Format.pp_print_int Format.std_formatter not_good
    Format.pp_print_newline Format.std_formatter ();
    ```
    
    ```reason
    let good: Tablecloth.Result.t(string, int) = Ok(42);
    let notGood: Tablecloth.Result.t(string, int) = Error("bad");
    pp(Format.pp_print_string, Format.pp_print_int, Format.std_formatter, good);
    pp(Format.pp_print_string, Format.pp_print_int, Format.std_formatter, notGood);
    Format.pp_print_newline(Format.std_formatter, ());
    ```
  *)
  val pp :
       (Format.formatter -> 'err -> unit)
    -> (Format.formatter -> 'ok -> unit)
    -> Format.formatter
    -> ('err, 'ok) t
    -> unit
end

(**
  This module provides functions to work with the `option` type,
  which has a variant for  valid values (`'Some`), and one for
  invalid values (`'None`).
*)

module Option : sig

  type 'a t = 'a option

  (**
    `some(value)` returns `Some(value)`. Use this to construct the Some branch
    of an option whenever you need a function to do so.

    ### Example

    ```ocaml
    List.map [1; 2; 3] ~f:some = [Some 1; Some 2; Some 3]
    ```

    ```reason
    Array.initialize(~length=3, ~f=some) == [|Some(0); Some(1); Some(2)|];
    ```
  *)
  val some : 'a -> 'a option

  (**
    `andThen(~f = fcn, opt)` applies function `fcn`, which takes a non-`Option`
    parameter and returns a `Option`, to an `Option` variable `opt`.
    
    If `opt` is of the form `Some(x)`, `andThen` returns `f(x)`;
    otherwise `andThen` returns `None`.
    
    (Same as `and_then`.)
    
    ### Example
    ```reason
    let recip = (x: float): option(float) => {
      if (x == 0.0) {
        None;
      } else {
        Some(1.0 /. x);
      }
    };
    
    andThen(~f = recip, Some(4.0)) == Some(0.25);
    andThen(~f = recip, None) == None;
    andThen(~f = recip, Some(0.0)) == None;
    ```
    
    `andThen` is usually used to implement a chain of function
    calls, each of which returns an `Option` value.
    
    ```reason
    let root = (x: float): option(float) => {
      if (x < 0.0) {
        None
      } else {
        Some(sqrt(x));
      }
    };
    
    root(4.0) |> andThen(~f = recip) == Some(0.5);
    root(-2.0) |> andThen(~f = recip) == None;
    root(0.0) |> andThen(~f = recip) == None;
    ```
  *)
  val andThen : f:('a -> 'b option) -> 'a option -> 'b option

  (**
    `and_then ~f:fcn opt` applies function `fcn`, which takes a non-`Option`
    parameter and returns an `Option`, to an `Option` variable `opt`.
    
    If `opt` is of the form `Some x`, `and_then` returns `f x`;
    otherwise it returns `None`.
    
    (Same as `andThen`.)
    
    ### Example
    ```ocaml
    let recip (x:float) : float option = (
      if (x == 0.0) then
        None
      else
        Some (1.0 /. x)
    )
    
    and_then ~f:recip (Some 4.0) = Some 0.25
    and_then ~f:recip None = None
    and_then ~f:recip (Some 0.0) = None
    ```
    
    `and_then` is usually used to implement a chain of function
    calls, each of which returns an `Option` value.
    
    ```ocaml
    let root (x:float) : float option = (
      if (x < 0.0) then
        None
      else
        Some (sqrt x)
    )
    
    root 4.0 |> and_then ~f:recip = Some 0.5
    root (-2.0) |> and_then ~f:recip = None 
    root(0.0) |> and_then ~f:recip = None
    ```
  *)
  val and_then : f:('a -> 'b option) -> 'a option -> 'b option

  (**
    `or_ opt_a opt_b` (`or_(opt_a, opt_b)` in ReasonML) returns
    `opt_a` if it is of the form `Some x` (`Some(x) in ReasonML);
    otherwise, it returns `opt_b`.
    
    Unlike the built in or operator, the or_ function does not short-circuit.
    When you call `or_`, both arguments are evaluated before
    being passed to the function.
    
    ### Example
    
    ```ocaml
    or_ (Some 11) (Some 22) = Some 11
    or_ None (Some 22) = Some 22
    or_ (Some 11) None = Some 11
    or_ None None = None
    ```

    ```reason
    or_(Some(11), Some(22)) == Some(11);
    or_(None, Some(22)) == Some(22);
    or_((Some(11)), None) == Some(11);
    or_(None, None) == None;
    ```
  *)
  val or_ : 'a option -> 'a option -> 'a option

  (**
    `orElse(opt_a, opt_b)` returns `opt_b` if it is of the form `Some(x)`;
    otherwise, it returns `opt_a`. 
    
    (Same as `or_else`.)
    
    ### Example
    
    ```reason
    orElse(Some(11), Some(22)) == Some(22);
    orElse(None, Some(22)) == Some(22);
    orElse((Some(11)), None) == Some(11);
    orElse(None, None) == None;
    ```

  *)
  val orElse : 'a option -> 'a option -> 'a option

  (**
    `or_else opt_a opt_b` returns `opt_b` if it is of the form `Some x`;
    otherwise, it returns `opt_a`.
    
    (Same as `orElse`.)
    
    ### Example
    
    ```ocaml
    orElse (Some 11) (Some 22) = Some 22
    orElse None (Some 22) = Some 22
    orElse (Some 11) None = Some 11
    orElse None None = None
    ```
  *)
  val or_else : 'a option -> 'a option -> 'a option

  (**
    `map ~f:fcn opt` (`map(~f = fcn, opt)` in ReasonML) returns
    `fcn x` (`fcn(x)` in ReasonML) if `opt` is of the form
    `Some x` (`Some(x)` in ReasonML); otherwise, it returns `None`.
    
    ### Example
    
    ```ocaml
    map ~f:(fun x -> x * x) (Some 9) = Some 81
    map ~f:(fun x -> x * x) None = None
    ```
    
    ```reason
    map(~f = (x) => x * x, Some(9)) == Some(81)
    map(~f = (x) => x * x, None) == None
    ```
  *)
  val map : f:('a -> 'b) -> 'a option -> 'b option

  (**
    `withDefault(~default = defVal, opt)` If `opt` is of the form `Some(x)`,
    this function returns `x`. Otherwise, it returns the default value `defVal`.
    
    (Same as `with_default`.)
    
    ### Example
    
    ```reason
    withDefault(~default = 99, Some(42)) == 42;
    withDefault(~default = 99, None) == 99;
    ```
  *)
  val withDefault : default:'a -> 'a option -> 'a

  (**
    `with_default(~default: def_val, opt)` If `opt` is of the form `Some x`,
    this function returns `x`. Otherwise, it returns the default value `def_val`.
    
    (Same as `withDefault`.)
    
    ### Example
    
    ```ocaml
    with_default ~default:99 (Some 42) = 42
    with_default ~default:99 None = 99
    ```
  *)
  val with_default : default:'a -> 'a option -> 'a

  val values : 'a option list -> 'a list

  (**
    `toList(opt)` returns the list `[x]` if `opt` is of the form `Some(x)`;
    otherwise, it returns the empty list.
    
    (Same as `to_list`.)
    
    ### Example
    ```reason
    toList(Some(99)) == [99];
    toList(None) == [];
    ```
  *)  
  val toList : 'a option -> 'a list

  (**
    `to_list opt` returns the list `[x]` if `opt` is of the form `Some x`;
    otherwise, it returns the empty list.
    
    (Same as `toList`.)
    
    ### Example
    ```reason
    toList (Some 99) = [99]
    toList None = []
    ```
  *)  
  val to_list : 'a option -> 'a list

  (**
    `isSome(opt)` returns `true` if `opt` is a `Some` value, `false` otherwise.
    (Same as `is_some`.)
  *)
  val isSome : 'a option -> bool

  (**
    `is_some opt` returns `true` if `opt` is a `Some` value, `false` otherwise.
    (Same as `isSome`.)
  *)
  val is_some : 'a option -> bool

  (**
    `toOption(~sentinel = s, x)` returns `Some(x)` unless `x` equals the sentinel
    value `s`, in which case `toOption` returns `None`.
    
    (Same as `to_option`.)
    
    ### Example
    
    ```reason
    toOption(~sentinel = 999, 100) == Some(100);
    toOption(~sentinel = 999, 999) == None;
    ```
  *)
  val toOption : sentinel:'a -> 'a -> 'a option

  (**
    `to_option ~sentinel:s, x` returns `Some x` unless `x` equals the sentinel
    value `s`, in which case `to_option` returns `None`.
    
    (Same as `toOption`.)
    
    ### Example
    
    ```reason
    to_option ~sentinel: 999 100 = Some 100
    to_option ~sentinel: 999 999 = None
    ```
  *)
  val to_option : sentinel:'a -> 'a -> 'a option
end


(**
  The functions in this module work on ASCII
  characters (range 0-255) only, not Unicode.
  Since character 128 through 255 have varying values
  depending on what standard you are using (ISO 8859-1
  or Windows 1252), you are advised to stick to the
  0-127 range.
*)
module Char : sig
  (**
    `toCode(ch)` returns the ASCII value for the given character `ch`.
    (Same as `to_code`.)
    
    ### Example
    ```reason
    toCode('a') == 97;
    toCode('\t') == 9;
    ```
  *)
  val toCode : char -> int

  (**
    `to_code ch` returns the ASCII value for the given character `ch`.
    (Same as `toCode`.)
    
    ### Example
    ```ocaml
    to_code 'a' = 97
    to_code '\t' = 9
    ```
  *)
  val to_code : char -> int

  (**
    `fromCode(n)` returns the character corresponding to ASCII code `n`
    as `Some(ch)` if `n` is in the range 0-255; otherwise `None`.
    
    (Same as `from_code`.)
    
    ### Example
    ```reason
    fromCode(65) == Some('A');
    fromCode(9) == Some('\t');
    fromCode(-1) == None;
    fromCode(256) == None;
    ```
  *)
  val fromCode : int -> char option

  (**
    `from_code n` returns the character corresponding to ASCII code `n`
    as `Some ch` if `n` is in the range 0-255; otherwise `None`.
    
    (Same as `fromCode`.)
    
    ### Example
    ```ocaml
    from_code 65 = Some 'A'
    from_code 9 = Some '\t'
    (from_code (-1)) = None
    from_code 256 = None
    ```
  *)
  val from_code : int -> char option

  (**
    `toString(ch)` returns a string of length one containing `ch`.
    
    (Same as `to_string`.)
    
    ### Example
    ```reason
    toString('a') == "a";
    ```
  *)
  val toString : char -> string

  (**
    `to_string ch` returns a string of length one containing `ch`.
    
    (Same as `toString`.)
    
    ### Example
    ```ocaml
    to_string 'a' = "a"
    ```
  *)
  val to_string : char -> string

  (**
    `fromString(s)` converts the first (and only) character in `s` to `Some(ch)`.
    If the length of `s` is not equal to one, returns `None`.
    
    (Same as `from_string`.)
    
    ### Example
    ```reason
    fromString("R") == Some('R');
    fromString("wrong") == None;
    fromString("") == None;
    ```
  *)
  val fromString : string -> char option

  (**
    `from_string s` converts the first (and only) character in `s` to `Some ch`.
    If the length of `s` is not equal to one, returns `None`.
    
    (Same as `fromString`.)
    
    ### Example
    ```ocaml
    from_string "R"= Some 'R'
    from_string "wrong" = None
    from_string "" = None
    ```
  *)
  val from_string : string -> char option

  (**
    For characters in the range `'0'` to `'9'`, `toDigit(ch)` returns the
    corresponding integer as `Some(n)`; for any characters outside that
    range, returns `None`.
    
    (Same as `to_digit`.)
    
    ### Example
    ```reason
    toDigit('5') == Some(5);
    toDigit('x') == None;
    ```
  *)
  val toDigit : char -> int option

  (**
    For characters in the range `'0'` to `'9'`, `to_digit ch` returns the
    corresponding integer as `Some n`; for any characters outside that
    range, returns `None`.
    
    (Same as `toDigit`.)
    
    ### Example
    ```ocaml
    to_digit '5' = Some 5
    to_digit 'x' = None
    ```
  *)
  val to_digit : char -> int option

  (**
    For characters in the range `'A'` to `'Z'`, `toLowercase(ch)` returns the
    corresponding lower case letter; for any characters outside that
    range, returns the character unchanged.
    
    (Same as `to_lowercase`.)
    
    ### Example
    ```reason
    toLowercase('G') == 'g';
    toLowercase('h') == 'h';
    toLowercase('%') == '%';
    ```
  *)
  val toLowercase : char -> char

  (**
    For characters in the range `'A'` to `'Z'`, `to_lowercase ch` returns the
    corresponding lower case letter; for any characters outside that
    range, returns the character unchanged.
    
    (Same as `toLowercase`.)
    
    ### Example
    ```ocaml
    to_lowercase 'G' = 'g'
    to_lowercase 'h' = 'h'
    to_lowercase '%' = '%'
    ```
  *)
  val to_lowercase : char -> char

  (**
    For characters in the range `'a'` to `'z'`, `toUppercase(ch)` returns the
    corresponding upper case letter; for any characters outside that
    range, returns the character unchanged.
    
    (Same as `to_uppercase`.)
    
    ### Example
    ```reason
    toUppercase('g') == 'G';
    toUppercase('H') == 'H';
    toUppercase('%') == '%';
    ```
  *)
  val toUppercase : char -> char

  (**
    For characters in the range `'A'` to `'Z'`, `to_uppercase ch` returns the
    corresponding upper case letter; for any characters outside that
    range, returns the character unchanged.
    
    (Same as `toUppercase`.)
    
    ### Example
    ```ocaml
    to_uppercase 'g' = 'G'
    to_uppercase 'H' = 'H'
    to_uppercase '%' = '%'
    ```
  *) 
  val to_uppercase : char -> char

  (**
    `isLowercase(ch)` returns `true` if `ch`
    is in the range `'a'` to `'z'`,
    `false` otherwise.
    
    (Same as `is_lowercase`.)
    
    ### Example
    ```reason
    isLowercase('g') == true;
    isLowercase('H') == false;
    isLowercase('%') == false;
    ```
  *)
  val isLowercase : char -> bool

  (**
    `is_lowercase ch` returns `true` if `ch`
    is in the range `'a'` to `'z'`,
    `false` otherwise.
    
    (Same as `isLowercase`.)
    
    ### Example
    ```ocaml
    is_lowercase 'g' = true
    is_lowercase 'H' = false
    is_lowercase '%' = false
    ```
  *)
  val is_lowercase : char -> bool

  (**
    `isUppercase(ch)` returns `true` if `ch`
    is in the range `'A'` to `'Z'`,
    `false` otherwise.
    
    (Same as `is_uppercase`.)
    
    ### Example
    ```reason
    isUppercase('G') == true;
    isUppercase('h') == false;
    isUppercase('%') == false;
    ```
  *)
  val isUppercase : char -> bool

  (**
    `is_uppercase ch` returns `true` if `ch`
    is in the range `'A'` to `'Z'`,
    `false` otherwise.
    
    (Same as `isUppercase`.)
    
    ### Example
    ```ocaml
    is_uppercase 'G' = true
    is_uppercase 'h' = false
    is_uppercase '%' = false
    ```
  *)
  val is_uppercase : char -> bool

  (**
    `isLetter(ch)` returns `true` if `ch` is
    in the range `'A'` to `'Z'`
    or `'a'` to `'z'`, `false` otherwise.
    
    (Same as `is_letter`.)
    
    ### Example
    ```reason
    isLetter('G') == true;
    isLetter('h') == true;
    isLetter('%') == false;
    ```
  *)
  val isLetter : char -> bool

  (**
    `is_letter ch` returns `true` if `ch` is in the range `'A'` to `'Z'`
    or `'a'` to `'z'`, `false` otherwise.
    
    (Same as `isLetter`.)
    
    ### Example
    ```ocaml
    is_letter 'G' = true
    is_letter 'h' = true
    is_letter '%' = false
    ```
  *)
  val is_letter : char -> bool

  (**
    `isDigit(ch)` returns `true` if `ch` is in the range `'0'` to `'9'`;
    `false` otherwise.
    
    (Same as `is_digit`.)
    
    ### Example
    ```reason
    isDigit('3') == true;
    isDigit('h') == false;
    isDigit('%') == false;
    ```
  *)
  val isDigit : char -> bool

  (**
    `is_digit ch` returns `true` if `ch` is in the range `'0'` to `'9'`;
    `false` otherwise.
    
    (Same as `isDigit`.)
    
    ### Example
    ```ocaml
    is_digit '3' = true
    is_digit 'h' = false
    is_digit '%' = false
    ```
  *)
  val is_digit : char -> bool

  (**
    `isAlphanumeric(ch)` returns `true` if `ch` is
    in the range `'0'` to `'9'`, `'A'` to `'Z'`, or `'a'` to `'z'`;
    `false` otherwise.
    
    (Same as `is_alphanumeric`.)
    
    ### Example
    ```reason
    isAlphanumeric('3') == true;
    isAlphanumeric('G') == true;
    isAlphanumeric('h') == true;
    isAlphanumeric('%') == false;
    ```
  *)
  val isAlphanumeric : char -> bool

  (**
    `is_alphanumeric ch` returns `true` if `ch` is
    in the range `'0'` to `'9'`, `'A'` to `'Z'`, or `'a'` to `'z'`;
    `false` otherwise.
    
    (Same as `isAlphanumeric`.)
    
    ### Example
    ```ocaml
    is_alphanumeric '3' = true
    is_alphanumeric 'G' = true
    is_alphanumeric 'h' = true
    is_alphanumeric '%' = false
    ```
  *)
  val is_alphanumeric : char -> bool

  (**
    `isPrintable(ch)` returns `true` if `ch` is
    in the range `' '` to `'~'`, (ASCII 32 to 127, inclusive)
    `false` otherwise.
    
    (Same as `is_printable`.)
    
    ### Example
    ```reason
    isPrintable('G') == true;
    isPrintable('%') == true;
    isPrintable('\t') == false;
    isPrintable('\007') == false;
    ```
  *)
  val isPrintable : char -> bool

  (**
    `is_printable ch` returns `true` if `ch` is
    in the range `' '` to `'~'`, (ASCII 32 to 127, inclusive)
    `false` otherwise.
    
    (Same as `isPrintable`.)
    
    ### Example
    ```ocaml
    is_printable 'G' = true
    is_printable '%' = true
    is_printable '\t' = false
    is_printable '\007' = false
    ```
  *)
  val is_printable : char -> bool

  (**
    `isWhitespace(ch)` returns `true` if `ch` is one of:
    `'\t'` (tab), `'\n'` (newline), `'\011'` (vertical tab),
    `'\012'` (form feed), `'\r'` (carriage return), or
    `' '` (space). Returns `false` otherwise.

    
    (Same as `is_whitespace`.)
    
    ### Example
    ```reason
    isWhitespace('\t') == true;
    isWhitespace(' ') == true;
    isWhitespace('?') == false;
    isWhitespace('G') == false;
    ```
  *)
  val isWhitespace : char -> bool

  (**
    `is_whitespace ch` returns `true` if `ch` is one of:
    `'\t'` (tab), `'\n'` (newline), `'\011'` (vertical tab),
    `'\012'` (form feed), `'\r'` (carriage return), or
    `' '` (space). Returns `false` otherwise.

    
    (Same as `isWhitespace`.)
    
    ### Example
    ```ocaml
    is_whitespace '\t' = true
    is_whitespace ' ' = true
    is_whitespace '?' = false
    is_whitespace 'G' = false
    ```
  *)
  val is_whitespace : char -> bool
end

module Float : sig
  (** A module for working with {{: https://en.wikipedia.org/wiki/Floating-point_arithmetic } floating-point numbers}. Valid syntax for [float]s includes:
    {[
      0.
      0.0
      42.
      42.0
      3.14
      0.1234
      123_456.123_456
      6.022e23   (* = (6.022 * 10^23) *)
      6.022e+23  (* = (6.022 * 10^23) *)
      1.602e−19  (* = (1.602 * 10^-19) *)
      1e3        (* = (1 * 10 ** 3) = 1000. *)
    ]}

    Without opening this module you can use the [.] suffixed operators e.g

    {[ 1. +. 2. /. 0.25 *. 2. = 17. ]}

    But by opening this module locally you can use the un-suffixed operators

    {[Float.((10.0 - 1.5 / 0.5) ** 3.0) = 2401.0]}

    {b Historical Note: } The particular details of floats (e.g. [NaN]) are
    specified by {{: https://en.wikipedia.org/wiki/IEEE_754 } IEEE 754 } which is literally hard-coded into almost all
    CPUs in the world.
  *)

  type t = float

  (** {1 Constants} *)

  val zero : t
  (** The literal [0.0] as a named value *)

  val one : t
  (** The literal [1.0] as a named value *)

  val nan : t
  (** [NaN] as a named value. NaN stands for {{: https://en.wikipedia.org/wiki/NaN } not a number}.

      {b Note } comparing values with {!Float.nan} will {b always return } [false] even if the value you are comparing against is also [NaN].

      e.g

      {[
let isNotANmber x = Float.(x = nan) in
isNotANumber nan = false


]}

      For detecting [Nan] you should use {!Float.isNaN}

  *)

  val infinity : t
  (** Positive {{: https://en.wikipedia.org/wiki/IEEE_754-1985#Positive_and_negative_infinity } infinity }

    {[Float.log ~base:10.0 0.0 = Float.infinity]} *)

  val negativeInfinity : t
  (** Negative infinity, see {!Float.infinity} *)

  val negative_infinity : t

  val e : t
  (** An approximation of {{: https://en.wikipedia.org/wiki/E_(mathematical_constant) } Euler's number }. *)

  val pi : t
  (** An approximation of {{: https://en.wikipedia.org/wiki/Pi } pi }. *)

  (** {1 Basic arithmetic and operators} *)

  val add : t -> t -> t
  (** Addition for floating point numbers.

    {[Float.add 3.14 3.14 = 6.28]}

    {[Float.(3.14 + 3.14 = 6.28)]}

    Although [int]s and [float]s support many of the same basic operations such as
    addition and subtraction you {b cannot} [add] an [int] and a [float] directly which
    means you need to use functions like {!Int.toFloat} or {!Float.roundToInt} to convert both values to the same type.

    So if you needed to add a {!List.length} to a [float] for some reason, you
    could:

    {[Float.add 3.14 (Int.toFloat (List.length [1,2,3])) = 6.14]}

    or

    {[Float.roundToInt 3.14 + List.length [1,2,3] = 6]}

    Languages like Java and JavaScript automatically convert [int] values
    to [float] values when you mix and match. This can make it difficult to be sure
    exactly what type of number you are dealing with and cause unexpected behavior.

    OCaml has opted for a design that makes all conversions explicit.
  *)

  val ( + ) : t -> t -> t
  (** See {!Float.add} *)

  val subtract : t -> t -> t
  (** Subtract numbers
    {[Float.subtract 4.0 3.0 = 1.0]}

    Alternatively the [-] operator can be used:

    {[Float.(4.0 - 3.0) = 1.0]}
  *)

  val ( - ) : t -> t -> t
  (** See {!Float.subtract} *)

  val multiply : t -> t -> t
  (** Multiply numbers like

    {[Float.multiply 2.0 7.0 = 14.0]}

    Alternatively the [*] operator can be used:

    {[Float.(2.0 * 7.0) = 14.0]}
  *)

  val ( * ) : t -> t -> t
  (** See {!Float.multiply} *)

  val divide : t -> by:t -> t
  (** Floating-point division:

    {[Float.divide 3.14 ~by:2.0 = 1.57]}

    Alternatively the [/] operator can be used:

    {[Float.(3.14 / 2.0) = 1.57]} *)

  val ( / ) : t -> t -> t
  (** See {!Float.divide} *)

  val power : base:t -> exponent:t -> t
  (** Exponentiation, takes the base first, then the exponent.

    {[Float.power ~base:7.0 ~exponent:3.0 = 343.0]}

    Alternatively the [**] operator can be used:

    {[Float.(7.0 ** 3.0) = 343.0]}
  *)

  val ( ** ) : t -> t -> t
  (** See {!Float.power} *)

  val negate : t -> t
  (** Flips the 'sign' of a [float] so that positive floats become negative and negative integers become positive. Zero stays as it is.

    {[Float.negate 8 = (-8)]}

    {[Float.negate (-7) = 7]}

    {[Float.negate 0 = 0]}

    Alternatively an operator is available:

    {[Float.(~- 4.0) = (-4.0)]}
  *)

  val (~-) : t -> t
  (** See {!Float.negate} *)

  val absolute : t -> t
  (** Get the {{: https://en.wikipedia.org/wiki/Absolute_value } absolute value} of a number.

    {[Float.absolute 8. = 8.]}

    {[Float.absolute (-7) = 7]}

    {[Float.absolute 0 = 0]}
  *)

  val maximum : t -> t -> t
   (** Returns the larger of two [float]s, if both arguments are equal, returns the first argument

    {[Float.maximum 7. 9. = 9.]}

    {[Float.maximum (-4.) (-1.) = (-1.)]}

    If either (or both) of the arguments are [NaN], returns [NaN]

    {[Float.(isNaN (maximum 7. nan) = true]}
  *)

  val minimum : t -> t -> t
  (** Returns the smaller of two [float]s, if both arguments are equal, returns the first argument

    {[Float.minimum 7.0 9.0 = 7.0]}

    {[Float.minimum (-4.0) (-1.0) = (-4.0)]}

    If either (or both) of the arguments are [NaN], returns [NaN]

    {[Float.(isNaN (minimum 7. nan) = true]}
  *)

  val clamp : t -> lower:t -> upper:t -> t
  (** Clamps [n] within the inclusive [lower] and [upper] bounds.

    {[Float.clamp ~lower:0. ~upper:8. 5. = 5.]}

    {[Float.clamp ~lower:0. ~upper:8. 9. = 8.]}

    {[Float.clamp ~lower:(-10.) ~upper:(-5.) 5. = -5.]}

    Throws an [Invalid_argument] exception if [lower > upper]
  *)

  (** {1 Fancier math} *)

  val squareRoot : t -> t
  (** Take the square root of a number.
    {[Float.squareRoot 4.0 = 2.0]}

    {[Float.squareRoot 9.0 = 3.0]}

    [squareRoot] returns [NaN] when its argument is negative. See {!Float.nan} for more.
  *)

  val square_root : t -> t

  val log : t -> base:t -> t
  (** Calculate the logarithm of a number with a given base.

    {[Float.log ~base:10. 100. = 2.]}

    {[Float.log ~base:2. 256. = 8.]}
  *)

  (** {1 Checks} *)

  val isNaN : t -> bool
  (** Determine whether a float is an undefined or unrepresentable number.

    {[Float.isNaN (0.0 / 0.0) = true]}

    {[Float.(isNaN (squareRoot (-1.0)) = true]}

    {[Float.isNaN (1.0 / 0.0) = false  (* Float.infinity {b is} a number *)]}

    {[Float.isNaN 1. = false]}

    {b Note } this function is more useful than it might seem since [NaN] {b does not } equal [Nan]:

    {[Float.(nan = nan) = false]}
  *)

  val is_nan : t -> bool

  val isFinite : t -> bool
  (** Determine whether a float is finite number. True for any float except [Infinity], [-Infinity] or [NaN]

    {[Float.isFinite (0. / 0.) = false]}

    {[Float.(isFinite (squareRoot (-1.)) = false]}

    {[Float.isFinite (1. / 0.) = false]}

    {[Float.isFinite 1. = true]}

    {[Float.(isFinite nan) = false]}

    Notice that [NaN] is not finite!

    For a [float] [n] to be finite implies that [Float.(not (isInfinite n || isNaN n))] evaluates to [true].
  *)

  val is_finite : t -> bool

  val isInfinite : t -> bool
  (** Determine whether a float is positive or negative infinity.

    {[Float.isInfinite (0. / 0.) = false]}

    {[Float.(isInfinite (squareRoot (-1.)) = false]}

    {[Float.isInfinite (1. / 0.) = true]}

    {[Float.isInfinite 1. = false]}

    {[Float.(isInfinite nan) = false]}

    Notice that [NaN] is not infinite!

    For a [float] [n] to be finite implies that [Float.(not (isInfinite n || isNaN n))] evaluates to [true].
  *)

  val is_infinite : t -> bool

  val inRange : t -> lower:t -> upper:t -> bool
  (** Checks if [n] is between [lower] and up to, but not including, [upper].
    If [lower] is not specified, it's set to to [0.0].

    {[Float.inRange ~lower:2. ~upper:4. 3. = true]}

    {[Float.inRange ~lower:1. ~upper:2. 2. = false]}

    {[Float.inRange ~lower:5.2 ~upper:7.9 9.6 = false]}

    Throws an [Invalid_argument] exception if [lower > upper]
  *)

  val in_range : t -> lower:t -> upper:t -> bool

  (** {1 Angles} *)

  val hypotenuse : t -> t -> t
  (** [hypotenuse x y] returns the length of the hypotenuse of a right-angled triangle with sides of length [x] and [y], or, equivalently, the distance of the point [(x, y)] to [(0, 0)].

    {[Float.hypotenuse 3. 4. = 5.]}
  *)

  val degrees : t -> t
  (** Converts an angle in {{: https://en.wikipedia.org/wiki/Degree_(angle) } degrees} to {!Float.radians}.

    {[Float.degrees 180. = v]}
  *)

  val radians : t -> t
  (** Convert a {!Float.t} to {{: https://en.wikipedia.org/wiki/Radian } radians }.

    {[Float.(radians pi) = 3.141592653589793]}

    {b Note } This function doesn't actually do anything to its argument, but can be useful to indicate intent when inter-mixing angles of different units within the same function.
  *)

  val turns : t -> t
  (** Convert an angle in {{: https://en.wikipedia.org/wiki/Turn_(geometry) } turns } into {!Float.radians}.

    One turn is equal to 360°.

    {[Float.(turns (1. / 2.)) = pi]}

    {[Float.(turns 1. = degrees 360.)]}
  *)

  (** {1 Polar coordinates} *)

  val fromPolar : (float * float) -> (float * float)
  (** Convert {{: https://en.wikipedia.org/wiki/Polar_coordinate_system } polar coordinates } (r, θ) to {{: https://en.wikipedia.org/wiki/Cartesian_coordinate_system } Cartesian coordinates } (x,y).

    {[Float.(fromPolar (squareRoot 2., degrees 45.)) = (1., 1.)]}
  *)

  val from_polar : (float * float) -> (float * float)

  val toPolar : (float * float) -> (float * float)
  (** Convert {{: https://en.wikipedia.org/wiki/Cartesian_coordinate_system } Cartesian coordinates } (x,y) to {{: https://en.wikipedia.org/wiki/Polar_coordinate_system } polar coordinates } (r, θ).

    {[Float.toPolar (3.0, 4.0) = (5.0, 0.9272952180016122)]}

    {[Float.toPolar (5.0, 12.0) = (13.0, 1.1760052070951352)]}
  *)

  val to_polar : (float * float) -> (float * float)

  val cos : t -> t
  (** Figure out the cosine given an angle in {{: https://en.wikipedia.org/wiki/Radian } radians }.

    {[Float.(cos (degrees 60.)) = 0.5000000000000001]}

    {[Float.(cos (radians (pi / 3.))) = 0.5000000000000001]}
  *)

  val acos : t -> t
  (** Figure out the arccosine for [adjacent / hypotenuse] in {{: https://en.wikipedia.org/wiki/Radian } radians }:

    {[Float.(acos (radians 1.0 / 2.0)) = Float.radians 1.0471975511965979 (* 60° or pi/3 radians *)]}
  *)

  val sin : t -> t
  (** Figure out the sine given an angle in {{: https://en.wikipedia.org/wiki/Radian } radians }.

    {[Float.(sin (degrees 30.)) = 0.49999999999999994]}

    {[Float.(sin (radians (pi / 6.)) = 0.49999999999999994]}
  *)

  val asin : t -> t
  (** Figure out the arcsine for [opposite / hypotenuse] in {{: https://en.wikipedia.org/wiki/Radian } radians }:

    {[Float.(asin (1.0 / 2.0)) = 0.5235987755982989 (* 30° or pi / 6 radians *)]}
  *)

  val tan : t -> t
  (** Figure out the tangent given an angle in radians.

    {[Float.(tan (degrees 45.)) = 0.9999999999999999]}

    {[Float.(tan (radians (pi / 4.)) = 0.9999999999999999]}

    {[Float.(tan (pi / 4.)) = 0.9999999999999999]}
  *)

  val atan : t -> t
  (** This helps you find the angle (in radians) to an [(x, y)] coordinate, but
    in a way that is rarely useful in programming.

    {b You probably want } {!atan2} instead!

    This version takes [y / x] as its argument, so there is no way to know whether
    the negative signs comes from the [y] or [x] value. So as we go counter-clockwise
    around the origin from point [(1, 1)] to [(1, -1)] to [(-1,-1)] to [(-1,1)] we do
    not get angles that go in the full circle:

    {[Float.atan (1. /. 1.) = 0.7853981633974483  (* 45° or pi/4 radians *)]}

    {[Float.atan (1. /. -1.) = -0.7853981633974483  (* 315° or 7 * pi / 4 radians *)]}

    {[Float.atan (-1. /. -1.) = 0.7853981633974483 (* 45° or pi/4 radians *)]}

    {[Float.atan (-1. /.  1.) = -0.7853981633974483 (* 315° or 7 * pi/4 radians *)]}

    Notice that everything is between [pi / 2] and [-pi/2]. That is pretty useless
    for figuring out angles in any sort of visualization, so again, check out
    {!Float.atan2} instead!
  *)

  val atan2 : y:t -> x:t -> t
  (** This helps you find the angle (in radians) to an [(x, y)] coordinate. So rather than saying [Float.(atan (y / x))] you can [Float.atan2 ~y ~x] and you can get a full range of angles:

    {[Float.atan2 ~y:1. ~x:1. = 0.7853981633974483  (* 45° or pi/4 radians *)]}

    {[Float.atan2 ~y:1. ~x:(-1.) = 2.3561944901923449  (* 135° or 3 * pi/4 radians *)]}

    {[Float.atan2 ~y:(-1.) ~x:(-1.) = -(2.3561944901923449) (* 225° or 5 * pi/4 radians *)]}

    {[Float.atan2 ~y:(-1.) ~x:1.) = -(0.7853981633974483) (* 315° or 7 * pi/4 radians *)]}
  *)

  (** {1 Conversion} *)

  type direction = [
    | `Zero
    | `AwayFromZero
    | `Up
    | `Down
    | `Closest of [
      | `Zero
      | `AwayFromZero
      | `Up
      | `Down
      | `ToEven
    ]
  ]

  val round : ?direction:direction -> t ->  t
  (** Round a number, by default to the to the closest [int] with halves rounded [`Up] (towards positive infinity)

    {[
Float.round 1.2 = 1.0
Float.round 1.5 = 2.0
Float.round 1.8 = 2.0
Float.round -1.2 = -1.0
Float.round -1.5 = -1.0
Float.round -1.8 = -2.0
    ]}

    Other rounding strategies are available by using the optional [~direction] label.

    {2 Towards zero}

    {[
Float.round ~direction:`Zero 1.2 = 1.0
Float.round ~direction:`Zero 1.5 = 1.0
Float.round ~direction:`Zero 1.8 = 1.0
Float.round ~direction:`Zero (-1.2) = -1.0
Float.round ~direction:`Zero (-1.5) = -1.0
Float.round ~direction:`Zero (-1.8) = -1.0
    ]}

    {2 Away from zero}

    {[
Float.round ~direction:`AwayFromZero 1.2 = 1.0
Float.round ~direction:`AwayFromZero 1.5 = 1.0
Float.round ~direction:`AwayFromZero 1.8 = 1.0
Float.round ~direction:`AwayFromZero (-1.2) = -1.0
Float.round ~direction:`AwayFromZero (-1.5) = -1.0
Float.round ~direction:`AwayFromZero (-1.8) = -1.0
    ]}

    {2 Towards infinity}

    This is also known as {!Float.ceiling}

    {[
Float.round ~direction:`Up 1.2 = 1.0
Float.round ~direction:`Up 1.5 = 1.0
Float.round ~direction:`Up 1.8 = 1.0
Float.round ~direction:`Up (-1.2) = -1.0
Float.round ~direction:`Up (-1.5) = -1.0
Float.round ~direction:`Up (-1.8) = -1.0
    ]}

    {2 Towards negative infinity}

    This is also known as {!Float.floor}

    {[List.map  ~f:(Float.round ~direction:`Down) [-1.8; -1.5; -1.2; 1.2; 1.5; 1.8] = [-2.0; -2.0; -2.0; 1.0 1.0 1.0]]}

    {2 To the closest integer}

    Rounding a number [x] to the closest integer requires some tie-breaking for when the [fraction] part of [x] is exactly [0.5].

    {3 Halves rounded towards zero}

    {[List.map  ~f:(Float.round ~direction:(`Closest `AwayFromZero)) [-1.8; -1.5; -1.2; 1.2; 1.5; 1.8] = [-2.0; -1.0; -1.0; 1.0 1.0 2.0]]}

    {3 Halves rounded away from zero}

    This method is often known as {b commercial rounding }

    {[List.map  ~f:(Float.round ~direction:(`Closest `AwayFromZero)) [-1.8; -1.5; -1.2; 1.2; 1.5; 1.8] = [-2.0; -2.0; -1.0; 1.0 2.0 2.0]]}

    {3 Halves rounded down}

    {[List.map  ~f:(Float.round ~direction:(`Closest `Down)) [-1.8; -1.5; -1.2; 1.2; 1.5; 1.8] = [-2.0; -2.0; -1.0; 1.0 1.0 2.0]]}

    {3 Halves rounded up}

    This is the default.

    [Float.round 1.5] is the same as [Float.round ~direction:(`Closest `Up) 1.5]

    {3 Halves rounded towards the closest even number}

    This tie-breaking rule is the default rounding mode using in

    {[Float.round ~direction:(`Closest `ToEven) -1.5 = -2.0]}

    {[Float.round ~direction:(`Closest `ToEven) -2.5 = -2.0]}
  *)

  val floor : t -> t
  (** Floor function, equivalent to [Float.round ~direction:`Down].

    {[Float.floor 1.2 = 1.0]}

    {[Float.floor 1.5 = 1.0]}

    {[Float.floor 1.8 = 1.0]}

    {[Float.floor -1.2 = -2.0]}

    {[Float.floor -1.5 = -2.0]}

    {[Float.floor -1.8 = -2.0]}
  *)

  val ceiling : t -> t
  (** Ceiling function, equivalent to [Float.round ~direction:`Up].

    {[Float.ceiling 1.2 = 2.0]}

    {[Float.ceiling 1.5 = 2.0]}

    {[Float.ceiling 1.8 = 2.0]}

    {[Float.ceiling -1.2 = (-1.0)]}

    {[Float.ceiling -1.5 = (-1.0)]}

    {[Float.ceiling -1.8 = (-1.0)]}
  *)

  val truncate : t -> t
  (** Ceiling function, equivalent to [Float.round ~direction:`Zero].

    {[Float.truncate 1.0 = 1]}

    {[Float.truncate 1.2 = 1]}

    {[Float.truncate 1.5 = 1]}

    {[Float.truncate 1.8 = 1]}

    {[Float.truncate (-1.2) = -1]}

    {[Float.truncate (-1.5) = -1]}

    {[Float.truncate (-1.8) = -1]}
  *)

  val fromInt : int -> float
  (** Convert an [int] to a [float]

    {[Float.fromInt 5 = 5.0]}

    {[Float.fromInt 0 = 0.0]}

    {[Float.fromInt -7 = -7.0]}
  *)

  val from_int : int -> float

  val toInt : t ->  int option
  (** Converts a [float] to an {!Int} by {b ignoring the decimal portion}. See {!Float.truncate} for examples.

    Returns [None] when trying to round a [float] which can't be represented as an [int] such as {!Float.nan} or {!Float.infinity} or numbers which are too large or small.

    {[Float.(toInt nan) = None]}

    {[Float.(toInt infinity) = None]}

    You probably want to use some form of {!Float.round} prior to using this function.

    {[Float.(round 1.6 |> toInt) = Some 2]}
  *)

  val to_int : t ->  int option
end

module Int : sig
  (** The platform-dependant {{: https://en.wikipedia.org/wiki/Integer } signed } {{: https://en.wikipedia.org/wiki/Integer } integer} type. An [int] is a whole number.
    Valid syntax for [int]s includes:
    {[
      0
      42
      9000
      1_000_000
      1_000_000
      0xFF (* 255 in hexadecimal *)
      0x000A (* 10 in hexadecimal *)
    ]}

    {b Note:} The number of bits used for an [int] is platform dependent.

    When targeting native OCaml uses 31-bits on a 32-bit platforms and 63-bits on a 64-bit platforms
    which means that [int] math is well-defined in the range [-2 ** 30] to [2 ** 30 - 1] for 32bit platforms [-2 ** 62] to [2 ** 62 - 1] for 64bit platforms.

    You can read about the reasons for OCamls unusual integer sizes {{: https://v1.realworldocaml.org/v1/en/html/memory-representation-of-values.html} here }.

    When targeting JavaScript, that range is [-2 ** 53] to [2 ** 53 - 1].

    Outside of that range, the behavior is determined by the compilation target.

    [int]s are subject to {{: https://en.wikipedia.org/wiki/Integer_overflow } overflow }, meaning that [Int.maximumValue + 1 = Int.minimumValue].

    {e Historical Note: } The name [int] comes from the term {{: https://en.wikipedia.org/wiki/Integer } integer}). It appears
    that the [int] abbreviation was introduced in the programming language ALGOL 68.

    Today, almost all programming languages use this abbreviation.
  *)

  type t = int

  (** {1 Constants } *)

  val zero : t
  (** The literal [0] as a named value *)

  val one : t
  (** The literal [1] as a named value *)

  val maximumValue : t
  (** The maximum representable [int] on the current platform *)

  val maximum_value : t

  val minimumValue : t
  (** The minimum representable [int] on the current platform *)

  val minimum_value : t

  (** {1 Operators }
    {b Note } You do not need to open the {!Int} module to use the {!( + )}, {!( - )}, {!( * )} or {!( / )} operators, these are available as soon as you [open Tablecloth]
  *)

  val add : t -> t -> t
  (** Add two {!Int} numbers.

    {[Int.add 3002 4004 = 7006]}

    Or using the globally available operator:

    {[3002 + 4004 = 7006]}

    You {e cannot } add an [int] and a [float] directly though.

    See {!Float.add} for why, and how to overcome this limitation.
  *)

  val ( + ) : t -> t -> t
  (** See {!Int.add} *)

  val subtract : t -> t -> t
  (** Subtract numbers
    {[Int.subtract 4 3 = 1]}

    Alternatively the operator can be used:

    {[4 - 3 = 1]}
  *)

  val ( - ) : t -> t -> t
  (** See {!Int.subtract} *)

  val multiply : t -> t -> t
  (** Multiply [int]s like

    {[Int.multiply 2 7 = 14]}

    Alternatively the operator can be used:

    {[(2 * 7) = 14]}
  *)

  val ( * ) : t -> t -> t
  (** See {!Int.multiply} *)

  val divide : t -> by:t -> t
  (** Integer division:

    {[Int.divide 3 ~by:2 = 1]}

    {[27 / 5 = 5]}

    Notice that the remainder is discarded.

    Throws [Division_by_zero] when the divisor is [0].
  *)

  val ( / ) : t -> t -> t
  (** See {!Int.divide} *)

  val ( // ) : t -> t -> float
  (** Floating point division
    {[3 // 2 = 1.5]}

    {[27 // 5 = 5.25]}

    {[8 // 4 = 2.0]}
  *)

  val power : base:t -> exponent:t -> t
  (** Exponentiation, takes the base first, then the exponent.

    {[Int.power ~base:7 ~exponent:3 = 343]}  

    Alternatively the [**] operator can be used:

    {[7 ** 3 = 343]}
  *)

  val ( ** ) : t -> t -> t
  (** See {!Int.power} *)

  val negate : t -> t
  (** Flips the 'sign' of an integer so that positive integers become negative and negative integers become positive. Zero stays as it is.

    {[Int.negate 8 = (-8)]}

    {[Int.negate (-7) = 7]}

    {[Int.negate 0 = 0]}

    Alternatively the operator can be used:

    {[~-(7) = (-7)]}
  *)

  val (~-) : t -> t
  (** See {!Int.negate} *)

  val absolute : t -> t
  (** Get the {{: https://en.wikipedia.org/wiki/Absolute_value } absolute value } of a number.

    {[Int.absolute 8 = 8]}

    {[Int.absolute (-7) = 7]}

    {[Int.absolute 0 = 0]} *)

  val modulo : t -> by:t -> t
  (** Perform {{: https://en.wikipedia.org/wiki/Modular_arithmetic } modular arithmetic }.

    If you intend to use [modulo] to detect even and odd numbers consider using {!Int.isEven} or {!Int.isOdd}.

    {[Int.modulo ~by:2 0 = 0]}

    {[Int.modulo ~by:2 1 = 1]}

    {[Int.modulo ~by:2 2 = 0]}

    {[Int.modulo ~by:2 3 = 1]}

    Our [modulo] function works in the typical mathematical way when you run into negative numbers:

    {[
      List.map ~f:(Int.modulo ~by:4) [(-5); (-4); -3; -2; -1;  0;  1;  2;  3;  4;  5 ] =
        [3; 0; 1; 2; 3; 0; 1; 2; 3; 0; 1]
    ]}

    Use {!Int.remainder} for a different treatment of negative numbers.
  *)

  val remainder : t -> by:t -> t
  (** Get the remainder after division. Here are bunch of examples of dividing by four:

    {[
      List.map ~f:(Int.remainder ~by:4) [(-5); (-4); (-3); (-2); (-1); 0; 1; 2; 3; 4; 5] =
        [(-1); 0; (-3); (-2); (-1); 0; 1; 2; 3; 0; 1]
    ]}


    Use {!Int.modulo} for a different treatment of negative numbers.
  *)

  val maximum : t -> t -> t
  (** Returns the larger of two [int]s

    {[Int.maximum 7 9 = 9]}

    {[Int.maximum (-4) (-1) = (-1)]} *)

  val minimum : t -> t -> t
  (** Returns the smaller of two [int]s

    {[Int.minimum 7 9 = 7]}

    {[Int.minimum (-4) (-1) = (-4)]} *)

  (** {1 Checks} *)

  val isEven : t -> bool
  (** Check if an [int] is even

    {[Int.isEven 8 = true]}

    {[Int.isEven 7 = false]}

    {[Int.isEven 0 = true]} *)

  val is_even : t -> bool

  val isOdd : t -> bool
  (** Check if an [int] is odd

    {[Int.isOdd 7 = true]}

    {[Int.isOdd 8 = false]}

    {[Int.isOdd 0 = false]} *)

  val is_odd : t -> bool

  val clamp : t -> lower:t -> upper:t -> t
  (** Clamps [n] within the inclusive [lower] and [upper] bounds.

    {[Int.clamp ~lower:0 ~upper:8 5 = 5]}

    {[Int.clamp ~lower:0 ~upper:8 9 = 8]}

    {[Int.clamp ~lower:(-10) ~upper:(-5) 5 = (-5)]}

    Throws an [Invalid_argument] exception if [lower > upper]
  *)

  val inRange : t -> lower:t -> upper:t -> bool
  (** Checks if [n] is between [lower] and up to, but not including, [upper].

    {[Int.inRange ~lower:2 ~upper:4 3 = true]}

    {[Int.inRange ~lower:5 ~upper:8 4 = false]}

    {[Int.inRange ~lower:(-6) ~upper:(-2) (-3) = true]}

    Throws an [Invalid_argument] exception if [lower > upper]
  *)

  val in_range : t -> lower:t -> upper:t -> bool

  (** {1 Conversion } *)

  val toFloat : t -> float
  (** Convert an integer into a float. Useful when mixing {!Int} and {!Float} values like this:

    {[
let halfOf (number : int) : float =
  Float.((Int.toFloat number) / 2)

halfOf 7 = 3.5
    ]}
    Note that locally opening the {!Float} module here allows us to use the floating point division operator
  *)

  val to_float : t -> float

  val toString : t -> string
  (** Convert an [int] into a [string] representation.

    {[Int.toString 3 = "3"]}

    {[Int.toString (-3) = "-3"]}

    {[Int.toString 0 = "0"]}

    Guarantees that

    {[Int.(fromString (toString n)) = Some n ]}
 *)

  val to_string : t -> string

  val fromString : string -> t option
  (** Attempt to parse a [string] into a [int].

    {[Int.fromString "0" = Some 0.]}

    {[Int.fromString "42" = Some 42.]}

    {[Int.fromString "-3" = Some (-3)]}

    {[Int.fromString "123_456" = Some 123_456]}

    {[Int.fromString "0xFF" = Some 255]}

    {[Int.fromString "0x00A" = Some 10]}

    {[Int.fromString "Infinity" = None]}

    {[Int.fromString "NaN" = None]}
  *)

  val from_string : string -> t option
end

module Tuple2 : sig

  (**
    `create x y` (`create(x, y)` in ReasonML) creates a two-tuple with the
    given values. The values do not have to be of the same type.
    
    ### Example
    ```ocaml
    create "str" 16.0 = ("str", 16.0)
    ```
    
    ```reason
    create("str", 16.0) == ("str", 16.0);
    ```
  *)
  val create : 'a -> 'b -> 'a * 'b

  (**
    `first (a, b)` (`first((a, b))` in ReasonML) returns the first element
    in the tuple.
    
    ### Example
    ```ocaml
    first ("str", 16.0) = "str"
    ```
    
    ```reason
    first(("str", 16.0)) == "str";
    ```
  *)
  val first : ('a * 'b) -> 'a

  (**
    `second (a, b)` (`second((a, b))` in ReasonML) returns the second element
    in the tuple.
    
    ### Example
    ```ocaml
    second ("str", 16.0) = 16.0
    ```
    
    ```reason
    second(("str", 16.0)) == 16.0;
    ```
  *)
  val second : ('a * 'b) -> 'b

  (**
    `mapFirst(~f=fcn, (a, b))` returns a new tuple with `fcn` applied to
    the first element of the tuple.
    
    (Same as `map_first')
    
    ### Example
    ```reason
    mapFirst(~f=String.length, ("str", 16.0)) == (3, 16.0);
    ```
  *)
  val mapFirst : f:('a -> 'x) -> ('a * 'b) -> ('x * 'b)

  (**
    `map_first ~f:fcn (a, b)` returns a new tuple with `fcn` applied to
    the first element of the tuple.
    
    (Same as `mapFirst')
    
    ### Example
    ```ocaml
    map_first ~f:String.length ("str", 16.0) = (3, 16.0)
    ```
  *)
  val map_first : f:('a -> 'x) -> ('a * 'b) -> ('x * 'b)

  (**
    `mapSecond(~f=fcn, (a, b))` returns a new tuple with `fcn` applied to
    the second element of the tuple.
    
    (Same as `map_second')
    
    ### Example
    ```reason
    mapSecond(~f=sqrt, ("str", 16.0)) == ("str", 4.0);
    ```
  *)
  val mapSecond : f:('b -> 'y) -> ('a * 'b) -> ('a * 'y)

  (**
    `map_second ~f:fcn (a, b)` returns a new tuple with `fcn` applied to
    the second element of the tuple.
    
    (Same as `mapSecond')
    
    ### Example
    ```ocaml
    map_second ~f:sqrt ("str", 16.0) = ("str", 4.0)
    ```
  *)
  val map_second : f:('b -> 'y) -> ('a * 'b) -> ('a * 'y)

  (**
    `mapEach(~f=fcn1, ~g=fcn2, (a, b))` returns a tuple whose first
    element is `fcn1(a)` and whose second element is `fcn2(b)`.
    
    (Same as `map_each`.)
    
    ### Example
    ```reason
    mapEach(~f=String.length, ~g=sqrt, ("str", 16.0)) == (3, 4.0);
    ```
  *)
  val mapEach : f:('a -> 'x) -> g:('b -> 'y) -> ('a * 'b) -> ('x * 'y)

  (**
    `map_each ~f:fcn1 ~g:fcn2 (a, b)` returns a tuple whose first
    element is `fcn1 a` and whose second element is `fcn2 b`.
    
    (Same as `mapEach`.)
    
    ### Example
    ```ocaml
    map_each ~f:String.length ~g:sqrt ("str", 16.0) = (3, 4.0)
    ```
  *)
  val map_each : f:('a -> 'x) -> g:('b -> 'y) -> ('a * 'b) -> ('x * 'y)

  (**
    `mapAll(~f=fcn, (a1, a2))` returns a tuple by applying `fcn` to
    both elements of the tuple. In this case, the tuple elements *must*
    be of the same type.
    
    (Same as `map_all`.)
    
    ### Example
    ```reason
    mapAll(~f=String.length, ("first", "second")) == (5, 6);
    ```
  *)
  val mapAll : f:('a -> 'b) -> ('a * 'a) -> ('b * 'b)

  (**
    `map_all ~f:fcn (a1, a2)` returns a tuple by applying `fcn` to
    both elements of the tuple. In this case, the tuple elements *must*
    be of the same type.
    
    (Same as `mapAll`.)
    
    ### Example
    ```ocaml
    map_all ~f:String.length ("first", "second") = (5, 6)
    ```
  *)
  val map_all : f:('a -> 'b) -> ('a * 'a) -> ('b * 'b)

  (**
    `swap (a, b)` (`swap((a, b))` in ReasonML) returns a
    tuple with the elements in reverse order.
    
    ### Example
    ```ocaml
    swap ("str", 16.0) = (16.0, "str")
    ```
    
    ```reason
    swap(("str", 16.0)) == (16.0, "str");
    ```
  *)
  val swap : ('a * 'b) -> ('b * 'a)

  (**
    Presume that `f` is a function that takes a 2-tuple as an
    argument and returns a result. `curry f` (`curry(f)` in ReasonML)
    returns a new function that takes the two items in the tuple
    as separate arguments and returns the same result as `f`.
    
    ### Example
    ```ocaml
    let combineTuple (a, b) = a ^ (string_of_int b)
    combineTuple ("car", 54) = "car54"

    let combineSeparate = curry combineTuple
    combineSeparate "car" 54 = "car54"
    ```
    ```reason
    let combineTuple = ((a, b)) => { a ++ string_of_int(b) };
    combineTuple(("car", 54)) == "car54";
    
    let combineSeparate = curry(combineTuple);
    combineSeparate("car", 54) == "car54";
    ```
  *)
  val curry : (('a * 'b) -> 'c) -> 'a -> 'b -> 'c

  (**
    Presume that `f` is a function that takes two arguments
    and returns a result. `uncurry f` (`uncurry(f)` in ReasonML)
    returns a new function that takes a two-tuple as its argument
    and returns the same result as `f`.
    
    ### Example
    ```ocaml
    let combineSeparate a b = a ^ (string_of_int b)
    combineSeparate "car" 54 = "car54"

    let combineTuple = uncurry combineSeparate
    combineTuple ("car", 54) = "car54"
    ```
    ```reason
    let combineSeparate = (a, b) => { a ++ string_of_int(b) };
    combineSeparate("car", 54) == "car54";
    
    let combineTuple = uncurry(combineSeparate);
    combineTuple(("car", 54)) == "car54";
    ```
  *)
  val uncurry : ('a -> 'b -> 'c) -> ('a * 'b) -> 'c

  (**
    `toList((a1, a2))` returns a list with the two elements in
    the tuple. Because list elements must have the same types,
    the tuple given to `toList()` must have both of its elements
    of the same type.
    
    (Same as `to_list`.)
    
    ### Example
    ```reason
    toList(("first", "second")) == ["first", "second"];
    ```
  *)
  val toList : ('a * 'a) -> 'a list

  (**
    `to_list (a1, a2)` returns a list with the two elements in
    the tuple. Because list elements must have the same types,
    the tuple given to `to_list` must have both of its elements
    of the same type.
    
    (Same as `toList`.)
    
    ### Example
    ```ocaml
    to_list ("first", "second") = ["first"; "second"]
    ```
  *)
  val to_list : ('a * 'a) -> 'a list
end

module Tuple3 : sig
  (**
    `create x y z` (`create(x, y, z)` in ReasonML) creates a three-tuple with the
    given values. The values do not have to be of the same type.
    
    ### Example
    ```ocaml
    create "str" 16.0 99 = ("str", 16.0, 99)
    ```
    
    ```reason
    create("str", 16.0, 99) == ("str", 16.0, 99);
    ```
  *)
  val create : 'a -> 'b -> 'c -> ('a * 'b * 'c)

  (**
    `first (a, b, c)` (`first((a, bm c))` in ReasonML) returns the first element
    in the tuple.
    
    ### Example
    ```ocaml
    first ("str", 16.0, 99) = "str"
    ```
    
    ```reason
    first(("str", 16.0, 99)) == "str";
    ```
  *)
  val first : ('a * 'b * 'c) -> 'a

  (**
    `second (a, b, c)` (`second((a, b, c))` in ReasonML) returns the second element
    in the tuple.
    
    ### Example
    ```ocaml
    second ("str", 16.0, 99) = 16.0
    ```
    
    ```reason
    second(("str", 16.0)) == 16.0;
    ```
  *)
  val second : ('a * 'b * 'c) -> 'b

  (**
    `third (a, b, c)` (`third((a, b, c))` in ReasonML) returns the third element
    in the tuple.
    
    ### Example
    ```ocaml
    third ("str", 16.0, 99) = 99
    ```
    
    ```reason
    third(("str", 16.0)) == 99;
    ```
  *)
  val third : ('a * 'b * 'c) -> 'c

  (**
    `init (a, b, c)` (`init((a, b, c))` in ReasonML) returns a
    two-tuple with the first two elements of the given three-tuple.
    
    ### Example
    ```ocaml
    init ("str", 16.0, 99) = ("str", 16.0)
    ```
    
    ```reason
    init(("str", 16.0, 99)) == ("str", 16.0);
    ```
  *)
  val init : ('a * 'b * 'c) -> ('a * 'b)

  (**
    `tail (a, b, c)` (`tail((a, b, c))` in ReasonML) returns a
    two-tuple with the last two elements of the given three-tuple.
    
    ### Example
    ```ocaml
    tail ("str", 16.0, 99) = (16.0, 99)
    ```
    
    ```reason
    tail(("str", 16.0, 99)) == (16.0, 99);
    ```
  *)
  val tail : ('a * 'b * 'c) -> ('b * 'c)

  (**
    `mapFirst(~f=fcn, (a, b, c))` returns a new tuple with `fcn` applied to
    the first element of the tuple.
    
    (Same as `map_first')
    
    ### Example
    ```reason
    mapFirst(~f=String.length, ("str", 16.0, 99)) == (3, 16.0, 99);
    ```
  *)
  val mapFirst : f:('a -> 'x) -> ('a * 'b * 'c) -> ('x * 'b *'c)

  (**
    `map_first ~f:fcn (a, b, c)` returns a new tuple with `fcn` applied to
    the first element of the tuple.
    
    (Same as `mapFirst')
    
    ### Example
    ```ocaml
    map_first ~f:String.length ("str", 16.0, 99) = (3, 16.0, 99)
    ```
  *)
  val map_first : f:('a -> 'x) -> ('a * 'b * 'c) -> ('x * 'b *'c)

  (**
    `mapSecond(~f=fcn, (a, b, c))` returns a new tuple with `fcn` applied to
    the second element of the tuple.
    
    (Same as `map_second')
    
    ### Example
    ```reason
    mapSecond(~f=sqrt, ("str", 16.0, 99)) == ("str", 4.0, 99);
    ```
  *)
  val mapSecond : f:('b -> 'y) -> ('a * 'b * 'c) -> ('a * 'y * 'c)

  (**
    `map_second ~f:fcn (a, b, c)` returns a new tuple with `fcn` applied to
    the second element of the tuple.
    
    (Same as `mapSecond')
    
    ### Example
    ```ocaml
    map_second ~f:sqrt ("str", 16.0, 99) = ("str", 4.0, 99)
    ```
  *)
  val map_second : f:('b -> 'y) -> ('a * 'b * 'c) -> ('a * 'y * 'c)

  (**
    `mapThird(~f=fcn, (a, b, c))` returns a new tuple with `fcn` applied to
    the third element of the tuple.
    
    (Same as `map_third')
    
    ### Example
    ```reason
    mapThird(~f=succ, ("str", 16.0, 99)) == ("str", 16.0, 100);
    ```
  *)
  val mapThird : f:('c -> 'z) -> ('a * 'b * 'c) -> ('a * 'b * 'z)

  (**
    `map_third ~f:fcn, (a, b, c)` returns a new tuple with `fcn` applied to
    the third element of the tuple.
    
    (Same as `mapThird')
    
    ### Example
    ```ocaml
    map_third ~f:succ ("str", 16.0, 99) = ("str", 16.0, 100)
    ```
  *)
  val map_third : f:('c -> 'z) -> ('a * 'b * 'c) -> ('a * 'b * 'z)

  (**
    `mapEach(~f=fcn1, ~g=fcn2, ~h=fcn3 (a, b, c))` returns a tuple whose elements are `fcn1(a)`, `fcn2(b)`, and `fcn3(c)`.
    
    (Same as `map_each`.)
    
    ### Example
    ```reason
    mapEach(~f=String.length, ~g=sqrt, ~h=succ, ("str", 16.0, 99)) == (3, 4.0, 100);
    ```
  *)
  val mapEach : f:('a -> 'x) -> g:('b -> 'y) -> h:('c -> 'z) -> ('a * 'b * 'c) -> ('x * 'y * 'z)

  (**
    `map_each ~f:fcn1 ~g:fcn2 ~h:fcn3 (a, b, c)` returns a tuple whose elements are `fcn1 a`, `fcn2 b`, and `fcn3 c`.
    
    (Same as `mapEach`.)
    
    ### Example
    ```ocaml
    map_each ~f:String.length ~g:sqrt ~h:succ ("str", 16.0, 99) = (3, 4.0, 100)
    ```
  *)
  val map_each : f:('a -> 'x) -> g:('b -> 'y) -> h:('c -> 'z) -> ('a * 'b * 'c) -> ('x * 'y * 'z)

  (**
    `mapAll(~f=fcn, (a1, a2, a3))` returns a tuple by applying `fcn` to
    all three elements of the tuple. In this case, the tuple elements *must*
    be of the same type.
    
    (Same as `map_all`.)
    
    ### Example
    ```reason
    mapAll(~f=String.length, ("first", "second", "last")) == (5, 6, 4);
    ```
  *)
  val mapAll : f:('a -> 'b) -> ('a * 'a * 'a) -> ('b * 'b * 'b)

  (**
    `map_all ~f:fcn (a1, a2, a3)` returns a tuple by applying `fcn` to
    all three elements of the tuple. In this case, the tuple elements *must*
    be of the same type.
    
    (Same as `mapAll`.)
    
    ### Example
    ```ocaml
    map_all ~f:String.length ("first", "second", "last") = (5, 6, 4)
    ```
  *)
  val map_all : f:('a -> 'b) -> ('a * 'a * 'a) -> ('b * 'b * 'b)

  (**
    `rotateLeft((a, b, c))` rotates the items of the tuple to the left one position.
    
    (Same as `rotate_left`.)
    
    ### Example
    ```reason
    rotateLeft(("str", 16.0, 99)) == (16.0, 99, "str");
    ```
  *)
  val rotateLeft : ('a * 'b * 'c) -> ('b * 'c * 'a)

  (**
    `rotate_left (a, b, c)` rotates the items of the tuple to the left one position.
    
    (Same as `rotateLeft`.)
    
    ### Example
    ```ocaml
    rotate_left ("str", 16.0, 99) = (16.0, 99, "str")
    ```
  *)
  val rotate_left : ('a * 'b * 'c) -> ('b * 'c * 'a)

  (**
    `rotateRight((a, b, c))` rotates the items of the tuple to the right one position.
    
    (Same as `rotate_right`.)
    
    ### Example
    ```reason
    rotateRight(("str", 16.0, 99)) == (99, "str", 16.0);
    ```
  *)
  val rotateRight : ('a * 'b * 'c) -> ('c * 'a * 'b)

  (**
    `rotate_right (a, b, c)` rotates the items of the tuple to the right one position.
    
    (Same as `rotateRight`.)
    
    ### Example
    ```ocaml
    rotate_right ("str", 16.0, 99) = (99, "str", 16.0)
    ```
  *)
  val rotate_right : ('a * 'b * 'c) -> ('c * 'a * 'b)

  (**
    Presume that `f` is a function that takes a 3-tuple as an
    argument and returns a result. `curry f` (`curry(f)` in ReasonML)
    returns a new function that takes the three items in the tuple
    as separate arguments and returns the same result as `f`.
    
    ### Example
    ```ocaml
    let combineTuple (a, b, c) = a ^ (string_of_int (b + c))
    combineTuple ("cloud", 5, 4) = "cloud9"

    let combineSeparate = curry combineTuple
    combineSeparate "cloud" 5 4 = "cloud9"
    ```
    ```reason
    let combineTuple = ((a, b, c)) => { a ++ string_of_int(b + c) };
    combineTuple(("cloud", 5, 4)) == "cloud9";
    
    let combineSeparate = curry(combineTuple);
    combineSeparate("cloud", 5, 4) == "cloud9";
    ```
  *)
  val curry : (('a * 'b * 'c) -> 'd) -> 'a -> 'b -> 'c -> 'd

  (**
    Presume that `f` is a function that takes three arguments
    and returns a result. `uncurry f` (`uncurry(f)` in ReasonML)
    returns a new function that takes a three-tuple as its argument
    and returns the same result as `f`.
    
    ### Example
    ```ocaml
    let combineSeparate a b c = a ^ (string_of_int (b + c))
    combineSeparate "cloud" 5 4 = "cloud9"

    let combineTuple = uncurry combineSeparate
    combineTuple ("cloud", 5, 4) = "cloud9"
    ```
    ```reason
    let combineSeparate = (a, b, c) => { a ++ string_of_int(b + c) };
    combineSeparate("cloud", 5, 4) == "cloud9";
    
    let combineTuple = uncurry(combineSeparate);
    combineTuple(("cloud", 5, 4)) == "cloud9";
    ```
  *)
  val uncurry : ('a -> 'b -> 'c -> 'd) -> ('a * 'b * 'c) -> 'd

  (**
    `toList((a1, a2, a3))` returns a list with the three elements in
    the tuple. Because list elements must have the same types,
    the tuple given to `toList()` must have all of its elements
    of the same type.
    
    (Same as `to_list`.)
    
    ### Example
    ```reason
    toList(("first", "second", "third")) == ["first", "second", "third"];
    ```
  *)
  val toList : ('a * 'a * 'a) -> 'a list

  (**
    `to_list (a1, a2, a3)` returns a list with the three elements in
    the tuple. Because list elements must have the same types,
    the tuple given to `to_list` must have all of its elements
    of the same type.
    
    (Same as `toList`.)
    
    ### Example
    ```ocaml
    to_list ("first", "second", "third") = ["first"; "second"; "third"]
    ```
  *)
  val to_list : ('a * 'a * 'a) -> 'a list
end

module String : sig
  val length : string -> int

  val toInt : string -> (string, int) Result.t

  val to_int : string -> (string, int) Result.t

  val toFloat : string -> (string, float) Result.t

  val to_float : string -> (string, float) Result.t

  val uncons : string -> (char * string) option

  (* Drop ~count characters from the beginning of a string. *)
  val dropLeft : count:int -> string -> string

  (* Drop ~count characters from the beginning of a string. *)
  val drop_left : count:int -> string -> string

  (* Drop ~count characters from the end of a string. *)
  val dropRight : count:int -> string -> string

  (* Drop ~count characters from the beginning of a string. *)
  val drop_right : count:int -> string -> string

  val split : on:string -> string -> string list

  val join : sep:string -> string list -> string

  val endsWith : suffix:string -> string -> bool

  val ends_with : suffix:string -> string -> bool

  val startsWith : prefix:string -> string -> bool

  val starts_with : prefix:string -> string -> bool

  val toLower : string -> string

  val to_lower : string -> string

  val toUpper : string -> string

  val to_upper : string -> string

  val uncapitalize : string -> string

  val capitalize : string -> string

  val isCapitalized : string -> bool

  val is_capitalized : string -> bool

  val contains : substring:string -> string -> bool

  val repeat : count:int -> string -> string

  val reverse : string -> string

  val fromList : char list -> string

  val from_list : char list -> string

  val toList : string -> char list

  val to_list : string -> char list

  val fromInt : int -> string

  val from_int : int -> string

  val concat : string list -> string

  val fromChar : char -> string

  val from_char : char -> string

  val slice : from:int -> to_:int -> string -> string

  val trim : string -> string

  val insertAt : insert:string -> index:int -> string -> string

  val insert_at : insert:string -> index:int -> string -> string
end

module IntSet : sig
  type t = Belt.Set.Int.t

  type value = int

  val fromList : value list -> t

  val from_list : value list -> t

  val member : value:value -> t -> bool

  val diff : t -> t -> t

  val isEmpty : t -> bool

  val is_empty : t -> bool

  val toList : t -> value list

  val to_list : t -> value list

  val ofList : value list -> t

  val of_list : value list -> t

  val union : t -> t -> t

  val remove : value:value -> t -> t

  val add : value:value -> t -> t

  val set : value:value -> t -> t

  val has : value:value -> t -> bool

  val empty : t

  val pp : Format.formatter -> t -> unit
end

module StrSet : sig
  type t = Belt.Set.String.t

  type value = string

  val fromList : value list -> t

  val from_list : value list -> t

  val member : value:value -> t -> bool

  val diff : t -> t -> t

  val isEmpty : t -> bool

  val is_empty : t -> bool

  val toList : t -> value list

  val to_list : t -> value list

  val ofList : value list -> t

  val of_list : value list -> t

  val union : t -> t -> t

  val remove : value:value -> t -> t

  val add : value:value -> t -> t

  val set : value:value -> t -> t

  val has : value:value -> t -> bool

  val empty : t

  val pp : Format.formatter -> t -> unit
end

module StrDict : sig
  type key = Belt.Map.String.key

  type 'value t = 'value Belt.Map.String.t

  val toList : 'a t -> (key * 'a) list

  val to_list : 'a t -> (key * 'a) list

  val empty : 'a t

  (* If there are multiple list items with the same key, the last one wins *)
  val fromList : (key * 'value) list -> 'value t

  (* If there are multiple list items with the same key, the last one wins *)
  val from_list : (key * 'value) list -> 'value t

  val get : key:key -> 'value t -> 'value option

  val insert : key:key -> value:'value -> 'value t -> 'value t

  val keys : 'a t -> key list

  val update :
    key:key -> f:('value option -> 'value option) -> 'value t -> 'value t

  val map : 'a t -> f:('a -> 'b) -> 'b t

  val toString : 'a t -> string

  val to_string : 'a t -> string

  val pp :
       (Format.formatter -> 'value -> unit)
    -> Format.formatter
    -> 'value t
    -> unit

  val merge :
       f:(key -> 'v1 option -> 'v2 option -> 'v3 option)
    -> 'v1 t
    -> 'v2 t
    -> 'v3 t
end

module IntDict : sig
  type key = Belt.Map.Int.key

  type 'value t = 'value Belt.Map.Int.t

  val toList : 'a t -> (key * 'a) list

  val to_list : 'a t -> (key * 'a) list

  val empty : 'a t

  (* If there are multiple list items with the same key, the last one wins *)
  val fromList : (key * 'value) list -> 'value t

  (* If there are multiple list items with the same key, the last one wins *)
  val from_list : (key * 'value) list -> 'value t

  val get : key:key -> 'value t -> 'value option

  val insert : key:key -> value:'value -> 'value t -> 'value t

  val update :
    key:key -> f:('value option -> 'value option) -> 'value t -> 'value t

  val keys : 'a t -> key list

  val map : 'a t -> f:('a -> 'b) -> 'b t

  val toString : 'a t -> string

  val to_string : 'a t -> string

  val pp :
       (Format.formatter -> 'value -> unit)
    -> Format.formatter
    -> 'value t
    -> unit

  val merge :
       f:(key -> 'v1 option -> 'v2 option -> 'v3 option)
    -> 'v1 t
    -> 'v2 t
    -> 'v3 t
end

