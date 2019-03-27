(** Documentation for tablecloth.mli *)

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

  `(f >> g) x`{:.ocaml} `(f >> g)(x)`{:.reason} is the equivalent of `f (g x)`{:.ocaml} `f(g(x))`{:.reason}

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

  `(f << g) x`{:.ocaml} `(f << g)(x)`{:.reason} is the equivalent of `g (f x)`{:.ocaml} `g(f(x))`{:.reason}


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
    `sum xs`{:.ocaml} `sum(xs)`{:.reason} returns the sum of the items in the given list of integers.

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
    Equivalent to float_sum
  *)
  val floatSum : float list -> float

  (**
    `float_sum xs`{:.ocaml} `floatSum(xs)`{:.reason} returns the sum of the given list of floats.
    
    ### Example

    ```ocaml
    float_sum [1.3; 5.75; 9.2] = 16.25
    ```

    ```reason
    floatSum([1.3, 5.75, 9.2]) == 16.25
    ```
  *)
  val float_sum : float list -> float

  (**
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
  *)
  val map : f:('a -> 'b) -> 'a list -> 'b list

  (**
    Same as indexed_map
  *)
  val indexedMap : f:(int -> 'a -> 'b) -> 'a list -> 'b list

  (**
    `indexed_map ~f:fcn xs`{:.ocaml} `indexedMap(~f=fcn, xs)`{:.reason} returns a new list that it is the result of applying function `fcn` to each item in the list `xs`. The function has two parameters: the index number of the item in the list, and the item being processed. Item numbers start with zero.

    ### Example

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
  *)
  val indexed_map : f:(int -> 'a -> 'b) -> 'a list -> 'b list

  (**
    Same as indexed_map
  *)
  val mapi : f:(int -> 'a -> 'b) -> 'a list -> 'b list

  (*
    `map2 ~f: fcn xs ys`{:.ocaml} `map2(~f=fcn, xs, ys)`{:.reason} returns a new list whose items are `fcn x y`{:.ocaml} `fcn(x,y)`{:.reason} where `x` and `y` are the items from the given lists.

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
    `getBy ~f: predicate xs`{:.ocaml} `getBy(~f=predicate, xs)`{:.reason} returns `Some value`{:.ocaml} `Some(value)`{:.reason} for the first value in `xs` that satisifies the `predicate` function; returns `None` if no element satisifies the function. 

    ### Example

    ```ocaml
    let even (x: int) = (x mod 2 = 0 : bool)
    getBy ~f:even [1;4;3;2]) = Some 4
    getBy ~f:even [15;13;11]) = None
    ```

    ```reason
    let even = (x: int): bool => {x mod 2 == 0};
    getBy(~f=even, [1, 4, 3, 2]) == Some(4);
    getBy(~f=even, [15, 13, 11]) == None;
    ```
  *)
  val getBy : f:('a -> bool) -> 'a list -> 'a option

  (**
    Same as getBy
  *)
  val get_by : f:('a -> bool) -> 'a list -> 'a option

  (**
    Same as getBy
  *)
  val find : f:('a -> bool) -> 'a list -> 'a option

  (**
    `elemIndex ~value:v xs`{:.ocaml} `elemIndex(~value: v, xs)`{:.reason} finds the first occurrence of `v` in `xs` and returns its position as `Some index`{:.ocaml} `Some(index)`{:.reason} (with zero being the first element), or `None` if the value is not found. 

    ### Example

    ```ocaml
    elemIndex ~value: 5 [7; 6; 5; 4; 5] = Some(2)
    elemIndex ~value: 8 [7; 6; 5; 4; 5] = None
    ```

    ```reason
    elemIndex(~value = 5, [7, 6, 5, 4, 5]) == Some(2);
    elemIndex(~value = 8, [7, 6, 5, 4, 5]) == None;
    ```
  *)
  val elemIndex : value:'a -> 'a list -> int option

  (**
    Same as elemIndex
  *)
  val elem_index : value:'a -> 'a list -> int option

  (**
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
  *)
  val last : 'a list -> 'a option

  (**
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
  *)
  val member : value:'a -> 'a list -> bool

  (**
    `unique_by ~f: fcn xs`{:.ocaml} `uniqueBy(~f=fcn, xs)`{:.reason} returns a new list containing only those elements from `xs` that have a unique value when `fcn` is applied to them. The function `fcn` takes as its single parameter an item from the list and returns a `string`. If the function generates the same string for two or more list items, only the first of them is retained. 

    ### Example
    ```ocaml
    uniqueBy ~f: string_of_int [1; 3; 4; 3; 7; 7; 6] = [1; 3; 4; 7; 6]

    let abs_str x = string_of_int (abs x)
    uniqueBy ~f: abs_str [1; 3; 4; -3; -7; 7; 6] = [1; 3; 4; -7; 6]
    ```

    ```reason
    uniqueBy(~f = string_of_int, [1, 3, 4, 3, 7, 7, 6]) == [1, 3, 4, 7, 6];

    let absStr= (x) => string_of_int(abs(x));
    uniqueBy(~f=absStr, [1, 3, 4, -3, -7, 7, 6]) == [1, 3, 4, -7, 6];
    ```
  *)
  val uniqueBy : f:('a -> string) -> 'a list -> 'a list

  (**
    Same as unique_by
  *)
  val unique_by : f:('a -> string) -> 'a list -> 'a list

  (**
    `getAt ~index: n xs`{:.ocaml} `getAt(~index=n, xs)`{:.reason} retrieves the value of the `n`th item in `xs` (with zero as the starting index) as `Some value`{:.ocaml} `Some(value)`{:.reason}, or `None` if `n` is less than zero or greater than the length of `xs`. 

    ### Example

    ```ocaml
    getAt ~index: 3 [100; 101; 102; 103] == Some 103
    getAt ~index: 4 [100; 101; 102; 103] == None
    getAt ~index: (-1) [100; 101; 102; 103] == None
    getAt ~index: 0 [] == None
    ```

    ```reason
    getAt(~index = 3, [100, 101, 102, 103]) == Some(103);
    getAt(~index = 4, [100, 101, 102, 103]) == None;
    getAt(~index = -1, [100, 101, 102, 103]) == None;
    getAt(~index = 0, []) == None;
    ```
  *)
  val getAt : index:int -> 'a list -> 'a option

  (**
    Same as getAt
  *)
  val get_at : index:int -> 'a list -> 'a option

  (**
    `any ~f:fcn xs`{:.ocaml} `any(~f=fcn, xs)`{:.reason} returns `true` if the predicate function `fcn x`{:.ocaml} `fcn(x)`{:.reason} returns `true` for any item in `x` in `xs`.

    ### Example
    
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
  *)
  val any : f:('a -> bool) -> 'a list -> bool

  (**
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
  *)
  val head : 'a list -> 'a option

  (**
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
  *)
  val drop : count:int -> 'a list -> 'a list

  (**
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
  *)
  val init : 'a list -> 'a list option


  (**
    `filterMap ~f:fcn xs`{:.ocaml} `filterMap(~f=fcn, xs)`{:.reason} applies `fcn` to each element of `xs`. If `fcn xi`{:.ocaml} `fcn(xi)`{:.reason} is `Some value`{:.ocaml} `Some(value)`{:.reason}, then `value` is kept in the resulting list. If the result is `None`, the element is not retained in the result. 

    ### Example

    ```ocaml
    filterMap ~f: (fun x -> if x mod 2 = 0 then Some (-x) else None)
      [1;2;3;4] = [-2;-4]
    ```

    ```reason
    filterMap(~f = (x) => if (x mod 2 == 0) {Some(- x)} else {None}, 
      [1, 2, 3, 4]) == [-2, -4]
    ```
  *)
  val filterMap : f:('a -> 'b option) -> 'a list -> 'b list

  (**
    Same as filterMap
  *)
  val filter_map : f:('a -> 'b option) -> 'a list -> 'b list

  (**
    `filter ~f:predicate xs`{:.ocaml} `filter(~f=predicate, xs)`{:.reason} returns a list of all elements in `xs` which satisfy the predicate function `predicate`.

    ### Example

    ```ocaml
    filter ~f: (fun x -> x mod 2 = 0) [1;2;3;4] = [2;4]
    ```

    ```reason
    filter(~f=((x) => x mod 2 == 0), [1, 2, 3, 4]) == [2, 4];
    ```
  *)
  val filter : f:('a -> bool) -> 'a list -> 'a list

  (**
    `concat xs`{:.ocaml} `concat(xs)`{:.reason} returns the list obtained by concatenating all the lists in the list `xs`

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
  *)
  val partition : f:('a -> bool) -> 'a list -> 'a list * 'a list

  val foldr : f:('a -> 'b -> 'b) -> init:'b -> 'a list -> 'b

  val foldl : f:('a -> 'b -> 'b) -> init:'b -> 'a list -> 'b

  val findIndex : f:('a -> bool) -> 'a list -> int option

  val find_index : f:('a -> bool) -> 'a list -> int option

  val take : count:int -> 'a list -> 'a list

  val updateAt : index:int -> f:('a -> 'a) -> 'a list -> 'a list

  val update_at : index:int -> f:('a -> 'a) -> 'a list -> 'a list

  val length : 'a list -> int

  val reverse : 'a list -> 'a list

  val dropWhile : f:('a -> bool) -> 'a list -> 'a list

  val drop_while : f:('a -> bool) -> 'a list -> 'a list

  val isEmpty : 'a list -> bool

  val is_empty : 'a list -> bool

  val cons : 'a -> 'a list -> 'a list

  val takeWhile : f:('a -> bool) -> 'a list -> 'a list

  val take_while : f:('a -> bool) -> 'a list -> 'a list

  val all : f:('a -> bool) -> 'a list -> bool

  val tail : 'a list -> 'a list option

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
