type t = int

include TableclothComparator.Make (struct
  type nonrec t = t

  let compare = compare
end)

let minimum_value = Base.Int.min_value

let maximum_value = Base.Int.max_value

let zero = 0

let one = 1

let add = ( + )

let ( + ) = ( + )

let subtract = ( - )

let ( - ) = ( - )

let multiply = ( * )

let ( * ) = multiply

let divide n ~by = n / by

let ( / ) = ( / )

let ( /. ) = Base.Int.( // )

let divide_float ~by n = Base.Int.(n // by)

let power ~base ~exponent = Base.Int.(base ** exponent)

let ( ** ) = Base.Int.( ** )

let negate = ( ~- )

let ( ~- ) = ( ~- )

let modulo n ~by = (if n < 0 then 2 * abs n else n) mod by

let ( mod ) n by = modulo n ~by

let remainder n ~by = Base.Int.rem n by

let maximum = Base.Int.max

let minimum = Base.Int.min

let absolute n = if n < 0 then n * -1 else n

let is_even n = n mod 2 = 0

let is_odd n = n mod 2 <> 0

let clamp n ~lower ~upper =
  if upper < lower
  then
    raise
      (Invalid_argument
         ( "~lower:"
         ^ Base.Int.to_string lower
         ^ " must be less than or equal to ~upper:"
         ^ Base.Int.to_string upper ) )
  else max lower (min upper n)


let in_range n ~lower ~upper =
  if upper < lower
  then
    raise
      (Invalid_argument
         ( "~lower:"
         ^ Base.Int.to_string lower
         ^ " must be less than or equal to ~upper:"
         ^ Base.Int.to_string upper ) )
  else n >= lower && n < upper


let to_float = Base.Int.to_float

let to_string = Base.Int.to_string

let from_string str = try Some (int_of_string str) with _ -> None

let equal = ( = )

let compare = compare
