module Comparator = TableclothComparator

type t = char

include TableclothComparator.Make (struct
  type nonrec t = t

  let compare = compare
end)

let to_code (c : char) : int = Base.Char.to_int c

let from_code (i : int) : char option =
  if 0 <= i && i <= 255 then Some (Char.chr i) else None


let to_string = Base.Char.to_string

let from_string (str : string) : char option =
  match String.length str with 1 -> Some str.[0] | _ -> None


let to_digit char =
  match char with '0' .. '9' -> Some (to_code char - to_code '0') | _ -> None


let to_lowercase = Base.Char.lowercase

let to_uppercase = Base.Char.uppercase

let is_lowercase = Base.Char.is_lowercase

let is_uppercase = Base.Char.is_uppercase

let is_letter = Base.Char.is_alpha

let is_digit = Base.Char.is_digit

let is_alphanumeric = Base.Char.is_alphanum

let is_printable = Base.Char.is_print

let is_whitespace = Base.Char.is_whitespace

let equal : char -> char -> bool = ( = )

let compare = compare
