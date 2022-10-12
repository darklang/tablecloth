(** *)

(** Functions for manipulating trios of values *)

type ('a, 'b, 'c) t = 'a * 'b * 'c

(** {1 Create} *)

val make : 'a -> 'b -> 'c -> 'a * 'b * 'c
(** Create a {!Tuple3}.

    {2 Examples}

    {[Tuple3.make 3 "cat" false = (3, "cat", false)]}
    {[
      List.map3 ~f:Tuple3.make [1;2;3] ['a'; 'b'; 'c'] [4.; 5.; 6.] =
        [(1, 'a', 4.), (2, 'b', 5.), (3, 'c', 6.)]
    ]}
*)

val from_array : 'a array -> ('a * 'a * 'a) option
(** Create a tuple from the first two elements of an {!Array}.

    If the array is longer than two elements, the extra elements are ignored.

    If the array is less than two elements, returns [None]

    {2 Examples}

    {[Tuple3.from_array [|1; 2;3 |] = Some (1, 2, 3)]}
    {[Tuple3.from_array [|1; 2|] = None]}
    {[Tuple3.from_array [|4;5;6;7|] = Some (4, 5, 6)]}
*)

val from_list : 'a list -> ('a * 'a * 'a) option
(** Create a tuple from the first two elements of a {!List}.

    If the list is longer than two elements, the extra elements are ignored.

    If the list is less than two elements, returns [None]

    {2 Examples}

    {[Tuple3.from_list [1; 2; 3] = Some (1, 2, 3)]}
    {[Tuple3.from_list [1; 2] = None]}
    {[Tuple3.from_list [4; 5; 6; 7] = Some (4, 5, 6)]}
*)

val first : 'a * 'b * 'c -> 'a
(** Extract the first value from a tuple.

    {2 Examples}

    {[Tuple3.first (3, 4, 5) = 3]}
    {[Tuple3.first ("john", "danger", "doe") = "john"]}
*)

val second : 'a * 'b * 'c -> 'b
(** Extract the second value from a tuple.

    {2 Examples}

    {[Tuple3.second (3, 4, 5) = 4]}
    {[Tuple3.second ("john", "danger", "doe") = "danger"]}
*)

val third : 'a * 'b * 'c -> 'c
(** Extract the third value from a tuple.

    {2 Examples}

    {[Tuple3.third (3, 4, 5) = 5]}
    {[Tuple3.third ("john", "danger", "doe") = "doe"]}
*)

val initial : 'a * 'b * 'c -> 'a * 'b
(** Extract the first and second values of a {!Tuple3} as a {!Tuple2}.

    {2 Examples}

    {[Tuple3.initial (3, "stressed", false) = (3, "stressed")]}
    {[Tuple3.initial ("john", 16, true) = ("john", 16)]}
*)

val tail : 'a * 'b * 'c -> 'b * 'c
(** Extract the second and third values of a {!Tuple3} as a {!Tuple2}.

    {2 Examples}

    {[Tuple3.tail (3, "stressed", false) = ("stressed", false)]}
    {[Tuple3.tail ("john", 16, true) = (16, true)]}
*)

(** {1 Modify} *)

val rotate_left : 'a * 'b * 'c -> 'b * 'c * 'a
(** Move each value in the tuple one position to the left, moving the value in the first position into the last position.

    {2 Examples}

    {[Tuple3.rotate_left (3, 4, 5) = (4, 5, 3)]}
    {[Tuple3.rotate_left ("was", "stressed", "then") = ("stressed", "then", "was")]}
*)

val rotate_right : 'a * 'b * 'c -> 'c * 'a * 'b
(** Move each value in the tuple one position to the right, moving the value in the last position into the first position.

    {2 Examples}

    {[Tuple3.rotate_right (3, 4, 5) = (5, 3, 4)]}
    {[Tuple3.rotate_right ("was", "stressed", "then") = ("then", "was", "stressed")]}
*)

val map_first : 'a * 'b * 'c -> f:('a -> 'x) -> 'x * 'b * 'c
(** Transform the first value in a tuple.

    {2 Examples}

    {[Tuple3.map_first ~f:String.reverse ("stressed", 16, false) = ("desserts", 16, false)]}
    {[Tuple3.map_first ~f:String.length ("stressed", 16, false) = (8, 16, false)]}
*)

