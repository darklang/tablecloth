type ('a, 'b, 'c) t = 'a * 'b * 'c

let make a b c = (a, b, c)

let fromArray array =
  match array with
  | [||] | [| _ |] | [| _; _ |] ->
      None
  | [| a; b; c |] ->
      Some (a, b, c)
  | _ ->
      Some (array.(0), array.(1), array.(2))


let fromList list =
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

let mapFirst (a, b, c) ~f = (f a, b, c)

let mapSecond (a, b, c) ~f = (a, f b, c)

let mapThird (a, b, c) ~f = (a, b, f c)

let mapEach (a, b, c) ~f ~g ~h = (f a, g b, h c)

let mapAll (a1, a2, a3) ~f = (f a1, f a2, f a3)

let rotateLeft (a, b, c) = (b, c, a)

let rotateRight (a, b, c) = (c, a, b)

let toArray (a, b, c) = [| a; b; c |]

let toList (a, b, c) = [ a; b; c ]

let equal (a, b, c) (a', b', c') equalFirst equalSecond equalThird =
  equalFirst a a' && equalSecond b b' && equalThird c c'


let compare
    (a, b, c) (a', b', c') ~f:compareFirst ~g:compareSecond ~h:compareThird =
  match compareFirst a a' with
  | 0 ->
    (match compareSecond b b' with 0 -> compareThird c c' | result -> result)
  | result ->
      result
