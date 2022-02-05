(** *)

(** The platform-dependant {{: https://en.wikipedia.org/wiki/Signed_number_representations } signed } {{: https://en.wikipedia.org/wiki/Integer } integer} type.

    An [int] is a whole number.

    [int]s are subject to {{: https://en.wikipedia.org/wiki/Integer_overflow } overflow }, meaning that [Int.maximum_value + 1 = Int.minimum_value].

    If you need to work with integers larger than {!maximum_value} (or smaller than {!minimum_value} you can use the {!Float} module.

    Valid syntax for [int]s includes:
    {[
      0
      42
      9000
      1_000_000
      1_000_000
      0xFF (* 255 in hexadecimal *)
      0x000A (* 10 in hexadecimal *)
    ]}

    {b Note:} The number of bits used for an [int] is platform dependent.

    When targeting Bucklescript {{: https://bucklescript.github.io/docs/en/common-data-types.html#int }  Ints are 32 bits}.

    When targeting native OCaml uses 31-bits on 32-bit platforms and 63-bits on 64-bit platforms
    which means that [int] math is well-defined in the range [-2 ** 30] to [2 ** 30 - 1] for 32bit platforms [-2 ** 62] to [2 ** 62 - 1] for 64bit platforms.

    Outside of that range, the behavior is determined by the compilation target.

    You can read about the reasons for OCaml's unusual integer sizes {{: https://v1.realworldocaml.org/v1/en/html/memory-representation-of-values.html} here }.

    {e Historical Note: } The name [int] comes from the term {{: https://en.wikipedia.org/wiki/Integer } integer}. It appears
    that the [int] abbreviation was introduced in the programming language ALGOL 68.

    Today, almost all programming languages use this abbreviation.
*)

type t = int

(** {1 Constants } *)

val zero : t
(** The literal [0] as a named value. *)

val one : t
(** The literal [1] as a named value. *)

val maximum_value : t
(** The maximum representable [int] on the current platform. *)

val minimum_value : t
(** The minimum representable [int] on the current platform. *)

(** {1 Create} *)

val from_string : string -> t option
(** Attempt to parse a [string] into a [int].

    {2 Examples}

    {[Int.from_string "0" = Some 0]}
    {[Int.from_string "42" = Some 42]}
    {[Int.from_string "-3" = Some (-3)]}
    {[Int.from_string "123_456" = Some 123_456]}
    {[Int.from_string "0xFF" = Some 255]}
    {[Int.from_string "0x00A" = Some 10]}
    {[Int.from_string "Infinity" = None]}
    {[Int.from_string "NaN" = None]}
*)

(** {1 Operators}

    {b Note } You do not need to open the {!Int} module to use the
    {!( + )}, {!( - )}, {!( * )}, {!( ** )}, {! (mod)} or {!( / )} operators, these are
    available as soon as you [open Tablecloth]
*)

val add : t -> t -> t
(** Add two {!Int} numbers.

  {[Int.add 3002 4004 = 7006]}

  Or using the globally available operator:

  {[3002 + 4004 = 7006]}

  You {e cannot } add an [int] and a [float] directly though.

  See {!Float.add} for why, and how to overcome this limitation.
*)

val ( + ) : t -> t -> t
(** See {!Int.add} *)

val subtract : t -> t -> t
(** Subtract numbers.

    {2 Examples}

    {[Int.subtract 4 3 = 1]}

    Alternatively the operator can be used:

    {[4 - 3 = 1]}
*)

val ( - ) : t -> t -> t
(** See {!Int.subtract} *)

val multiply : t -> t -> t
(** Multiply [int]s.

    {2 Examples}

    {[Int.multiply 2 7 = 14]}

    Alternatively the operator can be used:

    {[(2 * 7) = 14]}
*)

val ( * ) : t -> t -> t
(** See {!Int.multiply} *)

val divide : t -> by:t -> t
(** Integer division.

    Notice that the remainder is discarded.

    {3 Exceptions}

    Throws [Division_by_zero] when the divisor is [0].

    {2 Examples}

    {[Int.divide 3 ~by:2 = 1]}
    {[27 / 5 = 5]}
*)

val ( / ) : t -> t -> t
(** See {!Int.divide} *)

val ( /. ) : t -> t -> float
(** Floating point division.

    {2 Examples}

    {[Int.(3 /. 2) = 1.5]}
    {[Int.(27 /. 5) = 5.25]}
    {[Int.(8 /. 4) = 2.0]}
*)

val divide_float : by:t -> t -> float
(** Floating point division.

    {2 Examples}

    {[Int.divide_float 3 ~by:2 = 1.5]}
    {[Int.divide_float 27 ~by:5 = 5.25]}
    {[Int.divide_float 8 ~by:4 = 2.0]}

*)

val power : base:t -> exponent:t -> t
(** Exponentiation, takes the base first, then the exponent.

    {2 Examples}

    {[Int.power ~base:7 ~exponent:3 = 343]}

    Alternatively the [**] operator can be used:

    {[7 ** 3 = 343]}
*)

val ( ** ) : t -> t -> t
(** See {!Int.power} *)

val negate : t -> t
(** Flips the 'sign' of an integer so that positive integers become negative and negative integers become positive. Zero stays as it is.

    {2 Examples}

    {[Int.negate 8 = (-8)]}
    {[Int.negate (-7) = 7]}
    {[Int.negate 0 = 0]}

    Alternatively the [~-] operator can be used:

    {[~-(7) = (-7)]}
*)

val ( ~- ) : t -> t
(** See {!Int.negate} *)

val absolute : t -> t
(** Get the {{: https://en.wikipedia.org/wiki/Absolute_value } absolute value } of a number.

    {2 Examples}

    {[Int.absolute 8 = 8]}
    {[Int.absolute (-7) = 7]}
    {[Int.absolute 0 = 0]}
*)

val modulo : t -> by:t -> t
(** Perform {{: https://en.wikipedia.org/wiki/Modular_arithmetic } modular arithmetic }.

    If you intend to use [modulo] to detect even and odd numbers consider using {!Int.is_even} or {!Int.is_odd}.

    The [modulo] function works in the typical mathematical way when you run into negative numbers

    Use {!Int.remainder} for a different treatment of negative numbers.

    {2 Examples}

    {[Int.modulo ~by:3 (-4) = 2]}
    {[Int.modulo ~by:3 (-3 )= 0]}
    {[Int.modulo ~by:3 (-2) = 1]}
    {[Int.modulo ~by:3 (-1) = 2]}
    {[Int.modulo ~by:3 0 = 0]}
    {[Int.modulo ~by:3 1 = 1]}
    {[Int.modulo ~by:3 2 = 2]}
    {[Int.modulo ~by:3 3 = 0]}
    {[Int.modulo ~by:3 4 = 1]}
*)

val ( mod ) : t -> t -> t
(** See {!Int.modulo} *)

val remainder : t -> by:t -> t
(** Get the remainder after division. Here are bunch of examples of dividing by four:

    Use {!Int.modulo} for a different treatment of negative numbers.

    {2 Examples}

    {[
      List.map
        ~f:(Int.remainder ~by:4)
        [(-5); (-4); (-3); (-2); (-1); 0; 1; 2; 3; 4; 5] =
          [(-1); 0; (-3); (-2); (-1); 0; 1; 2; 3; 0; 1]
    ]}
*)

val maximum : t -> t -> t
(** Returns the larger of two [int]s.

    {2 Examples}

    {[Int.maximum 7 9 = 9]}
    {[Int.maximum (-4) (-1) = (-1)]}
*)

val minimum : t -> t -> t
(** Returns the smaller of two [int]s.

    {2 Examples}

    {[Int.minimum 7 9 = 7]}
    {[Int.minimum (-4) (-1) = (-4)]}
*)

(** {1 Query} *)

val is_even : t -> bool
(** Check if an [int] is even.

    {2 Examples}

    {[Int.is_even 8 = true]}
    {[Int.is_even 7 = false]}
    {[Int.is_even 0 = true]}
*)

val is_odd : t -> bool
(** Check if an [int] is odd.

  {2 Examples}

  {[Int.is_odd 7 = true]}
  {[Int.is_odd 8 = false]}
  {[Int.is_odd 0 = false]}
*)

val clamp : t -> lower:t -> upper:t -> t
(** Clamps [n] within the inclusive [lower] and [upper] bounds.

  {3 Exceptions}

  Throws an [Invalid_argument] exception if [lower > upper]

  {2 Examples}

  {[Int.clamp ~lower:0 ~upper:8 5 = 5]}
  {[Int.clamp ~lower:0 ~upper:8 9 = 8]}
  {[Int.clamp ~lower:(-10) ~upper:(-5) 5 = (-5)]}
*)

val in_range : t -> lower:t -> upper:t -> bool
(** Checks if [n] is between [lower] and up to, but not including, [upper].

    {3 Exceptions}

    Throws an [Invalid_argument] exception if [lower > upper]

    {2 Examples}

    {[Int.in_range ~lower:2 ~upper:4 3 = true]}
    {[Int.in_range ~lower:5 ~upper:8 4 = false]}
    {[Int.in_range ~lower:(-6) ~upper:(-2) (-3) = true]}

*)

(** {1 Convert} *)

val to_float : t -> float
(** Convert an [int] into a [float]. Useful when mixing {!Int} and {!Float} values like this:

    {2 Examples}

    {[
      let half_of (number : int) : float =
        Float.((Int.to_float number) / 2.)
        (* Note that locally opening the {!Float} module here allows us to use the floating point division operator *)
      in
      half_of 7 = 3.5
    ]}
*)

val to_string : t -> string
(** Convert an [int] into a [string] representation.

    Guarantees that

    {[Int.(from_string (to_string n)) = Some n ]}

    {2 Examples}

    {[Int.to_string 3 = "3"]}
    {[Int.to_string (-3) = "-3"]}
    {[Int.to_string 0 = "0"]}
*)

(** {1 Compare} *)

val equal : t -> t -> bool
(** Test two [int]s for equality. *)

val compare : t -> t -> int
(** Compare two [int]s. *)

(** The unique identity for {!Comparator}. *)
type identity

val comparator : (t, identity) TableclothComparator.t
