external identity : 'a -> 'a = "%identity"

external ignore : _ -> unit = "%ignore"

let constant a _ = a

let sequence _ b = b

let flip f x y = f y x

let negate f t = not (f t)

let apply f a = f a

let ( <| ) a b = a b

external pipe : 'a -> ('a -> 'b) -> 'b = "%revapply"

external ( |> ) : 'a -> ('a -> 'b) -> 'b = "%revapply"

let compose g f a = g (f a)

let ( << ) = compose

let composeRight g f a = f (g a)

let ( >> ) = composeRight

let tap a ~f =
  f a ;
  a


let rec times n ~f =
  if n <= 0
  then ()
  else (
    f () ;
    times (n - 1) ~f )


let forever f =
  try
    while true do
      f ()
    done ;
    failwith "[while true] managed to return, you are in trouble now."
  with
  | exn ->
      exn


let curry (f : 'a * 'b -> 'c) a b = (f (a, b) : 'c)

let uncurry (f : 'a -> 'b -> 'c) ((a, b) : 'a * 'b) = (f a b : 'c)

let curry3 f a b c = f (a, b, c)

let uncurry3 f (a, b, c) = f a b c
