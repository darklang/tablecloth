(** *)

(** Functions for working with boolean values.

    Booleans in Rescript are represented by the [true] and [false] literals.

    Whilst a bool isnt a variant, you will get warnings if you haven't
    exhaustively pattern match on them:

    {[
      let bool = false
      let string = switch bool {
      | false => "false"
      }

      (*
        Warning number 8
        You forgot to handle a possible case here, for example: 
        true
      *)
    ]}
*)

type t = bool

(** {1 Create} *)

val fromInt : int -> bool option
(** Convert an {!Int} into a {!Bool}.

    {2 Examples}

    {[
      Bool.fromInt(0) == Some(false)
      Bool.fromInt(1) == Some(true)
      Bool.fromInt(8) == None
      Bool.fromInt(-3) == None
    ]}
*)

val fromString : string -> bool option
(** Convert a {!String} into a {!Bool}.

    {2 Examples}

    {[
      Bool.fromString("true") == Some(true)
      Bool.fromString("false") == Some(false)
      Bool.fromString("True") == None
      Bool.fromString("False") == None
      Bool.fromString("0") == None
      Bool.fromString("1") == None
      Bool.fromString("Not even close") == None
    ]}
*)

(** {1 Basic operations} *)

val xor : bool -> bool -> bool
(** The exclusive or operator.

    Returns [true] if {b exactly one} of its operands is [true].

    {2 Examples}

    {[
      Bool.xor(true, true) == false
      Bool.xor(true, false) == true
      Bool.xor(false, true) == true
      Bool.xor(false, false) == false
    ]}
*)

val not : t -> bool
(** Negate a [bool].

    {2 Examples}

    {[
      Bool.not(false) == true
      Bool.not(true) == false
    ]}
*)

val and_ : bool -> bool -> bool
(** The logical conjunction [AND] operator.

    Returns [true] if {b both} of its operands are [true].
    If the 'left' operand evaluates to [false], the 'right' operand is not evaluated.

    {2 Examples}

    {[
      Bool.and_(true, true) == true
      Bool.and_(true, false) == false
      Bool.and_(false, true) == false
      Bool.and_(false, false) == false
    ]}
*)

(** {1 Convert} *)

val toString : bool -> string
(** Convert a [bool] to a {!String}

    {2 Examples}

    {[
      Bool.toString(true) == "true"
      Bool.toString(false) == "false"
    ]}
*)

val toInt : bool -> int
(** Convert a [bool] to an {!Int}.

    {2 Examples}

    {[
      Bool.toInt(true) == 1
      Bool.toInt(false) == 0
    ]}
*)

(** {1 Compare} *)

val equal : bool -> bool -> bool
(** Test for the equality of two [bool] values.

    {2 Examples}

    {[
      Bool.equal(true, true) == true
      Bool.equal(false, false) == true
      Bool.equal(false, true) == false
    ]}
*)

val compare : bool -> bool -> int
(** Compare two [bool] values.

    {2 Examples}

    {[
      Bool.compare(true, false) == 1
      Bool.compare(false, true) == -1
      Bool.compare(true, true) == 0
      Bool.compare(false, false) == 0
    ]}
*)
