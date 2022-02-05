(** *)

(** Functions for manipulating trios of values *)

type ('a, 'b, 'c) t = 'a * 'b * 'c

(** {1 Create} *)

val make : 'a -> 'b -> 'c -> 'a * 'b * 'c
(** Create a {!Tuple3}.

    {2 Examples}

    {[
      Tuple3.make(3, "cat", false) == (3, "cat", false)
      
      Array.map3(~f=Tuple3.make, [1, 2, 3], ['a', 'b', 'c'], [4., 5., 6.])
      == [
          (1, 'a', 4.),
          (2, 'b', 5.),
          (3, 'c', 6.),
      ]
   ]}
*)

val fromArray : 'a array -> ('a * 'a * 'a) option
(** Create a tuple from the first two elements of an {!Array}.

    If the array is longer than three elements, the extra elements are ignored.

    If the array is less than three elements, returns [None]

    {2 Examples}

    {[
      Tuple3.fromArray([1, 2, 3]) == Some(1, 2, 3)
      Tuple3.fromArray([1, 2]) == None
      Tuple3.fromArray([4, 5, 6, 7]) == Some(4, 5, 6)
    ]}
*)

val fromList : 'a list -> ('a * 'a * 'a) option
(** Create a tuple from the first two elements of a {!List}.

    If the list is longer than two elements, the extra elements are ignored.

    If the list is less than two elements, returns [None]

    {2 Examples}

    {[
      Tuple3.fromList(list{1, 2, 3}) == Some(1, 2, 3)
      Tuple3.fromList(list{1, 2}) == None
      Tuple3.fromList(list{4, 5, 6, 7}) == Some(4, 5, 6)
    ]}
*)

val first : 'a * 'b * 'c -> 'a
(** Extract the first value from a tuple.

    {2 Examples}

    {[
      Tuple3.first((3, 4, 5)) == 3
      Tuple3.first(("john", "danger", "doe")) == "john"
    ]}
*)

val second : 'a * 'b * 'c -> 'b
(** Extract the second value from a tuple.

    {2 Examples}

    {[
      Tuple3.second((3, 4, 5)) == 4
      Tuple3.second(("john", "danger", "doe")) == "danger"
    ]}
*)

val third : 'a * 'b * 'c -> 'c
(** Extract the third value from a tuple.

    {2 Examples}

    {[
      Tuple3.third((3, 4, 5)) == 5
      Tuple3.third(("john", "danger", "doe")) == "doe"
    ]}
*)

val initial : 'a * 'b * 'c -> 'a * 'b
(** Extract the first and second values of a {!Tuple3} as a {!Tuple2}.

    {2 Examples}

    {[
      Tuple3.initial((3, "stressed", false)) == (3, "stressed")
      Tuple3.initial(("john", 16, true)) == ("john", 16)
    ]}
*)

val tail : 'a * 'b * 'c -> 'b * 'c
(** Extract the second and third values of a {!Tuple3} as a {!Tuple2}.

    {2 Examples}

    {[
      Tuple3.tail((3, "stressed", false)) == ("stressed", false)
      Tuple3.tail(("john", 16, true)) == (16, true)
    ]}
*)

(** {1 Modify} *)

val rotateLeft : 'a * 'b * 'c -> 'b * 'c * 'a
(** Move each value in the tuple one position to the left, moving the value in the first position into the last position.

    {2 Examples}

    {[
      Tuple3.rotateLeft((3, 4, 5)) == (4, 5, 3)
      Tuple3.rotateLeft(("was", "stressed", "then")) == ("stressed", "then", "was")
    ]}
*)

val rotateRight : 'a * 'b * 'c -> 'c * 'a * 'b
(** Move each value in the tuple one position to the right, moving the value in the last position into the first position.

    {2 Examples}

    {[
      Tuple3.rotateRight((3, 4, 5)) == (5, 3, 4)
      Tuple3.rotateRight(("was", "stressed", "then")) == ("then", "was", "stressed")
    ]}
*)

val mapFirst : 'a * 'b * 'c -> f:('a -> 'x) -> 'x * 'b * 'c
(** Transform the first value in a tuple.

    {2 Examples}

    {[
      Tuple3.mapFirst(("stressed", 16, false), ~f=String.reverse) == ("desserts", 16, false)
      Tuple3.mapFirst(("stressed", 16, false), ~f=String.length) == (8, 16, false)
    ]}
*)