val map_second : 'a * 'b * 'c -> f:('b -> 'y) -> 'a * 'y * 'c
(** Transform the second value in a tuple.

    {2 Examples}

    {[Tuple3.map_second ~f:Float.square_root ("stressed", 16., false) = ("stressed", 4., false)]}
    {[Tuple3.map_second ~f:(~-) ("stressed", 16, false) = ("stressed", -16, false)]}
*)

val map_third : 'a * 'b * 'c -> f:('c -> 'z) -> 'a * 'b * 'z
(** Transform the third value in a tuple.

    {2 Examples}

    {[Tuple3.map_third ~f:not ("stressed", 16, false) ("stressed", 16, true)]}
*)

val map_each :
  'a * 'b * 'c -> f:('a -> 'x) -> g:('b -> 'y) -> h:('c -> 'z) -> 'x * 'y * 'z
(** Transform each value in a tuple by applying [f] to the {!first} value, [g] to the {!second} value and [h] to the {!third} value.

    {2 Examples}

    {[
      Tuple3.map_each
        ~f:String.reverse
        ~g:Float.square_root
        ~h:Bool.not
        ("stressed", 16., false) = ("desserts", 4., true)
    ]}
*)

val map_all : 'a * 'a * 'a -> f:('a -> 'b) -> 'b * 'b * 'b
(** Transform all the values of a tuple using the same function.

    [map_all] can only be used on tuples which have the same type for each value.

    {2 Examples}

    {[Tuple3.map_all ~f:Float.square_root (9., 16., 25.) = (3., 4., 5.)]}

    {[Tuple3.map_all ~f:String.length ("was", "stressed", "then") = (3, 8, 4)]}
*)

val to_array : 'a * 'a * 'a -> 'a array
(** Turns a tuple into a {!List} of length three.

    This function can only be used on tuples which have the same type for each value.

    {2 Examples}

    {[Tuple3.to_array (3, 4, 5) = [|3; 4; 5|]]}
    {[Tuple3.to_array ("was", "stressed", "then") = [|"was"; "stressed"; "then"|]]}
*)

val to_list : 'a * 'a * 'a -> 'a list
(** Turns a tuple into a {!List} of length three.

    This function can only be used on tuples which have the same type for each value.

    {2 Examples}

    {[Tuple3.to_list (3, 4, 5) = [3; 4; 5]]}
    {[Tuple3.to_list ("was", "stressed", "then") = ["was"; "stressed"; "then"]]}
*)

val equal :
     ('a -> 'a -> bool)
  -> ('b -> 'b -> bool)
  -> ('c -> 'c -> bool)
  -> ('a, 'b, 'c) t
  -> ('a, 'b, 'c) t
  -> bool
(** Test two {!Tuple3}s for equality, using the provided functions to test the
    first, second and third components.

    {2 Examples}

    {[Tuple3.equal Int.equal String.equal Char.equal (1, "Fox", 'j') (1, "Fox", 'k') = true]}
    {[Tuple3.equal Int.equal String.equal Char.equal (1, "Fox", 'j') (2, "Hen", 'j') = false]}
 *)

val compare :
     f:('a -> 'a -> int)
  -> g:('b -> 'b -> int)
  -> h:('c -> 'c -> int)
  -> ('a, 'b, 'c) t
  -> ('a, 'b, 'c) t
  -> int
(** Compare two {!Tuple3}s, using [f] to compare the first
    components then, if the first components are equal, the second components are compared with [g],
    then the third components are compared with [h]

    {2 Examples}

    {[Tuple3.compare ~f:Int.compare ~g:String.compare ~h:Char.compare (1, "Fox", 'j') (1, "Fox", 'j') = 0]}
    {[Tuple3.compare ~f:Int.compare ~g:String.compare ~h:Char.compare (1, "Fox", 'j') (1, "Eel", 'j') = 1]}
    {[Tuple3.compare ~f:Int.compare ~g:String.compare ~h:Char.compare (1, "Fox", 'j') (2, "Fox", 'm') = -1]}
 *)
