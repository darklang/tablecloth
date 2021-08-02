module Option = TableclothOption

type 'value t = 'value Belt.Map.String.t

let fromArray
    (values : ('key * 'v) array) : 'value t =
  Belt.Map.String.fromArray values


let from_array = fromArray

let empty = Belt.Map.String.empty

let fromList l = fromArray (Array.of_list l)

let from_list = fromList

let singleton ~key ~value = fromArray [| (key, value) |]

let isEmpty = Belt.Map.String.isEmpty

let is_empty = isEmpty

let includes = Belt.Map.String.has

let length = Belt.Map.String.size

let add m ~key ~value = Belt.Map.String.set m key value

let ( .?{}<- ) (map : 'value t) (key : string) (value : 'value) :
    'value t =
  add map ~key ~value


let remove = Belt.Map.String.remove

let get = Belt.Map.String.get

let ( .?{} ) (map : 'value t) (key : 'key) : 'value option =
  get map key


let update m ~key ~f = Belt.Map.String.update m key f

let merge m1 m2 ~f = Belt.Map.String.merge m1 m2 f

let map m ~f = Belt.Map.String.map m (fun value -> f value)

let mapWithIndex t ~f = Belt.Map.String.mapWithKey t f

let map_with_index = mapWithIndex

let filter m ~f = Belt.Map.String.keep m (fun _ value -> f value)

let partition m ~f = Belt.Map.String.partition m (fun key value -> f ~key ~value)

let find m ~f = Belt.Map.String.findFirstBy m (fun key value -> f ~key ~value)

let any m ~f = Belt.Map.String.some m (fun _ value -> f value)

let all m ~f = Belt.Map.String.every m (fun _ value -> f value)

let forEach m ~f = Belt.Map.String.forEach m (fun _ value -> f value)

let for_each = forEach

let forEachWithIndex m ~f = Belt.Map.String.forEach m (fun key value -> f ~key ~value)

let for_each_with_index = forEachWithIndex

let fold m ~initial ~f =
  Belt.Map.String.reduce m initial (fun acc key data -> f acc ~key ~value:data)


let keys m = Belt.Map.String.keysToArray m |. Array.to_list

let values m = Belt.Map.String.valuesToArray m |. Array.to_list

let maximum = Belt.Map.String.maxKey

let minimum = Belt.Map.String.minKey

let extent t = Option.both (minimum t) (maximum t)

let toArray = Belt.Map.String.toArray

let to_array = toArray

let toList = Belt.Map.String.toList

let to_list = toList
