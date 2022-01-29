type ('ok, 'error) t = ('ok, 'error) result

let ok a = Belt.Result.Ok a

let error e = Belt.Result.Error e

let fromOption ma ~error =
  match ma with
  | None ->
      Belt.Result.Error error
  | Some right ->
      Belt.Result.Ok right


let isError = Belt.Result.isError

let isOk = Belt.Result.isOk

let both a b =
  match (a, b) with
  | Ok a', Ok b' ->
      Ok (a', b')
  | Error a', _ ->
      Error a'
  | _, Error b' ->
      Error b'


let flatten a = match a with Ok a' -> a' | Error error -> Error error

let or_ a b = match a with Ok _ -> a | _ -> b

let and_ a b = match a with Ok _ -> b | _ -> a

let unwrap t ~default = Belt.Result.getWithDefault t default

let unwrapUnsafe t = Belt.Result.getExn t

let unwrapError t ~default =
  match t with Ok _ -> default | Error value -> value


let map2 a b ~f =
  match (a, b) with
  | Ok a, Ok b ->
      Ok (f a b)
  | Error a, _ ->
      Error a
  | _, Error b ->
      Error b


let values t = List.fold_right (map2 ~f:(fun a b -> a :: b)) t (Ok [])

let combine (l : ('ok, 'error) result list) : ('ok list, 'error) result =
  (TableclothList.foldRight
     ~f:(fun (accum : ('ok list, 'error) result) (value : ('ok, 'error) result)
             : ('ok list, 'error) result ->
       map2 ~f:(fun (head : 'ok) (list : 'ok list) -> head :: list) value accum
       )
     ~initial:(Ok []) )
    l


let map t ~f = Belt.Result.map t f

let mapError t ~f =
  match t with Error error -> Error (f error) | Ok value -> Ok value


let toOption r = match r with Ok v -> Some v | Error _ -> None

let andThen t ~f = Belt.Result.flatMap t f

let attempt f =
  match f () with value -> Ok value | exception error -> Error error


let tap t ~f = match t with Ok a -> f a | _ -> ()

let equal a b equalOk equalError =
  match (a, b) with
  | Error a', Error b' ->
      equalError a' b'
  | Ok a', Ok b' ->
      equalOk a' b'
  | _ ->
      false


let compare
    (a : ('ok, 'error) t)
    (b : ('ok, 'error) t)
    ~f:(compareOk : 'ok -> 'ok -> int)
    ~g:(compareError : 'error -> 'error -> int) : int =
  match (a, b) with
  | Error a', Error b' ->
      compareError a' b'
  | Ok a', Ok b' ->
      compareOk a' b'
  | Error _, Ok _ ->
      -1
  | Ok _, Error _ ->
      1
