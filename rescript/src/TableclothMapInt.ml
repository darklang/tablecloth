module Option = TableclothOption

type 'value t = 'value Belt.Map.Int.t

let fromArray
    (values : ('key * 'v) array) : 'value t =
  Belt.Map.Int.fromArray values


let from_array = fromArray

let empty = Belt.Map.Int.empty

let fromList l = fromArray (Array.of_list l)

let from_list = fromList

let singleton ~key ~value = fromArray [| (key, value) |]

let isEmpty = Belt.Map.Int.isEmpty

let is_empty = isEmpty

let includes = Belt.Map.Int.has

let length = Belt.Map.Int.size

let add m ~key ~value = Belt.Map.Int.set m key value

let ( .?{}<- ) (map : 'value t) (key : int) (value : 'value) :
    'value t =
  add map ~key ~value


let remove = Belt.Map.Int.remove

let get = Belt.Map.Int.get

let ( .?{} ) (map : 'value t) (key : int) : 'value option =
  get map key


let update m ~key ~f = Belt.Map.Int.update m key f

let merge m1 m2 ~f = Belt.Map.Int.merge m1 m2 f

let map m ~f = Belt.Map.Int.map m (fun value -> f value)

let mapWithIndex t ~f = Belt.Map.Int.mapWithKey t f

let map_with_index = mapWithIndex

let filter m ~f = Belt.Map.Int.keep m (fun _ value -> f value)

let partition m ~f = Belt.Map.Int.partition m (fun key value -> f ~key ~value)

let find m ~f = Belt.Map.Int.findFirstBy m (fun key value -> f ~key ~value)

let any m ~f = Belt.Map.Int.some m (fun _ value -> f value)

let all m ~f = Belt.Map.Int.every m (fun _ value -> f value)

let forEach m ~f = Belt.Map.Int.forEach m (fun _ value -> f value)

let for_each = forEach

let forEachWithIndex m ~f = Belt.Map.Int.forEach m (fun key value -> f ~key ~value)

let for_each_with_index = forEachWithIndex

let fold m ~initial ~f =
  Belt.Map.Int.reduce m initial (fun acc key data -> f acc ~key ~value:data)


let keys m = Belt.Map.Int.keysToArray m |. Array.to_list

let values m = Belt.Map.Int.valuesToArray m |. Array.to_list

let maximum = Belt.Map.Int.maxKey

let minimum = Belt.Map.Int.minKey

let extent t = Option.both (minimum t) (maximum t)

let toArray = Belt.Map.Int.toArray

let to_array = toArray

let toList = Belt.Map.Int.toList

let to_list = toList
