type t = Z.t

include Comparator.Make(struct
  type nonrec t = t
  let compare = Z.compare
end)

let fromInt = Z.of_int

let fromInt64 = Z.of_int64

let ofFloat float =
  match Z.of_float float with
  | integer ->
      Some integer
  | exception Z.Overflow ->
      None

let ofString string =
  match Z.of_string string with value -> Some value | exception _ -> None

let zero = Z.zero

let one = Z.one

let isEven t =
  let open Z in
  t mod ~$2 = zero

let isOdd t =
  let open Z in
  t mod ~$2 <> zero

let add = Z.add

let ( + ) = Z.( + )

let subtract = Z.sub

let ( - ) = subtract

let multiply = Z.mul

let ( * ) = multiply

let divide = Z.div

let ( / ) = divide

let divide n ~by = divide n by

let negate = Z.neg

let modulo (n : t) ~(by : t) : t = (Z.rem n by)

let (mod) (n : t) (by : t) : t = (Z.rem n by)

let remainder (n : t) ~(by : t) = (Z.rem n by)

let ( ** ) = Z.( ** )

let power ?modulo ~(base : t) ~(exponent : int) =
  match modulo with
  | Some modulus ->
      Z.powm base (fromInt exponent) modulus
  | None ->
      Z.pow base exponent

let maximum a b = if a < b then b else a

let minimum a b = if a > b then b else a

let absolute n = if n < zero then negate n else n

let clamp n ~lower ~upper =
  if upper < lower then
    raise (Invalid_argument "~lower must be less than or equal to ~upper")
  else max lower (min upper n)

let inRange n ~lower ~upper =
  if upper < lower then
    raise (Invalid_argument "~lower must be less than or equal to ~upper")
  else n >= lower && n < upper

let toInt t = if t > fromInt Int.maximumValue then None else Some (Z.to_int t)

let toInt64 t =
  if t > fromInt64 Int64.max_int then None else Some (Z.to_int64 t)

let toFloat = Z.to_float

let toString = Z.to_string

let equal = Z.equal

let compare = Z.compare
