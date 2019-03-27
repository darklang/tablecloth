(** Documentation for tablecloth.mli 

Function names that are all lower case have their descriptions and examples in both OCaml and ReasonML format.

Function names that are in snake_case have their documentation written in OCaml format.

Function names that are in camelCase have their documentation written in ReasonML format.
*)

(**
  The `<|` operator applies a function to an argument. It is equivalent to the `@@` operator, and its main use is to avoid needing extra parentheses.

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
    The `>>` operator returns a function that is the equivalent of the composition of its function arguments. The main use of `>>` is to avoid writing parentheses.

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
  `identity` returns its argument, unchanged. It is useful in circumstances when you need a placeholder function that does not alter the results of a computation.
*)
val identity : 'a -> 'a

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
    `map ~f:fcn xs` (`map(~f=fcn, xs)` in ReasonML) returns a new list that it is the result of applying function `fcn` to each item in the list `xs`.

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
    `indexedMap(~f=fcn, xs)` returns a new list that it is the result of applying function `fcn` to each item in the list `xs`. The function has two parameters: the index number of the item in the list, and the item being processed. Item numbers start with zero. (Same as `indexed_map`.)

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
    `indexed_map ~f:fcn xs` returns a new list that it is the result of applying function `fcn` to each item in the list `xs`. The function has two parameters: the index number of the item in the list, and the item being processed. Item numbers start with zero. (Same as `indexedMap`.)

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
    `map2 ~f:fcn xs ys` (`map2(~f=fcn, xs, ys)` in ReasonML) returns a new list whose items are `fcn x y` (`fcn(x,y)` in ReasonML) where `x` and `y` are the items from the given lists.

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
    `getBy(~f=predicate, xs)` returns `Some(value)` for the first value in `xs` that satisifies the `predicate` function; returns `None` if no element satisifies the function.  (Same as `get_by`.)

    ### Example

    ```reason
    let even = (x: int): bool => {x mod 2 == 0};
    getBy(~f=even, [1, 4, 3, 2]) == Some(4);
    getBy(~f=even, [15, 13, 11]) == None;
    ```
  *)
  val getBy : f:('a -> bool) -> 'a list -> 'a option

  (**
    `get_by ~f:predicate xs`  returns `Some value` for the first value in `xs` that satisifies the `predicate` function; returns `None` if no element satisifies the function. (Same as `getBy`.)

    ### Example

    ```ocaml
    let even (x: int) = (x mod 2 = 0 : bool)
    get_by ~f:even [1;4;3;2]) = Some 4
    get_by ~f:even [15;13;11]) = None
    ```

  *)
  val get_by : f:('a -> bool) -> 'a list -> 'a option

  (**
    Same as `getBy` and `get_by`
  *)
  val find : f:('a -> bool) -> 'a list -> 'a option

  (**
    `elemIndex(~value: v, xs)` finds the first occurrence of `v` in `xs` and returns its position as `Some(index)` (with zero being the first element), or `None` if the value is not found.  (Same as `elem_index`.)

    ### Example

    ```reason
    elemIndex(~value = 5, [7, 6, 5, 4, 5]) == Some(2);
    elemIndex(~value = 8, [7, 6, 5, 4, 5]) == None;
    ```
  *)
  val elemIndex : value:'a -> 'a list -> int option

  (**
    `elem_index ~value:v xs` finds the first occurrence of `v` in `xs` and returns its position as `Some index` (with zero being the first element), or `None` if the value is not found. (Same as `elemIndex`.)

    ### Example

    ```ocaml
    elem_index ~value: 5 [7; 6; 5; 4; 5] = Some(2)
    elem_index ~value: 8 [7; 6; 5; 4; 5] = None
    ```
  *)
  val elem_index : value:'a -> 'a list -> int option

  (**
    `last xs` (`last(xs)` in ReasonML) returns the last element in the list as `Some value` (`Some(value)` in ReasonML) unless the list is empty, in which case it returns `None`.

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
    `member ~value: v xs` (`member(~value=v, xs)` in ReasonML) returns `true` if the given value `v` is found in thelist `xs`, `false` otherwise.

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
    `uniqueBy ~f:fcn xs` (`uniqueBy(~f=fcn, xs)` in ReasonML) returns a new list containing only those elements from `xs` that have a unique value when `fcn` is applied to them. The function `fcn` takes as its single parameter an item from the list and returns a `string`. If the function generates the same string for two or more list items, only the first of them is retained. (Same as 'unique_by'.)

    ### Example
    ```reason
    uniqueBy(~f = string_of_int, [1, 3, 4, 3, 7, 7, 6]) == [1, 3, 4, 7, 6];

    let absStr= (x) => string_of_int(abs(x));
    uniqueBy(~f=absStr, [1, 3, 4, -3, -7, 7, 6]) == [1, 3, 4, -7, 6];
    ```
  *)
  val uniqueBy : f:('a -> string) -> 'a list -> 'a list

  (**
    `unique_by ~f:fcn xs` returns a new list containing only those elements from `xs` that have a unique value when `fcn` is applied to them. The function `fcn` takes as its single parameter an item from the list and returns a `string`. If the function generates the same string for two or more list items, only the first of them is retained. (Same as 'uniqueBy'.)

    ### Example
    ```ocaml
    unique_by ~f:string_of_int [1; 3; 4; 3; 7; 7; 6] = [1; 3; 4; 7; 6]

    let abs_str x = string_of_int (abs x)
    unique_by ~f:abs_str [1; 3; 4; -3; -7; 7; 6] = [1; 3; 4; -7; 6]
    ```
  *)
  val unique_by : f:('a -> string) -> 'a list -> 'a list

  (**
    `getAt(~index=n, xs)` retrieves the value of the `n`th item in `xs` (with zero as the starting index) as `Some(value)`, or `None` if `n` is less than zero or greater than the length of `xs`. 

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
    `get_at ~index: n xs` retrieves the value of the `n`th item in `xs` (with zero as the starting index) as `Some value`, or `None` if `n` is less than zero or greater than the length of `xs`. (Same as 'getAt'.)

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
    `any ~f:fcn xs` (`any(~f=fcn, xs)` in ReasonML) returns `true` if the predicate function `fcn x` (`fcn(x)` in ReasonML) returns `true` for any item in `x` in `xs`.

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
    `head xs` (`head(xs)` in ReasonML) (returns the first item in `xs` as `Some value` (`Some(value)` in ReasonML), unless it is given an empty list, in which case it returns `None`.

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
    `drop ~count:n xs` (`drop(~count=n, xs)` in ReasonML) returns a list without the first `n` elements of `xs`. If `n` negative or greater than the length of `xs`, it returns an empty list.

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
    For non-empty lists, `init xs` (`init(xs)` in ReasonML) returns a new list consisting of all but the last list item as a `Some` value. If `xs` is an empty list, `init` returns `None`.

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
    `filterMap(~f=fcn, xs)` applies `fcn` to each element of `xs`. If the function returns `Some(value)`, then `value` is kept in the resulting list. If the result is `None`, the element is not retained in the result. (Same as `filter_map`.)

    ### Example

    ```reason
    filterMap(~f = (x) => if (x mod 2 == 0) {Some(- x)} else {None}, 
      [1, 2, 3, 4]) == [-2, -4]
    ```
  *)
  val filterMap : f:('a -> 'b option) -> 'a list -> 'b list

  (**
    `filter_map ~f:fcn xs` applies `fcn` to each element of `xs`. If the function returns `Some value`, then `value` is kept in the resulting list. If the result is `None`, the element is not retained in the result. (Same as `filterMap`.)

    ### Example

    ```ocaml
    filter_map ~f:(fun x -> if x mod 2 = 0 then Some (-x) else None)
      [1;2;3;4] = [-2;-4]
    ```
  *)
  val filter_map : f:('a -> 'b option) -> 'a list -> 'b list

  (**
    `filter ~f:predicate xs` (`filter(~f=predicate, xs)` in ReasonML) returns a list of all elements in `xs` which satisfy the predicate function `predicate`.

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
    `concat xs` (`concat(xs)` in ReasonML) returns the list obtained by concatenating all the lists in the list `xs`

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
    `partition ~f:predicate` (`partition(~f=predicate, xs)` in ReasonML) returns a tuple of two lists. The first element is a list of all the elements of `xs` for which `predicate` returned `true`. The second element of the tuple is a list of all the elements in `xs` for which `predicate` returned `false`.

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
    `findIndex(~f=predicate, xs)` finds the position of the first element in `xs` for which `predicate` returns `true`. The position is returned as `Some(index)`. If no element satisfies the `predicate`, `findIndex` returns `None`. (Same as `find_index`.)

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
    `find_index ~f:predicate` finds the position of the first element in `xs` for which `predicate` returns `true`. The position is returned as `Some index`. If no element satisfies the `predicate`, `find_index` returns `None`. (Same as `findIndex`.)

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
    `take ~count:n xs` (`take(~count=n, xs)` in ReasonML) returns a list consisting of the first `n` elements of `xs`. If `n` is less than or equal to zero or greater than the length of `xs`, `take` returns the empty list.

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
    `updateAt(~index = n, ~f = fcn, xs)` returns a new list with function `fcn` applied to the list item at index position `n`. (The first item in a list has index zero.) If `n` is less than zero or greater than the number of items in `xs`, the new list is the same as the original list. (Same as `update_at`.)
  
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
    `update_at ~index:n ~f:fcn xs` returns a new list with function `fcn` applied to the list item at index position `n`. (The first item in a list has index zero.) If `n` is less than zero or greater than the number of items in `xs`, the new list is the same as the original list. (Same as `updateAt`.)
  
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
    `length xs` (`length(xs)` in ReasonML)` returns the number of items in the given list. An empty list returns zero.
  *)
  val length : 'a list -> int

  (**
    `reverse xs` (`reverse(xs)` in ReasonML)` returns a list whose items are in the reverse order of those in `xs`.
  *)
  val reverse : 'a list -> 'a list

  (**
    `dropWhile(~f=predicate, xs)` returns a list without the first elements of `xs` for which the `predicate` function returns `true`. (Same as `drop_while`.)

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
    `drop_while ~f:predicate xs` returns a list without the first elements of `xs` for which the `predicate` function returns `true`. (Same as `dropWhile`.)

    ### Example

    ```ocaml
    let even x = x mod 2 = 0
    drop_while ~f:even [2;4;6;7;8;9] = [7;8;9]
    drop_while ~f:even [2;4;6;8] = []
    drop_while ~f:even [1;2;3] = [1;2;3]
    ```

  *)
  val drop_while : f:('a -> bool) -> 'a list -> 'a list

  (**
    `isEmpty(xs)` returns `true` if `xs` is the empty list `[]`; `false` otherwise. (Same as `is_empty`.)
  *)
  val isEmpty : 'a list -> bool

  (**
    `is_empty xs`  returns `true` if `xs` is the empty list `[]`; `false` otherwise. (Same as `isEmpty`.)
  *)
  val is_empty : 'a list -> bool

  (**
    `cons item xs` (`cons(item, xs)` in ReasonML) prepends the `item` to `xs`.
    
    ### Example
    
    ```ocaml
    cons "one" ["two";"three"] = ["one";"two";"three"]
    cons 42 [] = [42]
    ```
    
    ```reason
    cons("one", ["two", "three"]) == ["one", "two", "three"];
    cons(42, []) == [42];
    ```
  *)
  val cons : 'a -> 'a list -> 'a list

  (**
    `takeWhile(~f=predicate, xs)` returns a list with the first elements of `xs` for which the `predicate` function returns `true`. (Same as `take_while`.)

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
    `take_while ~f:predicate xs` returns a list with the first elements of `xs` for which the `predicate` function returns `true`. (Same as `takeWhile`.)

    ### Example

    ```ocaml
    let even x = x mod 2 = 0
    take_while ~f:even [2;4;6;7;8;9] = [2;4;6]
    take_while ~f:even [2;4;6] = [2;4;6]
    take_while ~f:even [1;2;3] = []
    ```
  *)
  val take_while : f:('a -> bool) -> 'a list -> 'a list

  (**
    `all ~f:predicate xs` (`all(~f=predicate, xs)` in ReasonML) returns `true` if all the elements in `xs` satisfy the `predicate` function, `false` otherwise. Note: `all` returns `true` if `xs` is the empty list.
    
    ### Example
    
    ```ocaml
    let even x = x mod 2 = 0
    all ~f:even [16;22;40] = true
    all ~f:even [16;21;40] = false
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
    `tail xs` (`tail(xs)` in ReasonML) returns all except the first item in `xs` as a `Some` value when `xs` is not empty. If `xs` is the empty list, `tail` returns `None`.
    
    ```ocaml
    tail [3;4;5] = Some [4;5]
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
    `append xs ys` (`append(xs, ys)` in ReasonML) returns a new list with the elements of `xs` followed by the elements of `ys`
    
    ### Example
    ```ocaml
    append [1;2] [3;4;5] = [1;2;3;4;5]
    append [] [6;7] = [6;7]
    append [8;9] [] = [8;9]
    ```
    
    ```reason
    append([1, 2], [3, 4, 5]) == [1, 2, 3, 4, 5];
    append([], [6, 7]) == [6, 7];
    append([8, 9], []) == [8, 9];
    ```
  *)
  val append : 'a list -> 'a list -> 'a list

  val removeAt : index:int -> 'a list -> 'a list

  val remove_at : index:int -> 'a list -> 'a list

  val minimumBy : f:('a -> 'comparable) -> 'a list -> 'a option

  val minimum_by : f:('a -> 'comparable) -> 'a list -> 'a option

  val maximumBy : f:('a -> 'comparable) -> 'a list -> 'a option

  val maximum_by : f:('a -> 'comparable) -> 'a list -> 'a option

  val maximum : 'comparable list -> 'comparable option

  val sortBy : f:('a -> 'b) -> 'a list -> 'a list

  val sort_by : f:('a -> 'b) -> 'a list -> 'a list

  val span : f:('a -> bool) -> 'a list -> 'a list * 'a list

  val groupWhile : f:('a -> 'a -> bool) -> 'a list -> 'a list list

  val group_while : f:('a -> 'a -> bool) -> 'a list -> 'a list list

  val splitAt : index:int -> 'a list -> 'a list * 'a list

  val split_at : index:int -> 'a list -> 'a list * 'a list

  val insertAt : index:int -> value:'a -> 'a list -> 'a list

  val insert_at : index:int -> value:'a -> 'a list -> 'a list

  val splitWhen : f:('a -> bool) -> 'a list -> ('a list * 'a list) option

  val split_when : f:('a -> bool) -> 'a list -> ('a list * 'a list) option

  val intersperse : 'a -> 'a list -> 'a list

  val initialize : int -> (int -> 'a) -> 'a list

  val sortWith : ('a -> 'a -> int) -> 'a list -> 'a list

  val sort_with : ('a -> 'a -> int) -> 'a list -> 'a list

  val iter : f:('a -> unit) -> 'a list -> unit
end

module Result : sig
  type ('err, 'ok) t = ('ok, 'err) Belt.Result.t

  val withDefault : default:'ok -> ('err, 'ok) t -> 'ok

  val with_default : default:'ok -> ('err, 'ok) t -> 'ok

  val map2 : f:('a -> 'b -> 'c) -> ('err, 'a) t -> ('err, 'b) t -> ('err, 'c) t

  val combine : ('x, 'a) t list -> ('x, 'a list) t

  val map : ('ok -> 'value) -> ('err, 'ok) t -> ('err, 'value) t

  val toOption : ('err, 'ok) t -> 'ok option

  val to_option : ('err, 'ok) t -> 'ok option

  val andThen :
    f:('ok -> ('err, 'value) t) -> ('err, 'ok) t -> ('err, 'value) t

  val and_then :
    f:('ok -> ('err, 'value) t) -> ('err, 'ok) t -> ('err, 'value) t

  val pp :
       (Format.formatter -> 'err -> unit)
    -> (Format.formatter -> 'ok -> unit)
    -> Format.formatter
    -> ('err, 'ok) t
    -> unit
end

module Option : sig
  type 'a t = 'a option

  val andThen : f:('a -> 'b option) -> 'a option -> 'b option

  val and_then : f:('a -> 'b option) -> 'a option -> 'b option

  val or_ : 'a option -> 'a option -> 'a option

  val orElse : 'a option -> 'a option -> 'a option

  val or_else : 'a option -> 'a option -> 'a option

  val map : f:('a -> 'b) -> 'a option -> 'b option

  val withDefault : default:'a -> 'a option -> 'a

  val with_default : default:'a -> 'a option -> 'a

  val foldrValues : 'a option -> 'a list -> 'a list

  val foldr_values : 'a option -> 'a list -> 'a list

  val values : 'a option list -> 'a list

  val toList : 'a option -> 'a list

  val to_list : 'a option -> 'a list

  val isSome : 'a option -> bool

  val is_some : 'a option -> bool

  val toOption : sentinel:'a -> 'a -> 'a option

  val to_option : sentinel:'a -> 'a -> 'a option
end

module Char : sig
  val toCode : char -> int

  val to_code : char -> int

  val fromCode : int -> char

  val from_code : int -> char
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
