(** Construct sets of {!Int}s *)

type nonrec t = Belt.Set.Int.t

(** {1 Create}

  You can create a Set by providing a module conform to the {!Comparator.S} signature by using {!empty}, {!singleton}, {!fromList} or {!fromArray}.

  Specialised versions of the {!empty}, {!singleton}, {!fromList} and {!fromArray} functions available in the {!Set.Int} and {!Set.String} sub-modules.
*)

val empty : t
(** A set with nothing in it.  *)

val singleton : int -> t
(** Create a set from a single {!Int}

  {2 Examples}

  {[Set.Int.singleton 5 |> Set.toList = [5]]}
*)

val fromArray : int array -> t
(** Create a set from an {!Array}

    {2 Examples}

    {[Set.fromArray [|"Ant"; "Bat"; "Bat"; "Goldfish"|] |> Set.toArray = [|"Ant";"Bat";"Goldfish"|]]}
*)

val from_array : int array -> t

val fromList : int list -> t
(** Create a set from a {!List}

    {2 Examples}

    {[Set.Int.fromList [1;2;3;3;2;1;7] |> Set.toList = [1;2;3;7]]}
*)

val from_list : int list -> t

(** {1 Basic operations} *)

val add : t -> int -> t
(** Insert a value into a set.

    {2 Examples}

    {[Set.add (Set.Int.fromList [1; 2]) 3 |> Set.Int.toList = [1; 2; 3]]}

    {[Set.add (Set.Int.fromList [1; 2]) 2 |> Set.Int.toList = [1; 2]]}
*)

val remove : t -> int -> t
(** Remove a value from a set, if the set doesn't contain the value anyway, returns the original set

    {2 Examples}

    {[Set.remove (Set.Int.fromList [1; 2]) 2 |> Set.Int.toList = [1]]}

    {[
      let originalSet = Set.Int.fromList [1; 2] in
      let newSet = Set.Int.remove orignalSet 3 in
      originalSet = newSet
    ]}
*)

val includes : t -> int -> bool
(** Determine if a value is in a set

    {2 Examples}

    {[Set.Int.includes (Set.Int.fromList [1; 2; 3]) 3 = true]}
*)

val ( .?{} ) : t -> int -> bool
(** The {{: https://caml.inria.fr/pub/docs/manual-ocaml/indexops.html } index operator} version of {!includes}

    {b Note} Currently this is only supported by the OCaml syntax.

    {2 Examples}

    {[
let animals = Set.Int.fromList [1; 2; 3] in

      animals.Set.Int.?{3} = false
    ]}
 *)

val length : t -> int
(** Determine the number of elements in a set.

    {2 Examples}

    {[Set.Int.length (Set.Int.fromList [1; 2; 3]) = 3]}
*)

val find : t -> f:(int -> bool) -> int option
(** Returns, as an {!Option}, the first element for which [f] evaluates to [true]. If [f] doesn't return [true] for any of the elements [find] will return [None].

    {2 Examples}

    {[Set.Int.find ~f:Int.isEven (Set.Int.fromList [1; 3; 4; 8]) = Some 4]}

    {[Set.Int.find ~f:Int.isOdd (Set.Int.fromList [0; 2; 4; 8]) = None]}

    {[Set.Int.find ~f:Int.isEven Set.Int.empty = None]}
*)

(** {1 Query} *)

val isEmpty : t -> bool
(** Check if a set is empty.

    {2 Examples}

    {[Set.Int.isEmpty (Set.Int.empty) = true]}

    {[Set.Int.isEmpty (Set.Int.singleton 4) = false]}
*)

val is_empty : t -> bool

val any : t -> f:(int -> bool) -> bool
(** Determine if [f] returns true for [any] values in a set.

    {2 Examples}

    {[Set.Int.any (Set.Int.fromArray [|2;3|]) ~f:Int.isEven = true]}

    {[Set.Int.any (Set.Int.fromList [1;3]) ~f:Int.isEven = false]}

    {[Set.Int.any (Set.Int.fromList []) ~f:Int.isEven = false]}
*)

val all : t -> f:(int -> bool) -> bool
(** Determine if [f] returns true for [all] values in a set.

    {2 Examples}

    {[Set.Int.all ~f:Int.isEven (Set.Int.fromArray [|2;4|]) = true]}

    {[Set.Int.all ~f:Int.isEven (Set.Int.fromLis [2;3]) = false]}

    {[Set.Int.all ~f:Int.isEven Set.Int.empty = true]}
*)

(** {1 Combine} *)

val difference : t -> t -> t
(** Returns a new set with the values from the first set which are not in the second set.

    {2 Examples}

    {[Set.Int.difference (Set.Int.fromList [1;2;5]) (Set.Int.fromList [2;3;4]) |> Set.Int.toList = [1;5]]}

    {[Set.Int.difference (Set.Int.fromList [2;3;4]) (Set.Int.fromList [1;2;5]) |> Set.Int.toList = [3;4]]}
*)

val intersection : t -> t -> t
(** Get the intersection of two sets. Keeps values that appear in both sets.

    {2 Examples}

    {[Set.Int.intersection (Set.Int.fromList [1;2;5]) (Set.Int.fromList [2;3;4]) |> Set.Int.toList= [2]]}
*)

val union : t -> t -> t
(** Get the union of two sets. Keep all values.

    {2 Examples}

    {[Set.Int.union (Set.Int.fromList [1;2;5]) (Set.Int.fromList [2;3;4]) |> Set.Int.toList = [1;2;3;4;5]]}
*)

(** {1 Transform} *)

val filter : t -> f:(int -> bool) -> t
(** Keep elements that [f] returns [true] for.

    {2 Examples}

    {[Set.Int.filter (Set.Int.fromList [1;2;3]) ~f:Int.isEven |> Set.Int.toList = [2]]}
*)

val partition : t -> f:(int -> bool) -> t * t
(** Divide a set into two according to [f]. The first set will contain the values that [f] returns [true] for, values that [f] returns [false] for will end up in the second.

    {2 Examples}

    {[
      let numbers = Set.Int.fromList [1; 1; 5; 6; 5; 7; 9; 8] in
      let (evens, odds) = Set.Int.partition numbers ~f:Int.isEven in
      Set.Int.toList evens = [6; 8]
      Set.Int.toList odds = [1; 5; 7; 9]
    ]}
*)

val fold : t -> initial:'b -> f:('b -> int -> 'b) -> 'b
(** Transform a set into a value which is result of running each element in the set through [f], where each successive invocation is supplied the return value of the previous.

  See {!Array.fold} for a more in-depth explanation.

  {2 Examples}

  {[Set.Int.fold ~f:( * ) ~initial:1 (Set.Int.fromList [1;2;3;4]) = 24]}
*)

val forEach : t -> f:(int -> unit) -> unit
(** Runs a function [f] against each element of the set. *)

val for_each : t -> f:(int -> unit) -> unit

(** {1 Convert} *)

val toArray : t -> int array
(** Converts a set into an {!Array} *)

val to_array : t -> int array

val toList : t -> int list
(** Converts a set into a {!List}. *)

val to_list : t -> int list


