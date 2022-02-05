(** *)

(** Functions for working with boolean values.

    Booleans in OCaml / Reason are represented by the [true] and [false] literals.

    Whilst a bool isnt a variant, you will get warnings if you haven't
    exhaustively pattern match on them:

    {[
      let bool = false
      let string =
        match bool with
        | false -> "false"
      (*
        Warning 8: this pattern-matching is not exhaustive.
        Here is an example of a case that is not matched:
        true
      *)
    ]}
*)

type t = bool

(** {1 Create} *)

val from_int : int -> bool option
(** Convert an {!Int} into a {!Bool}.

    {2 Examples}

    {[Bool.from_int 0 = Some false]}
    {[Bool.from_int 1 = Some true]}
    {[Bool.from_int 8 = None]}
    {[Bool.from_int (-3) = None]}
*)

val from_string : string -> bool option
(** Convert a {!String} into a {!Bool}.

    {2 Examples}

    {[Bool.from_string "true" = Some true]}
    {[Bool.from_string "false" = Some false]}
    {[Bool.from_string "True" = None]}
    {[Bool.from_string "False" = None]}
    {[Bool.from_string "0" = None]}
    {[Bool.from_string "1" = None]}
    {[Bool.from_string "Not even close" = None]}
*)

(** {1 Basic operations} *)

external ( && ) : bool -> bool -> bool = "%sequand"
(** The lazy logical AND operator.

    Returns [true] if both of its operands evaluate to [true].

    If the 'left' operand evaluates to [false], the 'right' operand is not evaluated.

    {2 Examples}

    {[Bool.(true && true) = true]}
    {[Bool.(true && false) = false]}
    {[Bool.(false && true) = false]}
    {[Bool.(false && false) = false]}
*)

external ( || ) : bool -> bool -> bool = "%sequor"
(** The lazy logical OR operator.

    Returns [true] if one of its operands evaluates to [true].

    If the 'left' operand evaluates to [true], the 'right' operand is not evaluated.

    {2 Examples}

    {[Bool.(true || true) = true]}
    {[Bool.(true || false) = true]}
    {[Bool.(false || true) = true]}
    {[Bool.(false || false) = false]}
*)

val xor : bool -> bool -> bool
(** The exclusive or operator.

    Returns [true] if {b exactly one} of its operands is [true].

    {2 Examples}

    {[Bool.xor true true  = false]}
    {[Bool.xor true false = true]}
    {[Bool.xor false true  = true]}
    {[Bool.xor false false = false]}
*)

val not : t -> bool
(** Negate a [bool].

    {2 Examples}

    {[Bool.not false = true]}
    {[Bool.not true = false]}
*)

val and_ : bool -> bool -> bool
(** The logical conjunction [AND] operator.

    Returns [true] if {b both} of its operands are [true].
    If the 'left' operand evaluates to [false], the 'right' operand is not evaluated.

    {2 Examples}

    {[Bool.and_ true true == true]}
    {[Bool.and_ true false == false]}
    {[Bool.and_ false true == false]}
    {[Bool.and_ false false == false]}
*)

(** {1 Convert} *)

val to_string : bool -> string
(** Convert a [bool] to a {!String}

    {2 Examples}

    {[Bool.to_string true = "true"]}
    {[Bool.to_string false = "false"]}
*)

val to_int : bool -> int
(** Convert a [bool] to an {!Int}.

    {2 Examples}

    {[Bool.to_int true = 1]}
    {[Bool.to_int false = 0]}
*)

(** {1 Compare} *)

val equal : bool -> bool -> bool
(** Test for the equality of two [bool] values.

    {2 Examples}

    {[Bool.equal true true = true]}
    {[Bool.equal false false = true]}
    {[Bool.equal false true = false]}
*)

val compare : bool -> bool -> int
(** Compare two [bool] values.

    {2 Examples}

    {[Bool.compare true false = 1]}
    {[Bool.compare false true = -1]}
    {[Bool.compare true true = 0]}
    {[Bool.compare false false = 0]}
*)
