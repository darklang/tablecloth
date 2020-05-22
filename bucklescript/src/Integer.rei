(**
  Arbitrary precision integers.

  Backed by {{: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt } BigInt }
  when targeting Javascript and {{: https://github.com/ocaml/Zarith } Zarith } when targetting native.
*)
type t

(** {1 Create} *)

(** Create an {!Integer} from an {!Int} *)
val fromInt : int -> t

(** Create an {!Integer} from an Int64 *)
val fromInt64 : Int64.t -> t

(** Create an {!Integer} from an Int64.

    Returns [None] when called with {!Float.nan}, {!Float.infinity} or {!Float.negativeInfinity}
*)
val ofFloat : float -> t option

(** Attempt to parse a {!String} into a {!Integer}.

    {2 Examples}

    {[Integer.(ofString "0" = Some (fromInt 0))]}

    {[Integer.(ofString "42" = Some (fromInt 42))]}

    {[Integer.(ofString "-3" = Some (fromInt -3))]}

    {[Integer.(ofString "123_456" = Some (fromInt 123_456))]}

    {[Integer.(ofString "0xFF" = Some (fromInt 255))]}

    {[Integer.(ofString "0x00A" = Some (fromInt 10))]}

    {[Integer.(ofString "Infinity" = None)]}

    {[Integer.(ofString "NaN" = None)]}
*)
val ofString : string -> t option

(** {1 Constants } *)

(** The literal [0] as a named value *)
val zero : t

(** The literal [1] as a named value *)
val one : t

(** {1 Operators } *)

(** Add two {!Integer}s.

    {2 Examples}

    {[Integer.(add (fromInt 3002) (fromInt 4004) = fromInt 7006)]}

    Or using the operator:

    {[Integer.((fromInt 3002) + (fromInt 4004) = (fromInt 7006))]}
*)
val add : t -> t -> t

(** See {!Integer.add} *)
val (+) : t -> t -> t

(** Subtract numbers

    {2 Examples}

    {[Integer.(subtract one one = zero)]}

    Alternatively the operator can be used:

    {[Integer.((fromInt 4) - (fromInt 3) = one)]}
*)
val subtract : t -> t -> t

(** See {!Integer.subtract} *)
val (-) : t -> t -> t

(** Multiply two integers

    {2 Examples}

    {[Integer.(multiply (fromInt 2) (fromInt 7) = (fromInt 14))]}

    Alternatively the operator can be used:

    {[Integer.((fromInt 2) * (fromInt 7) = fromInt 14)]}
*)
val multiply : t -> t -> t

(** See {!Integer.multiply} *)
val ( * ) : t -> t -> t

(** Integer division

    Notice that the remainder is discarded.

    {3 Exceptions}

    Throws [Division_by_zero] when the divisor is [zero].

    {2 Examples}

    {[
      Integer.(divide (fromInt 3) ~by:(fromInt 2) = (fromInt 1))
    ]}

    {[
      Integer.((fromInt 27) / (fromInt 5) = (fromInt 5))
    ]}
*)
val divide : t -> by:t -> t

(** See {!Integer.divide} *)
val (/) : t -> t -> t

(** Exponentiation, takes the base first, then the exponent.

    Alternatively the [**] operator can be used.

    {2 Examples}

    {[
      Integer.(
        power ~base:(fromInt 7) ~exponent:3 ~modulo:(fromInt 300) = fromInt 43
      )
    ]}

    {[
      Integer.(
        (fromInt 7) ** 4 = fromInt 2401
      )
    ]}
*)
val power : ?modulo:t -> base:t -> exponent:int -> t

(** See {!Integer.power} *)
val ( ** ) : t -> int -> t

(** Flips the 'sign' of an integer so that positive integers become negative and negative integers become positive. Zero stays as it is.

    {2 Examples}

    {[
      Integer.(
        assert (negate (fromInt 8) = fromInt -8);
        assert (negate (fromInt -7) = fromInt 7);
        assert (negate zero = zero)
      )
    ]}
*)
val negate : t -> t

(** Get the {{: https://en.wikipedia.org/wiki/Absolute_value } absolute value } of a number.

    {2 Examples}

    {[
      Integer.(
        assert (absolute 8 = 8);
        assert (absolute (-7) = 7);
        assert (absolute 0 = 0);
      )
    ]}
*)
val absolute : t -> t

(** Perform {{: https://en.wikipedia.org/wiki/Modular_arithmetic } modular arithmetic }.

    If you intend to use [modulo] to detect even and odd numbers consider using {!Integer.isEven} or {!Integer.isOdd}.

    Our [modulo] function works in the typical mathematical way when you run into negative numbers

    Use {!Integer.remainder} for a different treatment of negative numbers.

    {2 Examples}

    {[
      Integer.(

        let three = fromInt 3 in
        let two = fromInt 2 in

        assert (modulo three ~by:three = zero);
        assert (modulo two ~by:three = two);
        assert (modulo one ~by:three = one);
        assert (modulo zero ~by:three = zero);
        assert (modulo (negate one) ~by:three = one);
        assert (modulo (negate two) ~by:three = two);
        assert (modulo (negate three) ~by:three = zero)
      )
    ]}
*)
val modulo : t -> by:t -> t

(** See {!Integer.modulo} *)
val (mod) : t -> t -> t

(** Get the remainder after division. Here are bunch of examples of dividing by four:

    Use {!Integer.modulo} for a different treatment of negative numbers.

    {2 Examples}

    {[
      Integer.(
        let three = fromInt 3 in
        let two = fromInt 2 in

        assert (remainder three ~by:three = zero);
        assert (remainder two ~by:three = two);
        assert (remainder one ~by:three = one);
        assert (remainder zero ~by:three = zero);
        assert (remainder (negate one) ~by:three = (negate one));
        assert (remainder (negate two) ~by:three = (negate two));
        assert (remainder (negate three) ~by:three = zero)
      )
    ]}
*)
val remainder : t -> by:t -> t

(** Returns the larger of two [Integers]s

    {2 Examples}

    {[Integer.(maximum (fromInt 7) (fromInt 9) = (fromInt 9))]}

    {[Integer.(maximum (fromInt -4) (fromInt -1) = (fromInt -1))]}
*)
val maximum : t -> t -> t

(** Returns the smaller of two [Integers]s

    {2 Examples}

    {[Integer.(minimum (fromInt 7) (fromInt 9) = (fromInt 7))]}

    {[Integer.(minimum (fromInt -4) (fromInt -1) = (fromInt -4))]}
*)
val minimum : t -> t -> t

(** {1 Query} *)

(** Check if an [int] is even

    {2 Examples}

    {[Integer.(isEven (fromInt 8)) = true]}

    {[Integer.(isEven (fromInt 7)) = false]}

    {[Integer.(isEven (fromInt 0)) = true]}
*)
val isEven : t -> bool

(** Check if an [int] is odd

    {2 Examples}

    {[Integer.(isOdd (fromInt 7) = true)]}

    {[Integer.(isOdd (fromInt 8) = false)]}

    {[Integer.(isOdd (fromInt 0) = false)]}
*)
val isOdd : t -> bool

(** Clamps an integer within the inclusive [lower] and [upper] bounds.

    {3 Exceptions}

    Throws an [Invalid_argument] exception if [lower > upper]

    {2 Examples}

    {[Integer.(clamp ~lower:zero ~upper:(fromInt 8) (fromInt 5) = (fromInt 5))]}

    {[Integer.(clamp ~lower:zero ~upper:(fromInt 8) (fromInt 9) = (fromInt 8))]}

    {[Integer.(clamp ~lower:(fromInt -10) ~upper:(fromInt -5) (fromInt 5) = (fromInt -5))]}
*)
val clamp : t -> lower:t -> upper:t -> t

(** Checks if an integer is between [lower] and up to, but not including, [upper].

    {3 Exceptions}

    Throws an [Invalid_argument] exception if [lower > upper]

    {2 Examples}

    {[Integer.(inRange ~lower:(fromInt 2) ~upper:(fromInt 4) (fromInt 3) = true)]}

    {[Integer.(inRange ~lower:(fromInt 5) ~upper:(fromInt 8) (fromInt 4) = false)]}

    {[Integer.(inRange ~lower:(fromInt -6) ~upper:(fromInt -2) (fromInt -3) = true)]}
*)
val inRange : t -> lower:t -> upper:t -> bool


(** {1 Convert} *)

(** Convert an {!Integer} to an {!Int}

    Returns [None] when greater than [Int.maximumValue] or less than [Int.minimumValue]

    {2 Examples}

    {[Integer.(fromInt 4 |> toInt) = Some 4]}

    {[
      String.repeat "9" ~times:10_000
      |> Integer.ofString
      |> Option.flatMap ~f:Integer.toString
         = None
    ]}
*)
val toInt : t -> int option

(** Convert an {!Integer} to an [Int64.t]

    Returns [None] when greater than [Int64.max_int] or less than [Int64.min_int]

    {2 Examples}

    {[Integer.fromInt 1 |> Integer.toInt64 = Some Int64.one]}

    {[
      String.repeat "9" ~times:10_000
      |> Integer.ofString
      |> Option.flatMap ~f:Integer.toString
         = None
    ]}
*)
val toInt64 : t -> Int64.t option

(** Convert an {!Integer} to a {!Float}

    Returns {!Float.infinity} when greater than {!Float.largestValue}.

    {2 Examples}

    {[Integer.ofString "8" |> Integer.toFloat = 8.0]}

    {[
      String.repeat "9" ~times:10_000
      |> Integer.ofString
      |> Option.map ~f:Integer.toFloat
        = Some Float.infinity
    ]}
*)
val toFloat : t -> float

(** Gives a human-readable, decimal string representation *)
val toString : t -> string

(** {1 Compare} *)

(** Test two {!Integer}s for equality *)
val equal : t -> t -> bool

(** Compare two {!Integer}s *)
val compare : t -> t -> int

(** The unique identity for [ints] {!Comparator} *)
type identity

val comparator: (t, identity) Comparator.t