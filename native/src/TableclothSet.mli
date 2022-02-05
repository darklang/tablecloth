(** *)

(** A {!Set} represents a collection of unique values.

    [Set] is an immutable data structure which means operations like {!Set.add} and {!Set.remove} do not modify the data structure, but return a new set with the desired changes.

    Since sets of [int]s and [string]s are so common the specialised {!Set.Int} and {!Set.String} modules are available which offer a convenient way to construct new sets.

    Custom data types can be used with sets as long as the module satisfies the {!Comparator.S} interface.

    {[
      module Point = struct
        type t = int * int
        let compare = Tuple2.compare ~f:Int.compare ~g:Int.compare
        include Comparator.Make(struct
          type nonrec t = t
          let compare = compare
        end)
      end

      let points : Set.Of(Point).t = Set.from_list (module Point) [(0, 0); (3, 4); (6, 7)]
    ]}

    See the {!Comparator} module for a more details.
*)

type ('a, 'id) t = ('a, 'id) Base.Set.t

(** This functor lets you describe the type of Sets a little more concisely.

    {[
      let names : Set.Of(String).t =
        Set.from_list (module String) ["Andrew"; "Tina"]
    ]}

    Is the same as

    {[
      let names : (string, String.identity) Set.t =
        Set.from_list (module String) ["Andrew"; "Tina"]
    ]}
*)
module Of (M : TableclothComparator.S) : sig
  type nonrec t = (M.t, M.identity) t
end

(** {1 Create}  
  
  You can create a Set by providing a module conform to the {!Comparator.S} signature by using {!empty}, {!singleton}, {!from_list} or {!from_array}.

  Specialised versions of the {!empty}, {!singleton}, {!from_list} and {!from_array} functions available in the {!Set.Int} and {!Set.String} sub-modules.
*)

val empty : ('a, 'identity) TableclothComparator.s -> ('a, 'identity) t
(** A set with nothing in it. 

    Often used as an initial value for functions like {!Array.fold}

    {2 Examples}

    {[
      Array.fold 
        [|'m'; 'i'; 's'; 's'; 'i'; 's'; 's';'i';'p';'p';'i'|] 
        ~initial:(Set.empty (module Char))
        ~f:Set.add
      |> Set.to_array
      = [|'i'; 'm'; 'p'; 's'|] 
    ]}
*)

val singleton :
  ('a, 'identity) TableclothComparator.s -> 'a -> ('a, 'identity) t
(** Create a set from a single {!Int}.

  {2 Examples}

  {[Set.singleton (module Int) 7 |> Set.to_list = [7]]}
*)

val from_array :
  ('a, 'identity) TableclothComparator.s -> 'a array -> ('a, 'identity) t
(** Create a set from an {!Array}.

    {2 Examples}

    {[Set.from_array (module String) [|"Ant"; "Bat"; "Bat"; "Goldfish"|] |> Set.to_array = [|"Ant";"Bat";"Goldfish"|]]}
*)

val from_list :
  ('a, 'identity) TableclothComparator.s -> 'a list -> ('a, 'identity) t
(** Create a set from a {!List}.

    {2 Examples}

    {[Set.from_list (module Char) ['A'; 'B'; 'B'; 'G'] |> Set.to_list = ['A';'B';'G']]}
*)

(** {1 Basic operations} *)

val add : ('a, 'id) t -> 'a -> ('a, 'id) t
(** Insert a value into a set.

    {2 Examples}

    {[Set.add (Set.Int.from_list [1; 2]) 3 |> Set.to_list = [1; 2; 3]]}
    {[Set.add (Set.Int.from_list [1; 2]) 2 |> Set.to_list = [1; 2]]}
*)

val remove : ('a, 'id) t -> 'a -> ('a, 'id) t
(** Remove a value from a set, if the set doesn't contain the value anyway, returns the original set.

    {2 Examples}

    {[Set.remove (Set.Int.from_list [1; 2]) 2 |> Set.to_list = [1]]}
    {[
      let original_set = Set.Int.from_list [1; 2] in
      let new_set = Set.remove original_set 3 in
      original_set = new_set
    ]}
*)

