module Comparator = TableclothComparator

type t = string

include TableclothComparator.Make (struct
  type nonrec t = t

  let compare = compare
end)

let initialize length ~f = Base.List.init length ~f |> Base.String.of_char_list

let repeat t ~count = Base.List.init count ~f:(fun _ -> t) |> Base.String.concat

let from_char = Base.String.of_char

let from_array characters =
  let open Base in
  Array.to_list characters |> String.of_char_list


let from_list = Base.String.of_char_list

let length = String.length

let is_empty t = length t = 0

let get = Base.String.get

let get_at a ~index =
  if index >= 0 && index < length a
  then Some (Base.String.get a index)
  else None


let ( .?[] ) (string : string) (index : int) : char option =
  get_at string ~index


let uncons (s : string) : (char * string) option =
  match s with
  | "" ->
      None
  | s ->
      Some (s.[0], String.sub s 1 (String.length s - 1))


let drop_left (s : string) ~(count : int) : string =
  Base.String.drop_prefix s count


let drop_right (s : string) ~(count : int) : string =
  Base.String.drop_suffix s count


let split t ~(on : string) : string list =
  Str.split_delim (Str.regexp_string on) t


let starts_with t ~prefix = Base.String.is_prefix ~prefix t

let ends_with t ~suffix = Base.String.is_suffix ~suffix t

let to_lowercase (s : string) : string = String.lowercase_ascii s

let to_uppercase (s : string) : string = String.uppercase_ascii s

let uncapitalize (s : string) : string = String.uncapitalize_ascii s

let capitalize (s : string) : string = String.capitalize_ascii s

let is_capitalized (s : string) : bool = s = String.capitalize_ascii s

let includes t ~substring : bool = Base.String.is_substring t ~substring

let reverse = Base.String.rev

let slice ?(to_ = 0) str ~from = String.sub str from (to_ - from)

let index_of haystack needle =
  Base.String.Search_pattern.index
    ~pos:0
    ~in_:haystack
    (Base.String.Search_pattern.create needle)


let index_of_right haystack needle =
  Base.String.Search_pattern.index_all
    ~may_overlap:false
    ~in_:haystack
    (Base.String.Search_pattern.create needle)
  |> Base.List.last


let insert_at t ~(index : int) ~(value : string) : string =
  let length = length t in
  (* Handle overflow *)
  let index = if index > length then length else index in
  (* Negative is an index from the end *)
  let index = if index < 0 then length + index else index in
  (* Handle case where it's still less than zero *)
  let index = if index < 0 then 0 else index in
  let start_count = index in
  let end_count = length - index in
  let start = drop_right ~count:end_count t in
  let end_ = drop_left ~count:start_count t in
  String.concat "" [ start; value; end_ ]


let to_array string = Base.String.to_list string |> Array.of_list

let to_list = Base.String.to_list

let trim string = Base.String.strip string

let trim_left string = Base.String.lstrip string

let trim_right string = Base.String.rstrip string

let pad_left string target_length ~with_ =
  if length string >= target_length
  then string
  else
    let padding_length = target_length - length string in
    let count = padding_length / length with_ in
    let padding = slice (repeat with_ ~count) ~from:0 ~to_:padding_length in
    padding ^ string


let pad_right string target_length ~with_ =
  if length string >= target_length
  then string
  else
    let padding_length = target_length - length string in
    let count = padding_length / length with_ in
    let padding = slice (repeat with_ ~count) ~from:0 ~to_:padding_length in
    string ^ padding


let pad_right = pad_right

let for_each = Base.String.iter

let fold s ~initial ~f = Base.String.fold s ~init:initial ~f

let equal = Base.String.equal

let compare = Base.String.compare
