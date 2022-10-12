type 'a t = 'a option

let some a = Some a

let isSome = Belt.Option.isSome

let isNone = Belt.Option.isNone

let or_ ta tb = match isSome ta with true -> ta | false -> tb

let orElse ta tb = match isSome tb with true -> tb | false -> ta

let and_ ta tb = match isSome ta with true -> tb | false -> ta

let andThen t ~f = match t with None -> None | Some x -> f x

let flatten = function Some option -> option | None -> None

let both a b = match (a, b) with Some a, Some b -> Some (a, b) | _ -> None

let map t ~f = Belt.Option.map t f

let map2 a b ~f = match (a, b) with Some a, Some b -> Some (f a b) | _ -> None

let unwrap t ~default = Belt.Option.getWithDefault t default

let unwrapOrFailWith t ~exn =
  match t with Some value -> value | None -> raise exn


let unwrapUnsafe =
  unwrapOrFailWith ~exn:(Invalid_argument "Option.unwrapUnsafe called with None")


let toArray t = match t with None -> [||] | Some value -> [| value |]

let toList t = match t with None -> [] | Some value -> [ value ]

let tap t ~f = match t with None -> () | Some x -> f x

let equal a b equal =
  match (a, b) with
  | None, None ->
      true
  | Some a', Some b' ->
      equal a' b'
  | _ ->
      false


let compare a b ~f:compare =
  match (a, b) with
  | None, None ->
      0
  | Some a', Some b' ->
      compare a' b'
  | None, Some _ ->
      -1
  | Some _, None ->
      1
