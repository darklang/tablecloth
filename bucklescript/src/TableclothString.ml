type t = string

include TableclothComparator.Make (struct
  type nonrec t = t

  let compare = compare
end)

let initialize length ~f =
  Js.Array.joinWith
    ""
    (Array.init length (fun index -> f index |> TableclothChar.toString))


let get (string : string) (index : int) = string.[index]

let getAt (string : string) ~(index : int) =
  if index < 0 || index >= String.length string
  then None
  else Some string.[index]


let get_at = getAt

let ( .?[] ) (string : string) (index : int) : char option = getAt string ~index

let fromArray characters =
  Js.Array.joinWith
    ""
    (Array.map
       (fun character ->
         TableclothChar.toCode character |. Js.String.fromCharCode)
       characters)


let from_array = fromArray

let fromList t =
  Js.Array.joinWith
    ""
    (Array.map
       (fun character ->
         TableclothChar.toCode character |. Js.String.fromCharCode)
       (Array.of_list t))


let from_list = fromList

let fromChar c = TableclothChar.toCode c |. Js.String.fromCharCode

let from_char = fromChar

let firstIndexOf (s : string) ~char:(char : char)  =
  (let result = Js.String.indexOf (TableclothChar.toCode char |. Js.String.fromCharCode) s in
   if result = (-1) then None else Some (result): 
  int option)

let first_index_of = firstIndexOf

let lastIndexOf (s : string) ~char:(char : char)  =
  (let result = Js.String.lastIndexOf (TableclothChar.toCode char |. Js.String.fromCharCode) s in
   if result = (-1) then None else Some (result): 
  int option)

let last_index_of = lastIndexOf

let isEmpty t = t = ""

let is_empty = isEmpty

let length = String.length

let uncons s =
  match s with
  | "" ->
      None
  | s ->
      Some (s.[0], String.sub s 1 (String.length s - 1))


let dropLeft s ~count = Js.String.substr ~from:count s

let drop_left = dropLeft

let dropRight s ~count =
  if count < 1 then s else Js.String.slice ~from:0 ~to_:(-count) s


let drop_right = dropRight

let split t ~on = Js.String.split on t |> Array.to_list

let endsWith t ~suffix = Js.String.endsWith suffix t

let ends_with = endsWith

let startsWith t ~prefix = Js.String.startsWith prefix t

let starts_with = startsWith

let trim = Js.String.trim

external trimLeft : string -> string = "trimStart" [@@bs.send]

let trim_left = trimLeft

external trimRight : string -> string = "trimEnd" [@@bs.send]

let trim_right = trimRight

external padLeft : string -> int -> string -> string = "padStart" [@@bs.send]

let padLeft string count ~with_ = padLeft string count with_

let pad_left = padLeft

external padRight : string -> int -> string -> string = "padEnd" [@@bs.send]

let padRight string count ~with_ = padRight string count with_

let pad_right = padRight

let toLowercase s = String.lowercase_ascii s

let to_lowercase = toLowercase

let toUppercase s = String.uppercase_ascii s

let to_uppercase = toUppercase

let uncapitalize = String.uncapitalize_ascii

let capitalize = String.capitalize_ascii

let isCapitalized s = s = String.capitalize_ascii s

let is_capitalized = isCapitalized

let includes t ~substring = Js.String.includes substring t

let repeat s ~count = Js.String.repeat count s

let reverse s =
  Js.Array.joinWith "" (Js.Array.reverseInPlace (Js.String.split "" s))


let toArray (t : string) : char array =
  Js.String.castToArrayLike t
  |. Js.Array.from
  |> Js.Array.map (fun characterString ->
         TableclothChar.fromString characterString |. Belt.Option.getExn)


let to_array = toArray

let toList (s : string) : char list = toArray s |> Belt.List.fromArray

let to_list = toList

let slice ?to_ (t : string) ~from =
  ( Js.String.slice ~from ~to_:(Belt.Option.getWithDefault to_ (length t)) t
    : string )


let insertAt t ~index ~value =
  Js.String.slice ~from:0 ~to_:index t
  ^ value
  ^ Js.String.sliceToEnd ~from:index t


let insert_at = insertAt

let forEach t ~f = Array.iter f (toArray t)

let for_each = forEach

let fold t ~initial ~f = Belt.Array.reduce (toArray t) initial f

let equal = ( = )

let compare = compare
