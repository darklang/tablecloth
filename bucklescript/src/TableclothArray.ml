type 'a t = 'a array

let singleton a = [| a |]

let clone t = Array.map Fun.identity t

let length = Belt.Array.length

let isEmpty a = length a = 0

let is_empty = isEmpty

let initialize length ~f = Belt.Array.makeBy length f

let range ?(from = 0) to_ = Belt.Array.makeBy (to_ - from) (fun i -> i + from)

let fromList = Belt.List.toArray

let from_list = fromList

let toList = Belt.List.fromArray

let to_list = toList

let toIndexedList array =
  Belt.Array.reduceReverse
    array
    (length array - 1, [])
    (fun (i, acc) x -> (i - 1, (i, x) :: acc))
  |. snd


let to_indexed_list = toIndexedList

let get = Belt.Array.getExn

let getAt t ~index = Belt.Array.get t index

let get_at = getAt

let ( .?() ) (array : 'element t) (index : int) : 'element option =
  getAt array ~index


let first t = getAt t ~index:0

let last t = getAt t ~index:(Array.length t - 1)

let set t index value = t.(index) <- value

let setAt t ~index ~value = t.(index) <- value

let set_at = setAt

let filter t ~f = Belt.Array.keep t f

let swap t i j =
  let temp = t.(i) in
  t.(i) <- t.(j) ;
  t.(j) <- temp ;
  ()


let fold t ~initial ~f = Belt.Array.reduce t initial f

let foldRight t ~initial ~f = Belt.Array.reduceReverse t initial f

let fold_right = foldRight

let maximum t ~compare =
  fold t ~initial:None ~f:(fun max element ->
      match max with
      | None ->
          Some element
      | Some current ->
        ( match compare element current > 0 with
        | true ->
            Some element
        | false ->
            max ))


let minimum t ~compare =
  fold t ~initial:None ~f:(fun min element ->
      match min with
      | None ->
          Some element
      | Some current ->
        ( match compare element current < 0 with
        | true ->
            Some element
        | false ->
            min ))


let extent t ~compare =
  fold t ~initial:None ~f:(fun range element ->
      match range with
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


let sum (type a) t (module M : Container.Sum with type t = a) =
  (Array.fold_left M.add M.zero t : a)


let map t ~f = Belt.Array.map t f

let mapWithIndex t ~f = Belt.Array.mapWithIndex t f

let map_with_index = mapWithIndex

let map2 a b ~(f : 'a -> 'b -> 'c) = (Belt.Array.zipBy a b f : 'c array)

let map3 as_ bs (cs : 'c t) ~f =
  let minLength =
    Belt.Array.reduce [| length bs; length cs |] (length as_) min
  in
  Belt.Array.makeBy minLength (fun i -> f as_.(i) bs.(i) cs.(i))


let zip = map2 ~f:(fun a b -> (a, b))

let flatMap t ~f = Belt.Array.map t f |. Belt.Array.concatMany

let flat_map = flatMap

let sliding ?(step = 1) a ~size =
  let n = Array.length a in
  if size > n
  then [||]
  else
    initialize
      (1 + ((n - size) / step))
      ~f:(fun i -> initialize size ~f:(fun j -> a.((i * step) + j)))


let find t ~f =
  let rec find_loop t ~f ~length i =
    if i >= length
    then None
    else if f t.(i)
    then Some t.(i)
    else find_loop t ~f ~length (i + 1)
  in
  find_loop t ~f ~length:(length t) 0


let findIndex array ~f =
  let rec loop index =
    if index >= length array
    then None
    else if f index array.(index)
    then Some (index, array.(index))
    else loop (index + 1)
  in
  loop 0


let find_index = findIndex

let any t ~f = Belt.Array.some t f

let all t ~f = Belt.Array.every t f

let includes t v ~equal = any t ~f:(equal v)

let append a a' = Belt.Array.concat a a'

let flatten (ars : 'a array array) = Belt.Array.concatMany ars

let intersperse t ~sep =
  Belt.Array.makeBy
    (max 0 ((length t * 2) - 1))
    (fun i -> if i mod 2 <> 0 then sep else t.(i / 2))


let slice ?to_ array ~from =
  let defaultTo = match to_ with None -> length array | Some i -> i in
  let sliceFrom =
    if from >= 0
    then min (length array) from
    else max 0 (min (length array) (length array + from))
  in
  let sliceTo =
    if defaultTo >= 0
    then min (length array) defaultTo
    else max 0 (min (length array) (length array + defaultTo))
  in
  if sliceFrom >= sliceTo
  then [||]
  else Belt.Array.makeBy (sliceTo - sliceFrom) (fun i -> array.(i + sliceFrom))


let count t ~f =
  fold t ~initial:0 ~f:(fun total element ->
      total + match f element with true -> 1 | false -> 0)


let chunksOf t ~size = sliding t ~step:size ~size

let chunks_of = chunksOf

let reverse = Belt.Array.reverseInPlace

let forEach t ~f = (Belt.Array.forEach t f : unit)

let for_each = forEach

let forEachWithIndex t ~f =
  ( for i = 0 to length t - 1 do
      f i t.(i)
    done
    : unit )


let for_each_with_index = forEachWithIndex

let partition t ~f =
  let left, right =
    foldRight t ~initial:([], []) ~f:(fun (lefts, rights) element ->
        if f element
        then (element :: lefts, rights)
        else (lefts, element :: rights))
  in
  (fromList left, fromList right)


let splitAt t ~index =
  (slice t ~from:0 ~to_:index, slice t ~from:index ~to_:(length t))


let split_at = splitAt

let splitWhen t ~f =
  match findIndex t ~f:(fun _ e -> f e) with
  | None ->
      (t, [||])
  | Some (index, _) ->
      splitAt t ~index


let split_when = splitWhen

let unzip t =
  ( Array.init (length t) (fun i -> fst t.(i))
  , Array.init (length t) (fun i -> snd t.(i)) )


let repeat element ~length = Array.init (max length 0) (fun _ -> element)

let filterMap t ~f =
  fold t ~initial:[] ~f:(fun results element ->
      match f element with None -> results | Some value -> value :: results)
  |. fromList


let filter_map = filterMap

let sort a ~compare = Array.sort compare a

let values t =
  fold t ~initial:[] ~f:(fun results element ->
      match element with None -> results | Some value -> value :: results)
  |. fromList


let join t ~sep = Js.Array.joinWith sep t

let equal equal a b =
  if length a <> length b
  then false
  else if length a = 0
  then true
  else
    let rec loop index =
      if index = length a
      then true
      else equal a.(index) b.(index) && loop (index + 1)
    in
    loop 0


let compare compare a b =
  match Int.compare (length a) (length b) with
  | 0 ->
      if length a == 0
      then 0
      else
        let rec loop index =
          if index = length a
          then 0
          else
            match compare a.(index) b.(index) with
            | 0 ->
                loop (index + 1)
            | result ->
                result
        in
        loop 0
  | result ->
      result
