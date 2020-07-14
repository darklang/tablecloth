type t = bool

let fromInt i = match i with 0 -> Some false | 1 -> Some true | _ -> None

let from_int = fromInt

let fromString string =
  match string with "false" -> Some false | "true" -> Some true | _ -> None


let from_string = fromString

external ( && ) : bool -> bool -> bool = "%sequand"

external ( || ) : bool -> bool -> bool = "%sequor"

let xor a b = (a && not b) || ((not a) && b)

let not = not

let equal = ( = )

let compare = compare

let toString = function true -> "true" | false -> "false"

let to_string = toString

let toInt t = match t with true -> 1 | false -> 0

let to_int = toInt
