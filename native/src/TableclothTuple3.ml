type ('a, 'b, 'c) t = 'a * 'b * 'c

let make a b c = (a, b, c)

let from_array array =
  match array with
  | [||] | [| _ |] | [| _; _ |] ->
      None
  | [| a; b; c |] ->
      Some (a, b, c)
  | _ ->
      Some (array.(0), array.(1), array.(2))


let from_list list =
  match list with
  | [] | [ _ ] | [ _; _ ] ->
      None
  | a :: b :: c :: _rest ->
      Some (a, b, c)


let first (a, _, _) = a

let second (_, b, _) = b

let third (_, _, c) = c

let initial (a, b, _) = (a, b)

let tail (_, b, c) = (b, c)

let map_first (a, b, c) ~f = (f a, b, c)

let map_second (a, b, c) ~f = (a, f b, c)

let map_third (a, b, c) ~f = (a, b, f c)

let map_each (a, b, c) ~f ~g ~h = (f a, g b, h c)

let map_all (a1, a2, a3) ~f = (f a1, f a2, f a3)

let rotate_left (a, b, c) = (b, c, a)

let rotate_right (a, b, c) = (c, a, b)

let to_array (a, b, c) = [| a; b; c |]

let to_list (a, b, c) = [ a; b; c ]

let equal equal_first equal_second equal_third (a, b, c) (a', b', c') =
  equal_first a a' && equal_second b b' && equal_third c c'


let compare
    ~f:compare_first ~g:compare_second ~h:compare_third (a, b, c) (a', b', c') =
  match compare_first a a' with
  | 0 ->
    (match compare_second b b' with 0 -> compare_third c c' | result -> result)
  | result ->
      result
