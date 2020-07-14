type 'a t = 'a list

let empty = []

let singleton x = [ x ]

let fromArray array = List.init (Array.length array) (fun i -> array.(i))

let from_array = fromArray

let range ?(from = 0) to_ = List.init (to_ - from) (fun i -> i + from)

let rec repeat element ~times =
  if times <= 0 then [] else element :: repeat element ~times:(times - 1)


let flatten = Belt.List.flatten

let reverse = Belt.List.reverse

let append = Belt.List.concat

let sum (type a) t (module M : TableclothContainer.Sum with type t = a) =
  List.fold_left M.add M.zero t


let map t ~f = Belt.List.map t f

let flatMap t ~f = flatten (map t ~f)

let flat_map = flatMap

let mapWithIndex list ~f = Belt.List.mapWithIndex list f

let map_with_index = mapWithIndex

let map2 a b ~f = Belt.List.zipBy a b f

let zip = map2 ~f:(fun a b -> (a, b))

let rec map3 a b c ~f =
  match (a, b, c) with
  | x :: xs, y :: ys, z :: zs ->
      f x y z :: map3 xs ys zs ~f
  | _ ->
      []


let rec last l =
  match l with [] -> None | [ x ] -> Some x | _ :: rest -> last rest


let unzip list =
  (List.map (fun (a, _) -> a) list, List.map (fun (_, b) -> b) list)


let includes t value ~equal = Belt.List.has t value equal

let find t ~f = Belt.List.getBy t f

let getAt t ~index = Belt.List.get t index

let get_at = getAt

let any t ~f = List.exists f t

let head l = Belt.List.head l

let drop t ~count = Belt.List.drop t count |. Belt.Option.getWithDefault []

let take t ~count = Belt.List.take t count |. Belt.Option.getWithDefault []

let initial l =
  match reverse l with [] -> None | _ :: rest -> Some (reverse rest)


let filterMap t ~f = Belt.List.keepMap t f

let filter_map = filterMap

let filter t ~f = Belt.List.keep t f

let filterWithIndex t ~f = Belt.List.keepWithIndex t (fun e i -> f i e)

let filter_with_index = filterWithIndex

let partition t ~f = Belt.List.partition t f

let fold t ~initial ~f = Belt.List.reduce t initial f

let count t ~f =
  fold t ~initial:0 ~f:(fun total element ->
      total + match f element with true -> 1 | false -> 0)


let foldRight t ~initial ~f = Belt.List.reduceReverse t initial f

let fold_right = foldRight

let findIndex list ~f =
  let rec loop i l =
    match l with
    | [] ->
        None
    | x :: rest ->
        if f i x then Some (i, x) else loop (i + 1) rest
  in
  loop 0 list


let find_index = findIndex

let splitAt t ~index =
  if index < 0
  then raise (Invalid_argument "List.splitAt called with negative index") ;
  let rec loop front back i =
    match back with
    | [] ->
        (t, [])
    | element :: rest ->
        if i = 0
        then (reverse front, back)
        else loop (element :: front) rest (i - 1)
  in
  loop [] t index


let split_at = splitAt

let updateAt =
  ( fun t ~index ~f ->
      Belt.List.mapWithIndex t (fun i element ->
          if i = index then f element else element)
    : 'a t -> index:int -> f:('a -> 'a) -> 'a t )


let update_at = updateAt

let length l = Belt.List.length l

let rec dropWhile t ~f =
  match t with [] -> [] | x :: rest -> if f x then dropWhile rest ~f else t


let drop_while = dropWhile

let isEmpty t = t = []

let is_empty = isEmpty

let sliding ?(step = 1) t ~size =
  let rec loop t =
    if isEmpty t
    then []
    else
      let sample = Belt.List.take t size in
      let rest = Belt.List.drop t step in
      match (sample, rest) with
      | None, _ ->
          []
      | Some x, None ->
          [ x ]
      | Some x, Some xs ->
          x :: loop xs
  in
  loop t


let chunksOf t ~size = sliding t ~step:size ~size

