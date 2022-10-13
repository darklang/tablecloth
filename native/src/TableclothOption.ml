type 'a t = 'a option

let some a = Some a

let is_some = Option.is_some

let is_none = Option.is_none

let and_ ta tb = match is_some ta with true -> tb | false -> None

let or_ ta tb = match is_some ta with true -> ta | false -> tb

let or_else ta tb = match is_some tb with true -> tb | false -> ta

let and_then t ~f = match t with Some x -> f x | None -> None

let flatten = Option.join

let both a b = match (a, b) with Some a, Some b -> Some (a, b) | _ -> None

let map t ~f = Option.map f t

let map2 (ta : 'a t) (tb : 'b t) ~(f : 'a -> 'b -> 'c) : 'c t =
  match (ta, tb) with Some a, Some b -> Some (f a b) | _ -> None


let unwrap t ~default = match t with None -> default | Some value -> value

let unwrap_unsafe x =
  match x with
  | None ->
      raise (Invalid_argument "Option.unwrap_unsafe called with None")
  | Some x ->
      x


let tap t ~f = Option.iter f t

let to_array t = match t with None -> [||] | Some value -> [| value |]

let to_list t = match t with None -> [] | Some value -> [ value ]

let equal equal a b =
  match (a, b) with
  | None, None ->
      true
  | Some a', Some b' ->
      equal a' b'
  | _ ->
      false


let compare ~f:compare a b =
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

let ( >>= ) t f = and_then t ~f
