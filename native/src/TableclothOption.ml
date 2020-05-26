type 'a t = 'a option

let some a = Some a

let isSome = Option.is_some

let is_some = isSome

let isNone = Option.is_none

let is_none = isNone

let and_ ta tb = match isSome ta with true -> tb | false -> None

let or_ ta tb = match isSome ta with true -> ta | false -> tb

let orElse ta tb = match isSome tb with true -> tb | false -> ta

let or_else = orElse

let andThen t ~f = match t with Some x -> f x | None -> None

let and_then = andThen

let flatten = Option.join

let both a b = match (a, b) with Some a, Some b -> Some (a, b) | _ -> None

let map t ~f = Option.map f t

let map2 (ta : 'a t) (tb : 'b t) ~(f : 'a -> 'b -> 'c) =
  (match (ta, tb) with Some a, Some b -> Some (f a b) | _ -> None : 'c t)


let unwrap t ~default = match t with None -> default | Some value -> value

let unwrapUnsafe x =
  match x with
  | None ->
      raise (Invalid_argument "Option.unwrapUnsafe called with None")
  | Some x ->
      x


let unwrap_unsafe = unwrapUnsafe

let forEach t ~f = Option.iter f t

let for_each = forEach

let toArray t = match t with None -> [||] | Some value -> [| value |]

let to_array = toArray

let toList t = match t with None -> [] | Some value -> [ value ]

let to_list = toList

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


let ( |? ) t default = unwrap t ~default

let ( >>| ) t f = map t ~f

let ( >>= ) t f = andThen t ~f
