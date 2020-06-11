(** *)

(** A {!Set} represents a collection of unique values.

    [Set] is an immutable data structure which means operations like {!Set.add} and {!Set.remove} do not modify the data structure, but return a new set with the desired changes.

    Since sets of [int]s and [string]s are so common the specialised {!Set.Int} and {!Set.String} modules are available which offer a convenient way to construct new sets.

    Custom data types can be used with sets as long as the module satisfies the {!Comparator.S} interface.

    {[
      module Point = struct
        type t = int * int
        let compare = Tuple2.compare Int.compare Int.compare
        include Comparator.Make(struct
          type nonrec t = t
          let compare = compare
        end)
      end

      let points : Set.Of(Point).t = Set.fromList (module Points) [(0, 0); (3, 4); (6, 7)]
    ]}

    See the {!Comparator} module for a more details.
*)

type ('a, 'id) t = ('a, 'id) Belt.Set.t

(** This functor lets you describe the type of Sets a little more concisely.

    {[
      let names : Set.Of(String).t =
        Set.fromList (module String) ["Andrew"; "Tina"]
    ]}

    Is the same as

    {[
      let names : (string, String.identity) Set.t =
        Set.fromList (module String) ["Andrew"; "Tina"]
    ]}
*)
module Of : functor (M : Comparator.S) -> sig
  type nonrec t = (M.t, M.identity) t
end

(** {1 Create}  
  
  You can create a Set by providing a module conform to the {!Comparator.S} signature by using {!empty}, {!singleton}, {!fromList} or {!fromArray}.

  Specialised versions of the {!empty}, {!singleton}, {!fromList} and {!fromArray} functions available in the {!Set.Int} and {!Set.String} sub-modules.
*)

val empty : ('a, 'identity) Comparator.s -> ('a, 'identity) t
(** A set with nothing in it. 

    Often used as an initial value for functions like {!Array.fold}

    {2 Examples}

    {[
      Array.fold 
        [|'m'; 'i'; 's'; 's'; 'i'; 's'; 's';'i';'p';'p';'i'|] 
        ~intial:(Set.empty (module Char))
        ~f:Set.add
      |> Set.toArray
      = [|'i'; 'm'; 'p'; 's'|] 
    ]}
*)

val singleton : ('a, 'identity) Comparator.s -> 'a -> ('a, 'identity) t
(** Create a set from a single {!Int}

  {2 Examples}

  {[Set.singleton (module Int) 7 |> Set.toList = [7]]}
*)

val fromArray : ('a, 'identity) Comparator.s -> 'a array -> ('a, 'identity) t
(** Create a set from an {!Array}

    {2 Examples}

    {[Set.fromArray (module String) [|"Ant"; "Bat"; "Bat"; "Goldfish"|] |> Set.toArray = [|"Ant";"Bat";"Goldfish"|]]}
*)

val from_array : ('a, 'identity) Comparator.s -> 'a array -> ('a, 'identity) t

val fromList : ('a, 'identity) Comparator.s -> 'a list -> ('a, 'identity) t
(** Create a set from a {!List}

    {2 Examples}

    {[Set.fromList (module Char) ['A'; 'B'; 'B'; 'G'] |> Set.toList = ['A';'B';'G']]}
*)

val from_list : ('a, 'identity) Comparator.s -> 'a list -> ('a, 'identity) t

(** {1 Basic operations} *)

val add : ('a, 'id) t -> 'a -> ('a, 'id) t
(** Insert a value into a set.

    {2 Examples}

    {[Set.add (Set.Int.fromList [1; 2]) 3 |> Set.toList = [1; 2; 3]]}

    {[Set.add (Set.Int.fromList [1; 2]) 2 |> Set.toList = [1; 2]]}
*)

val remove : ('a, 'id) t -> 'a -> ('a, 'id) t
(** Remove a value from a set, if the set doesn't contain the value anyway, returns the original set

    {2 Examples}

    {[Set.remove (Set.Int.fromList [1; 2]) 2 |> Set.toList = [1]]}

    {[
      let originalSet = Set.Int.fromList [1; 2] in
      let newSet = Set.remove orignalSet 3 in
      originalSet = newSet
    ]}
*)

