type t = int

include TableclothComparator.Make (struct
  type nonrec t = t

  let compare = compare
end)

let minimumValue = Js.Int.min

let minimum_value = minimumValue

let maximumValue = Js.Int.max

let maximum_value = maximumValue

let zero = 0

let one = 1

let fromString s =
  match int_of_string s with i -> Some i | exception Failure _ -> None


let from_string = fromString

let add = ( + )

let ( + ) = ( + )

let subtract = ( - )

let ( - ) = ( - )

let multiply = ( * )

let ( * ) = multiply

let divide n ~by = n / by

let ( / ) = ( / )

let ( /. ) n by = Js.Int.toFloat n /. Js.Int.toFloat by

let power ~base ~exponent = Js.Math.pow_int ~base ~exp:exponent

let ( ** ) base exponent = Js.Math.pow_int ~base ~exp:exponent

let negate = ( ~- )

let ( ~- ) = ( ~- )

let remainder n ~by = n mod by

let ( mod ) n by = (if n <= 0 then abs n * 2 else n) mod by

let modulo n ~by = n mod by

let maximum = Js.Math.max_int

let minimum = Js.Math.min_int

let absolute = abs

let isEven n = n mod 2 = 0

let is_even = isEven

let isOdd n = n mod 2 <> 0

let is_odd = isOdd

let clamp n ~lower ~upper =
  if upper < lower
  then raise (Invalid_argument "~lower must be less than or equal to ~upper")
  else max lower (min upper n)


let inRange n ~lower ~upper =
  if upper < lower
  then raise (Invalid_argument "~lower must be less than or equal to ~upper")
  else n >= lower && n < upper


let in_range = inRange

let toFloat = Js.Int.toFloat

let to_float = toFloat

let toString = Js.Int.toString

let to_string = toString

let equal = ( = )

let compare = compare
