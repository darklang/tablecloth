(** *)

(** Functions for manipulating pairs of values *)

type ('a, 'b) t = 'a * 'b

(** {1 Create} *)

val make : 'a -> 'b -> 'a * 'b
(** Create a two-tuple with the given values.

    The values do not have to be of the same type.

    {2 Examples}

    {[Tuple2.make 3 "Clementine" = (3, "Clementine")]}
*)

val from_array : 'a array -> ('a * 'a) option
(** Create a tuple from the first two elements of an {!Array}.

    If the array is longer than two elements, the extra elements are ignored.

    If the array is less than two elements, returns [None].

    {2 Examples}

    {[Tuple2.from_array [|1; 2|] = Some (1, 2)]}
    {[Tuple2.from_array [|1|] = None]}
    {[Tuple2.from_array [|4; 5; 6|] = Some (4, 5)]}
*)

val from_list : 'a list -> ('a * 'a) option
(** Create a tuple from the first two elements of a {!List}.

    If the list is longer than two elements, the extra elements are ignored.

    If the list is less than two elements, returns [None].

    {2 Examples}

    {[Tuple2.from_list [1; 2] = Some (1, 2)]}
    {[Tuple2.from_list [1] = None]}
    {[Tuple2.from_list [4; 5; 6] = Some (4, 5)]}
*)

val first : 'a * 'b -> 'a
(** Extract the first value from a tuple.

    {2 Examples}

    {[Tuple2.first (3, 4) = 3]}
    {[Tuple2.first ("john", "doe") = "john"]}
*)

val second : 'a * 'b -> 'b
(** Extract the second value from a tuple.

    {2 Examples}

    {[Tuple2.second (3, 4) = 4]}
    {[Tuple2.second ("john", "doe") = "doe"]}
*)

(** {1 Transform} *)

val map_first : 'a * 'b -> f:('a -> 'x) -> 'x * 'b
(** Transform the {!first} value in a tuple.

    {2 Examples}

    {[Tuple2.map_first ~f:String.reverse ("stressed", 16) = ("desserts", 16)]}
    {[Tuple2.map_first ~f:String.length ("stressed", 16) = (8, 16)]}
*)

val map_second : 'a * 'b -> f:('b -> 'c) -> 'a * 'c
(** Transform the second value in a tuple.

    {2 Examples}

    {[Tuple2.map_second ~f:Float.square_root ("stressed", 16.) = ("stressed", 4.)]}
    {[Tuple2.map_second ~f:(~-) ("stressed", 16) = ("stressed", -16)]}
*)

val map_each : 'a * 'b -> f:('a -> 'x) -> g:('b -> 'y) -> 'x * 'y
(** Transform both values of a tuple, using [f] for the first value and [g] for the second.

    {2 Examples}

    {[Tuple2.map_each ~f:String.reverse ~g:Float.square_root ("stressed", 16.) = ("desserts", 4.)]}
    {[Tuple2.map_each ~f:String.length ~g:(~-) ("stressed", 16) = (8, -16)]}
*)

val map_all : 'a * 'a -> f:('a -> 'b) -> 'b * 'b
(** Transform both of the values of a tuple using the same function.

    [map_all] can only be used on tuples which have the same type for each value.

    {2 Examples}

    {[Tuple2.map_all ~f:(Int.add 1) (3, 4) = (4, 5)]}
    {[Tuple2.map_all ~f:String.length ("was", "stressed") = (3, 8)]}
*)

val swap : 'a * 'b -> 'b * 'a
(** Switches the first and second values of a tuple.

    {2 Examples}

    {[Tuple2.swap (3, 4) = (4, 3)]}
    {[Tuple2.swap ("stressed", 16) = (16, "stressed")]}
*)

(** {1 Convert} *)

val to_array : 'a * 'a -> 'a array
(** Turns a tuple into an {!Array} of length two.

    This function can only be used on tuples which have the same type for each value.

    {2 Examples}

    {[Tuple2.to_array (3, 4) = [|3; 4|]]}
    {[Tuple2.to_array ("was", "stressed") = [|"was"; "stressed"|]]}
*)

val to_list : 'a * 'a -> 'a list
(** Turns a tuple into a list of length two. This function can only be used on tuples which have the same type for each value.

    {2 Examples}

    {[Tuple2.to_list (3, 4) = [3; 4]]}
    {[Tuple2.to_list ("was", "stressed") = ["was"; "stressed"]]}
*)

val equal :
  ('a -> 'a -> bool) -> ('b -> 'b -> bool) -> ('a, 'b) t -> ('a, 'b) t -> bool
(** Test two {!Tuple2}s for equality, using the provided functions to test the
    first and second components.

    {2 Examples}

    {[Tuple2.equal Int.equal String.equal (1, "Fox") (1, "Fox") = true]}
    {[Tuple2.equal Int.equal String.equal (1, "Fox") (2, "Hen") = false]}
*)

val compare :
  f:('a -> 'a -> int) -> g:('b -> 'b -> int) -> ('a, 'b) t -> ('a, 'b) t -> int
(** Compare two {!Tuple2}s, using the provided [f] function to compare the first components.
    Then, if the first components are equal, the second components are compared with [g].

    {2 Examples}

    {[Tuple2.compare ~f:Int.compare ~g:String.compare (1, "Fox") (1, "Fox") = 0]}
    {[Tuple2.compare ~f:Int.compare ~g:String.compare (1, "Fox") (1, "Eel") = 1]}
    {[Tuple2.compare ~f:Int.compare ~g:String.compare (1, "Fox") (2, "Hen") = -1]}
*)
