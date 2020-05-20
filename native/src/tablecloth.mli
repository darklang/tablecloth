(**  *)

(** Functions for working with boolean ([true] or [false]) values. *)
module Bool : module type of Bool

(** Functions for working with single characters. *)
module Char : module type of TableclothChar

module String : module type of TableclothString

(** Fixed precision integers *)
module Int : module type of Int

(** Functions for working with floating point numbers. *)
module Float : module type of Float

module Array : sig
  (** A mutable vector of elements which must have the same type with O(1) {!get} and {!set} operations.

   You can create an [array] in OCaml with the [[|1; 2; 3|]] syntax. *)

  type 'a t = 'a array

  val empty : unit -> 'a array
  (** An empty array.

    {[Array.empty () = [||]]}

    {[Array.length (Array.empty ()) = 0]} *)

  val singleton : 'a -> 'a array
  (** Create an array with only one element.

    {[Array.singleton 1234 = [|1234|]]}

    {[Array.singleton "hi" = [|"hi"|]]} *)

  val length : 'a array -> int
  (** Return the length of an array.

    {[Array.length [|1; 2, 3|] = 3]}

    {[Array.length [||] = 0]} *)

  val isEmpty : 'a array -> bool
  (** Determine if an array is empty.

    {[Array.isEmpty Array.empty = true]}

    {[Array.isEmpty [||] = true]}

    {[Array.isEmpty [|1; 2; 3|] = false]} *)

  val is_empty : 'a array -> bool

  val initialize : length:int -> f:(int -> 'a) -> 'a array
  (** Initialize an array. [Array.initialize ~length:n ~f] creates an array of length [n] with
    the element at index [i] initialized to the result of [(f i)].

    {[Array.initialize ~length:4 ~f:identity = [|0; 1; 2; 3|]]}

    {[Array.initialize ~length:4 ~f:(fun n -> n * n) = [|0; 1; 4; 9|]]} *)

  val repeat : length:int -> 'a -> 'a array
  (** Creates an array of length [length] with the value [x] populated at each index.

    {[repeat ~length:5 'a' = [|'a'; 'a'; 'a'; 'a'; 'a'|]]}

    {[repeat ~length:0 7 = [||]]}

    {[repeat ~length:(-1) "Why?" = [||]]} *)

  val range : ?from:int -> int -> int array
  (** Creates an array containing all of the integers from [from] if it is provided or [0] if not, up to but not including [to]

    {[Array.range 5 = [|0; 1; 2; 3; 4|] ]}

    {[Array.range ~from: 2 5 = [|2; 3; 4|] ]}

    {[Array.range ~from:(-2) 3 = [|-2; -1; 0; 1; 2|] ]} *)

  val fromList : 'a list -> 'a array
  (** Create an array from a {!List}.

    {[Array.fromList [1;2;3] = [|1;2;3|]]} *)

  val from_list : 'a list -> 'a array

  val toList : 'a array -> 'a list
  (** Create a {!List} of elements from an array.

    {[Array.toList [|1;2;3|] = [1;2;3]]}

    {[Array.toList (Array.fromList [3; 5; 8]) = [3; 5; 8]]} *)

  val to_list : 'a array -> 'a list

  val toIndexedList : 'a array -> (int * 'a) list
  (**  Create an indexed {!List} from an array. Each element of the array will be paired with its index as a {!Tuple2}.

    {[Array.toIndexedList [|"cat"; "dog"|] = [(0, "cat"); (1, "dog")]]} *)

  val to_indexed_list : 'a array -> (int * 'a) list

  val get : 'a array -> int -> 'a option
  (** [Array.get a n] returns, as an {!Option}, the element at index number [n] of array [a].

    The first element has index number 0.

    The last element has index number [Array.length a - 1].

    Returns [None] if [n] is outside the range [0] to [(Array.length a - 1)].

    You can also write [a.(n)] instead of [Array.get n a]

    {[Array.get [|"cat"; "dog"; "eel"|] 2 = Some "eel"]}

    {[Array.get [|0; 1; 2|] 5 = None]}

    {[Array.get [||] 0 = None]} *)

  val getAt : index:int -> 'a array -> 'a option

  val get_at : index:int -> 'a array -> 'a option

  val set : 'a array -> int -> 'a -> unit
  (** [Array.set a i x] modifies array [a] in place, replacing the element at index number [i] with [x].

    You can also write [a.(n) <- x] instead of [Array.set a i x].

    Raises [Invalid_argument "index out of bounds"] if [i] is outside the range [0] to [Array.length a - 1]. *)

  val setAt : index:int -> value:'a -> 'a array -> unit

  val set_at : index:int -> value:'a -> 'a array -> unit

  val sum : int array -> int
  (** Get the total of adding all of the integers in an array.

    {[Array.sum [|1; 2; 3|] = 6]} *)

  val floatSum : float array -> float
  (** Get the total of adding all of the floating point numbers in an array.

    {[Array.floatSum [|1.0; 2.0; 3.0|] = 6.0]} *)

  val float_sum : float array -> float

  val filter : f:('a -> bool) -> 'a array -> 'a array
  (** Keep elements that [f] returns [true] for.

    {[Array.filter ~f:Int.isEven [|1; 2; 3; 4; 5; 6|] = [|2; 4; 6|]]} *)

  val swap : 'a t -> int -> int -> unit
  (** [Array.swap array i j] swaps the value at index [i] with the value at index [j].
    {[Array.swap [|1;2;3|] 1 2 = [|1;3;2|]]}
  *)

  val map : f:('a -> 'b) -> 'a array -> 'b array
  (** Create a new array which is the result of applying a function [f] to every element.

    {[Array.map ~f:sqrt [|1.0; 4.0; 9.0|] = [|1.0; 2.0; 3.0|]]} *)

  val mapWithIndex : f:(int -> 'a -> 'b) -> 'a array -> 'b array
  (** Apply a function [f] to every element with its index as the first argument.

   {[Array.mapWithIndex ~f:( * ) [|5; 5; 5|] = [|0; 5; 10|]]} *)

  val map_with_index : f:(int -> 'a -> 'b) -> 'a array -> 'b array

  val map2 : f:('a -> 'b -> 'c) -> 'a array -> 'b array -> 'c array
  (** Combine two arrays, using [f] to combine each pair of elements.
    If one array is longer, the extra elements are dropped.

    {[let totals (xs : int array) (ys : int array) : int array =
Array.map2 ~f:(+) xs ys in

totals [|1;2;3|] [|4;5;6|] = [|5;7;9|]

Array.map2
  ~f:Tuple2.create
  [|"alice"; "bob"; "chuck"|]
  [|2; 5; 7; 8|] =
    [|("alice",2); ("bob",5); ("chuck",7)|] ]} *)

  val map3 :
    f:('a -> 'b -> 'c -> 'd) -> 'a array -> 'b array -> 'c array -> 'd array
  (** Combine three arrays, using [f] to combine each {!Tuple3} of elements.
    If one array is longer, the extra elements are dropped.

    {[
  Array.map3
    ~f:Tuple3.create
    [|"alice"; "bob"; "chuck"|]
    [|2; 5; 7; 8;|]
    [|true; false; true; false|] =
      [|("alice", 2, true); ("bob", 5, false); ("chuck", 7, true)|]
    ]} *)

  val flatMap : f:('a -> 'b array) -> 'a array -> 'b array
  (** Apply a function [f] onto an array and flatten the resulting array of arrays.

    {[Array.flatMap ~f xs = Array.map ~f xs |> Array.flatten]}

    {[Array.flatMap ~f:(fun n -> [|n; n|]) [|1; 2; 3|] = [|1; 1; 2; 2; 3; 3|]]} *)

  val flat_map : f:('a -> 'b array) -> 'a array -> 'b array

  val find : 'a array -> f:('a -> bool) -> 'a option
  (** Returns as an option the first element for which f evaluates to true. If [f] doesn't return [true] for any of the elements [find] will return [None]
    {[Array.find ~f:Int.isEven [|1; 3; 4; 8;|] = Some 4]}

    {[Array.find ~f:Int.isOdd [|0; 2; 4; 8;|] = None]}

    {[Array.find ~f:Int.isEven [||] = None]} *)

  val findIndex : 'a array -> f:(int -> 'a -> bool) -> (int * 'a) option
  (** Similar to {!Array.find} but [f] is also called with the current index, and the return value will be a tuple of the index the passing value was found at and the passing value.
    {[Array.findIndex ~f:(fun index number -> index > 2 && Int.isEven number) [|1; 3; 4; 8;|] = Some (3, 8)]}
  *)

  val find_index : 'a array -> f:(int -> 'a -> bool) -> (int * 'a) option

  val any : f:('a -> bool) -> 'a array -> bool
  (**  Determine if [f] returns true for [any] values in an array.

    {[Array.any ~f:isEven [|2;3|] = true]}

    {[Array.any ~f:isEven [|1;3|] = false]}

    {[Array.any ~f:isEven [||] = false]} *)

  val all : f:('a -> bool) -> 'a array -> bool
  (** Determine if [f] returns true for [all] values in an array.

    {[Array.all ~f:Int.isEven [|2;4|] = true]}

    {[Array.all ~f:Int.isEven [|2;3|] = false]}

    {[Array.all ~f:Int.isEven [||] = true]} *)

  val append : 'a array -> 'a array -> 'a array
  (** Creates a new array which is the result of appending the second array onto the end of the first.

    {[let fortyTwos = Array.repeat ~length:2 42 in
let eightyOnes = Array.repeat ~length:3 81 in
Array.append fourtyTwos eightyOnes = [|42; 42; 81; 81; 81|];]} *)

  val concatenate : 'a array array -> 'a array
  (** Concatenate an array of arrays into a single array:

    {[Array.concatenate [|[|1; 2|]; [|3|]; [|4; 5|]|] = [|1; 2; 3; 4; 5|]]} *)

  val intersperse : sep:'a -> 'a array -> 'a array
  (** Places [sep] between all elements of the given array.

    {[Array.intersperse ~sep:"on" [|"turtles"; "turtles"; "turtles"|] = [|"turtles"; "on"; "turtles"; "on"; "turtles"|]]}

    {[Array.intersperse ~sep:0 [||] = [||]]} *)

  val slice : from:int -> ?to_:int -> 'a array -> 'a array
  (** Get a sub-section of an array. [from] is a zero-based index where we will start our slice.
    The [to_] is a zero-based index that indicates the end of the slice.

    The slice extracts up to but not including [to_].

    {[Array.slice ~from:0  ~to_:3 [|0; 1; 2; 3; 4|] = [|0; 1; 2|]]}

    {[Array.slice ~from:1  ~to_:4 [|0; 1; 2; 3; 4|] = [|1; 2; 3|]]}

    {[Array.slice ~from:5  ~to_:3 [|0; 1; 2; 3; 4|] = [||]]}

    Both the [from] and [to_] indexes can be negative, indicating an offset from the end of the array.

    {[Array.slice  ~from:1 ~to_:(-1) [|0; 1; 2; 3; 4|] = [|1; 2; 3|]]}

    {[Array.slice ~from:(-2)  ~to_:5 [|0; 1; 2; 3; 4|] = [|3; 4|]]}

    {[Array.slice ~from:(-2)  ~to_:(-1) [|0; 1; 2; 3; 4|] = [|3|]]} *)

  val sliding : ?step:int -> 'a t -> size:int -> 'a t t
  (** Provides a sliding 'window' of sub-arrays over an array.

    The first sub-array starts at index [0] of the array and takes the first [size] elements.

    The sub-array then advances the index [step] (which defaults to 1) positions before taking the next [size] elements.

    The sub-arrays are guaranteed to always be of length [size] and iteration stops once a sub-array would extend beyond the end of the array.

    {[Array.sliding [|1;2;3;4;5|] ~size:1 = [|[|1|]; [|2|]; [|3|]; [|4|]; [|5|]|] ]}

    {[Array.sliding [|1;2;3;4;5|] ~size:2 = [|[|1;2|]; [|2;3|]; [|3;4|]; [|4;5|]|] ]}

    {[Array.sliding [|1;2;3;4;5|] ~size:3 = [|[|1;2;3|]; [|2;3;4|]; [|3;4;5|]|] ]}

    {[Array.sliding [|1;2;3;4;5|] ~size:2 ~step:2 = [|[|1;2|]; [|3;4|]|] ]}

    {[Array.sliding [|1;2;3;4;5|] ~size:1 ~step:3 = [|[|1|]; [|4|]|] ]}
  *)

  val foldLeft : f:('a -> 'b -> 'b) -> initial:'b -> 'a array -> 'b
  (** Reduces collection to a value which is the accumulated result of running each element in the array through [f],
      where each successive invocation is supplied the return value of the previous.

    Read [foldLeft] as 'fold from the left'.

    {[Array.foldLeft ~f:( * ) ~initial:1 (Array.repeat ~length:4 7) = 2401]}

    {[Array.foldLeft ~f:((fun element list -> element :: list)) ~initial:[] [|1; 2; 3|] = [3; 2; 1]]} *)

  val fold_left : f:('a -> 'b -> 'b) -> initial:'b -> 'a array -> 'b

  val foldRight : f:('a -> 'b -> 'b) -> initial:'b -> 'a array -> 'b
  (** This method is like [foldLeft] except that it iterates over the elements of the array from right to left.

    {[Array.foldRight ~f:(+) ~initial:0 (Array.repeat ~length:3 5) = 15]}

    {[Array.foldRight ~f:(fun element list -> element :: list) ~initial:[] [|1; 2; 3|] = [1; 2; 3]]} *)

  val fold_right : f:('a -> 'b -> 'b) -> initial:'b -> 'a array -> 'b

  val reverse : 'a array -> 'a array
  (** Create a new reversed array leaving the original untouched

  {[let numbers = [|1; 2; 3|] in
Array.reverse numbers = [|3; 2; 1|];
numbers = [|1; 2; 3|]; ]} *)

  val reverseInPlace : 'a array -> unit
  (** Reverses array so that the first element becomes the last, the second element becomes the second to last, and so on.

  {[let numbers = [|1; 2; 3|] in
Array.reverseInPlace numbers;
numbers = [|3; 2; 1|]]} *)

  val reverse_in_place : 'a array -> unit

  val forEach : f:('a -> unit) -> 'a array -> unit
  (** Iterates over the elements of invokes [f] for each element.

    {[Array.forEach [|1; 2; 3|] ~f:(fun int -> print (Int.toString int))]} *)

  val for_each : f:('a -> unit) -> 'a array -> unit
end

module List : sig
  type 'a t = 'a list

  val concat : 'a list list -> 'a list

  val sum : int list -> int

  val floatSum : float list -> float

  val float_sum : float list -> float

  val map : f:('a -> 'b) -> 'a list -> 'b list

  val sliding : ?step:int -> 'a t -> size:int -> 'a t t
  (** Provides a sliding 'window' of sub-lists over a list.

    The first sub-list starts at the head of the list and takes the first [size] elements.

    The sub-list then advances [step] (which defaults to 1) positions before taking the next [size] elements.

    The sub-lists are guaranteed to always be of length [size] and iteration stops once a sub-list would extend beyond the end of the list.

    {[List.sliding [1;2;3;4;5] ~size:1 = [[1]; [2]; [3]; [4]; [5]] ]}

    {[List.sliding [1;2;3;4;5] ~size:2 = [[1;2]; [2;3]; [3;4]; [4;5]] ]}

    {[List.sliding [1;2;3;4;5] ~size:3 = [[1;2;3]; [2;3;4]; [3;4;5]] ]}

    {[List.sliding [1;2;3;4;5] ~size:2 ~step:2 = [[1;2]; [3;4]] ]}

    {[List.sliding [1;2;3;4;5] ~size:1 ~step:3 = [[1]; [4]] ]}

    {[List.sliding [1;2;3;4;5] ~size:2 ~step:3 = [[1; 2]; [4; 5]]]}

    {[List.sliding [1;2;3;4;5] ~size:7 = []]}
  *)

  val indexedMap : f:(int -> 'a -> 'b) -> 'a list -> 'b list

  val indexed_map : f:(int -> 'a -> 'b) -> 'a list -> 'b list

  val mapi : f:(int -> 'a -> 'b) -> 'a list -> 'b list

  val map2 : f:('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list

  val getBy : f:('a -> bool) -> 'a list -> 'a option

  val get_by : f:('a -> bool) -> 'a list -> 'a option

  val find : f:('a -> bool) -> 'a list -> 'a option

  val elemIndex : value:'a -> 'a list -> int option

  val elem_index : value:'a -> 'a list -> int option

  val last : 'a list -> 'a option

  val member : value:'a -> 'a list -> bool

  val uniqueBy : f:('a -> string) -> 'a list -> 'a list

  val unique_by : f:('a -> string) -> 'a list -> 'a list

  val getAt : index:int -> 'a list -> 'a option

  val get_at : index:int -> 'a list -> 'a option

  val any : f:('a -> bool) -> 'a list -> bool

  val head : 'a list -> 'a option

  val drop : count:int -> 'a list -> 'a list

  val init : 'a list -> 'a list option

  val filterMap : f:('a -> 'b option) -> 'a list -> 'b list

  val filter_map : f:('a -> 'b option) -> 'a list -> 'b list

  val filter : f:('a -> bool) -> 'a list -> 'a list

  val partition : f:('a -> bool) -> 'a list -> 'a list * 'a list

  val foldRight : f:('a -> 'b -> 'b) -> initial:'b -> 'a list -> 'b

  val fold_right : f:('a -> 'b -> 'b) -> initial:'b -> 'a list -> 'b

  val foldLeft : f:('a -> 'b -> 'b) -> initial:'b -> 'a list -> 'b

  val fold_left : f:('a -> 'b -> 'b) -> initial:'b -> 'a list -> 'b

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

  val minimum : 'comparable list -> 'comparable option

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

  val splitWhen : f:('a -> bool) -> 'a list -> 'a list * 'a list

  val split_when : f:('a -> bool) -> 'a list -> 'a list * 'a list

  val intersperse : 'a -> 'a list -> 'a list

  val initialize : int -> (int -> 'a) -> 'a list

  val sortWith : ('a -> 'a -> int) -> 'a list -> 'a list

  val sort_with : ('a -> 'a -> int) -> 'a list -> 'a list

  val iter : f:('a -> unit) -> 'a list -> unit

  val forEachWithIndex : 'a list -> f:(int -> 'a -> unit) -> unit

  val repeat : count:int -> 'a -> 'a list
  (**
    [List.repeat ~count=n v] returns a list with the value [v] repeated [n] times.

    {[
    List.repeat ~count:3 99 = [99; 99; 99]
    List.repeat ~count:0 99 = []
    ]}
  *)
end

module Result : sig
  type ('err, 'ok) t = ('ok, 'err) Base.Result.t

  val succeed : 'ok -> ('err, 'ok) t

  val fail : 'err -> ('err, 'ok) t

  val withDefault : default:'ok -> ('err, 'ok) t -> 'ok

  val with_default : default:'ok -> ('err, 'ok) t -> 'ok

  val map2 : f:('a -> 'b -> 'c) -> ('err, 'a) t -> ('err, 'b) t -> ('err, 'c) t

  val combine : ('x, 'a) t list -> ('x, 'a list) t

  val map : f:('ok -> 'value) -> ('err, 'ok) t -> ('err, 'value) t

  val fromOption : error:'err -> 'ok option -> ('err, 'ok) t

  val from_option : error:'err -> 'ok option -> ('err, 'ok) t

  val toOption : ('err, 'ok) t -> 'ok option

  val to_option : ('err, 'ok) t -> 'ok option

  val andThen : f:('ok -> ('err, 'value) t) -> ('err, 'ok) t -> ('err, 'value) t

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

  val some : 'a -> 'a option

  val andThen : f:('a -> 'b option) -> 'a option -> 'b option

  val and_then : f:('a -> 'b option) -> 'a option -> 'b option

  val or_ : 'a option -> 'a option -> 'a option

  val orElse : 'a option -> 'a option -> 'a option

  val or_else : 'a option -> 'a option -> 'a option

  val map : f:('a -> 'b) -> 'a option -> 'b option

  val withDefault : default:'a -> 'a option -> 'a

  val with_default : default:'a -> 'a option -> 'a

  val values : 'a option list -> 'a list

  val toList : 'a option -> 'a list

  val to_list : 'a option -> 'a list

  val isSome : 'a option -> bool

  val is_some : 'a option -> bool

  val toOption : sentinel:'a -> 'a -> 'a option

  val to_option : sentinel:'a -> 'a -> 'a option

  val getExn : 'a option -> 'a
  (**
    Same as {!Option.get_exn}
  *)

  val get_exn : 'a option -> 'a
  (** [get_exn optional_value]
    Returns [value] if [optional_value] is [Some value], otherwise raises [Invalid_argument]

    {[
      get_exn (Some 3) = 3;;
      get_exn None (* Raises Invalid_argument error *)
    ]}
  *)
end

module Tuple : module type of Tuple

module Tuple3 : module type of Tuple3

module IntSet : sig
  type t = Base.Set.M(Base.Int).t

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
  type t = Base.Set.M(Base.String).t

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
  type key = string

  type 'value t = 'value Base.Map.M(Base.String).t

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

  val pp :
    (Format.formatter -> 'value -> unit) -> Format.formatter -> 'value t -> unit

  val merge :
    f:(key -> 'v1 option -> 'v2 option -> 'v3 option) -> 'v1 t -> 'v2 t -> 'v3 t
end

module IntDict : sig
  type key = int

  type 'value t = 'value Base.Map.M(Base.Int).t

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

  val pp :
    (Format.formatter -> 'value -> unit) -> Format.formatter -> 'value t -> unit

  val merge :
    f:(key -> 'v1 option -> 'v2 option -> 'v3 option) -> 'v1 t -> 'v2 t -> 'v3 t
end

(** Functions for working with functions. *)
module Fun : module type of Fun
