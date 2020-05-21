type 'a t = 'a option

let some a = Some a

let isSome = Belt.Option.isSome

let is_some = isSome

let isNone = Belt.Option.isNone

let is_none = isNone

let or_ ta tb = match isSome ta with true -> ta | false -> tb

let orElse ta tb = match isSome tb with true -> tb | false -> ta

let or_else = orElse

let and_ ta tb = match isSome ta with true -> tb | false -> ta

let andThen t ~f = match t with None -> None | Some x -> f x

let and_then = andThen

let flatten = function Some option -> option | None -> None

let both a b = match (a, b) with Some a, Some b -> Some (a, b) | _ -> None

let map t ~f = Belt.Option.map t f

let map2 a b ~f = match (a, b) with Some a, Some b -> Some (f a b) | _ -> None

let get t ~default = Belt.Option.getWithDefault t default

let getOrFailWith t ~exn =
  match t with Some value -> value | None -> raise exn


let getUnsafe =
  getOrFailWith ~exn:(Invalid_argument "Option.getUnsafe called with None")


let get_unsafe = getUnsafe

let toArray t = match t with None -> [||] | Some value -> [| value |]

let to_array = toArray

let toList t = match t with None -> [] | Some value -> [ value ]

let to_list = toList

let forEach t ~f = match t with None -> () | Some x -> f x

let for_each = forEach

let equal equal a b =
  match (a, b) with
  | None, None ->
      true
  | Some a', Some b' ->
      equal a' b'
  | _ ->
      false


let compare compare a b =
  match (a, b) with
  | None, None ->
      0
  | Some a', Some b' ->
      compare a' b'
  | None, Some _ ->
      -1
  | Some _, None ->
      1


let ( |? ) t default = get t ~default

let ( >>| ) t f = map t ~f

let ( >>= ) t f = andThen t ~f
