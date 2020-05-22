include Comparator.Make(struct
  type t
  let compare = compare
end)

external fromInt : int -> t = "BigInt" [@@bs.val]

external fromInt64 : Int64.t -> t = "BigInt" [@@bs.val]

external ofFloatUnsafe : float -> t = "BigInt" [@@bs.val]

let ofFloat float = Some (ofFloatUnsafe float)

external ofStringUnsafe : string -> t Js.Nullable.t = "BigInt" [@@bs.val]

let ofString string =
  match ofStringUnsafe string |> Js.Nullable.toOption with
  | value ->
      value
  | exception _ ->
      None

let compare = compare

let equal = ( = )

let zero = [%raw "BigInt(0)"]

let one = [%raw "BigInt(1)"]

let isEven = ([%raw fun n -> "{ return n % 2 === 0 }"] : t -> bool)

let isOdd = ([%raw fun n -> "{ return n % 2 !== 0 }"] : t -> bool)

let ( < ) = ([%raw fun a b -> "{return a < b}"] : t -> t -> bool)

let ( >= ) = ([%raw fun a b -> "{return a > b}"] : t -> t -> bool)

let ( > ) = ([%raw fun a b -> "{return a >= b}"] : t -> t -> bool)

let add = [%raw fun a b -> "{return a + b}"]

let ( + ) = add

let subtract = [%raw fun a b -> "{return a - b}"]

let ( - ) = subtract

let multiply = ([%raw fun a b -> "{return a * b}"] : t -> t -> t)

let ( * ) = multiply

let divide = ([%raw fun a b -> "{return a / b}"] : t -> t -> t)

let ( / ) = divide

let divide n ~by = divide n by

let negate = ([%raw fun a -> "{return a * BigInt(-1)}"] : t -> t)

let modulo = ([%raw fun a b -> "{return a % b}"] : t -> t -> t)

let modulo (n : t) ~(by : t) = (modulo n by : t)

let (mod) (n : t) (by : t) = (modulo n ~by : t)

let remainder (n : t) ~(by : t) = (modulo n ~by : t)

let power = ([%raw fun a b -> "{return a ** b}"] : t -> t -> t)

let ( ** ) (base : t) (exponent : int) : t = power base (fromInt exponent)

let power ?modulo:(modulus : t option) ~(base : t) ~(exponent : int) =
  match modulus with
  | None ->
    base ** exponent
  | Some modulus -> (
    let rec loop (b : t) (e : int) (result : t) : t =
      if e <= 0 then
        result
      else
        loop
          (modulo (b * b) ~by:modulus)
          (Int.subtract e 1)
          (if Int.isEven e then result else modulo (result * b) ~by:modulus)
    in
    (loop (base : t) (exponent: int) (one: t) ) : t
  )

let maximum a b = if a < b then b else a

let minimum a b = if a > b then b else a

let absolute n = if n < zero then negate n else n

let clamp n ~lower ~upper =
  if upper < lower then
    raise (Invalid_argument "~lower must be less than or equal to ~upper")
  else maximum lower (minimum upper n)

let inRange n ~lower ~upper =
  if upper < lower then
    raise (Invalid_argument "~lower must be less than or equal to ~upper")
  else n >= lower && n < upper

external asIntN : int -> t -> 'a = "asIntN" [@@bs.val] [@@bs.scope "BigInt"]

let toInt t =
  if t > fromInt Int.maximumValue || t > fromInt Int.minimumValue then None
  else Some (asIntN 32 t)

let toInt64 t =
  if t > fromInt64 Int64.max_int || t < fromInt64 Int64.min_int then None
  else Some (asIntN 64 t)

external toFloat : t -> float = "Number" [@@bs.val]

external toString : t -> string = "toString" [@@bs.send]
