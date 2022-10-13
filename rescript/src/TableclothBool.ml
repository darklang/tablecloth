type t = bool

let fromInt i = match i with 0 -> Some false | 1 -> Some true | _ -> None

let fromString string =
  match string with "false" -> Some false | "true" -> Some true | _ -> None


let xor a b = (a && not b) || ((not a) && b)

let not = not

let and_ a b = a && b

external toString : bool -> string = "toString" [@@bs.send]

let toInt t = match t with true -> 1 | false -> 0

let compare = compare

let equal = ( = )
