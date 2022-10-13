type ('a, 'b) t = 'a * 'b

let make a b = (a, b)

let fromArray array =
  match array with
  | [||] | [| _ |] ->
      None
  | [| a; b |] ->
      Some (a, b)
  | _ ->
      Some (array.(0), array.(1))


let fromList list =
  match list with [] | [ _ ] -> None | a :: b :: _rest -> Some (a, b)


let first (a, _) = a

let second (_, b) = b

let mapFirst (a, b) ~f = (f a, b)

let mapSecond (a, b) ~f = (a, f b)

let mapEach (a, b) ~f ~g = (f a, g b)

let mapAll (a1, a2) ~f = (f a1, f a2)

let swap (a, b) = (b, a)

let toArray (a, b) = [| a; b |]

let toList (a, b) = [ a; b ]

let equal (a, b) (a', b') equalFirst equalSecond =
  equalFirst a a' && equalSecond b b'


let compare (a, b) (a', b') ~f:compareFirst ~g:compareSecond =
  match compareFirst a a' with 0 -> compareSecond b b' | result -> result