let chunks_of = chunksOf

let cons t element = element :: t

let takeWhile t ~f =
  let rec takeWhileHelper acc t =
    match t with
    | [] ->
        reverse acc
    | x :: rest ->
        if f x then takeWhileHelper (x :: acc) rest else reverse acc
  in
  takeWhileHelper [] t


let take_while = takeWhile

let all t ~f = Belt.List.every t f

let tail t = match t with [] -> None | _ :: rest -> Some rest

let removeAt t ~index =
  if index < 0
  then t
  else
    let (front, back) : 'a t * 'a t = splitAt t ~index in
    match tail back with None -> t | Some t -> append front t


let remove_at = removeAt

let minimum t ~compare =
  fold t ~initial:None ~f:(fun min element ->
      match min with
      | None ->
          Some element
      | Some value ->
        ( match compare element value < 0 with
        | true ->
            Some element
        | false ->
            min ))


let maximum t ~compare =
  fold t ~initial:None ~f:(fun max element ->
      match max with
      | None ->
          Some element
      | Some value ->
        ( match compare element value > 0 with
        | true ->
            Some element
        | false ->
            max ))


let extent t ~compare =
  fold t ~initial:None ~f:(fun current element ->
      match current with
      | None ->
          Some (element, element)
      | Some (min, max) ->
          Some
            ( ( match compare element min < 0 with
              | true ->
                  element
              | false ->
                  min )
            , match compare element max > 0 with
              | true ->
                  element
              | false ->
                  max ))


let sort t ~compare = Belt.List.sort t compare

let span t ~f =
  match t with [] -> ([], []) | _ -> (takeWhile t ~f, dropWhile t ~f)


let rec groupWhile t ~f =
  match t with
  | [] ->
      []
  | x :: rest ->
      let ys, zs = span rest ~f:(f x) in
      (x :: ys) :: groupWhile zs ~f


let group_while = groupWhile

let insertAt t ~index ~value =
  if index < 0
  then raise (Invalid_argument "List.splitAt called with negative index") ;
  let rec loop front back i =
    match back with
    | [] ->
        reverse (value :: front)
    | element :: rest ->
        if i = 0
        then append (reverse front) (value :: element :: rest)
        else loop (element :: front) rest (index - 1)
  in
  loop [] t index


let insert_at = insertAt

let splitWhen t ~f =
  let rec loop front back =
    match back with
    | [] ->
        (t, [])
    | element :: rest ->
        if f element
        then (reverse front, back)
        else loop (element :: front) rest
  in
  loop [] t


let split_when = splitWhen

let intersperse t ~sep =
  match t with
  | [] ->
      []
  | [ x ] ->
      [ x ]
  | x :: rest ->
      x :: foldRight rest ~initial:[] ~f:(fun acc x -> sep :: x :: acc)


let initialize length ~f = Belt.List.makeBy length f

let forEach t ~f = (Belt.List.forEach t f : unit)

let for_each = forEach

let forEachWithIndex t ~f = (Belt.List.forEachWithIndex t f : unit)

let for_each_with_index = forEachWithIndex

let toArray = Array.of_list

let to_array = toArray

let join strings ~sep = Js.Array.joinWith sep (toArray strings)

let groupBy t comparator ~f =
  fold t ~initial:(TableclothMap.empty comparator) ~f:(fun map element ->
      let key = f element in
      TableclothMap.update map ~key ~f:(function
          | None ->
              Some [ element ]
          | Some elements ->
              Some (element :: elements)))


let group_by = groupBy

let rec equal equalElement a b =
  match (a, b) with
  | [], [] ->
      true
  | x :: xs, y :: ys ->
      equalElement x y && equal equalElement xs ys
  | _ ->
      false


let rec compare compareElement a b =
  match (a, b) with
  | [], [] ->
      0
  | [], _ ->
      -1
  | _, [] ->
      1
  | x :: xs, y :: ys ->
    ( match compareElement x y with
    | 0 ->
        compare compareElement xs ys
    | result ->
        result )
