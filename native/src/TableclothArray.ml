type 'a t = 'a array

let singleton (a : 'a) = ([| a |] : 'a array)

let clone = Base.Array.copy

let initialize (length : int) ~(f : int -> 'a) =
  if length <= 0 then [||] else Base.Array.init length ~f


let repeat element ~length =
  initialize length ~f:(TableclothFun.constant element)


let range ?(from = 0) (to_ : int) =
  (Base.Array.init (max 0 (to_ - from)) ~f:(fun i -> i + from) : int array)


let fromList = Base.List.to_array

let from_list = fromList

let length (a : 'a array) = (Base.Array.length a : int)

let isEmpty a = length a = 0

let is_empty = isEmpty

let first t = if length t < 1 then None else Some t.(0)

let last t = if length t < 1 then None else Some t.(length t - 1)

let get = Base.Array.get

let getAt a ~index =
  if index >= 0 && index < length a
  then Some (Base.Array.get a index)
  else None


let get_at = getAt

let ( .?() ) (array : 'element t) (index : int) : 'element option =
  getAt array ~index


let set = Base.Array.set

let setAt t ~index ~value = set t index value

let set_at = setAt

let filter = Base.Array.filter

let sum (type a) t (module M : TableclothContainer.Sum with type t = a) =
  Base.Array.fold t ~init:M.zero ~f:M.add


let filterMap = Base.Array.filter_map

let filter_map = filterMap

let flatMap = Base.Array.concat_map

let flat_map = flatMap

let fold a ~initial ~f = Base.Array.fold a ~init:initial ~f

let foldRight a ~initial ~f =
  Base.Array.fold_right a ~init:initial ~f:(Fun.flip f)


let fold_right = foldRight

let count t ~f =
  fold t ~initial:0 ~f:(fun total element ->
      total + match f element with true -> 1 | false -> 0)


let swap = Base.Array.swap

let find = Base.Array.find

let findIndex = Base.Array.findi

let find_index = findIndex

let map = Base.Array.map

let mapWithIndex = Base.Array.mapi

let map_with_index = mapWithIndex

let map2 (a : 'a array) (b : 'b array) ~(f : 'a -> 'b -> 'c) =
  ( let minLength = min (length a) (length b) in
    Base.Array.init minLength ~f:(fun i -> f a.(i) b.(i))
    : 'c array )


let zip = map2 ~f:(fun left right -> (left, right))

let map3
    (arrayA : 'a array)
    (arrayB : 'b array)
    (arrayC : 'c array)
    ~(f : 'a -> 'b -> 'c -> 'd) =
  let minLength =
    Base.min (length arrayA) (Base.min (length arrayC) (length arrayB))
  in
  Base.Array.init minLength ~f:(fun i -> f arrayA.(i) arrayB.(i) arrayC.(i))


let partition = Base.Array.partition_tf

let splitAt a ~index =
  ( Base.Array.init index ~f:(fun i -> a.(i))
  , Base.Array.init (length a - 1) ~f:(fun i -> a.(index + i)) )


let split_at = splitAt

let splitWhen a ~f =
  match findIndex a ~f:(fun _index element -> f element) with
  | None ->
      (a, [||])
  | Some (index, _) ->
      splitAt a ~index


let split_when = splitWhen

let unzip = Base.Array.unzip

let append (a : 'a array) (a' : 'a array) = (Base.Array.append a a' : 'a array)

let flatten (al : 'a array array) =
  (Base.Array.concat (Base.Array.to_list al) : 'a array)


let intersperse array ~sep =
  Base.Array.init
    (max 0 ((Array.length array * 2) - 1))
    ~f:(fun i -> if i mod 2 <> 0 then sep else array.(i / 2))


let any = Base.Array.exists

let all = Base.Array.for_all

let includes = Base.Array.mem

let values t =
  fold t ~initial:[] ~f:(fun results element ->
      match element with None -> results | Some value -> value :: results)
  |> fromList


let join t ~sep = Stdlib.String.concat sep (Array.to_list t)

let groupBy t comparator ~f =
  fold t ~initial:(TableclothMap.empty comparator) ~f:(fun map element ->
      let key = f element in
      TableclothMap.update map ~key ~f:(function
          | None ->
              Some [ element ]
          | Some elements ->
              Some (element :: elements)))


let group_by = groupBy

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
  else
    Base.Array.init (sliceTo - sliceFrom) ~f:(fun i -> array.(i + sliceFrom))


let sliding ?(step = 1) a ~size =
  let n = Array.length a in
  if size > n
  then [||]
  else
    initialize
      (1 + ((n - size) / step))
      ~f:(fun i -> initialize size ~f:(fun j -> a.((i * step) + j)))


let chunksOf t ~size = sliding t ~step:size ~size

let chunks_of = chunksOf

let maximum = Base.Array.max_elt

let minimum = Base.Array.min_elt

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


let sort t = Base.Array.sort t

let reverse = Base.Array.rev_inplace

let forEach a ~f = Base.Array.iter a ~f

let for_each = forEach

let forEachWithIndex a ~f = Base.Array.iteri a ~f

let for_each_with_index = forEachWithIndex

let toList (a : 'a array) = (Base.Array.to_list a : 'a list)

let to_list = toList

let toIndexedList a =
  Base.Array.fold_right
    a
    ~init:(length a - 1, [])
    ~f:(fun x (i, acc) -> (i - 1, (i, x) :: acc))
  |> Base.snd


let to_indexed_list = toIndexedList

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
