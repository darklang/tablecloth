type ('a, 'b) t = 'a * 'b

let make a b = (a, b)

let from_array array =
  match array with
  | [||] | [| _ |] ->
      None
  | [| a; b |] ->
      Some (a, b)
  | _ ->
      Some (array.(0), array.(1))


let from_array = from_array

let from_list list =
  match list with [] | [ _ ] -> None | a :: b :: _rest -> Some (a, b)


let first (a, _) = a

let second (_, b) = b

let map_first (a, b) ~f = (f a, b)

let map_second (a, b) ~f = (a, f b)

let map_each (a, b) ~f ~g = (f a, g b)

let map_all (a1, a2) ~f = (f a1, f a2)

let swap (a, b) = (b, a)

let to_array (a, b) = [| a; b |]

let to_list (a, b) = [ a; b ]

let equal equal_first equal_second (a, b) (a', b') =
  equal_first a a' && equal_second b b'


let compare ~f:compare_first ~g:compare_second (a, b) (a', b') =
  match compare_first a a' with 0 -> compare_second b b' | result -> result
