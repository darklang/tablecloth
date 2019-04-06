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
  let result = sqr |< 25 (* 625 *)
  ```

  ```reason
  let sqr = (x) => {x * x};
  let result = sqr |< 25  /* 625 */
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
  let f = sqrt >> floor
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

module Char : sig
  val toCode : char -> int

  val to_code : char -> int

  val fromCode : int -> char option

  val from_code : int -> char option

  val toString : char -> string

  val to_string : char -> string

  val fromString : string -> char option

  val from_string : string -> char option

  val toDigit : char -> int option

  val to_digit : char -> int option

  val toLowercase : char -> char

  val to_lowercase : char -> char

  val toUppercase : char -> char

  val to_uppercase : char -> char

  val isLowercase : char -> bool

  val is_lowercase : char -> bool

  val isUppercase : char -> bool

  val is_uppercase : char -> bool

  val isLetter : char -> bool

  val is_letter : char -> bool

  val isDigit : char -> bool

  val is_digit : char -> bool

  val isAlphanumeric : char -> bool

  val is_alphanumeric : char -> bool

  val isPrintable : char -> bool

  val is_printable : char -> bool

  val isWhitespace : char -> bool

  val is_whitespace : char -> bool
end

module Int : sig
  val negate : int -> int

  val isEven : int -> bool

  val is_even : int -> bool

  val isOdd : int -> bool

  val is_odd : int -> bool
end

module Tuple2 : sig
  val create : 'a -> 'b -> 'a * 'b

  val first : ('a * 'b) -> 'a

  val second : ('a * 'b) -> 'b

  val mapFirst : f:('a -> 'x) -> ('a * 'b) -> ('x * 'b)

  val map_first : f:('a -> 'x) -> ('a * 'b) -> ('x * 'b)

  val mapSecond : f:('b -> 'y) -> ('a * 'b) -> ('a * 'y)

  val map_second : f:('b -> 'y) -> ('a * 'b) -> ('a * 'y)

  val mapEach : f:('a -> 'x) -> g:('b -> 'y) -> ('a * 'b) -> ('x * 'y)

  val map_each : f:('a -> 'x) -> g:('b -> 'y) -> ('a * 'b) -> ('x * 'y)

  val mapAll : f:('a -> 'b) -> ('a * 'a) -> ('b * 'b)

  val map_all : f:('a -> 'b) -> ('a * 'a) -> ('b * 'b)

  val swap : ('a * 'b) -> ('b * 'a)

  val curry : (('a * 'b) -> 'c) -> 'a -> 'b -> 'c

  val uncurry : ('a -> 'b -> 'c) -> ('a * 'b) -> 'c

  val toList : ('a * 'a) -> 'a list

  val to_list : ('a * 'a) -> 'a list
end

module Tuple3 : sig
  val create : 'a -> 'b -> 'c -> ('a * 'b * 'c)

  val first : ('a * 'b * 'c) -> 'a

  val second : ('a * 'b * 'c) -> 'b

  val third : ('a * 'b * 'c) -> 'c

  val init : ('a * 'b * 'c) -> ('a * 'b)

  val tail : ('a * 'b * 'c) -> ('b * 'c)

  val mapFirst : f:('a -> 'x) -> ('a * 'b * 'c) -> ('x * 'b *'c)

  val map_first : f:('a -> 'x) -> ('a * 'b * 'c) -> ('x * 'b *'c)

  val mapSecond : f:('b -> 'y) -> ('a * 'b * 'c) -> ('a * 'y * 'c)

  val map_second : f:('b -> 'y) -> ('a * 'b * 'c) -> ('a * 'y * 'c)

  val mapThird : f:('c -> 'z) -> ('a * 'b * 'c) -> ('a * 'b * 'z)

  val map_third : f:('c -> 'z) -> ('a * 'b * 'c) -> ('a * 'b * 'z)

  val mapEach : f:('a -> 'x) -> g:('b -> 'y) -> h:('c -> 'z) -> ('a * 'b * 'c) -> ('x * 'y * 'z)

  val map_each : f:('a -> 'x) -> g:('b -> 'y) -> h:('c -> 'z) -> ('a * 'b * 'c) -> ('x * 'y * 'z)

  val mapAll : f:('a -> 'b) -> ('a * 'a * 'a) -> ('b * 'b * 'b)

  val map_all : f:('a -> 'b) -> ('a * 'a * 'a) -> ('b * 'b * 'b)

  val rotateLeft : ('a * 'b * 'c) -> ('b * 'c * 'a)

  val rotate_left : ('a * 'b * 'c) -> ('b * 'c * 'a)

  val rotateRight : ('a * 'b * 'c) -> ('c * 'a * 'b)

  val rotate_right : ('a * 'b * 'c) -> ('c * 'a * 'b)

  val curry : (('a * 'b * 'c) -> 'd) -> 'a -> 'b -> 'c -> 'd

  val uncurry : ('a -> 'b -> 'c -> 'd) -> ('a * 'b * 'c) -> 'd

  val toList : ('a * 'a * 'a) -> 'a list

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

module Regex : sig
  type t = Js.Re.t

  type result = Js.Re.result

  val regex : string -> t

  val contains : re:t -> string -> bool

  val replace : re:t -> repl:string -> string -> string

  val matches : re:t -> string -> result option
end