val includes : ('a, _) t -> 'a -> bool
(** Determine if a value is in a set

    {2 Examples}

   {[Set.includes (Set.String.fromList ["Ant"; "Bat"; "Cat"]) "Bat" = true]}
*)

val ( .?{} ) : ('element, _) t -> 'element -> bool
(** The {{: https://caml.inria.fr/pub/docs/manual-ocaml/indexops.html } index operator} version of {!includes}

    {b Note} Currently this is only supported by the OCaml syntax.

    {2 Examples}

    {[
      let animals = Set.String.fromList ["Ant"; "Bat"; "Cat"] in

      animals.Set.?{"Emu"} = false
    ]}
 *)

val length : (_, _) t -> int
(** Determine the number of elements in a set.

    {2 Examples}

    {[Set.length (Set.Int.fromList [1; 2; 3]) = 3]}
*)

val find : ('value, _) t -> f:('value -> bool) -> 'value option
(** Returns, as an {!Option}, the first element for which [f] evaluates to [true]. If [f] doesn't return [true] for any of the elements [find] will return [None].

    {2 Examples}

    {[Set.find ~f:Int.isEven (Set.Int.fromList [1; 3; 4; 8]) = Some 4]}

    {[Set.find ~f:Int.isOdd (Set.Int.fromList [0; 2; 4; 8]) = None]}

    {[Set.find ~f:Int.isEven Set.Int.empty = None]}
*)

(** {1 Query} *)

val isEmpty : (_, _) t -> bool
(** Check if a set is empty.

    {2 Examples}

    {[Set.isEmpty (Set.Int.empty) = true]}

    {[Set.isEmpty (Set.Int.singleton 4) = false]}
*)

val is_empty : (_, _) t -> bool

val any : ('value, _) t -> f:('value -> bool) -> bool
(** Determine if [f] returns true for [any] values in a set.

    {2 Examples}

    {[Set.any (Set.Int.fromArray [|2;3|]) ~f:Int.isEven = true]}

    {[Set.any (Set.Int.fromList [1;3]) ~f:Int.isEven = false]}

    {[Set.any (Set.Int.fromList []) ~f:Int.isEven = false]}
*)

val all : ('value, _) t -> f:('value -> bool) -> bool
(** Determine if [f] returns true for [all] values in a set.

    {2 Examples}

    {[Set.all ~f:Int.isEven (Set.Int.fromArray [|2;4|]) = true]}

    {[Set.all ~f:Int.isEven (Set.Int.fromLis [2;3]) = false]}

    {[Set.all ~f:Int.isEven Set.Int.empty = true]}
*)

(** {1 Combine} *)

val difference : ('a, 'id) t -> ('a, 'id) t -> ('a, 'id) t
(** Returns a new set with the values from the first set which are not in the second set.

    {2 Examples}

    {[Set.difference (Set.Int.fromList [1;2;5]) (Set.Int.fromList [2;3;4]) |> Set.toList = [1;5]]}

    {[Set.difference (Set.Int.fromList [2;3;4]) (Set.Int.fromList [1;2;5]) |> Set.toList = [3;4]]}
*)

val intersection : ('a, 'id) t -> ('a, 'id) t -> ('a, 'id) t
(** Get the intersection of two sets. Keeps values that appear in both sets.

    {2 Examples}

    {[Set.intersection (Set.Int.fromList [1;2;5]) (Set.Int.fromList [2;3;4]) |> Set.toList= [2]]}
*)

val union : ('a, 'id) t -> ('a, 'id) t -> ('a, 'id) t
(** Get the union of two sets. Keep all values.

    {2 Examples}

    {[Set.union (Set.Int.fromList [1;2;5]) (Set.Int.fromList [2;3;4]) |> Set.toList = [1;2;3;4;5]]}
*)

(** {1 Transform} *)

val filter : ('a, 'id) t -> f:('a -> bool) -> ('a, 'id) t
(** Keep elements that [f] returns [true] for.

    {2 Examples}

    {[Set.filter (Set.Int.fromList [1;2;3]) ~f:Int.isEven |> Set.toList = [2]]}
*)

val partition : ('a, 'id) t -> f:('a -> bool) -> ('a, 'id) t * ('a, 'id) t
(** Divide a set into two according to [f]. The first set will contain the values that [f] returns [true] for, values that [f] returns [false] for will end up in the second.

    {2 Examples}

    {[
      let numbers = Set.Int.fromList [1; 1; 5; 6; 5; 7; 9; 8] in
      let (evens, odds) = Set.partition numbers ~f:Int.isEven in
      Set.toList evens = [6; 8]
      Set.toList odds = [1; 5; 7; 9]
    ]}
*)

val fold : ('a, _) t -> initial:'b -> f:('b -> 'a -> 'b) -> 'b
(** Transform a set into a value which is result of running each element in the set through [f], where each successive invocation is supplied the return value of the previous.

  See {!Array.fold} for a more in-depth explanation.

  {2 Examples}

  {[Set.fold ~f:( * ) ~initial:1 (Set.Int.fromList [1;2;3;4]) = 24]}
*)

val forEach : ('a, _) t -> f:('a -> unit) -> unit
(** Runs a function [f] against each element of the set. *)

val for_each : ('a, _) t -> f:('a -> unit) -> unit

(** {1 Convert} *)

val toArray : ('a, _) t -> 'a array
(** Converts a set into an {!Array} *)

val to_array : ('a, _) t -> 'a array

val toList : ('a, _) t -> 'a list
(** Converts a set into a {!List}. *)

val to_list : ('a, _) t -> 'a list

(** Construct sets which can hold any data type using the polymorphic [compare] function. *)
module Poly : sig
  type identity

  type nonrec 'a t = ('a, identity) t

  val empty : unit -> 'a t
  (** The empty set.

      A great starting point.
   *)

  val singleton : 'a -> 'a t
  (** Create a set of a single value

      {2 Examples}

      {[Set.Int.singleton (5, "Emu") |> Set.toList = [(5, "Emu")]]}
  *)

  val fromArray : 'a array -> 'a t
  (** Create a set from an {!Array}

      {2 Examples}

      {[Set.Poly.fromArray [(1, "Ant");(2, "Bat");(2, "Bat")] |> Set.toList = [(1, "Ant"); (2, "Bat")]]}
  *)

  val from_array : 'a array -> 'a t

  val fromList : 'a list -> 'a t
  (** Create a set from a {!List}

    {2 Examples}

    {[Set.Poly.fromList [(1, "Ant");(2, "Bat");(2, "Bat")] |> Set.toList = [(1, "Ant"); (2, "Bat")]]}
  *)

  val from_list : 'a list -> 'a t
end

(** Construct sets of {!Int}s *)
module Int : sig
  type nonrec t = Of(Int).t

  val empty : t
  (** A set with nothing in it. *)

  val singleton : int -> t
  (** Create a set from a single {!Int}

    {2 Examples}

    {[Set.Int.singleton 5 |> Set.toList = [5]]}
  *)

  val fromArray : int array -> t
  (** Create a set from an {!Array}

      {2 Examples}

      {[Set.Int.fromArray [|1;2;3;3;2;1;7|] |> Set.toArray = [|1;2;3;7|]]}
  *)

  val from_array : int array -> t

  val fromList : int list -> t
  (** Create a set from a {!List}

      {2 Examples}

      {[Set.Int.fromList [1;2;3;3;2;1;7] |> Set.toList = [1;2;3;7]]}
  *)

  val from_list : int list -> t
end

(** Construct sets of {!String}s *)
module String : sig
  type nonrec t = Of(TableclothString).t

  val empty : t
  (** A set with nothing in it. *)

  val singleton : string -> t
  (** Create a set of a single {!String}

      {2 Examples}

      {[Set.String.singleton "Bat" |> Set.toList = ["Bat"]]}
  *)

  val fromArray : string array -> t
  (** Create a set from an {!Array}

      {2 Examples}

      {[Set.String.fromArray [|"a";"b";"g";"b";"g";"a";"a"|] |> Set.toArray = [|"a";"b";"g"|]]}
  *)

  val from_array : string array -> t

  val fromList : string list -> t
  (** Create a set from a {!List}

      {2 Examples}

      {[Set.String.fromList [|"a";"b";"g";"b";"g";"a";"a"|] |> Set.toList = ["a";"b";"g"]]}
  *)

  val from_list : string list -> t
end
