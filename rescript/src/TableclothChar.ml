(*
  This file has a `Tablecloth` prefix since it uses Stdlib.Char in its implementation.
  Without the prefix we would encounter circular reference compiler errors.
*)

type t = char

include TableclothComparator.Make (struct
  type nonrec t = t

  let compare = compare
end)

let toCode (c : char) = Char.code c

let to_code = toCode

let fromCode i =
  (if 0 <= i && i <= 255 then Some (Char.chr i) else None : char option)


let from_code = fromCode

let toString c = String.make 1 c

let to_string = toString

let fromString str =
  (match String.length str with 1 -> Some str.[0] | _ -> None : char option)


let from_string = fromString

let toDigit char =
  match char with '0' .. '9' -> Some (toCode char - toCode '0') | _ -> None


let to_digit = toDigit

let toLowercase char =
  match char with
  | 'A' .. 'Z' ->
      Char.chr (toCode 'a' + (toCode char - toCode 'A'))
  | _ ->
      char


let to_lowercase = toLowercase

let toUppercase char =
  match char with
  | 'a' .. 'z' ->
      Char.chr (toCode 'A' + (toCode char - toCode 'a'))
  | _ ->
      char


let to_uppercase = toUppercase

let isLowercase = function 'a' .. 'z' -> true | _ -> false

let is_lowercase = isLowercase

let isUppercase = function 'A' .. 'Z' -> true | _ -> false

let is_uppercase = isUppercase

let isLetter = function 'a' .. 'z' | 'A' .. 'Z' -> true | _ -> false

let is_letter = isLetter

let isDigit = function '0' .. '9' -> true | _ -> false

let is_digit = isDigit

let isAlphanumeric = function
  | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' ->
      true
  | _ ->
      false


let is_alphanumeric = isAlphanumeric

let isPrintable = function ' ' .. '~' -> true | _ -> false

let is_printable = isPrintable

let isWhitespace = function
  | '\t' | '\n' | '\011' | '\012' | '\r' | ' ' ->
      true
  | _ ->
      false


let is_whitespace = isWhitespace

let equal = ( = )

let compare = compare
