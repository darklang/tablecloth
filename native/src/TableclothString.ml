type t = string

include Comparator.Make (struct
  type nonrec t = t

  let compare = compare
end)

let initialize length ~f = Base.List.init length ~f |> Base.String.of_char_list

let repeat t ~count = Base.List.init count ~f:(fun _ -> t) |> Base.String.concat

let fromChar = Base.String.of_char

let from_char = fromChar

let fromArray characters =
  let open Base in
  Array.to_list characters |> String.of_char_list


let from_array = fromArray

let fromList = Base.String.of_char_list

let from_list = fromList

let length = String.length

let isEmpty t = length t = 0

let is_empty = isEmpty

let get = Base.String.get

let getAt a ~index =
  if index >= 0 && index < length a
  then Some (Base.String.get a index)
  else None


let get_at = getAt

let ( .?[] ) (string : string) (index : int) : char option = getAt string ~index

let uncons (s : string) =
  ( match s with
    | "" ->
        None
    | s ->
        Some (s.[0], String.sub s 1 (String.length s - 1))
    : (char * string) option )


let dropLeft (s : string) ~(count : int) =
  (Base.String.drop_prefix s count : string)


let drop_left = dropLeft

let dropRight (s : string) ~(count : int) =
  (Base.String.drop_suffix s count : string)


let drop_right = dropRight

let split t ~(on : string) =
  (Str.split_delim (Str.regexp_string on) t : string list)


let startsWith t ~prefix = Base.String.is_prefix ~prefix t

let starts_with = startsWith

let endsWith t ~suffix = Base.String.is_suffix ~suffix t

let ends_with = endsWith

let toLowercase (s : string) = (String.lowercase_ascii s : string)

let to_lowercase = toLowercase

let toUppercase (s : string) = (String.uppercase_ascii s : string)

let to_uppercase = toUppercase

let uncapitalize (s : string) = (String.uncapitalize_ascii s : string)

let capitalize (s : string) = (String.capitalize_ascii s : string)

let isCapitalized (s : string) = (s = String.capitalize_ascii s : bool)

let is_capitalized = isCapitalized

let includes t ~substring = (Base.String.is_substring t ~substring : bool)

let reverse = Base.String.rev

let slice ?(to_ = 0) str ~from = String.sub str from (to_ - from)

let insertAt t ~(index : int) ~(value : string) =
  ( let length = length t in
    let startCount = index in
    let endCount = length - index in
    let start = dropRight ~count:endCount t in
    let end_ = dropLeft ~count:startCount t in
    String.concat "" [ start; value; end_ ]
    : string )


let insert_at = insertAt

let toArray string = Base.String.to_list string |> Array.of_list

let to_array = toArray

let toList = Base.String.to_list

let to_list = toList

let trim string = Base.String.strip string

let trimLeft string = Base.String.lstrip string

let trim_left = trimLeft

let trimRight string = Base.String.rstrip string

let trim_right = trimRight

let padLeft string targetLength ~with_ =
  if length string >= targetLength
  then string
  else
    let paddingLength = targetLength - length string in
    let count = paddingLength / length with_ in
    let padding = slice (repeat with_ ~count) ~from:0 ~to_:paddingLength in
    padding ^ string


let pad_left = padLeft

let padRight string targetLength ~with_ =
  if length string >= targetLength
  then string
  else
    let paddingLength = targetLength - length string in
    let count = paddingLength / length with_ in
    let padding = slice (repeat with_ ~count) ~from:0 ~to_:paddingLength in
    string ^ padding


let pad_right = padRight

let forEach = Base.String.iter

let for_each = forEach

let fold s ~initial ~f = Base.String.fold s ~init:initial ~f

let equal = Base.String.equal

let compare = Base.String.compare
