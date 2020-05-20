(** Functions for manipulating pairs of values *)

type ('a, 'b) t = 'a * 'b

(** {1 Create} *)

val make : 'a -> 'b -> 'a * 'b
(** Create a two-tuple with the given values.

    The values do not have to be of the same type.

    {2 Examples}

    {[Tuple.make 3 "Clementine" = (3, "Clementine")]}
*)

val fromArray : 'a array -> ('a * 'a) option
(** Create a tuple from the first two elements of an {!Array}.

    If the array is longer than two elements, the extra elements are ignored.

    If the array is less than two elements, returns [None]

    {2 Examples}

    {[Tuple.fromArray [|1; 2|] = Some (1, 2)]}

    {[Tuple.fromArray [|1|] = None]}

    {[Tuple.fromArray [|4; 5; 6|] = Some (4, 5)]}
*)

val from_array : 'a array -> ('a * 'a) option

val fromList : 'a list -> ('a * 'a) option
(** Create a tuple from the first two elements of a {!List}.

    If the list is longer than two elements, the extra elements are ignored.

    If the list is less than two elements, returns [None]

    {2 Examples}

    {[Tuple.fromList [1; 2] = Some (1, 2)]}

    {[Tuple.fromList [1] = None]}

    {[Tuple.fromList [4; 5; 6] = Some (4, 5)]}
*)

val from_list : 'a list -> ('a * 'a) option

val first : 'a * 'b -> 'a
(** Extract the first value from a tuple.

    {2 Examples}

    {[Tuple.first (3, 4) = 3]}

    {[Tuple.first ("john", "doe") = "john"]}
*)

val second : 'a * 'b -> 'b
(** Extract the second value from a tuple.

    {2 Examples}

    {[Tuple.second (3, 4) = 4]}

    {[Tuple.second ("john", "doe") = "doe"]}
*)

(** {1 Transform} *)

val mapFirst : 'a * 'b -> f:('a -> 'x) -> 'x * 'b
(** Transform the {!first} value in a tuple.

    {2 Examples}

    {[Tuple.mapFirst ~f:String.reverse ("stressed", 16) = ("desserts", 16)]}

    {[Tuple.mapFirst ~f:String.length ("stressed", 16) = (8, 16)]}
*)

val map_first : 'a * 'b -> f:('a -> 'x) -> 'x * 'b

val mapSecond : 'a * 'b -> f:('b -> 'c) -> 'a * 'c
(** Transform the second value in a tuple.

    {2 Examples}

    {[Tuple.mapSecond ~f:Float.squareRoot ("stressed", 16.) = ("stressed", 4.)]}

    {[Tuple.mapSecond ~f:(~-) ("stressed", 16) = ("stressed", -16)]}
*)

val map_second : 'a * 'b -> f:('b -> 'c) -> 'a * 'c

val mapEach : 'a * 'b -> f:('a -> 'x) -> g:('b -> 'y) -> 'x * 'y
(** Transform both values of a tuple, using [f] for the first value and [g] for the second.

    {2 Examples}

    {[Tuple.mapEach ~f:String.reverse ~g:Float.squareRoot ("stressed", 16.) = ("desserts", 4.)]}

    {[Tuple.mapEach ~f:String.length ~g:(~-) ("stressed", 16) = (8, -16)]}
*)

val map_each : 'a * 'b -> f:('a -> 'x) -> g:('b -> 'y) -> 'x * 'y

val mapAll : 'a * 'a -> f:('a -> 'b) -> 'b * 'b
(** Transform both of the values of a tuple using the same function.

    [mapAll] can only be used on tuples which have the same type for each value.

    {2 Examples}

    {[Tuple.mapAll ~f:(Int.add 1) (3, 4, 5) = (4, 5, 6)]}

    {[Tuple.mapAll ~f:String.length ("was", "stressed") = (3, 8)]}
*)

val map_all : 'a * 'a -> f:('a -> 'b) -> 'b * 'b

val swap : 'a * 'b -> 'b * 'a
(** Switches the first and second values of a tuple.

    {2 Examples}

    {[Tuple.swap (3, 4) = (4, 3)]}

    {[Tuple.swap ("stressed", 16) = (16, "stressed")]}
*)

(** {1 Convert} *)

val toArray : 'a * 'a -> 'a array
(** Turns a tuple into an {!Array} of length two.

    This function can only be used on tuples which have the same type for each value.

    {2 Examples}

    {[Tuple.toArray (3, 4) = [|3; 4|]]}

    {[Tuple.toArray ("was", "stressed") = [|"was"; "stressed"|]]}
*)

val to_array : 'a * 'a -> 'a array

val toList : 'a * 'a -> 'a list
(** Turns a tuple into a list of length two. This function can only be used on tuples which have the same type for each value.

    {2 Examples}

    {[Tuple.toList (3, 4) = [3; 4]]}

    {[Tuple.toList ("was", "stressed") = ["was"; "stressed"]]}
*)

val to_list : 'a * 'a -> 'a list

(** {1 Compare} *)

val equal :
  ('a -> 'a -> bool) -> ('b -> 'b -> bool) -> ('a, 'b) t -> ('a, 'b) t -> bool
(** Test two {!Tuple}s for equality, using the provided functions to test the
    first and second components.

    {2 Examples}

    {[Tuple.equal Int.equal String.equal (1, "Fox") (1, "Fox") = true]}

    {[Tuple.equal Int.equal String.equal (1, "Fox") (2, "Hen") = false]}
*)

val compare :
  ('a -> 'a -> int) -> ('b -> 'b -> int) -> ('a, 'b) t -> ('a, 'b) t -> int
(** Compare two {!Tuple}s, using the provided functions to compare the first
    components then, if the first components are equal, the second components.

    {2 Examples}

    {[Tuple.compare Int.compare String.compare (1, "Fox") (1, "Fox") = 0]}

    {[Tuple.compare Int.compare String.compare (1, "Fox") (1, "Eel") = 1]}

    {[Tuple.compare Int.compare String.compare (1, "Fox") (2, "Hen") = -1]}
*)
