type 'a t = 'a list

let empty = []

let singleton x = [ x ]

let fromArray array = List.init (Array.length array) (fun i -> array.(i))

let range ?(from = 0) to_ =
  if to_ < from then [] else List.init (to_ - from) (fun i -> i + from)


let rec repeat element ~times =
  if times <= 0 then [] else element :: repeat element ~times:(times - 1)


let flatten = Belt.List.flatten

let reverse = Belt.List.reverse

let append = Belt.List.concat

let sum (type a) t (module M : TableclothContainer.Sum with type t = a) =
  List.fold_left M.add M.zero t


let map t ~f = Belt.List.map t f

let flatMap t ~f = flatten (map t ~f)

let mapWithIndex list ~f = Belt.List.mapWithIndex list f

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

let uniqueBy (l : 'a list) ~(f : 'a -> string) : 'a list =
  let rec uniqueHelper
      (f : 'a -> string)
      (existing : Belt.Set.String.t)
      (remaining : 'a list)
      (accumulator : 'a list) =
    match remaining with
    | [] ->
        reverse accumulator
    | first :: rest ->
        let computedFirst = f first in
        if Belt.Set.String.has existing computedFirst
        then uniqueHelper f existing rest accumulator
        else
          uniqueHelper
            f
            (Belt.Set.String.add existing computedFirst)
            rest
            (first :: accumulator)
  in
  uniqueHelper f Belt.Set.String.empty l []


let find t ~f = Belt.List.getBy t f

let getAt t ~index = Belt.List.get t index

let any t ~f = List.exists f t

let head l = Belt.List.head l

let drop t ~count =
  match Belt.List.drop t count with
  | None ->
      if count <= 0 then t else []
  | Some v ->
      v


let take t ~count =
  match Belt.List.take t count with
  | None ->
      if count <= 0 then [] else t
  | Some v ->
      v


let initial l =
  match reverse l with [] -> None | _ :: rest -> Some (reverse rest)


let filterMap t ~f = Belt.List.keepMap t f

let filter t ~f = Belt.List.keep t f

let filterWithIndex t ~f = Belt.List.keepWithIndex t (fun e i -> f i e)

let partition t ~f = Belt.List.partition t f

let fold t ~initial ~f = Belt.List.reduce t initial f

let count t ~f =
  fold t ~initial:0 ~f:(fun total element ->
      total + match f element with true -> 1 | false -> 0 )


let foldRight t ~initial ~f = Belt.List.reduceReverse t initial f

let findIndex list ~f =
  let rec loop i l =
    match l with
    | [] ->
        None
    | x :: rest ->
        if f i x then Some (i, x) else loop (i + 1) rest
  in
  loop 0 list


let splitAt t ~index = (take ~count:index t, drop ~count:index t)

let updateAt =
  ( fun t ~index ~f ->
      Belt.List.mapWithIndex t (fun i element ->
          if i = index then f element else element )
    : 'a t -> index:int -> f:('a -> 'a) -> 'a t )


let length l = Belt.List.length l

let rec dropWhile t ~f =
  match t with [] -> [] | x :: rest -> if f x then dropWhile rest ~f else t


let isEmpty t = t = []

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


let all t ~f = Belt.List.every t f

let tail t = match t with [] -> None | _ :: rest -> Some rest

let removeAt t ~index =
  if index < 0
  then t
  else
    let (front, back) : 'a t * 'a t = splitAt t ~index in
    match tail back with None -> t | Some t -> append front t


let minimumBy ~(f : 'a -> 'comparable) (l : 'a list) : 'a option =
  let minBy (y, fy) x =
    let fx = f x in
    if fx < fy then (x, fx) else (y, fy)
  in
  match l with
  | [] ->
      None
  | [ x ] ->
      Some x
  | x :: rest ->
      Some (fst (fold ~f:minBy ~initial:(x, f x) rest))


let maximumBy ~(f : 'a -> 'comparable) (l : 'a list) : 'a option =
  let maxBy (y, fy) x =
    let fx = f x in
    if fx > fy then (x, fx) else (y, fy)
  in
  match l with
  | [] ->
      None
  | [ x ] ->
      Some x
  | x :: rest ->
      Some (fst (fold ~f:maxBy ~initial:(x, f x) rest))


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
            min ) )


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
            max ) )


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


let sort t ~compare = Belt.List.sort t compare

let sortBy (l : 'a t) ~(f : 'a -> 'b) : 'a t =
  Belt.List.sort l (fun a b ->
      let a' = f a in
      let b' = f b in
      if a' = b' then 0 else if a' < b' then -1 else 1 )


let groupi l ~break =
  let groups =
    Belt.List.reduceWithIndex l [] (fun acc x i ->
        match acc with
        | [] ->
            [ [ x ] ]
        | current_group :: tl ->
            if break i (Belt.List.headExn current_group) x
            then [ x ] :: current_group :: tl (* start new group *)
            else (x :: current_group) :: tl )
    (* extend current group *)
  in
  match groups with [] -> [] | l -> Belt.List.mapReverse l reverse


let groupWhile l ~f = groupi l ~break:(fun _ x y -> f x y)

let insertAt t ~index ~value =
  let front, back = splitAt t ~index in
  append front (value :: back)


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


let intersperse t ~sep =
  match t with
  | [] ->
      []
  | [ x ] ->
      [ x ]
  | x :: rest ->
      x :: foldRight rest ~initial:[] ~f:(fun acc x -> sep :: x :: acc)


let initialize length ~f = Belt.List.makeBy length f

let forEach t ~f : unit = Belt.List.forEach t f

let forEachWithIndex t ~f : unit = Belt.List.forEachWithIndex t f

let toArray = Array.of_list

let join strings ~sep = Js.Array.joinWith sep (toArray strings)

let groupBy t comparator ~f =
  fold t ~initial:(TableclothMap.empty comparator) ~f:(fun map element ->
      let key = f element in
      TableclothMap.update map ~key ~f:(function
          | None ->
              Some [ element ]
          | Some elements ->
              Some (element :: elements) ) )


let rec equal a b equalElement =
  match (a, b) with
  | [], [] ->
      true
  | x :: xs, y :: ys ->
      equalElement x y && equal xs ys equalElement
  | _ ->
      false


let rec compare a b ~f:compareElement =
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
        compare ~f:compareElement xs ys
    | result ->
        result )
