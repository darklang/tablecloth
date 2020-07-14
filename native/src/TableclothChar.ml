module Comparator = TableclothComparator

type t = char

include TableclothComparator.Make (struct
  type nonrec t = t

  let compare = compare
end)

let toCode (c : char) = (Base.Char.to_int c : int)

let to_code = toCode

let fromCode (i : int) =
  (if 0 <= i && i <= 255 then Some (Char.chr i) else None : char option)


let from_code = fromCode

let toString = Base.Char.to_string

let to_string = toString

let fromString (str : string) =
  (match String.length str with 1 -> Some str.[0] | _ -> None : char option)


let from_string = fromString

let toDigit char =
  match char with '0' .. '9' -> Some (toCode char - toCode '0') | _ -> None


let to_digit = toDigit

let toLowercase = Base.Char.lowercase

let to_lowercase = toLowercase

let toUppercase = Base.Char.uppercase

let to_uppercase = toUppercase

let isLowercase = Base.Char.is_lowercase

let is_lowercase = isLowercase

let isUppercase = Base.Char.is_uppercase

let is_uppercase = isUppercase

let isLetter = Base.Char.is_alpha

let is_letter = isLetter

let isDigit = Base.Char.is_digit

let is_digit = isDigit

let isAlphanumeric = Base.Char.is_alphanum

let is_alphanumeric = isAlphanumeric

let isPrintable = Base.Char.is_print

let is_printable = isPrintable

let isWhitespace = Base.Char.is_whitespace

let is_whitespace = isWhitespace

let equal : char -> char -> bool = ( = )

let compare = compare
