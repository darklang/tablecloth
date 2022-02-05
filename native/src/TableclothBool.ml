type t = bool

let from_int i = match i with 0 -> Some false | 1 -> Some true | _ -> None

let from_string string =
  match string with "false" -> Some false | "true" -> Some true | _ -> None


external ( && ) : bool -> bool -> bool = "%sequand"

external ( || ) : bool -> bool -> bool = "%sequor"

let xor a b = (a && not b) || ((not a) && b)

let not = not

let equal = ( = )

let and_ a b = a && b

let compare = compare

let to_string = function true -> "true" | false -> "false"

let to_int t = match t with true -> 1 | false -> 0