val includes : ('a, _) t -> 'a -> bool
(** Determine if a value is in a set.

    {2 Examples}

   {[Set.includes (Set.String.from_list ["Ant"; "Bat"; "Cat"]) "Bat" = true]}
*)

val ( .?{} ) : ('element, _) t -> 'element -> bool
(** The {{: https://caml.inria.fr/pub/docs/manual-ocaml/indexops.html } index operator} version of {!includes}

    {b Note} Currently this is only supported by the OCaml syntax.

    {2 Examples}

    {[
      let animals = Set.String.from_list ["Ant"; "Bat"; "Cat"] in

      animals.Set.?{"Emu"} = false
    ]}
 *)

val length : (_, _) t -> int
(** Determine the number of elements in a set.

    {2 Examples}

    {[Set.length (Set.Int.from_list [1; 2; 3]) = 3]}
*)

val find : ('value, _) t -> f:('value -> bool) -> 'value option
(** Returns, as an {!Option}, the first element for which [f] evaluates to [true]. If [f] doesn't return [true] for any of the elements [find] will return [None].

    {2 Examples}

    {[Set.find ~f:Int.is_even (Set.Int.from_list [1; 3; 4; 8]) = Some 4]}
    {[Set.find ~f:Int.is_odd (Set.Int.from_list [0; 2; 4; 8]) = None]}
    {[Set.find ~f:Int.is_even Set.Int.empty = None]}
*)

(** {1 Query} *)

val is_empty : (_, _) t -> bool
(** Check if a set is empty.

    {2 Examples}

    {[Set.is_empty (Set.Int.empty) = true]}
    {[Set.is_empty (Set.Int.singleton 4) = false]}
*)

val any : ('value, _) t -> f:('value -> bool) -> bool
(** Determine if [f] returns true for [any] values in a set.

    {2 Examples}

    {[Set.any (Set.Int.from_array [|2;3|]) ~f:Int.is_even = true]}
    {[Set.any (Set.Int.from_list [1;3]) ~f:Int.is_even = false]}
    {[Set.any (Set.Int.from_list []) ~f:Int.is_even = false]}
*)

val all : ('value, _) t -> f:('value -> bool) -> bool
(** Determine if [f] returns true for [all] values in a set.

    {2 Examples}

    {[Set.all ~f:Int.is_even (Set.Int.from_array [|2;4|]) = true]}
    {[Set.all ~f:Int.is_even (Set.Int.from_list [2;3]) = false]}
    {[Set.all ~f:Int.is_even Set.Int.empty = true]}
*)

(** {1 Combine} *)

val difference : ('a, 'id) t -> ('a, 'id) t -> ('a, 'id) t
(** Returns a new set with the values from the first set which are not in the second set.

    {2 Examples}

    {[Set.difference (Set.Int.from_list [1;2;5]) (Set.Int.from_list [2;3;4]) |> Set.to_list = [1;5]]}
    {[Set.difference (Set.Int.from_list [2;3;4]) (Set.Int.from_list [1;2;5]) |> Set.to_list = [3;4]]}
*)

val intersection : ('a, 'id) t -> ('a, 'id) t -> ('a, 'id) t
(** Get the intersection of two sets. Keeps values that appear in both sets.

    {2 Examples}

    {[Set.intersection (Set.Int.from_list [1;2;5]) (Set.Int.from_list [2;3;4]) |> Set.to_list= [2]]}
*)

val union : ('a, 'id) t -> ('a, 'id) t -> ('a, 'id) t
(** Get the union of two sets. Keep all values.

    {2 Examples}

    {[Set.union (Set.Int.from_list [1;2;5]) (Set.Int.from_list [2;3;4]) |> Set.to_list = [1;2;3;4;5]]}
*)

(** {1 Transform} *)

val filter : ('a, 'id) t -> f:('a -> bool) -> ('a, 'id) t
(** Keep elements that [f] returns [true] for.

    {2 Examples}

    {[Set.filter (Set.Int.from_list [1;2;3]) ~f:Int.is_even |> Set.to_list = [2]]}
*)

val partition : ('a, 'id) t -> f:('a -> bool) -> ('a, 'id) t * ('a, 'id) t
(** Divide a set into two according to [f]. The first set will contain the values that [f] returns [true] for, values that [f] returns [false] for will end up in the second.

    {2 Examples}

    {[
      let numbers = Set.Int.from_list [1; 1; 5; 6; 5; 7; 9; 8] in
      let (evens, odds) = Set.partition numbers ~f:Int.is_even in
      Set.to_list evens = [6; 8];
      Set.to_list odds = [1; 5; 7; 9]
    ]}
*)

val fold : ('a, _) t -> initial:'b -> f:('b -> 'a -> 'b) -> 'b
(** Transform a set into a value which is result of running each element in the set through [f], where each successive invocation is supplied the return value of the previous.

  See {!Array.fold} for a more in-depth explanation.

  {2 Examples}

  {[Set.fold ~f:( * ) ~initial:1 (Set.Int.from_list [1;2;3;4]) = 24]}
*)

val for_each : ('a, _) t -> f:('a -> unit) -> unit
(** Runs a function [f] against each element of the set. *)

(** {1 Convert} *)

val to_array : ('a, _) t -> 'a array
(** Converts a set into an {!Array} *)

val to_list : ('a, _) t -> 'a list
(** Converts a set into a {!List}. *)

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

      {[Set.Poly.singleton 5 "Emu" |> Set.to_list = [(5, "Emu")]]}
  *)

  val from_array : 'a array -> 'a t
  (** Create a set from an {!Array}

      {2 Examples}

      {[Set.Poly.from_array [|(1, "Ant");(2, "Bat");(2, "Bat")|] |> Set.to_list = [(1, "Ant"); (2, "Bat")]]}
  *)

  val from_list : 'a list -> 'a t
  (** Create a set from a {!List}

    {2 Examples}

    {[Set.Poly.from_list [(1, "Ant");(2, "Bat");(2, "Bat")] |> Set.to_list = [(1, "Ant"); (2, "Bat")]]}
  *)
end

(** Construct sets of {!Int}s *)
module Int : sig
  type nonrec t = Of(TableclothInt).t

  val empty : t
  (** A set with nothing in it. *)

  val singleton : int -> t
  (** Create a set from a single {!Int}

    {2 Examples}

    {[Set.Int.singleton 5 |> Set.to_list = [5]]}
  *)

  val from_array : int array -> t
  (** Create a set from an {!Array}

      {2 Examples}

      {[Set.Int.from_array [|1;2;3;3;2;1;7|] |> Set.to_array = [|1;2;3;7|]]}
  *)

  val from_list : int list -> t
  (** Create a set from a {!List}

      {2 Examples}

      {[Set.Int.from_list [1;2;3;3;2;1;7] |> Set.to_list = [1;2;3;7]]}
  *)
end

(** Construct sets of {!String}s *)
module String : sig
  type nonrec t = Of(TableclothString).t

  val empty : t
  (** A set with nothing in it. *)

  val singleton : string -> t
  (** Create a set of a single {!String}.

      {2 Examples}

      {[Set.String.singleton "Bat" |> Set.to_list = ["Bat"]]}
  *)

  val from_array : string array -> t
  (** Create a set from an {!Array}.

      {2 Examples}

      {[Set.String.from_array [|"a";"b";"g";"b";"g";"a";"a"|] |> Set.to_array = [|"a";"b";"g"|]]}
  *)

  val from_list : string list -> t
  (** Create a set from a {!List}.

      {2 Examples}

      {[Set.String.from_list [|"a";"b";"g";"b";"g";"a";"a"|] |> Set.to_list = ["a";"b";"g"]]}
  *)
end
