type 'a t = 'a array

let singleton (a : 'a) : 'a array = [| a |]

let clone = Base.Array.copy

let initialize (length : int) ~(f : int -> 'a) =
  if length <= 0 then [||] else Base.Array.init length ~f


let repeat element ~length =
  initialize length ~f:(TableclothFun.constant element)


let range ?(from = 0) (to_ : int) : int array =
  Base.Array.init (max 0 (to_ - from)) ~f:(fun i -> i + from)


let from_list = Base.List.to_array

let length (a : 'a array) : int = Base.Array.length a

let is_empty a = length a = 0

let first t = if length t < 1 then None else Some t.(0)

let last t = if length t < 1 then None else Some t.(length t - 1)

let get = Base.Array.get

let get_at a ~index =
  if index >= 0 && index < length a then Some (Base.Array.get a index) else None


let ( .?() ) (array : 'element t) (index : int) : 'element option =
  get_at array ~index


let set = Base.Array.set

let set_at t ~index ~value = set t index value

let filter = Base.Array.filter

let sum (type a) t (module M : TableclothContainer.Sum with type t = a) =
  Base.Array.fold t ~init:M.zero ~f:M.add


let filter_map = Base.Array.filter_map

let flat_map = Base.Array.concat_map

let fold a ~initial ~f = Base.Array.fold a ~init:initial ~f

let fold_right a ~initial ~f =
  Base.Array.fold_right a ~init:initial ~f:(Fun.flip f)


let count t ~f =
  fold t ~initial:0 ~f:(fun total element ->
      total + match f element with true -> 1 | false -> 0 )


let swap = Base.Array.swap

let find = Base.Array.find

let find_index = Base.Array.findi

let map = Base.Array.map

let map_with_index = Base.Array.mapi

let map2 (a : 'a array) (b : 'b array) ~(f : 'a -> 'b -> 'c) : 'c array =
  let min_length = min (length a) (length b) in
  Base.Array.init min_length ~f:(fun i -> f a.(i) b.(i))


let zip = map2 ~f:(fun left right -> (left, right))

let map3
    (array_a : 'a array)
    (array_b : 'b array)
    (array_c : 'c array)
    ~(f : 'a -> 'b -> 'c -> 'd) =
  let min_length =
    Base.min (length array_a) (Base.min (length array_c) (length array_b))
  in
  Base.Array.init min_length ~f:(fun i -> f array_a.(i) array_b.(i) array_c.(i))


let partition = Base.Array.partition_tf

let split_at a ~index =
  ( Base.Array.init index ~f:(fun i -> a.(i))
  , Base.Array.init (length a - index) ~f:(fun i -> a.(index + i)) )


let split_when a ~f =
  match find_index a ~f:(fun _index element -> f element) with
  | None ->
      (a, [||])
  | Some (index, _) ->
      split_at a ~index


let unzip = Base.Array.unzip

let append (a : 'a array) (a' : 'a array) : 'a array = Base.Array.append a a'

let flatten (al : 'a array array) : 'a array =
  Base.Array.concat (Base.Array.to_list al)


let intersperse array ~sep =
  Base.Array.init
    (max 0 ((Array.length array * 2) - 1))
    ~f:(fun i -> if i mod 2 <> 0 then sep else array.(i / 2))


let any = Base.Array.exists

let all = Base.Array.for_all

let includes = Base.Array.mem

let reverse = Base.Array.rev_inplace

let values t =
  let result =
    fold t ~initial:[] ~f:(fun results element ->
        match element with None -> results | Some value -> value :: results )
    |> from_list
  in
  reverse result ;
  result


let join t ~sep = Stdlib.String.concat sep (Array.to_list t)

let group_by t comparator ~f =
  fold t ~initial:(TableclothMap.empty comparator) ~f:(fun map element ->
      let key = f element in
      TableclothMap.update map ~key ~f:(function
          | None ->
              Some [ element ]
          | Some elements ->
              Some (element :: elements) ) )


let slice ?to_ array ~from =
  let default_to = match to_ with None -> length array | Some i -> i in
  let slice_from =
    if from >= 0
    then min (length array) from
    else max 0 (min (length array) (length array + from))
  in
  let slice_to =
    if default_to >= 0
    then min (length array) default_to
    else max 0 (min (length array) (length array + default_to))
  in
  if slice_from >= slice_to
  then [||]
  else
    Base.Array.init (slice_to - slice_from) ~f:(fun i -> array.(i + slice_from))


let sliding ?(step = 1) a ~size =
  let n = Array.length a in
  if size > n
  then [||]
  else
    initialize
      (1 + ((n - size) / step))
      ~f:(fun i -> initialize size ~f:(fun j -> a.((i * step) + j)))


let chunks_of t ~size = sliding t ~step:size ~size

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
                  max ) )


let sort t = Base.Array.sort t

let for_each a ~f = Base.Array.iter a ~f

let for_each_with_index a ~f = Base.Array.iteri a ~f

let to_list (a : 'a array) : 'a list = Base.Array.to_list a

let to_indexed_list a =
  Base.Array.fold_right
    a
    ~init:(length a - 1, [])
    ~f:(fun x (i, acc) -> (i - 1, (i, x) :: acc))
  |> Base.snd


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


let compare ~f:compare a b =
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
