(** Construct sets of {!String}s *)

type nonrec t = Belt.Set.String.t

(** {1 Create}

  You can create a Set by providing a module conform to the {!Comparator.S} signature by using {!empty}, {!singleton}, {!fromList} or {!fromArray}.

  Specialised versions of the {!empty}, {!singleton}, {!fromList} and {!fromArray} functions available in the {!Set.String} and {!Set.String} sub-modules.
*)

val empty : t
(** A set with nothing in it.  *)

val singleton : string -> t
(** Create a set from a single {!Int}

  {2 Examples}

  {[Set.String.singleton 5 |> Set.toList = [5]]}
*)

val fromArray : string array -> t
(** Create a set from an {!Array}

    {2 Examples}

    {[Set.fromArray [|"Ant"; "Bat"; "Bat"; "Goldfish"|] |> Set.toArray = [|"Ant";"Bat";"Goldfish"|]]}
*)

val from_array : string array -> t

val fromList : string list -> t
(** Create a set from a {!List}

    {2 Examples}

    {[Set.String.fromList [1;2;3;3;2;1;7] |> Set.toList = [1;2;3;7]]}
*)

val from_list : string list -> t

(** {1 Basic operations} *)

val add : t -> string -> t
(** Insert a value into a set.

    {2 Examples}

    {[Set.add (Set.String.fromList [1; 2]) 3 |> Set.String.toList = [1; 2; 3]]}

    {[Set.add (Set.String.fromList [1; 2]) 2 |> Set.String.toList = [1; 2]]}
*)

val remove : t -> string -> t
(** Remove a value from a set, if the set doesn't contain the value anyway, returns the original set

    {2 Examples}

    {[Set.remove (Set.String.fromList [1; 2]) 2 |> Set.String.toList = [1]]}

    {[
      let originalSet = Set.String.fromList [1; 2] in
      let newSet = Set.String.remove orignalSet 3 in
      originalSet = newSet
    ]}
*)

val includes : t -> string -> bool
(** Determine if a value is in a set

    {2 Examples}

    {[Set.String.includes (Set.String.fromList [1; 2; 3]) 3 = true]}
*)

val ( .?{} ) : t -> string -> bool
(** The {{: https://caml.inria.fr/pub/docs/manual-ocaml/indexops.html } index operator} version of {!includes}

    {b Note} Currently this is only supported by the OCaml syntax.

    {2 Examples}

    {[
let animals = Set.String.fromList [1; 2; 3] in

      animals.Set.String.?{3} = false
    ]}
 *)

val length : t -> int
(** Determine the number of elements in a set.

    {2 Examples}

    {[Set.String.length (Set.String.fromList [1; 2; 3]) = 3]}
*)

val find : t -> f:(string -> bool) -> string option
(** Returns, as an {!Option}, the first element for which [f] evaluates to [true]. If [f] doesn't return [true] for any of the elements [find] will return [None].

    {2 Examples}

    {[Set.String.find ~f:Int.isEven (Set.String.fromList [1; 3; 4; 8]) = Some 4]}

    {[Set.String.find ~f:Int.isOdd (Set.String.fromList [0; 2; 4; 8]) = None]}

    {[Set.String.find ~f:Int.isEven Set.String.empty = None]}
*)

(** {1 Query} *)

val isEmpty : t -> bool
(** Check if a set is empty.

    {2 Examples}

    {[Set.String.isEmpty (Set.String.empty) = true]}

    {[Set.String.isEmpty (Set.String.singleton 4) = false]}
*)

val is_empty : t -> bool

val any : t -> f:(string -> bool) -> bool
(** Determine if [f] returns true for [any] values in a set.

    {2 Examples}

    {[Set.String.any (Set.String.fromArray [|2;3|]) ~f:Int.isEven = true]}

    {[Set.String.any (Set.String.fromList [1;3]) ~f:Int.isEven = false]}

    {[Set.String.any (Set.String.fromList []) ~f:Int.isEven = false]}
*)

val all : t -> f:(string -> bool) -> bool
(** Determine if [f] returns true for [all] values in a set.

    {2 Examples}

    {[Set.String.all ~f:Int.isEven (Set.String.fromArray [|2;4|]) = true]}

    {[Set.String.all ~f:Int.isEven (Set.String.fromLis [2;3]) = false]}

    {[Set.String.all ~f:Int.isEven Set.String.empty = true]}
*)

(** {1 Combine} *)

val difference : t -> t -> t
(** Returns a new set with the values from the first set which are not in the second set.

    {2 Examples}

    {[Set.String.difference (Set.String.fromList [1;2;5]) (Set.String.fromList [2;3;4]) |> Set.String.toList = [1;5]]}

    {[Set.String.difference (Set.String.fromList [2;3;4]) (Set.String.fromList [1;2;5]) |> Set.String.toList = [3;4]]}
*)

val intersection : t -> t -> t
(** Get the intersection of two sets. Keeps values that appear in both sets.

    {2 Examples}

    {[Set.String.intersection (Set.String.fromList [1;2;5]) (Set.String.fromList [2;3;4]) |> Set.String.toList= [2]]}
*)

val union : t -> t -> t
(** Get the union of two sets. Keep all values.

    {2 Examples}

    {[Set.String.union (Set.String.fromList [1;2;5]) (Set.String.fromList [2;3;4]) |> Set.String.toList = [1;2;3;4;5]]}
*)

(** {1 Transform} *)

val filter : t -> f:(string -> bool) -> t
(** Keep elements that [f] returns [true] for.

    {2 Examples}

    {[Set.String.filter (Set.String.fromList [1;2;3]) ~f:Int.isEven |> Set.String.toList = [2]]}
*)

val partition : t -> f:(string -> bool) -> t * t
(** Divide a set into two according to [f]. The first set will contain the values that [f] returns [true] for, values that [f] returns [false] for will end up in the second.

    {2 Examples}

    {[
      let numbers = Set.String.fromList [1; 1; 5; 6; 5; 7; 9; 8] in
      let (evens, odds) = Set.String.partition numbers ~f:Int.isEven in
      Set.String.toList evens = [6; 8]
      Set.String.toList odds = [1; 5; 7; 9]
    ]}
*)

val fold : t -> initial:'b -> f:('b -> string -> 'b) -> 'b
(** Transform a set into a value which is result of running each element in the set through [f], where each successive invocation is supplied the return value of the previous.

  See {!Array.fold} for a more in-depth explanation.

  {2 Examples}

  {[Set.String.fold ~f:( * ) ~initial:1 (Set.String.fromList [1;2;3;4]) = 24]}
*)

val forEach : t -> f:(string -> unit) -> unit
(** Runs a function [f] against each element of the set. *)

val for_each : t -> f:(string -> unit) -> unit

(** {1 Convert} *)

val toArray : t -> string array
(** Converts a set into an {!Array} *)

val to_array : t -> string array

val toList : t -> string list
(** Converts a set into a {!List}. *)

val to_list : t -> string list
