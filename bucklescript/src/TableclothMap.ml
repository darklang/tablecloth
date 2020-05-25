module Option = TableclothOption

type ('key, 'value, 'cmp) t = ('key, 'value, 'cmp) Belt.Map.t

module Of (M : Comparator.S) = struct
  type nonrec 'value t = (M.t, 'value, M.identity) t
end

let fromArray
    (comparator : ('key, 'id) Comparator.s) (values : ('key * 'v) array) :
    ('key, 'value, 'id) t =
  Belt.Map.fromArray values ~id:(Internal.toBeltComparator comparator)


let from_array = fromArray

let empty comparator = fromArray comparator [||]

let fromList comparator l = fromArray comparator (Array.of_list l)

let from_list = fromList

let singleton comparator ~key ~value = fromArray comparator [| (key, value) |]

let isEmpty = Belt.Map.isEmpty

let is_empty = isEmpty

let includes = Belt.Map.has

let length = Belt.Map.size

let add m ~key ~value = Belt.Map.set m key value

let ( .?{}<- ) (map : ('key, 'value, 'id) t) (key : 'key) (value : 'value) :
    ('key, 'value, 'id) t =
  add map ~key ~value


let remove = Belt.Map.remove

let get = Belt.Map.get

let ( .?{} ) (map : ('key, 'value, _) t) (key : 'key) : 'value option =
  get map key


let update m ~key ~f = Belt.Map.update m key f

let merge m1 m2 ~f = Belt.Map.merge m1 m2 f

let map m ~f = Belt.Map.map m (fun value -> f value)

let mapWithIndex t ~f = Belt.Map.mapWithKey t f

let map_with_index = mapWithIndex

let filter m ~f = Belt.Map.keep m (fun _ value -> f value)

let partition m ~f = Belt.Map.partition m (fun key value -> f ~key ~value)

let find m ~f = Belt.Map.findFirstBy m (fun key value -> f ~key ~value)

let any m ~f = Belt.Map.some m (fun _ value -> f value)

let all m ~f = Belt.Map.every m (fun _ value -> f value)

let forEach m ~f = Belt.Map.forEach m (fun _ value -> f value)

let for_each = forEach

let forEachWithIndex m ~f = Belt.Map.forEach m (fun key value -> f ~key ~value)

let for_each_with_index = forEachWithIndex

let fold m ~initial ~f =
  Belt.Map.reduce m initial (fun acc key data -> f acc ~key ~value:data)


let keys m = Belt.Map.keysToArray m |. Array.to_list

let values m = Belt.Map.valuesToArray m |. Array.to_list

let maximum = Belt.Map.maxKey

let minimum = Belt.Map.minKey

let extent t = Option.both (minimum t) (maximum t)

let toArray = Belt.Map.toArray

let to_array = toArray

let toList = Belt.Map.toList

let to_list = toList

module Poly = struct
  type identity

  type nonrec ('k, 'v) t = ('k, 'v, identity) t

  let fromArray (type k v) (a : (k * v) array) =
    ( Belt.Map.fromArray
        a
        ~id:
          ( module struct
            type t = k

            type nonrec identity = identity

            let cmp = Pervasives.compare |. Obj.magic
          end )
      : (k, v) t )


  let from_array = fromArray

  let empty () = fromArray [||]

  let fromList l = fromArray (Array.of_list l)

  let from_list = fromList

  let singleton ~key ~value = fromArray [| (key, value) |]
end

module Int = struct
  type nonrec 'value t = 'value Of(Int).t

  let fromArray a = Poly.fromArray a |. Obj.magic

  let from_array = fromArray

  let empty = fromArray [||]

  let singleton ~key ~value = fromArray [| (key, value) |]

  let fromList l = fromArray (Array.of_list l)

  let from_list = fromList
end

module String = struct
  type nonrec 'value t = 'value Of(TableclothString).t

  let fromArray a = Poly.fromArray a |. Obj.magic

  let from_array = fromArray

  let empty = fromArray [||]

  let singleton ~key ~value = fromArray [| (key, value) |]

  let fromList l = fromArray (Array.of_list l)

  let from_list = fromList
end
