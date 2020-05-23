type ('ok, 'error) t = ('ok, 'error) result

let ok value = Ok value

let error value = Error value

let fromOption ma ~error =
  match ma with None -> Error error | Some right -> Result.Ok right


let from_option = fromOption

let isOk = Result.is_ok

let is_ok = isOk

let isError = Result.is_error

let is_error = isError

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

let get = Result.value

let getUnsafe = Result.get_ok

let get_unsafe = getUnsafe

let getError t ~default = match t with Ok _ -> default | Error error -> error

let get_error = getError

let map t ~f = Result.map f t

let map2 a b ~f =
  match (a, b) with
  | Ok a, Ok b ->
      Ok (f a b)
  | Error a, _ ->
      Error a
  | _, Error b ->
      Error b


let mapError t ~f =
  match t with Error error -> Error (f error) | Ok value -> Ok value


let map_error = mapError

let values t =
  Base.List.fold_right t ~f:(map2 ~f:(fun a b -> a :: b)) ~init:(Ok [])


let toOption r = match r with Ok v -> Some v | Error _ -> None

let to_option = toOption

let andThen t ~f = Result.bind t f

let and_then = andThen

let attempt f =
  match f () with value -> Ok value | exception error -> Error error


let forEach t ~f = match t with Ok a -> f a | _ -> ()

let for_each = forEach

let equal equalOk equalError a b =
  match (a, b) with
  | Error a', Error b' ->
      equalError a' b'
  | Ok a', Ok b' ->
      equalOk a' b'
  | _ ->
      false


let compare
    (compareOk : 'ok -> 'ok -> int)
    (compareError : 'error -> 'error -> int)
    (a : ('ok, 'error) t)
    (b : ('ok, 'error) t) =
  ( match (a, b) with
    | Error a', Error b' ->
        compareError a' b'
    | Ok a', Ok b' ->
        compareOk a' b'
    | Error _, Ok _ ->
        -1
    | Ok _, Error _ ->
        1
    : int )


let ( |? ) t default = get t ~default

let ( >>| ) t f = map t ~f

let ( >>= ) t f = andThen t ~f

let pp
    (okf : Format.formatter -> 'ok -> unit)
    (errf : Format.formatter -> 'err -> unit)
    (fmt : Format.formatter)
    (r : ('ok, 'error) t) =
  match r with
  | Ok ok ->
      Format.pp_print_string fmt "<ok: " ;
      okf fmt ok ;
      Format.pp_print_string fmt ">"
  | Error err ->
      Format.pp_print_string fmt "<error: " ;
      errf fmt err ;
      Format.pp_print_string fmt ">"
