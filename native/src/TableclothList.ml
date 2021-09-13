type 'a t = 'a list

let empty = []

let singleton = Base.List.return

let repeat element ~times = Base.List.init times ~f:(fun _ -> element)

let rec range ?(from = 0) to_ =
  if from >= to_ then [] else from :: range ~from:(from + 1) to_


let initialize = Base.List.init

let sum (type a) (a : a t) (module M : TableclothContainer.Sum with type t = a)
    : a =
  Base.List.fold a ~init:M.zero ~f:M.add


let fromArray = Base.Array.to_list

let from_array = fromArray

let isEmpty (l : 'a list) : bool = l = []

let is_empty = isEmpty

let head = Base.List.hd

let tail = Base.List.tl

let cons list element = element :: list

let take t ~count = Base.List.take t count

let takeWhile (l : 'a list) ~(f : 'a -> bool) : 'a list =
  let rec takeWhileHelper acc l' =
    match l' with
    | [] ->
        Base.List.rev acc
    | x :: rest ->
        if f x then takeWhileHelper (x :: acc) rest else Base.List.rev acc
  in
  takeWhileHelper [] l


let take_while = takeWhile

let drop t ~count = Base.List.drop t count

let rec dropWhile (l : 'a list) ~(f : 'a -> bool) : 'a list =
  match l with [] -> [] | x :: rest -> if f x then dropWhile ~f rest else l


let drop_while = dropWhile

let initial (l : 'a list) : 'a list option =
  match Base.List.rev l with
  | [] ->
      None
  | _ :: rest ->
      Some (Base.List.rev rest)


let rec last (l : 'a list) : 'a option =
  match l with [] -> None | [ a ] -> Some a | _ :: tail -> last tail


let append (l1 : 'a list) (l2 : 'a list) : 'a list = Base.List.append l1 l2

let flatten = Base.List.concat

let map2 = Base.List.map2_exn

let map3 = Base.List.map3_exn

let reverse (l : 'a list) : 'a list = Base.List.rev l

let map = Base.List.map

let mapWithIndex = Base.List.mapi

let map_with_index = mapWithIndex

let flatMap = Base.List.concat_map

let flat_map = flatMap

let includes = Base.List.mem

let uniqueBy ~(f : 'a -> string) (l : 'a list) : 'a list =
  let rec uniqueHelper
      ~(f : 'a -> string)
      (existing : Base.Set.M(Base.String).t)
      (remaining : 'a list)
      (accumulator : 'a list) : 'a list =
    match remaining with
    | [] ->
        reverse accumulator
    | first :: rest ->
        let computedFirst = f first in
        if Base.Set.mem existing computedFirst
        then uniqueHelper ~f existing rest accumulator
        else
          uniqueHelper
            ~f
            (Base.Set.add existing computedFirst)
            rest
            (first :: accumulator)
  in
  uniqueHelper ~f (Base.Set.empty (module Base.String)) l []


let unique_by = uniqueBy

let find = Base.List.find

let findIndex = Base.List.findi

let find_index = findIndex

let any = Base.List.exists

let all = Base.List.for_all

let getAt (l : 'a list) ~(index : int) : 'a option = Base.List.nth l index

let get_at = getAt

let filterMap = Base.List.filter_map

let filter_map = filterMap

let filter t ~f = Base.List.filter t ~f

let filterWithIndex t ~f = Base.List.filteri t ~f

let filter_with_index = filterWithIndex

let partition = Base.List.partition_tf

let fold t ~initial ~f = Base.List.fold t ~init:initial ~f

let count = Base.List.count

let foldRight t ~initial ~f =
  Base.List.fold_right t ~init:initial ~f:(Fun.flip f)


let fold_right = foldRight

let splitAt (l : 'a list) ~(index : int) : 'a list * 'a list =
  (take ~count:index l, drop ~count:index l)


let split_at = splitAt

let splitWhen (l : 'a list) ~(f : 'a -> bool) : 'a list * 'a list =
  match findIndex ~f:(fun _ element -> f element) l with
  | Some (index, _) ->
      splitAt ~index l
  | None ->
      (l, [])


let split_when = splitWhen

let updateAt (l : 'a list) ~(index : int) ~(f : 'a -> 'a) : 'a list =
  if index < 0
  then l
  else
    let front, back = splitAt ~index l in
    match back with [] -> l | x :: rest -> append front (f x :: rest)


let update_at = updateAt

let length (l : 'a list) : int = List.length l

let removeAt (l : 'a list) ~(index : int) : 'a list =
  if index < 0
  then l
  else
    let front, back = splitAt ~index l in
    match tail back with None -> l | Some t -> append front t


let remove_at = removeAt

let minimumBy ~(f : 'a -> 'comparable) (ls : 'a list) : 'a option =
  let minBy (y, fy) x =
    let fx = f x in
    if fx < fy then (x, fx) else (y, fy)
  in
  match ls with
  | [ l ] ->
      Some l
  | l1 :: lrest ->
      Some (fst (fold ~f:minBy ~initial:(l1, f l1) lrest))
  | _ ->
      None


let minimum_by = minimumBy

let minimum = Base.List.min_elt

let maximum = Base.List.max_elt

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
                  max ) )


let insertAt (t : 'a list) ~(index : int) ~(value : 'a) : 'a list =
  let front, back = splitAt t ~index in
  append front (value :: back)


let insert_at = insertAt

let zip listA listB =
  let rec loop result xs ys =
    match (xs, ys) with
    | [], _ ->
        result
    | _, [] ->
        result
    | x :: xs, y :: ys ->
        loop ((x, y) :: result) xs ys
  in
  loop [] listA listB


let unzip = Base.List.unzip

let sliding ?(step = 1) (t : 'a t) ~(size : int) : 'a t t =
  let rec takeAllOrEmpty t n (current, count) =
    if count = n
    then reverse current
    else
      match t with
      | [] ->
          []
      | x :: xs ->
          takeAllOrEmpty xs n (x :: current, count + 1)
  in
  let rec loop t =
    if isEmpty t
    then []
    else
      let sample = takeAllOrEmpty t size ([], 0) in
      if isEmpty sample then [] else sample :: loop (Base.List.drop t step)
  in
  loop t


let chunksOf t ~size = sliding t ~step:size ~size

let chunks_of = chunksOf

let intersperse (l : 'a list) ~sep : 'a list =
  match l with
  | [] ->
      []
  | [ x ] ->
      [ x ]
  | x :: rest ->
      x :: foldRight rest ~initial:[] ~f:(fun acc x -> sep :: x :: acc)


let forEach l ~f = Base.List.iter l ~f

let for_each = forEach

let forEachWithIndex = Base.List.iteri

let for_each_with_index = forEachWithIndex

let toArray = Base.List.to_array

let to_array = toArray

let groupWhile t ~f = Base.List.group t ~break:f

let group_while = groupWhile

let sort = Base.List.sort

let sortBy ~(f : 'a -> 'b) (l : 'a list) : 'a list =
  Base.List.sort l ~compare:(fun a b ->
      let a' = f a in
      let b' = f b in
      if a' = b' then 0 else if a' < b' then -1 else 1 )


let sort_by = sortBy

let join t ~sep = Stdlib.String.concat sep t

let groupBy t comparator ~f =
  fold t ~initial:(TableclothMap.empty comparator) ~f:(fun map element ->
      let key = f element in
      TableclothMap.update map ~key ~f:(function
          | None ->
              Some [ element ]
          | Some elements ->
              Some (element :: elements) ) )


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
