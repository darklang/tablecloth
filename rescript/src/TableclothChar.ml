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

let fromCode i : char option =
  if 0 <= i && i <= 255 then Some (Char.chr i) else None


let toString c = String.make 1 c

let fromString str : char option =
  match String.length str with 1 -> Some str.[0] | _ -> None


let toDigit char =
  match char with '0' .. '9' -> Some (toCode char - toCode '0') | _ -> None


let toLowercase char =
  match char with
  | 'A' .. 'Z' ->
      Char.chr (toCode 'a' + (toCode char - toCode 'A'))
  | _ ->
      char


let toUppercase char =
  match char with
  | 'a' .. 'z' ->
      Char.chr (toCode 'A' + (toCode char - toCode 'a'))
  | _ ->
      char


let isLowercase = function 'a' .. 'z' -> true | _ -> false

let isUppercase = function 'A' .. 'Z' -> true | _ -> false

let isLetter = function 'a' .. 'z' | 'A' .. 'Z' -> true | _ -> false

let isDigit = function '0' .. '9' -> true | _ -> false

let isAlphanumeric = function
  | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' ->
      true
  | _ ->
      false


let isPrintable = function ' ' .. '~' -> true | _ -> false

let isWhitespace = function
  | '\t' | '\n' | '\011' | '\012' | '\r' | ' ' ->
      true
  | _ ->
      false


let equal = ( = )

let compare = compare
