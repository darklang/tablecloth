type 'a t = 'a list

let empty = []

let singleton = Base.List.return

let repeat element ~times =
  if times < 0 then [] else Base.List.init times ~f:(fun _ -> element)


let rec range ?(from = 0) to_ =
  if from >= to_ then [] else from :: range ~from:(from + 1) to_


let initialize = Base.List.init

let sum (type a) (a : a t) (module M : TableclothContainer.Sum with type t = a)
    : a =
  Base.List.fold a ~init:M.zero ~f:M.add


let from_array = Base.Array.to_list

let is_empty (l : 'a list) : bool = l = []

let head = Base.List.hd

let tail = Base.List.tl

let cons list element = element :: list

let take t ~count = Base.List.take t count

let take_while (l : 'a list) ~(f : 'a -> bool) : 'a list =
  let rec take_while_helper acc l' =
    match l' with
    | [] ->
        Base.List.rev acc
    | x :: rest ->
        if f x then take_while_helper (x :: acc) rest else Base.List.rev acc
  in
  take_while_helper [] l


let drop t ~count = Base.List.drop t count

let rec drop_while (l : 'a list) ~(f : 'a -> bool) : 'a list =
  match l with [] -> [] | x :: rest -> if f x then drop_while ~f rest else l


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

let reverse (l : 'a list) : 'a list = Base.List.rev l

let map2 listA listB ~f =
  let mapped, _ =
    Base.List.fold listA ~init:([], listB) ~f:(fun (result, lb) a ->
        match lb with b :: rest -> (f a b :: result, rest) | [] -> (result, []) )
  in
  reverse mapped


let map3 listA listB listC ~f =
  let mapped, _, _ =
    Base.List.fold listA ~init:([], listB, listC) ~f:(fun (result, lb, lc) a ->
        match lb with
        | b :: rest1 ->
          ( match lc with
          | c :: rest2 ->
              (f a b c :: result, rest1, rest2)
          | [] ->
              (result, [], []) )
        | [] ->
            (result, [], []) )
  in
  reverse mapped


let map = Base.List.map

let map_with_index = Base.List.mapi

let flat_map = Base.List.concat_map

let includes = Base.List.mem

let unique_by ~(f : 'a -> string) (l : 'a list) : 'a list =
  let rec unique_helper
      ~(f : 'a -> string)
      (existing : Base.Set.M(Base.String).t)
      (remaining : 'a list)
      (accumulator : 'a list) : 'a list =
    match remaining with
    | [] ->
        reverse accumulator
    | first :: rest ->
        let computed_first = f first in
        if Base.Set.mem existing computed_first
        then unique_helper ~f existing rest accumulator
        else
          unique_helper
            ~f
            (Base.Set.add existing computed_first)
            rest
            (first :: accumulator)
  in
  unique_helper ~f (Base.Set.empty (module Base.String)) l []


let find = Base.List.find

let find_index = Base.List.findi

let any = Base.List.exists

let all = Base.List.for_all

let get_at (l : 'a list) ~(index : int) : 'a option = Base.List.nth l index

let filter_map = Base.List.filter_map

let filter t ~f = Base.List.filter t ~f

let filter_with_index t ~f = Base.List.filteri t ~f

let partition = Base.List.partition_tf

let fold t ~initial ~f = Base.List.fold t ~init:initial ~f

let count = Base.List.count

let fold_right t ~initial ~f =
  Base.List.fold_right t ~init:initial ~f:(Fun.flip f)


let split_at (l : 'a list) ~(index : int) : 'a list * 'a list =
  (take ~count:index l, drop ~count:index l)


let split_when (l : 'a list) ~(f : 'a -> bool) : 'a list * 'a list =
  match find_index ~f:(fun _ element -> f element) l with
  | Some (index, _) ->
      split_at ~index l
  | None ->
      (l, [])


let update_at (l : 'a list) ~(index : int) ~(f : 'a -> 'a) : 'a list =
  if index < 0
  then l
  else
    let front, back = split_at ~index l in
    match back with [] -> l | x :: rest -> append front (f x :: rest)


let length (l : 'a list) : int = List.length l

let remove_at (l : 'a list) ~(index : int) : 'a list =
  if index < 0
  then l
  else
    let front, back = split_at ~index l in
    match tail back with None -> l | Some t -> append front t


let minimum_by ~(f : 'a -> 'comparable) (ls : 'a list) : 'a option =
  let min_by (y, fy) x =
    let fx = f x in
    if fx < fy then (x, fx) else (y, fy)
  in
  match ls with
  | [ l ] ->
      Some l
  | l1 :: lrest ->
      Some (fst (fold ~f:min_by ~initial:(l1, f l1) lrest))
  | _ ->
      None


let maximum_by ~(f : 'a -> 'comparable) (l : 'a list) : 'a option =
  let max_by (y, fy) x =
    let fx = f x in
    if fx > fy then (x, fx) else (y, fy)
  in
  match l with
  | [] ->
      None
  | [ x ] ->
      Some x
  | x :: rest ->
      Some (fst (fold ~f:max_by ~initial:(x, f x) rest))


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


let insert_at (t : 'a list) ~(index : int) ~(value : 'a) : 'a list =
  let front, back = split_at t ~index in
  append front (value :: back)


let zip listA listB = map2 listA listB ~f:(fun x y -> (x, y))

let unzip = Base.List.unzip

let sliding ?(step = 1) (t : 'a t) ~(size : int) : 'a t t =
  let rec take_all_or_empty t n (current, count) =
    if count = n
    then reverse current
    else
      match t with
      | [] ->
          []
      | x :: xs ->
          take_all_or_empty xs n (x :: current, count + 1)
  in
  let rec loop t =
    if is_empty t
    then []
    else
      let sample = take_all_or_empty t size ([], 0) in
      if is_empty sample then [] else sample :: loop (Base.List.drop t step)
  in
  loop t


let chunks_of t ~size = sliding t ~step:size ~size

let intersperse (l : 'a list) ~sep : 'a list =
  match l with
  | [] ->
      []
  | [ x ] ->
      [ x ]
  | x :: rest ->
      x :: fold_right rest ~initial:[] ~f:(fun acc x -> sep :: x :: acc)


let for_each l ~f = Base.List.iter l ~f

let for_each_with_index = Base.List.iteri

let to_array = Base.List.to_array

let group_while t ~f = Base.List.group t ~break:f

let sort = Base.List.sort

let sort_by ~(f : 'a -> 'b) (l : 'a list) : 'a list =
  Base.List.sort l ~compare:(fun a b ->
      let a' = f a in
      let b' = f b in
      if a' = b' then 0 else if a' < b' then -1 else 1 )


let join t ~sep = Stdlib.String.concat sep t

let group_by t comparator ~f =
  fold t ~initial:(TableclothMap.empty comparator) ~f:(fun map element ->
      let key = f element in
      TableclothMap.update map ~key ~f:(function
          | None ->
              Some [ element ]
          | Some elements ->
              Some (element :: elements) ) )


let rec equal equal_element a b =
  match (a, b) with
  | [], [] ->
      true
  | x :: xs, y :: ys ->
      equal_element x y && equal equal_element xs ys
  | _ ->
      false


let rec compare ~f:compare_element a b =
  match (a, b) with
  | [], [] ->
      0
  | [], _ ->
      -1
  | _, [] ->
      1
  | x :: xs, y :: ys ->
    ( match compare_element x y with
    | 0 ->
        compare ~f:compare_element xs ys
    | result ->
        result )
