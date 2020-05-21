(** Documentation for tablecloth.mli *)

(** Functions for working with boolean ([true] or [false]) values. *)
module Bool : module type of Bool

module Char : module type of TableclothChar

(** Fixed precision integers *)
module Int : module type of Int

module Float : module type of Float

module Array : sig
  type 'a t = 'a array

  val empty : unit -> 'a array

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

  val toIndexedList : 'a array -> (int * 'a) list

  val to_indexed_list : 'a array -> (int * 'a) list

  val get : 'a array -> int -> 'a option

  val getAt : index:int -> 'a array -> 'a option

  val get_at : index:int -> 'a array -> 'a option

  val set : 'a array -> int -> 'a -> unit

  val setAt : index:int -> value:'a -> 'a array -> unit

  val set_at : index:int -> value:'a -> 'a array -> unit

  val sum : int array -> int

  val floatSum : float array -> float

  val float_sum : float array -> float

  val filter : f:('a -> bool) -> 'a array -> 'a array

  val swap : 'a t -> int -> int -> unit

  val map : f:('a -> 'b) -> 'a array -> 'b array

  val mapWithIndex : f:(int -> 'a -> 'b) -> 'a array -> 'b array

  val map_with_index : f:(int -> 'a -> 'b) -> 'a array -> 'b array

  val map2 : f:('a -> 'b -> 'c) -> 'a array -> 'b array -> 'c array

  val map3 :
    f:('a -> 'b -> 'c -> 'd) -> 'a array -> 'b array -> 'c array -> 'd array

  val flatMap : f:('a -> 'b array) -> 'a array -> 'b array

  val flat_map : f:('a -> 'b array) -> 'a array -> 'b array

  val sliding : ?step:int -> 'a t -> size:int -> 'a t t

  val find : f:('a -> bool) -> 'a array -> 'a option

  val findIndex : 'a array -> f:(int -> 'a -> bool) -> (int * 'a) option

  val find_index : 'a array -> f:(int -> 'a -> bool) -> (int * 'a) option

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
  type 'a t = 'a list

  val concat : 'a list list -> 'a list
  (**
    [List.concat] returns the list obtained by concatenating in order all the sub-lists in a given list.

    {[
    List.concat [[1; 2]; [3; 4; 5]; []; [6]] = [1; 2; 3; 4; 5; 6]
    ]}
  *)

  val sum : int list -> int
  (**
    [List.sum xs] returns the sum of the items in the given list of integers.

    {[
    List.sum [1; 3; 5; 7] = 16
    ]}
  *)

  val floatSum : float list -> float
  (**
    Same as {!List.float_sum}.
  *)

  val float_sum : float list -> float
  (**
    [List.float_sum(xs)] returns the sum of the given list of floats.

    {[
    List.float_sum [1.3; 5.75; 9.2] = 16.25
    ]}
  *)

  val map : f:('a -> 'b) -> 'a list -> 'b list
  (**
    [List.map ~f:fcn xs] returns a new list that it is the result of
    applying function [fcn] to each item in the list [xs].

    {[
    let cube_root (x : int) =
      ((float_of_int x) ** (1.0 /. 3.0) : float)

    List.map ~f:cube_root [8; 1000; 1728] (* [2; 9.999..; 11.999..] *)
    ]}
  *)

  val indexedMap : f:(int -> 'a -> 'b) -> 'a list -> 'b list
  (**
    Same as {!List.indexed_map}.
  *)

  val indexed_map : f:(int -> 'a -> 'b) -> 'a list -> 'b list
  (**
    [List.indexed_map ~f:fcn xs] returns a new list that it is the result of applying
    function [fcn] to each item in the list [xs]. The function has two parameters:
    the index number of the item in the list, and the item being processed.
    Item numbers start with zero.

    {[
    let numbered (idx: int) (item: string) =
      ((string_of_int idx) ^ ": " ^ item : string)

    List.indexed_map ~f:numbered ["zero"; "one"; "two"] =
      ["0: zero"; "1: one"; "2: two"]
    ]}
  *)

  val mapi : f:(int -> 'a -> 'b) -> 'a list -> 'b list
  (**
    Same as {!List.indexedMap} and {!List.indexed_map}.
  *)

  val map2 : f:('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list
  (**
    [List.map2 f xs ys] creates a new list by applying [f], which
    takes two arguments, to corresponding elements of [xs] and [ys].
    The operation stops when every element in the shorter of [xs] and [ys]
    has been processed.

    {[
    let subtract x y = x - y
    List.map2 subtract [6; 5; 4] [1; 2; 3] = [5; 3; 1]
    List.map2 subtract [6; 5] [1; 2; 3] = [5; 3]
    ]}
  *)

  val sliding : ?step:int -> 'a t -> size:int -> 'a t t

  val getBy : f:('a -> bool) -> 'a list -> 'a option
  (**
    Same as {!List.get_by}.
  *)

  val get_by : f:('a -> bool) -> 'a list -> 'a option
  (**
    [List.get_by ~f:predicate xs]  returns [Some value] for the first value in [xs]
    that satisifies the [predicate] function; returns [None] if no element
    satisifies the function.

    {[
    let even (x: int) = (x mod 2 = 0 : bool)
    List.get_by ~f:even [1; 4; 3; 2] = Some 4
    List.get_by ~f:even [15; 13; 11] = None
    ]}
  *)

  val find : f:('a -> bool) -> 'a list -> 'a option
  (**
    Same as {!List.getBy} and {!List.get_by}.
  *)

  val elemIndex : value:'a -> 'a list -> int option
  (**
    Same as {!List.elem_index}.
  *)

  val elem_index : value:'a -> 'a list -> int option
  (**
    [List.elem_index ~value:v xs] finds the first occurrence of [v] in [xs] and
    returns its position as [Some index] (with zero being the first element),
    or [None] if the value is not found.

    {[
    List.elem_index ~value: 5 [7; 6; 5; 4; 5] = Some(2)
    List.elem_index ~value: 8 [7; 6; 5; 4; 5] = None
    ]}
  *)

  val last : 'a list -> 'a option
  (**
    [List.last xs] returns the last element in the list
    as [Some value] unless the list is empty,
    in which case it returns [None].

    {[
    List.last ["this"; "is"; "the"; "end"] = Some("end")
    List.last [] = None
    ]}
  *)

  val member : value:'a -> 'a list -> bool
  (**
    [List.member ~value: v xs] returns [true]
    if the given value [v] is found in thelist [xs], [false] otherwise.

    {[
    List.member ~value:3 [1;3;5;7] = true
    List.member ~value:4 [1;3;5;7] = false
    List.member ~value:5 [] = false
    ]}
  *)

  val uniqueBy : f:('a -> string) -> 'a list -> 'a list
  (**
    Same as {!List.unique_by}.
  *)

  val unique_by : f:('a -> string) -> 'a list -> 'a list
  (**
    [List.unique_by ~f:fcn xs] returns a new list containing only those elements from [xs]
    that have a unique value when [fcn] is applied to them.

    The function [fcn] takes as its single parameter an item from the list
    and returns a [string]. If the function generates the same string for two or more
    list items, only the first of them is retained.

    {[
    List.unique_by ~f:string_of_int [1; 3; 4; 3; 7; 7; 6] = [1; 3; 4; 7; 6]

    let abs_str x = string_of_int (abs x)
    List.unique_by ~f:abs_str [1; 3; 4; -3; -7; 7; 6] = [1; 3; 4; -7; 6]
    ]}
  *)

  val getAt : index:int -> 'a list -> 'a option
  (**
    Same as {!List.get_at}.
  *)

  val get_at : index:int -> 'a list -> 'a option
  (**
    [List.get_at ~index: n xs] retrieves the value of the [n]th item in [xs]
    (with zero as the starting index) as [Some value], or [None]
    if [n] is less than zero or greater than the length of [xs].

    {[
    List.get_at ~index:3 [100; 101; 102; 103] == Some 103
    List.get_at ~index:4 [100; 101; 102; 103] == None
    List.get_at ~index:(-1) [100; 101; 102; 103] == None
    List.get_at ~index:0 [] == None
    ]}
  *)

  val any : f:('a -> bool) -> 'a list -> bool
  (**
    [List.any ~f:fcn xs] returns [true] if
    the predicate function [fcn x] returns [true]
    for any item in [x] in [xs].

    {[
    let even x = (x mod 2) = 0
    List.any ~f:even [1; 3; 4; 5] = true
    List.any ~f:even [1; 3; 5; 7] = false
    List.any ~f:even [] = false
    ]}
  *)

  val head : 'a list -> 'a option
  (**
    [List.head xs] (returns the first item in [xs] as
    [Some value], unless it is given an empty list,
    in which case it returns [None].

    {[
    List.head ["first"; "second"; "third"] = Some "first"
    List.head [] = None
    ]}
  *)

  val drop : count:int -> 'a list -> 'a list
  (**
    [List.drop ~count:n xs] returns a list
    without the first [n] elements of [xs]. If [n] negative or greater
    than the length of [xs], it returns an empty list.

    {[
    List.drop ~count:3 [1;2;3;4;5;6] = [4;5;6]
    List.drop ~count:9 [1;2;3;4;5;6] = []
    List.drop ~count:(-2) [1;2;3;4;5;6] = []
    ]}
  *)

  val init : 'a list -> 'a list option
  (**
    For non-empty lists, [List.init xs] returns a new list
    consisting of all but the last list item as a [Some] value.
    If [xs] is an empty list, [List.init] returns [None].

    {[
    List.init ["ant";"bee";"cat";"extra"] = Some ["ant";"bee";"cat"]
    List.init [1] = Some []
    List.init [] = None
    ]}
  *)

  val filterMap : f:('a -> 'b option) -> 'a list -> 'b list
  (**
    Same as {!List.filter_map}.
  *)

  val filter_map : f:('a -> 'b option) -> 'a list -> 'b list
  (**
    [List.filter_map ~f:fcn xs] applies [fcn] to each element of [xs].
    If the function returns [Some value], then [value] is kept in the resulting list.
    If the result is [None], the element is not retained in the result.

    {[
    List.filter_map ~f:(fun x -> if x mod 2 = 0 then Some (-x) else None)
      [1;2;3;4] = [-2;-4]
    ]}
  *)

  val filter : f:('a -> bool) -> 'a list -> 'a list
  (**
    [List.filter ~f:predicate xs] returns
    a list of all elements in [xs] which satisfy the predicate function [predicate].

    {[
    List.filter ~f:(fun x -> x mod 2 = 0) [1;2;3;4] = [2;4]
    ]}
  *)

  (**
    `partition ~f:predicate` (`partition(~f=predicate, xs)` in ReasonML) returns
    a tuple of two lists. The first element is a list of all the elements of `xs`
    for which `predicate` returned `true`. The second element of the tuple is a list
    of all the elements in `xs` for which `predicate` returned `false`.
  *)

  val partition : f:('a -> bool) -> 'a list -> 'a list * 'a list
  (**
    [List.partition ~f:predicate] returns
    a tuple of two lists. The first element is a list of all the elements of [xs]
    for which [predicate] returned [true]. The second element of the tuple is a list
    of all the elements in [xs] for which [predicate] returned [false].

    {[
    let positive x = (x > 0)
    List.partition ~f:positive [1;-2;-3;4;5] = ([1;4;5], [-2;-3])
    ]}
  *)

  val foldRight : f:('a -> 'b -> 'b) -> initial:'b -> 'a list -> 'b

  val fold_right : f:('a -> 'b -> 'b) -> initial:'b -> 'a list -> 'b

  val foldLeft : f:('a -> 'b -> 'b) -> initial:'b -> 'a list -> 'b

  val fold_left : f:('a -> 'b -> 'b) -> initial:'b -> 'a list -> 'b

  val findIndex : f:('a -> bool) -> 'a list -> int option
  (**
    Same as {!List.find_index}.
  *)

  val find_index : f:('a -> bool) -> 'a list -> int option
  (**
    [List.find_index ~f:predicate] finds the position of the first element in [xs] for which
    [predicate] returns [true]. The position is returned as [Some index].
    If no element satisfies the [predicate], [find_index] returns [None].

    {[
    let negative x = (x < 0)
    List.find_index ~f:negative [100;101;-102;103] = Some 2
    List.find_index ~f:negative [100;101] = None
    List.find_index ~f:negative [] = None
    ]}
  *)

  val take : count:int -> 'a list -> 'a list
  (**
    [List.take ~count:n xs] returns a list consisting of
    the first [n] elements of [xs]. If [n] is less than or equal to zero or greater than
    the length of [xs], [take] returns the empty list.

    {[
    List.take ~count:3 [1;2;3;4;5;6] = [1;2;3]
    List.take ~count:9 [1;2;3;4;5;6] = []
    List.take ~count:(-2) [1;2;3;4;5;6] = []
    ]}
  *)

  val updateAt : index:int -> f:('a -> 'a) -> 'a list -> 'a list
  (**
    Same as {!List.update_at}.
  *)

  val update_at : index:int -> f:('a -> 'a) -> 'a list -> 'a list
  (**
    [List.update_at ~index:n ~f:fcn xs] returns a new list with function [fcn] applied
    to the list item at index position [n]. (The first item in a list has index zero.)
    If [n] is less than zero or greater than the number of items in [xs],
    the new list is the same as the original list.

    {[
    let double x = x * 2
    List.update_at ~index:1 ~f:double [1;2;3]  = [1;4;3]
    List.update_at ~index:(-2) ~f:double [1;2;3] = [1;2;3]
    List.update_at ~index:7 ~f:double [1;2;3] = [1;2;3]
    ]}
  *)

  val length : 'a list -> int
  (**
    [List.length xs] returns the number of items in the given list.
    An empty list returns zero.
  *)

  val reverse : 'a list -> 'a list
  (**
    [List.reverse xs] returns a list whose items are in the
    reverse order of those in [xs].
  *)

  val dropWhile : f:('a -> bool) -> 'a list -> 'a list
  (**
    Same as {!List.drop_while}.
  *)

  val drop_while : f:('a -> bool) -> 'a list -> 'a list
  (**
    [List.drop_while ~f:predicate xs] returns a list without the first elements
    of [xs] for which the [predicate] function returns [true].

    {[
    let even x = x mod 2 = 0
    List.drop_while ~f:even [2; 4; 6; 7; 8; 9] = [7; 8; 9]
    List.drop_while ~f:even [2; 4; 6; 8] = []
    List.drop_while ~f:even [1; 2; 3] = [1; 2; 3]
    ]}
  *)

  val isEmpty : 'a list -> bool
  (**
    Same as {!List.is_empty}.
  *)

  val is_empty : 'a list -> bool
  (**
    [List.is_empty xs]  returns [true] if [xs] is the empty list [[]]; [false] otherwise.
  *)

  val cons : 'a -> 'a list -> 'a list
  (**
    [List.cons item xs] prepends the [item] to [xs].

    {[
    List.cons "one" ["two"; "three"] = ["one"; "two"; "three"]
    List.cons 42 [] = [42]
    ]}
  *)

  val takeWhile : f:('a -> bool) -> 'a list -> 'a list
  (**
    Same as {!List.take_while}.
  *)

  val take_while : f:('a -> bool) -> 'a list -> 'a list
  (**
    [List.take_while ~f:predicate xs] returns a list with the first elements
    of [xs] for which the [predicate] function returns [true].

    {[
    let even x = x mod 2 = 0
    List.take_while ~f:even [2; 4; 6; 7; 8; 9] = [2; 4; 6]
    List.take_while ~f:even [2; 4; 6] = [2; 4; 6]
    List.take_while ~f:even [1; 2; 3] = []
    ]}
  *)

  val all : f:('a -> bool) -> 'a list -> bool
  (**
    [List.all ~f:predicate xs] returns [true]
    if all the elements in [xs] satisfy the [predicate] function, [false] otherwise.
    Note: [List.all] returns [true] if [xs] is the empty list.

    {[
    let even x = x mod 2 = 0
    List.all ~f:even [16; 22; 40] = true
    List.all ~f:even [16; 21; 40] = false
    List.all ~f:even [] = true
    ]}
  *)

  val tail : 'a list -> 'a list option
  (**
    [List.tail xs] returns all except the first item in [xs]
    as a [Some] value when [xs] is not empty. If [xs] is the empty list,
    [List.tail] returns [None].

    {[
    List.tail [3; 4; 5] = Some [4; 5]
    List.tail [3] = Some []
    List.tail [] = None
    ]}
  *)

  val append : 'a list -> 'a list -> 'a list
  (**
    [List.append xs ys] returns a new list with
    the elements of [xs] followed by the elements of [ys].

    {[
    List.append [1; 2] [3; 4; 5] = [1; 2; 3; 4; 5]
    List.append [] [6; 7] = [6; 7]
    List.append [8; 9] [] = [8; 9]
    ]}
  *)

  val removeAt : index:int -> 'a list -> 'a list
  (**
    Same as {!List.remove_at}.
  *)

  val remove_at : index:int -> 'a list -> 'a list
  (**
    [List.remove_at n xs] returns a new list with the item at the given index removed.
    If [n] is less than zero or greater than the length of [xs], the new list is
    the same as the original.

    {[
    List.remove_at ~index:2, ["a"; "b"; "c"; "d"] = ["a"; "b"; "d"]
    List.remove_at ~index:(-2) ["a"; "b"; "c"; "d"] = ["a"; "b"; "c"; "d"]
    List.remove_at ~index:7 ["a"; "b"; "c"; "d"] = ["a"; "b"; "c"; "d"]
    ]}
  *)

  val minimumBy : f:('a -> 'comparable) -> 'a list -> 'a option
  (**
    Same as {!List.:minimum_by}.
   *)

  val minimum_by : f:('a -> 'comparable) -> 'a list -> 'a option
  (**
    [List.minimum_by ~f:fcn, xs], when given a non-empty list, returns the item in the list
    for which [fcn item] is a minimum. It is returned as [Some item].

    If given an empty list, [List.minimumBy] returns [None]. If more than one value has
    a minimum value for [fcn item], the first one is returned.

    The function provided takes a list item as its parameter and must return a value
    that can be compared---for example, a [string] or [int].

    {[
    let mod12 x = x mod 12
    let hours = [7; 9; 15; 10; 3; 22]
    List.minimum_by ~f:mod12 hours = Some 15
    List.minimum_by ~f:mod12 [] = None
    ]}
   *)

  val minimum : 'comparable list -> 'comparable option
  (**
    [List.minimum xs], when given a non-empty list, returns
    the item in the list with the minimum value. It is returned as [Some value]
    ([Some(value) in ReasonML)]. If given an empty list, [List.maximum] returns [None].

    The items in the list must be of a type that can be compared---for example, a [string] or [int].
   *)

  val maximumBy : f:('a -> 'comparable) -> 'a list -> 'a option
  (**
    Same as {!List.maximum_by}.
   *)

  val maximum_by : f:('a -> 'comparable) -> 'a list -> 'a option
  (**
    [List.maximum_by ~f:fcn, xs], when given a non-empty list, returns the item in the list
    for which [fcn item] is a maximum. It is returned as [Some item].

    If given an empty list, [List.maximumBy] returns [None]. If more than one value
    has a maximum value for [fcn item], the first one is returned.

    The function provided takes a list item as its parameter and must return a value
    that can be compared---for example, a [string] or [int].

    {[
    let mod12 x = x mod 12
    let hours = [7;9;15;10;3;22]
    List.maximum_by ~f:mod12 hours = Some 10
    List.maximum_by ~f:mod12 [] = None
    ]}
   *)

  val maximum : 'comparable list -> 'comparable option
  (**
    [List.maximum xs], when given a non-empty list, returns
    the item in the list with the maximum value. It is returned as [Some value].
    If given an empty list, [List.maximum] returns [None].

    The items in the list must be of a type that can be compared---for example, a [string] or [int].
   *)

  val sortBy : f:('a -> 'b) -> 'a list -> 'a list
  (**
    Same as {!List.sort_by}.
  *)

  val sort_by : f:('a -> 'b) -> 'a list -> 'a list
  (**
    [List.sort_by ~f:fcn xs] returns a new list sorted according to the values
    returned by [fcn]. This is a stable sort; if two items have the same value,
    they will appear in the same order that they appeared in the original list.

    {[
    List.sort_by ~f:(fun x -> x * x) [3; 2; 5; -2; 4] = [2; -2; 3; 4; 5]
    ]}
  *)

  val span : f:('a -> bool) -> 'a list -> 'a list * 'a list
  (**
    [List.span ~f:predicate xs] splits the list [xs]
    into a tuple of two lists. The first list contains the first elements of [xs]
    that satisfy the predicate; the second list contains the remaining elements of [xs].

    {[
    let even x = x mod 2 = 0
    List.span ~f:even [4; 6; 8; 1; 2; 3] = ([4; 6; 8], [1; 2; 3])
    List.span ~f:even [1; 2; 3] = ([], [1; 2; 3])
    List.span ~f:even [20; 40; 60] = ([20; 40; 60], [])
    ]}
  *)

  val groupWhile : f:('a -> 'a -> bool) -> 'a list -> 'a list list
  (**
    Same as {!List.group_while}.
  *)

  val group_while : f:('a -> 'a -> bool) -> 'a list -> 'a list list
  (**
    [List.group_while ~f:fcn xs] produces a list of lists. Each sublist consists of
    consecutive elements of [xs] which belong to the same group according to [fcn].

    [fcn] takes two parameters and returns a [bool]: [true] if
    the values should be grouped together, [false] if not.

    {[
    List.groupWhile ~f:(fun x y -> x mod 2 == y mod 2)
      [2; 4; 6; 5; 3; 1; 8; 7; 9] = [[2; 4; 6]; [5; 3; 1]; [8]; [7; 9]]
    ]}
  *)

  val splitAt : index:int -> 'a list -> 'a list * 'a list
  (**
    Same as {!val:split_at}.
  *)

  val split_at : index:int -> 'a list -> 'a list * 'a list
  (**
    [List.split_at ~index:n xs] returns a tuple of two lists. The first list has the
    first [n] items of [xs], the second has the remaining items of [xs].

    If [n] is less than zero or greater than the length of [xs], [List.split_at]
    returns two empty lists.

    {[
    List.split_at ~index:3 [10; 11; 12; 13; 14] = ([10; 11; 12], [13; 14])
    List.split_at ~index:0 [10; 11; 12] = ([], [10; 11; 12])
    List.split_at ~index:3 [10; 11; 12] = ([10; 11; 12], [])
    List.split_at ~index:(-1) [10; 11; 12] = ([], [])
    List.split_at ~index:4 [10; 11; 12] = ([], [])
    ]}
  *)

  val insertAt : index:int -> value:'a -> 'a list -> 'a list
  (**
    Same as {!List.insert_at}
  *)

  val insert_at : index:int -> value:'a -> 'a list -> 'a list
  (**
    [List.insert_at ~index=n ~value=v xs] returns a new list with the value [v] inserted
    before position [n] in [xs]. If [n] is less than zero or greater than the length of [xs],
    returns a list consisting only of the value [v].

    {[
    List.insert_at ~index:2 ~value:999 [100; 101; 102; 103] = [100; 101; 999; 102; 103]
    List.insert_at ~index:0 ~value:999 [100; 101; 102; 103] = [999; 100; 101; 102; 103]
    List.insert_at ~index:4 ~value:999 [100; 101; 102; 103] = [100; 101; 102; 103; 999]
    List.insert_at ~index:(-1) ~value:999 [100; 101; 102; 103] = [999]
    List.insert_at ~index:5 ~value:999 [100; 101; 102; 103] = [999]
    ]}
  *)

  val splitWhen : f:('a -> bool) -> 'a list -> 'a list * 'a list
  (**
    Same as {!List.split_when}.
  *)

  val split_when : f:('a -> bool) -> 'a list -> 'a list * 'a list
  (**
    [List.split_when ~f:predicate  xs] returns a tuple of two lists as an [option] value.
    The first element of the tuple is the list of all the elements at the
    beginning of [xs] that  do _not_ satisfy the [predicate] function.
    The second element of the tuple is the list of the remaining items in [xs].

    {[
    let even x: int = ((x mod 2) = 0 : bool)
    List.split_when ~f: even [5; 1; 2; 6; 3] =  ([5; 1], [2; 6; 3]);
    List.split_when ~f: even [2; 6; 5] =  ([], [2; 6; 5]);
    List.split_when ~f: even [1; 5; 3] =  ([1; 5; 3], []);
    List.split_when ~f: even [2; 6; 4] =  ([], [2; 6; 4]);
    List.split_when ~f: even [] =  ([], [])
    ]}
  *)

  val intersperse : 'a -> 'a list -> 'a list
  (**
    [List.intersperse separator xs]
    inserts [separator]  between all the elements in [xs]. If [xs] is empty,
    [List.intersperse] returns the empty list.

    {[
    List.intersperse "/" ["a"; "b"; "c"] = ["a"; "/"; "b"; "/"; "c"]
    List.intersperse "?" [] = []
    ]}
  *)

  val initialize : int -> (int -> 'a) -> 'a list
  (**
    [List.initialize n f] creates a list with values
    [[f 0; f 1; ...f (n - 1)]] ([[f(0), f(1),...f(n - 1)]] in ReasonML. Returns
    the empty list if given a negative value for [n].

    {[
    let cube_plus_one x = ((float_of_int x) +. 1.0) ** 3.0
    List.initialize 3 cube_plus_one = [1.0; 8.0; 27.0]
    List.initialize 0 cube_plus_one = []
    List.initialize (-2) cube_plus_one = []
    ]}
  *)

  val sortWith : ('a -> 'a -> int) -> 'a list -> 'a list
  (**
    Same as {!List.sort_with}.
  *)

  val sort_with : ('a -> 'a -> int) -> 'a list -> 'a list
  (**
    [List.sort_with compareFcn xs] returns a new list with the elements in [xs] sorted according
    to [compareFcn]. The [compareFcn] function takes two list items and returns a value
    less than zero if the first item compares less than the second, zero if the items compare equal,
    and one if the first item compares greater than the second.

    This is a stable sort; items with equivalent values according to the [compareFcn]
    appear in the sorted list in the same order as they appeared in the original list.

    let cmp_mod12 a b = (
      (a mod 12) - (b mod 12)
    )

    List.sort_with cmp_mod12 [15; 3; 22; 10; 16] == [3; 15; 10; 22; 10]
  *)

  val iter : f:('a -> unit) -> 'a list -> unit
  (**
    [List.iter ~f: fcn xs] applies the given function
    to each element in [xs]. The function you provide must return [unit], and the
    [iter] call itself also returns [unit]. You use [List.iter] when you want to process
    a list only for side effects.

    The following code will print the items in the list to the console.

    {[
    let _ = List.iter ~f:Js.log ["a"; "b"; "c"]
    ]}
  *)

  val repeat : count:int -> 'a -> 'a list
  (**
    [List.repeat ~count=n v] returns a list with the value [v] repeated [n] times.

    {[
    List.repeat ~count:3 99 = [99; 99; 99]
    List.repeat ~count:0 99 = []
    ]}
  *)
end

(**
  This module implements the [Result] type, which has a variant for
  successful results (['ok]), and one for unsuccessful results (['error]).
*)
module Result : sig
  (**
    [type] is the type constructor for a [Result] type. You specify
    the type of the [Error] and [Ok] variants, in that order.


    Here is how you would annotate a [Result] variable whose [Ok]
    variant is an integer and whose [Error] variant is a string:

    {[
    let x: (string, int) Tablecloth.Result.t = Ok 3
    let y: (string, int) Tablecloth.Result.t = Error "bad"
    ]}

  *)
  type ('err, 'ok) t = ('ok, 'err) Belt.Result.t

  val succeed : 'ok -> ('err, 'ok) t
  (**
    [Result.succeed(value)] returns [Ok(value)]. Use this to construct a successful
    result without having to depend directly on Belt or Base.

    Not only can you use [Result.succeed] whenever you would use the type constructor,
    but you can also use it when you would have wanted to pass the constructor
    itself as a function.

    {[
    Result.succeed 3 = Ok 3
    Tablecloth.List.map [1; 2; 3] ~f:Result.succeed = [Ok 1; Ok 2; Ok 3]
    ]}
  *)

  val fail : 'err -> ('err, 'ok) t
  (**
    [Result.fail(value)] returns [Error(value)]. Use this to construct a failing
    result without having to depend directly on Belt or Base.

    (Similar to {!Result.succeed})

    Not only can you use [Result.fail] whenever you would use the type constructor,
    but you can also use it when you would have wanted to pass the constructor
    itself as a function.

    {[
    Result.fail 3 = Error 3
    Tablecloth.List.map [1; 2; 3] ~f:Result.fail =
      [Error 1; Error 2; Error 3]
    ]}
  *)

  val withDefault : default:'ok -> ('err, 'ok) t -> 'ok
  (**
    Same as {!Result.with_default}.
  *)

  val with_default : default:'ok -> ('err, 'ok) t -> 'ok
  (**
    [Result.with_default ~default:defaultValue, result], when given an [Ok value], returns
    [value]; if given an [Error errValue ], returns [defaultValue].

    {[
    Result.with_default ~default:0 (Ok 12) = 12
    Result.with_default ~default:0 (Error "bad") = 0
    ]}
  *)

  val map2 : f:('a -> 'b -> 'c) -> ('err, 'a) t -> ('err, 'b) t -> ('err, 'c) t
  (**
    [Result.map2 ~f:fcn result_a result_b] applies
    [fcn], a function taking two non-[Result] parameters and returning a
    non-[Result] result to two [Result] arguments [result_a] and [result_b] as follows:

    If [result_a] and [result_b] are of the form [Ok a] and [OK b],
    the return value is [Ok (f a b)].

    If only one of [result_a] and [result_b] is of the form [Error err],
    that becomes the return result.  If both are [Error] values,
    [Result.map2] returns [result_a].


    {[
    let sum_diff x y = (x + y) * (x - y)
    Result.map2 ~f:sum_diff (Ok 7) (Ok 3) = Ok 40
    Result.map2 ~f:sum_diff (Error "err A") (Ok 3) = Error "err A"
    Result.map2 ~f:sum_diff (Ok 7) (Error "err B") = Error "err B"
    Result.map2 ~f:sum_diff (Error "err A") (Error "err B") = Error ("err A")
    ]}

  *)

  val combine : ('x, 'a) t list -> ('x, 'a list) t
  (**
    [Result.combine results] takes a list of [Result] values. If all
    the elements in [results] are of the form [Ok x], then [Result.combine]
    creates a list [xs] of all the values extracted from their [Ok]s, and returns
    [Ok xs]

    If any of the elements in [results] are of the form [Error err],
    the first of them is returned as the result of [Result.combine].

    {[
    Result.combine [Ok 1; Ok 2; Ok 3; Ok 4] = Ok [1; 2; 3; 4]
    Result.combine [Ok 1; Error "two"; Ok 3; Error "four"] = Error "two"
    ]}
  *)

  val map : f:('ok -> 'value) -> ('err, 'ok) t -> ('err, 'value) t
  (**
    [Result.map f r] applies a function [f], which
    takes a non-[Result] argument and returns a non-[Result] value, to
    a [Result] variable [r] as follows:

    If [r] is of the form [Ok x] ([Ok(x) in ReasonMl), [Result.map]
    returns [Ok (f x)]. Otherwise, [r] is an [Error]
    value and is returned unchanged.

    {[
    Result.map (fun x -> x * x) (Ok 3) = Ok 9
    Result.map (fun x -> x * x) (Error "bad") = Error "bad"
    ]}
  *)

  val fromOption : error:'err -> 'ok option -> ('err, 'ok) t
  (**
    Same as {!Result.from_option}.

  *)

  val from_option : error:'err -> 'ok option -> ('err, 'ok) t
  (**
    Map a [Option] to a [Result] value where [None] becomes [Error] and [Some]
    becomes [Ok].

    Useful for interacting with code that primarily uses [Result]s.
  *)

  val toOption : ('err, 'ok) t -> 'ok option
  (**
    Same as {!Result.to_option}.

  *)

  val to_option : ('err, 'ok) t -> 'ok option
  (**
    [Result.to_option r] converts a [Result] value [r] to an [Option] value as follows:
    a value of [Ok x] becomes [Some x]; a value of [Error err] becomes [None].

    {[
    Result.to_option (Ok 42) = Some 42
    Result.to_option (Error "bad") = None
    ]}
  *)

  val andThen : f:('ok -> ('err, 'value) t) -> ('err, 'ok) t -> ('err, 'value) t
  (**
    Same as {!Result.and_then}.
  *)

  val and_then :
    f:('ok -> ('err, 'value) t) -> ('err, 'ok) t -> ('err, 'value) t
  (**
    [Result.and_then ~f:fcn r] applies function [fcn], which takes a non-[Result]
    parameter and returns a [Result], to a [Result] variable [r].

    If [r] is of the form [Ok x], [Result.and_then] returns [f x];
    otherwise [r] is an [Error], and is returned unchanged.

    {[
    let recip (x:float) : (string, float) Tablecloth.Result.t = (
      if (x = 0.0) then
        Error "Divide by zero"
      else
        Ok (1.0 /. x)
    )

    Result.and_then ~f:recip (Ok 4.0) = Ok 0.25
    Result.and_then ~f:recip (Error "bad") = Error "bad"
    Result.and_then ~f:recip (Ok 0.0) = Error "Divide by zero"
    ]}

    [Result.and_then] is usually used to implement a chain of function
    calls, each of which returns a [Result] value.

    {[
    let root (x:float) : (string, float) Tablecloth.Result.t = (
      if (x < 0.0) then
        Error "Cannot be negative"
      else
        Ok (sqrt x)
    )

    root 4.0 |> Result.and_then ~f:recip = Ok 0.5
    root (-2.0) |> Result.and_then ~f:recip = Error "Cannot be negative"
    root(0.0) |> Result.and_then ~f:recip = Error "Divide by zero"
    ]}
  *)

  val pp :
       (Format.formatter -> 'err -> unit)
    -> (Format.formatter -> 'ok -> unit)
    -> Format.formatter
    -> ('err, 'ok) t
    -> unit
end
(**
    [Result.pp errFormat okFormat destFormat result]“pretty-prints”
    the [result], using [errFormat] if the [result] is an [Error] value or
    [okFormat] if the [result] is an [Ok] value. [destFormat] is a formatter
    that tells where to send the output.

    The following example will print [<ok: 42><error: bad>].


    {[
    let good: (string, int) Tablecloth.Result.t = Ok 42
    let not_good: (string, int) Tablecloth.Result.t = Error "bad"
    Result.pp Format.pp_print_string Format.pp_print_int Format.std_formatter good
    Result.pp Format.pp_print_string Format.pp_print_int Format.std_formatter not_good
    Format.pp_print_newline Format.std_formatter ();
    ]}

  *)

(**
  This module provides functions to work with the [option] type,
  which has a variant for  valid values (['Some]), and one for
  invalid values (['None]).
*)
module Option : sig
  type 'a t = 'a option

  val some : 'a -> 'a option
  (**
    [Option.some(value)] returns [Some(value)]. Use this to construct the Some branch
    of an option whenever you need a function to do so.

    {[
    Tablecloth.List.map [1; 2; 3] ~f:Option.some = [Some 1; Some 2; Some 3]
    ]}
  *)

  val andThen : f:('a -> 'b option) -> 'a option -> 'b option
  (**
    Same as {!Option.and_then}.
  *)

  val and_then : f:('a -> 'b option) -> 'a option -> 'b option
  (**
    [Option.and_then ~f:fcn opt] applies function [fcn], which takes a non-[Option]
    parameter and returns an [Option], to an [Option] variable [opt].

    If [opt] is of the form [Some x], [and_then] returns [f x];
    otherwise it returns [None].

    {[
    let recip (x:float) : float option = (
      if (x == 0.0) then
        None
      else
        Some (1.0 /. x)
    )

    Option.and_then ~f:recip (Some 4.0) = Some 0.25
    Option.and_then ~f:recip None = None
    Option.and_then ~f:recip (Some 0.0) = None
    ]}

    [Option.and_then] is usually used to implement a chain of function
    calls, each of which returns an [Option] value.

    {[
    let root (x:float) : float option = (
      if (x < 0.0) then
        None
      else
        Some (sqrt x)
    )

    root 4.0 |> Option.and_then ~f:recip = Some 0.5
    root (-2.0) |> Option.and_then ~f:recip = None
    root(0.0) |> Option.and_then ~f:recip = None
    ]}
  *)

  val or_ : 'a option -> 'a option -> 'a option
  (**
    [Option.or_ opt_a opt_b] returns
    [opt_a] if it is of the form [Some x];
    otherwise, it returns [opt_b].

    Unlike the built in or operator, the [Option.or_] function
    does not short-circuit. When you call [Option.or_], both arguments
    are evaluated before being passed to the function.

    {[
    Option.or_ (Some 11) (Some 22) = Some 11
    Option.or_ None (Some 22) = Some 22
    Option.or_ (Some 11) None = Some 11
    Option.or_ None None = None
    ]}
  *)

  val orElse : 'a option -> 'a option -> 'a option
  (**
    Same as {!Option.or_else}.
  *)

  val or_else : 'a option -> 'a option -> 'a option
  (**
    [Option.or_else opt_a opt_b] returns [opt_b] if it is of the form [Some x];
    otherwise, it returns [opt_a].

    {[
    Option.orElse (Some 11) (Some 22) = Some 22
    Option.orElse None (Some 22) = Some 22
    Option.orElse (Some 11) None = Some 11
    Option.orElse None None = None
    ]}
  *)

  val map : f:('a -> 'b) -> 'a option -> 'b option
  (**
    [Option.map ~f:fcn opt] returns
    [fcn x] if [opt] is of the form
    [Some x]; otherwise, it returns [None].

    {[
    Option.map ~f:(fun x -> x * x) (Some 9) = Some 81
    Option.map ~f:(fun x -> x * x) None = None
    ]}
  *)

  val withDefault : default:'a -> 'a option -> 'a
  (**
    Same as {!Option.with_default}.
  *)

  val with_default : default:'a -> 'a option -> 'a
  (**
    [Option.with_default(~default: def_val, opt)] If [opt] is of the form [Some x],
    this function returns [x]. Otherwise, it returns the default value [def_val].

    {[
    Option.with_default ~default:99 (Some 42) = 42
    Option.with_default ~default:99 None = 99
    ]}
  *)

  val values : 'a option list -> 'a list
  (**
    [Option.values xs] takes a list of [option] values and creates
    a new list consisting of the values wrapped in [Some x].

    {[
    Option.values [Some 1; None; Some 3; None] = [1; 3]
    Option.values [None; None] = [ ]
    ]}
  *)

  val toList : 'a option -> 'a list
  (**
    Same as {!Option.to_list}.
  *)

  val to_list : 'a option -> 'a list
  (**
    [Option.to_list opt] returns the list [[x]] if [opt] is of the form [Some x];
    otherwise, it returns the empty list.
  *)

  val isSome : 'a option -> bool
  (**
    Same as {!Option.is_some}.
  *)

  val is_some : 'a option -> bool
  (**
    [Option.is_some opt] returns [true] if [opt] is a [Some] value, [false] otherwise.
  *)

  val toOption : sentinel:'a -> 'a -> 'a option
  (**
    Same as {!Option.to_option}.
  *)

  val to_option : sentinel:'a -> 'a -> 'a option
  (**
    [Option.to_option ~sentinel:s, x] returns [Some x] unless [x] equals the sentinel
    value [s], in which case [Option.to_option] returns [None].
  *)

  val getExn : 'a option -> 'a
  (**
    Same as {!Option.get_exn}
  *)

  val get_exn : 'a option -> 'a
  (** [get_exn optional_value]
    Returns [value] if [optional_value] is [Some value], otherwise raises [get_exn]

    @example {[
      get_exn (Some 3) = 3;;
      get_exn None (* Raises get_exn error *)
    ]}
  *)
end

module Tuple2 : sig
  val create : 'a -> 'b -> 'a * 'b
  (**
    [Tuple2.create x y] creates a two-tuple with the
    given values. The values do not have to be of the same type.

    {[
    Tuple2.create "str" 16.0 = ("str", 16.0)
    ]}
  *)

  val first : 'a * 'b -> 'a
  (**
    [Tuple2.first (a, b)] returns the first element
    in the tuple.

    {[
    Tuple2.first ("str", 16.0) = "str"
    ]}
  *)

  val second : 'a * 'b -> 'b
  (**
    [Tuple2.second (a, b)] returns the second element
    in the tuple.

    {[
    Tuple2.second ("str", 16.0) = 16.0
    ]}
  *)

  val mapFirst : f:('a -> 'x) -> 'a * 'b -> 'x * 'b
  (**
    Same as {!Tuple2.map_first})

  *)

  val map_first : f:('a -> 'x) -> 'a * 'b -> 'x * 'b
  (**
    [Tuple2.map_first ~f:fcn (a, b)] returns a new tuple with [fcn] applied to
    the first element of the tuple.

    {[
    Tuple2.map_first ~f:String.length ("str", 16.0) = (3, 16.0)
    ]}
  *)

  val mapSecond : f:('b -> 'y) -> 'a * 'b -> 'a * 'y
  (**
    Same as {!Tuple2.map_second}.

  *)

  val map_second : f:('b -> 'y) -> 'a * 'b -> 'a * 'y
  (**
    [Tuple2.map_second ~f:fcn (a, b)] returns a new tuple with [fcn] applied to
    the second element of the tuple.

    {[
    Tuple2.map_second ~f:sqrt ("str", 16.0) = ("str", 4.0)
    ]}
  *)

  val mapEach : f:('a -> 'x) -> g:('b -> 'y) -> 'a * 'b -> 'x * 'y
  (**
    Same as {!Tuple2.map_each}.

  *)

  val map_each : f:('a -> 'x) -> g:('b -> 'y) -> 'a * 'b -> 'x * 'y
  (**
    [Tuple2.map_each ~f:fcn1 ~g:fcn2 (a, b)] returns a tuple whose first
    element is [fcn1 a] and whose second element is [fcn2 b].

    {[
    Tuple2.map_each ~f:String.length ~g:sqrt ("str", 16.0) = (3, 4.0)
    ]}
  *)

  val mapAll : f:('a -> 'b) -> 'a * 'a -> 'b * 'b
  (**
    Same as {!Tuple2.map_all}.
  *)

  val map_all : f:('a -> 'b) -> 'a * 'a -> 'b * 'b
  (**
    [Tuple2.map_all ~f:fcn (a1, a2)] returns a tuple by applying [fcn] to
    both elements of the tuple. In this case, the tuple elements {i must}
    be of the same type.

    {[
    map_all ~f:String.length ("first", "second") = (5, 6)
    ]}
  *)

  val swap : 'a * 'b -> 'b * 'a
  (**
    [Tuple2.swap (a, b)] returns a
    tuple with the elements in reverse order.

    {[
    Tuple2.swap ("str", 16.0) = (16.0, "str")
    ]}
  *)

  val toList : 'a * 'a -> 'a list
  (**
    Same as {!Tuple2.to_list}.

  *)

  val to_list : 'a * 'a -> 'a list
  (**
    [Tuple2.to_list (a1, a2)] returns a list with the two elements in
    the tuple. Because list elements must have the same types,
    the tuple given to [Tuple2.to_list] must have both of its elements
    of the same type.

    {[
    Tuple2.to_list ("first", "second") = ["first"; "second"]
    ]}
  *)
end

module Tuple3 : sig
  val create : 'a -> 'b -> 'c -> 'a * 'b * 'c
  (**
    [Tuple3.create x y z] creates a three-tuple with the
    given values. The values do not have to be of the same type.

    {[
    Tuple3.create "str" 16.0 99 = ("str", 16.0, 99)
    ]}
  *)

  val first : 'a * 'b * 'c -> 'a
  (**
    [Tuple3.first (a, b, c)] returns the first element
    in the tuple.

    {[
    Tuple3.first ("str", 16.0, 99) = "str"
    ]}

  *)

  val second : 'a * 'b * 'c -> 'b
  (**
    [Tuple3.second (a, b, c)] returns the second element
    in the tuple.

    {[
    Tuple3.second ("str", 16.0, 99) = 16.0
    ]}
  *)

  val third : 'a * 'b * 'c -> 'c
  (**
    [Tuple3.third (a, b, c)] returns the third element
    in the tuple.

    {[
    Tuple3.third ("str", 16.0, 99) = 99
    ]}
  *)

  val init : 'a * 'b * 'c -> 'a * 'b
  (**
    [Tuple3.init (a, b, c)] returns a
    two-tuple with the first two elements of the given three-tuple.

    {[
    Tuple3.init ("str", 16.0, 99) = ("str", 16.0)
    ]}
  *)

  val tail : 'a * 'b * 'c -> 'b * 'c
  (**
    [Tuple3.tail (a, b, c)] returns a
    two-tuple with the last two elements of the given three-tuple.

    {[
    Tuple3.tail ("str", 16.0, 99) = (16.0, 99)
    ]}
  *)

  val mapFirst : f:('a -> 'x) -> 'a * 'b * 'c -> 'x * 'b * 'c
  (**
    Same as {!Tuple3.map_first}.
  *)

  val map_first : f:('a -> 'x) -> 'a * 'b * 'c -> 'x * 'b * 'c
  (**
    [Tuple3.map_first ~f:fcn (a, b, c)] returns a new tuple with [fcn] applied to
    the first element of the tuple.

    {[
    Tuple3.map_first ~f:String.length ("str", 16.0, 99) = (3, 16.0, 99)
    ]}
  *)

  val mapSecond : f:('b -> 'y) -> 'a * 'b * 'c -> 'a * 'y * 'c
  (**
    Same as {!Tuple3.map_second}.
  *)

  val map_second : f:('b -> 'y) -> 'a * 'b * 'c -> 'a * 'y * 'c
  (**
    [Tuple3.map_second ~f:fcn (a, b, c)] returns a new tuple with [fcn] applied to
    the second element of the tuple.

    {[
    Tuple3.map_second ~f:sqrt ("str", 16.0, 99) = ("str", 4.0, 99)
    ]}
  *)

  val mapThird : f:('c -> 'z) -> 'a * 'b * 'c -> 'a * 'b * 'z
  (**
    Same as {!Tuple3.map_third}.

  *)

  val map_third : f:('c -> 'z) -> 'a * 'b * 'c -> 'a * 'b * 'z
  (**
    [Tuple3.map_third ~f:fcn, (a, b, c)] returns a new tuple with [fcn] applied to
    the third element of the tuple.

    {[
    Tuple3.map_third ~f:succ ("str", 16.0, 99) = ("str", 16.0, 100)
    ]}
  *)

  val mapEach :
    f:('a -> 'x) -> g:('b -> 'y) -> h:('c -> 'z) -> 'a * 'b * 'c -> 'x * 'y * 'z
  (**
    Same as {!Tuple3.map_each}.
  *)

  val map_each :
    f:('a -> 'x) -> g:('b -> 'y) -> h:('c -> 'z) -> 'a * 'b * 'c -> 'x * 'y * 'z
  (**
    [Tuple3.map_each ~f:fcn1 ~g:fcn2 ~h:fcn3 (a, b, c)] returns a tuple
    whose elements are [fcn1 a], [fcn2 b], and [fcn3 c].

    {[
    Tuple3.map_each ~f:String.length ~g:sqrt ~h:succ ("str", 16.0, 99) = (3, 4.0, 100)
    ]}
  *)

  val mapAll : f:('a -> 'b) -> 'a * 'a * 'a -> 'b * 'b * 'b
  (**
    Same as {!Tuple3.map_all}.
  *)

  val map_all : f:('a -> 'b) -> 'a * 'a * 'a -> 'b * 'b * 'b
  (**
    [Tuple3.map_all ~f:fcn (a1, a2, a3)] returns a tuple by applying [fcn] to
    all three elements of the tuple. In this case, the tuple elements {i must}
    be of the same type.

    {[
    Tuple3.map_all ~f:String.length ("first", "second", "last") = (5, 6, 4)
    ]}
  *)

  val rotateLeft : 'a * 'b * 'c -> 'b * 'c * 'a
  (**
     Same as {!Tuple3.rotate_left}.
  *)

  val rotate_left : 'a * 'b * 'c -> 'b * 'c * 'a
  (**
    [Tuple3.rotate_left (a, b, c)] rotates the items of the tuple to the left one position.

    {[
    Tuple3.rotate_left ("str", 16.0, 99) = (16.0, 99, "str")
    ]}
  *)

  val rotateRight : 'a * 'b * 'c -> 'c * 'a * 'b
  (**
    Same as {!Tuple3.rotate_right}.
  *)

  val rotate_right : 'a * 'b * 'c -> 'c * 'a * 'b
  (**
    [Tuple3.rotate_right (a, b, c)] rotates the items of the tuple to the right one position.

    {[
    Tuple3.rotate_right ("str", 16.0, 99) = (99, "str", 16.0)
    ]}
  *)

  val toList : 'a * 'a * 'a -> 'a list
  (**
    Same as {!Tuple3.to_list}.

  *)

  val to_list : 'a * 'a * 'a -> 'a list
  (**
    [Tuple3.to_list (a1, a2, a3)] returns a list with the three elements in
    the tuple. Because list elements must have the same types,
    the tuple given to [Tuple3.to_list] must have all of its elements
    of the same type.

    Same as {!Tuple3.toList}.

    {[
    Tuple3.to_list ("first", "second", "third") = ["first"; "second"; "third"]
    ]}
  *)
end

module String : sig
  val length : string -> int
  (**
    [length s] returns the length of the given string.
  *)

  val toInt : string -> (string, int) Result.t
  (**
    Same as {!String.to_int}.
  *)

  val to_int : string -> (string, int) Result.t
  (**
    [String.to_int s] converts the given string to a [Ok n] if the string represents
    a valid integer, [Error "Failure(_)"] if not.

    {[
    String.to_int "123" = Belt.Result.Ok 123
    String.to_int "xyz" = Belt.Result.Error "Failure(_)"
    ]}
  *)

  val toFloat : string -> (string, float) Result.t
  (**
    Same as {!String.to_float}.
  *)

  val to_float : string -> (string, float) Result.t
  (**
    [String.to_float s] converts the given string to a [Ok n] if the string represents
    a valid float, [Error "Failure(_)"] if not.

    {[
    String.to_float "123.4" = Belt.Result.Ok 123.4
    String.to_float "123" = Belt.Result.Ok 123.0
    String.to_float "xyz" = Belt.Result.Error "Failure(_)"
    ]}
  *)

  val uncons : string -> (char * string) option
  (**
    [String.uncons s] returns [Some (head_ch, tail)],
    where the first element of the
    tuple is the first character of [s] and the second element is a string
    with the remaining characters of [s]. If given an empty string, [String.uncons]
    returns [None].

    {[
    String.uncons "abcde" = Some ('a', "bcde")
    String.uncons "a" = Some ('a', "")
    String.uncons "" = None
    ]}

  *)

  val dropLeft : count:int -> string -> string
  (**
    Same as {!String.drop_left}.
  *)

  val drop_left : count:int -> string -> string
  (**
    [String.drop_left ~count:n str] drops [n] characters from the beginning of
    the string [str]. Same as {!String.dropLeft}.

    {[
    String.drop_left ~count:3 "abcdefg" = "defg"
    String.drop_left ~count:0 "abcdefg" = "abcdefg"
    String.drop_left ~count:7 "abcdefg" = ""
    String.drop_left ~count:(-2) "abcdefg" = "fg"
    String.drop_left ~count:8 "abcdefg" = ""
    ]}
  *)

  val dropRight : count:int -> string -> string
  (**
    Same as {!String.drop_right}.
  *)

  val drop_right : count:int -> string -> string
  (**
    [String.drop_right(~count=n, str)] drops [n] characters from the end of
    the string [str].

    {[
    String.drop_right ~count:3 "abcdefg" = "abcd"
    String.drop_right ~count:0 "abcdefg" = "abcdefg"
    String.drop_right ~count:7 "abcdefg" = ""
    String.drop_right ~count:(-2) "abcdefg" = "abcdefg"
    String.drop_right ~count:8 "abcdefg" = ""
    ]}
  *)

  val split : on:string -> string -> string list
  (**
    [String.split ~on:delim str] splits the given string
    into a list of substrings separated by the given delimiter.

    {[
    String.split ~on:"/" "a/b/c" = ["a"; "b"; "c"]
    String.split ~on:"--" "a--b--c" = ["a"; "b"; "c"]
    String.split ~on:"/" "abc" = ["abc"]
    String.split ~on:"/" "" = [""]
    String.split ~on:"" "abc" = ["a"; "b"; "c"]
    ]}

  *)

  val join : sep:string -> string list -> string
  (**
    [String.join ~sep: delim xs] returns a
    string created by putting the separator [delim] between every string in
    the list [xs].

    {[
    String.join ~sep:"-" ["2019"; "31"; "01"] = "2019-31-01"
    String.join ~sep:"-" [ ] = ""
    String.join ~sep:"-" ["2019"] = "2019"
    String.join ~sep:"" ["OC"; ""; "aml"] = "OCaml"
    ]}

  *)

  val endsWith : suffix:string -> string -> bool
  (**
    Same  as {!String.ends_with}.
  *)

  val ends_with : suffix:string -> string -> bool
  (**
    [String.ends_with ~suffix: sfx s] returns [true] if
    [s] ends with [sfx], [false] otherwise.
    [String.ends_with ~suffix:"" s] always returns [true].
  *)

  val startsWith : prefix:string -> string -> bool
  (**
    Same as {!String.starts_with}.
  *)

  val starts_with : prefix:string -> string -> bool
  (**
    [String.starts_with ~prefix:pfx str] returns [true] if
    [str] begins with [pfx], [false] otherwise.
    [String.startsWith ~prefix:"" str] always returns [true].
  *)

  val toLower : string -> string
  (**
    Same as {!String.to_lower}.
  *)

  val to_lower : string -> string
  (**
    [String.to_lower s] converts all upper case letters in [s] to
    lower case. This function works only with ASCII characters,
    not Unicode.

    {[
    String.to_lower "AaBbCc123" = "aabbcc123"
    ]}
  *)

  val toUpper : string -> string
  (**
    Same as {!String.to_upper}.
  *)

  val to_upper : string -> string
  (**
    [String.to_upper s] converts all lower case letters in [s] to
    upper case.  This function works only with ASCII characters,
    not Unicode.

    {[
    String.to_upper "AaBbCc123" = "AABBCC123"
    ]}
  *)

  val uncapitalize : string -> string
  (**
    [String.uncapitalize s] converts
    the first letter of [s] to lower case if it is upper case.
    This function works only with ASCII characters,
    not Unicode.
  *)

  val capitalize : string -> string
  (**
    [String.capitalize s] converts
    the first letter of [s] to upper case if it is lower case.
    This function works only with ASCII characters,
    not Unicode.
  *)

  val isCapitalized : string -> bool
  (**
    Same as {!String.is_capitalized}.
  *)

  val is_capitalized : string -> bool
  (**
    [is_capitalized s] returns [true] if  the first letter
    of [s] is upper case, [false] otherwise. This function
    works only with ASCII characters, not Unicode.
  *)

  val contains : substring:string -> string -> bool
  (**
    [String.contains ~substring:sub s]
    returns [true] if [sub] is contained anywhere in [s]; [false] otherwise.
    [String.contains ~substring:"" s] returns [true] for all [s].
  *)

  val repeat : count:int -> string -> string
  (**
    [String.repeat ~count:n s] creates a
    string with [n] repetitions of [s]. If [n] is negative,
    [String.repeat] throws a [RangeError] exception.

    {[
    String.repeat ~count:3 "ok" = "okokok"
    String.repeat ~count:3 "" = ""
    String.repeat ~count:0 "ok" = ""
    ]}
  *)

  val reverse : string -> string
  (**
    [String.reverse s] returns a new string
    with its characters in the reverse order of the characters in
    [s]. This function works with Unicode characters.
  *)

  val fromList : char list -> string
  (**
    Same as {!String.from_list}.
  *)

  val from_list : char list -> string
  (**
    [String.from_list chars] creates a new string from the given list of
    characters. Note that these {i must} be individual characters
    in single quotes, not strings of length one.

    {[
    String.from_list [] = ""
    String.from_list ['a'; 'b'; 'c'] = "abc"
    ]}
  *)

  val toList : string -> char list
  (**
    Same as {!String.to_list}.

  *)

  val to_list : string -> char list
  (**
    [String.to_list s] returns a list with the individual characters
    in the given string. Works with Unicode characters, but
    because they don't have a literal representation, there is
    no example here.

    {[
    String.to_list "" = []
    String.to_list "abc" = ['a'; 'b'; 'c']
    ]}
  *)

  val fromInt : int -> string
  (**
    Same as {!String.from_int}.
  *)

  val from_int : int -> string
  (**
    [String.from_int n] converts the given integer to a
    base 10 string representation. Gets rid of leading
    zeros and does base conversion.

    {[
    String.from_int (-3) = "-3"
    String.from_int 009 = "9"
    String.from_int 0xa5 = "165"
    ]}
  *)

  val concat : string list -> string
  (**
    [String.concat xs] creates a string by
    concatenating all the strings in the list [xs].

    {[
    String.concat ["ab"; ""; "c"; "de"] = "abcde"
    String.concat [] = ""
    ]}
  *)

  val fromChar : char -> string
  (**
    Same as {!String.from_char}.
  *)

  val from_char : char -> string
  (**
    [String.from_char ch] converts the given character to
    an equivalent string of length one.
  *)

  val slice : from:int -> to_:int -> string -> string
  (**
    [String.slice ~from:n ~to_:m s]
    returns a string with characters [n] up to but not including [m]
    from string [s]. If [n] or [m] are negative, they are interpreted
    as [length s - (n + 1)]. If [n] is greater than [m], [String.slice]
    returns the empty string.

    {[
    String.slice ~from:2 ~to_:5 "abcdefg" = "cde"
    String.slice ~from:2 ~to_:8 "abcdefg" = "cdefg"
    String.slice ~from:(-6) ~to_:5 "abcdefg" = "bcde"
    String.slice ~from:5 ~to_:2 "abcdefg" = ""
    ]}

  *)

  val trim : string -> string
  (**
    [String.trim s] returns a new string with
    leading and trailing whitespace (blank, tab, newline,non-breaking
    space and others as described in <https://www.ecma-international.org/ecma-262/5.1/#sec-7.2>)
    removed from [s].

    {[
    String.trim "  abc  " = "abc"
    String.trim "  abc def  " = "abc def"
    String.trim {js|\n\u00a0 \t abc \f\r \t|js} = "abc"
    ]}
  *)

  val insertAt : insert:string -> index:int -> string -> string
  (**
    Same as {!String.insert_at}.
  *)

  val insert_at : insert:string -> index:int -> string -> string
  (**
    [String.insert_at ~insert:ins, ~index:n, s)] returns a new string with the value [ins]
    inserted at position [n] in [s]. If [n] is less than zero, the position is evaluated as
    [(length s) - (n + 1)]. [n] is pinned to the range [0..length s].

    {[
    String.insert_at ~insert:"**" ~index:2 "abcde" = "ab**cde"
    String.insert_at ~insert:"**" ~index:0 "abcde" = "**abcde"
    String.insert_at ~insert:"**" ~index:5 "abcde" = "abcde**"
    String.insert_at ~insert:"**" ~index:(-2) "abcde" = "abc**de"
    String.insert_at ~insert:"**" ~index:(-9) "abcde" = "**abcde"
    String.insert_at ~insert:"**" ~index:9 "abcde" = "abcde**"
    ]}
  *)
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

  val fromList : (key * 'value) list -> 'value t

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
    (Format.formatter -> 'value -> unit) -> Format.formatter -> 'value t -> unit

  val merge :
    f:(key -> 'v1 option -> 'v2 option -> 'v3 option) -> 'v1 t -> 'v2 t -> 'v3 t
end

module IntDict : sig
  type key = Belt.Map.Int.key

  type 'value t = 'value Belt.Map.Int.t

  val toList : 'a t -> (key * 'a) list

  val to_list : 'a t -> (key * 'a) list

  val empty : 'a t

  val fromList : (key * 'value) list -> 'value t

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
    (Format.formatter -> 'value -> unit) -> Format.formatter -> 'value t -> unit

  val merge :
    f:(key -> 'v1 option -> 'v2 option -> 'v3 option) -> 'v1 t -> 'v2 t -> 'v3 t
end

(** Functions for working with functions. *)
module Fun : module type of Fun
