type ('a, 'b) t = 'a * 'b

let make a b = (a, b)

let fromArray array =
  match array with
  | [||] | [| _ |] ->
      None
  | [| a; b |] ->
      Some (a, b)
  | _ ->
      None


let from_array = fromArray

let fromList list =
  match list with [] | [ _ ] -> None | a :: b :: _rest -> Some (a, b)


let from_list = fromList

let first (a, _) = a

let second (_, b) = b

let mapFirst (a, b) ~f = (f a, b)

let map_first = mapFirst

let mapSecond (a, b) ~f = (a, f b)

let map_second = mapSecond

let mapEach (a, b) ~f ~g = (f a, g b)

let map_each = mapEach

let mapAll (a1, a2) ~f = (f a1, f a2)

let map_all = mapAll

let swap (a, b) = (b, a)

let toArray (a, b) = [| a; b |]

let to_array = toArray

let toList (a, b) = [ a; b ]

let to_list = toList

let equal equalFirst equalSecond (a, b) (a', b') =
  equalFirst a a' && equalSecond b b'


let compare compareFirst compareSecond (a, b) (a', b') =
  match compareFirst a a' with 0 -> compareSecond b b' | result -> result
