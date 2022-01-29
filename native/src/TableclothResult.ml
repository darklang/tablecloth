type ('ok, 'error) t = ('ok, 'error) result

let ok value = Ok value

let error value = Error value

let from_option ma ~error =
  match ma with None -> Error error | Some right -> Result.Ok right


let is_ok = Result.is_ok

let is_error = Result.is_error

let both a b =
  match (a, b) with
  | Ok a', Ok b' ->
      Ok (a', b')
  | Error a', _ ->
      Error a'
  | _, Error b' ->
      Error b'


let flatten = Result.join

let or_ a b = match a with Ok _ -> a | _ -> b

let and_ a b = match a with Ok _ -> b | _ -> a

let unwrap = Result.value

let unwrap_unsafe = Result.get_ok

let unwrap_error t ~default =
  match t with Ok _ -> default | Error error -> error


let map t ~f = Result.map f t

let map2 a b ~f =
  match (a, b) with
  | Ok a, Ok b ->
      Ok (f a b)
  | Error a, _ ->
      Error a
  | _, Error b ->
      Error b


let map_error t ~f =
  match t with Error error -> Error (f error) | Ok value -> Ok value


let values t =
  Base.List.fold_right t ~f:(map2 ~f:(fun a b -> a :: b)) ~init:(Ok [])


let combine (l : ('ok, 'error) result list) : ('ok list, 'error) result =
  (TableclothList.fold_right
     ~f:(fun (accum : ('ok list, 'error) result) (value : ('ok, 'error) result)
             : ('ok list, 'error) result ->
       map2 ~f:(fun (head : 'ok) (list : 'ok list) -> head :: list) value accum
       )
     ~initial:(Ok []) )
    l


let to_option r = match r with Ok v -> Some v | Error _ -> None

let and_then t ~f = Result.bind t f

let attempt f =
  match f () with value -> Ok value | exception error -> Error error


let tap t ~f = match t with Ok a -> f a | _ -> ()

let equal equal_ok equal_error a b =
  match (a, b) with
  | Error a', Error b' ->
      equal_error a' b'
  | Ok a', Ok b' ->
      equal_ok a' b'
  | _ ->
      false


let compare
    ~f:(compare_ok : 'ok -> 'ok -> int)
    ~g:(compare_error : 'error -> 'error -> int)
    (a : ('ok, 'error) t)
    (b : ('ok, 'error) t) : int =
  match (a, b) with
  | Error a', Error b' ->
      compare_error a' b'
  | Ok a', Ok b' ->
      compare_ok a' b'
  | Error _, Ok _ ->
      -1
  | Ok _, Error _ ->
      1


let ( |? ) t default = unwrap t ~default

let ( >>| ) t f = map t ~f

let ( >>= ) t f = and_then t ~f
