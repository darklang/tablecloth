(** *)

(** An [int] is a whole number.

    Rescript's has a 32-bit {{: https://en.wikipedia.org/wiki/Signed_number_representations } signed } {{: https://en.wikipedia.org/wiki/Integer } integer}.
    Largegest [int] value is 2^31 - 1 === [2_147_483_647], and smallest is -2^31 - 1 === [-2_147_483_647]

    [int]s are subject to {{: https://en.wikipedia.org/wiki/Integer_overflow } overflow }, meaning that [Int.maximumValue + 1 == Int.minimumValue].

    If you work with integers larger than {!minimumValue} and smaller than {!maximumValue} you can use the {!Int} module.
    If you need to work with larger numbers, concider using {!Float} since they are signed 64-bit [float]s and limited by
    [1.79E+308], or 1.7976931348623157 * 10^308 at the upper end and [5E-324] at the lower.

    Valid syntax for [int]s includes:
    {[
      0
      42
      9000
      1_000_000
      1_000_000
      0xFF // 255 in hexadecimal
      0x000A // 10 in hexadecimal
   ]}

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

val maximumValue : t
(** The maximum representable [int] on the current platform. *)

val minimumValue : t
(** The minimum representable [int] on the current platform. *)

(** {1 Create} *)

val fromString : string -> t option
(** Attempt to parse a [string] into a [int].

    {2 Examples}

    {[
      Int.fromString("0") == Some(0)
      Int.fromString("42") == Some(42)
      Int.fromString("-3") == Some(-3)
      Int.fromString("123_456") == Some(123_456)
      Int.fromString("0xFF") == Some(255)
      Int.fromString("0x00A") == Some(10)
      Int.fromString("Infinity") == None
      Int.fromString("NaN") == None
    ]}
*)

(** {1 Operators} *)

val add : t -> t -> t
(** Add two {!Int} numbers.

    You {e cannot } add an [int] and a [float] directly though.

    See {!Float.add} for why, and how to overcome this limitation.

    {2 Examples}

    {[
      Int.add(3002, 4004) == 7006
    ]}
*)

val subtract : t -> t -> t
(** Subtract numbers.
    
    {2 Examples}

    {[
      Int.subtract(4, 3) == 1
    ]}
*)

val multiply : t -> t -> t
(** Multiply [int]s.
    
    {2 Examples}

    {[
      Int.multiply(2, 7) == 14
    ]}
*)

val divide : t -> by:t -> t
(** Integer division.

    Notice that the remainder is discarded.

    {3 Exceptions}

    Throws [Division_by_zero] when the divisor is [0].

    {2 Examples}

    {[
      Int.divide(3, ~by=2) == 1
    ]}
*)

val divideFloat : t -> by:t -> float
(** Floating point division

    {2 Examples}

    {[
      Int.divideFloat(3, ~by=2) == 1.5
      Int.divideFloat(27, ~by=5) == 5.25
      Int.divideFloat(8, ~by=4) == 2.0
    ]}
*)

val power : base:t -> exponent:t -> t
(** Exponentiation, takes the base first, then the exponent.

    {2 Examples}

    {[
      Int.power(~base=7, ~exponent=3) == 343
    ]}
*)

val negate : t -> t
(** Flips the 'sign' of an integer so that positive integers become negative and negative integers become positive. Zero stays as it is.

    {2 Examples}

    {[
      Int.negate(8) == -8
      Int.negate(-7) == 7
      Int.negate(0) == 0
    ]}
*)

val absolute : t -> t
(** Get the {{: https://en.wikipedia.org/wiki/Absolute_value } absolute value } of a number.

    {2 Examples}

    {[
      Int.absolute(8) == 8
      Int.absolute(-7) == 7
      Int.absolute(0) == 0
    ]}
*)

val modulo : t -> by:t -> t
(** Perform {{: https://en.wikipedia.org/wiki/Modular_arithmetic } modular arithmetic }.

    {b Note:} {!modulo} is not [%] JS operator. If you want [%], use {!remainder}

    If you intend to use [modulo] to detect even and odd numbers consider using {!Int.isEven} or {!Int.isOdd}.

    The [modulo] function works in the typical mathematical way when you run into negative numbers

    Use {!Int.remainder} for a different treatment of negative numbers.

    {2 Examples}

    {[
      Int.modulo(-4, ~by=3) == 2
      Int.modulo(-3, ~by=3) == 0
      Int.modulo(-2, ~by=3) = 1
      Int.modulo(-1, ~by=3) == 2
      Int.modulo(0, ~by=3) == 0
      Int.modulo(1, ~by=3) == 1
      Int.modulo(2, ~by=3) == 2
      Int.modulo(3, ~by=3) == 0
      Int.modulo(4, ~by=3) == 1
    ]}
*)

val remainder : t -> by:t -> t
(** Get the remainder after division. Works the same as [%] JS operator

    Use {!Int.modulo} for a different treatment of negative numbers.

    The sign of the result is the same as the sign 
    of the dividend ([~by]) while with a {!modulo} the sign 
    of the result is the same as the divisor ([t]).

    {2 Examples}

    {[
      Array.map([-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5], ~f=Int.remainder(~by=4)) ==
      [-1, 0, -3, -2, -1, 0, 1, 2, 3, 0, 1]
   ]}
*)

val maximum : t -> t -> t
(** Returns the larger of two [int]s.

    {2 Examples}

    {[
      Int.maximum(7, 9) == 9
      Int.maximum(-4, -1) == -1
    ]}
*)

val minimum : t -> t -> t
(** Returns the smaller of two [int]s.

    {2 Examples}

    {[
      Int.minimum(7, 9) == 7
      Int.minimum(-4, -1) == -4
    ]}
*)

(** {1 Query} *)

val isEven : t -> bool
(** Check if an [int] is even.

    {2 Examples}

    {[
      Int.isEven(8) == true
      Int.isEven(7) == false
      Int.isEven(0) == true
    ]}
*)

val isOdd : t -> bool
(** Check if an [int] is odd.

  {2 Examples}

  {[
      Int.isOdd(7) == true
      Int.isOdd(8) == false
      Int.isOdd(0) == false
    ]}
*)

val clamp : t -> lower:t -> upper:t -> t
(** Clamps [n] within the inclusive [lower] and [upper] bounds.

  {3 Exceptions}

  Throws an [Invalid_argument] exception if [lower > upper]

  {2 Examples}

  {[
      Int.clamp(5, ~lower=0, ~upper=8) == 5
      Int.clamp(9, ~lower=0, ~upper=8) == 8
      Int.clamp(5, ~lower=-10, ~upper=-5) == -5
    ]}
*)

val inRange : t -> lower:t -> upper:t -> bool
(** Checks if [n] is between [lower] and up to, but not including, [upper].

    {3 Exceptions}

    Throws an [Invalid_argument] exception if [lower > upper]

    {2 Examples}

    {[
      Int.inRange(3, ~lower=2, ~upper=4) == true
      Int.inRange(4, ~lower=5, ~upper=8) == false
      Int.inRange(-3, ~lower=-6, ~upper=-2) == true
    ]}

*)

(** {1 Convert} *)

val toFloat : t -> float
(** Convert an [int] into a [float]. Useful when mixing {!Int} and {!Float} values like this:

    {2 Examples}

    {[
      let halfOf = (number: int): float => Int.toFloat(number) /. 2.

      halfOf(7) == 3.5
   ]}
*)

val toString : t -> string
(** Convert an [int] into a [string] representation.

    Guarantees that

    {[
      n->Int.toString->Int.fromString == Some(n)
    ]}

    {2 Examples}

    {[
      Int.toString(3) == "3"
      Int.toString(-3) == "-3"
      Int.toString(0) == "0"
    ]}
*)

(** {1 Compare} *)

val equal : t -> t -> bool
(** Test two [int]s for equality. *)

val compare : t -> t -> int
(** Compare two [int]s. *)

(** The unique identity for {!Comparator}.*)
type identity

val comparator : (t, identity) TableclothComparator.t
