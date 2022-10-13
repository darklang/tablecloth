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
  if index < 0 || index >= Js.String.length string
  then None
  else Some string.[index]


let fromArray characters =
  Js.Array.joinWith
    ""
    (Array.map
       (fun character ->
         TableclothChar.toCode character |> Js.String.fromCharCode )
       characters )


let fromList t =
  Js.Array.joinWith
    ""
    (Array.map
       (fun character ->
         TableclothChar.toCode character |> Js.String.fromCharCode )
       (Array.of_list t) )


let fromChar c = TableclothChar.toCode c |> Js.String.fromCharCode

let indexOf haystack needle : int option =
  let result = Js.String.indexOf needle haystack in
  if result = -1 then None else Some result


let indexOfRight haystack needle : int option =
  let result = Js.String.lastIndexOf needle haystack in
  if result = -1 then None else Some result


let isEmpty t = t = ""

let length = Js.String.length

let uncons s =
  match s with
  | "" ->
      None
  | s ->
      Some (s.[0], String.sub s 1 (Js.String.length s - 1))


let dropLeft s ~count = Js.String.substr ~from:count s

let dropRight s ~count =
  if count < 1 then s else Js.String.slice ~from:0 ~to_:(-count) s


let split t ~on = Js.String.split on t |> Array.to_list

let endsWith t ~suffix = Js.String.endsWith suffix t

let startsWith t ~prefix = Js.String.startsWith prefix t

let trim = Js.String.trim

external trimLeft : string -> string = "trimStart" [@@bs.send]

external trimRight : string -> string = "trimEnd" [@@bs.send]

external padLeft : string -> int -> string -> string = "padStart" [@@bs.send]

let padLeft string count ~with_ = padLeft string count with_

external padRight : string -> int -> string -> string = "padEnd" [@@bs.send]

let padRight string count ~with_ = padRight string count with_

let toLowercase = Js.String.toLowerCase

let toUppercase = Js.String.toUpperCase

let uncapitalize str =
  Js.String.toLowerCase (Js.String.charAt 0 str)
  ^ Js.String.sliceToEnd ~from:1 str


let capitalize str =
  Js.String.toUpperCase (Js.String.charAt 0 str)
  ^ Js.String.sliceToEnd ~from:1 str


let isCapitalized s = s = capitalize s

let includes t ~substring = Js.String.includes substring t

let repeat s ~count = Js.String.repeat count s

let reverse s =
  Js.Array.joinWith "" (Js.Array.reverseInPlace (Js.String.split "" s))


let toArray (t : string) : char array =
  Js.String.castToArrayLike t
  |> Js.Array.from
  |> Js.Array.map (fun characterString ->
         TableclothChar.fromString characterString |> Belt.Option.getExn )


let toList (s : string) : char list = toArray s |> Belt.List.fromArray

let slice ?to_ (t : string) ~from : string =
  Js.String.slice ~from ~to_:(Belt.Option.getWithDefault to_ (length t)) t


let insertAt t ~index ~value =
  Js.String.slice ~from:0 ~to_:index t
  ^ value
  ^ Js.String.sliceToEnd ~from:index t


let forEach t ~f = Array.iter f (toArray t)

let fold t ~initial ~f = Belt.Array.reduce (toArray t) initial f

let equal = ( = )

let compare = compare