val mapSecond : 'a * 'b * 'c -> f:('b -> 'y) -> 'a * 'y * 'c
(** Transform the second value in a tuple.

    {2 Examples}

    {[
      Tuple3.mapSecond(("stressed", 16., false), ~f=Float.squareRoot) == ("stressed", 4., false)
      Tuple3.mapSecond(~f=Int.negate, ("stressed", 16, false)) == ("stressed", -16, false)
    ]}
*)

val mapThird : 'a * 'b * 'c -> f:('c -> 'z) -> 'a * 'b * 'z
(** Transform the third value in a tuple.

    {2 Examples}

    {[
      Tuple3.mapThird(("stressed", 16, false), ~f=Bool.not) == ("stressed", 16, true)
    ]}
*)

val mapEach :
  'a * 'b * 'c -> f:('a -> 'x) -> g:('b -> 'y) -> h:('c -> 'z) -> 'x * 'y * 'z
(** Transform each value in a tuple by applying [f] to the {!first} value, [g] to the {!second} value and [h] to the {!third} value.

    {2 Examples}

    {[
      Tuple3.mapEach(
          ("stressed", 16., false)
          ~f=String.reverse, 
          ~g=Float.squareRoot, 
          ~h=Bool.not)
      == ("desserts", 4., true)
   ]}
*)

val mapAll : 'a * 'a * 'a -> f:('a -> 'b) -> 'b * 'b * 'b
(** Transform all the values of a tuple using the same function.

    [mapAll] can only be used on tuples which have the same type for each value.

    {2 Examples}

    {[
      Tuple3.mapAll((9., 16., 25.), ~f=Float.squareRoot) == (3., 4., 5.)
      Tuple3.mapAll(("was", "stressed", "then"), ~f=String.length) == (3, 8, 4)
    ]}
*)

val toArray : 'a * 'a * 'a -> 'a array
(** Turns a tuple into a {!List} of length three.

    This function can only be used on tuples which have the same type for each value.

    {2 Examples}

    {[
      Tuple3.toArray((3, 4, 5)) == [3, 4, 5]
      Tuple3.toArray(("was", "stressed", "then")) == ["was", "stressed", "then"]
    ]}
*)

val toList : 'a * 'a * 'a -> 'a list
(** Turns a tuple into a {!List} of length three.

    This function can only be used on tuples which have the same type for each value.

    {2 Examples}

    {[
      Tuple3.toList((3, 4, 5)) == list{3, 4, 5}
      Tuple3.toList(("was", "stressed", "then")) == list{"was", "stressed", "then"}
    ]}
*)

val equal :
     ('a, 'b, 'c) t
  -> ('a, 'b, 'c) t
  -> ('a -> 'a -> bool)
  -> ('b -> 'b -> bool)
  -> ('c -> 'c -> bool)
  -> bool
(** Test two {!Tuple3}s for equality, using the provided functions to test the
    first, second and third components.

    {2 Examples}

    {[
      Tuple3.equal((1, "Fox", 'j'), (1, "Fox", 'k'), Int.equal, String.equal, Char.equal) == false
      Tuple3.equal((1, "Fox", 'j'), (2, "Hen", 'j'), Int.equal, String.equal, Char.equal) == false
    ]}
 *)

val compare :
     ('a, 'b, 'c) t
  -> ('a, 'b, 'c) t
  -> f:('a -> 'a -> int)
  -> g:('b -> 'b -> int)
  -> h:('c -> 'c -> int)
  -> int
(** Compare two {!Tuple3}s, using [f] to compare the first
    components then, if the first components are equal, the second components are compared with [g],
    then the third components are compared with [h].

    {2 Examples}

    {[
      Tuple3.compare((1, "Fox", 'j'), (1, "Fox", 'j'), ~f=Int.compare, ~g=String.compare, ~h=Char.compare) == 0
      Tuple3.compare((1, "Fox", 'j'), (1, "Eel", 'j'), ~f=Int.compare, ~g=String.compare, ~h=Char.compare) == 1
      Tuple3.compare((1, "Fox", 'j'), (2, "Fox", 'm'), ~f=Int.compare, ~g=String.compare, ~h=Char.compare) == -1
    ]}
 *)
