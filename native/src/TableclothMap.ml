module Comparator = TableclothComparator

type ('key, 'value, 'id) t = ('key, 'value, 'id) Base.Map.t

module Of (M : TableclothComparator.S) = struct
  type nonrec 'value t = (M.t, 'value, M.identity) t
end

let keepLatestOnly _ latest = latest

let empty (comparator : ('key, 'identity) TableclothComparator.s) :
    ('key, 'value, 'identity) t =
  Base.Map.empty (Internal.toBaseComparator comparator)


let singleton
    (comparator : ('key, 'identity) TableclothComparator.s) ~key ~value :
    ('key, 'value, 'identity) t =
  Base.Map.of_alist_reduce
    (Internal.toBaseComparator comparator)
    [ (key, value) ]
    ~f:keepLatestOnly


let fromArray
    (comparator : ('key, 'identity) TableclothComparator.s)
    (elements : ('key * 'value) array) : ('key, 'value, 'identity) t =
  Base.Map.of_alist_reduce
    (Internal.toBaseComparator comparator)
    (Array.to_list elements)
    ~f:keepLatestOnly


let from_array = fromArray

let fromList
    (comparator : ('key, 'identity) TableclothComparator.s)
    (elements : ('key * 'value) list) : ('key, 'value, 'identity) t =
  Base.Map.of_alist_reduce
    (Internal.toBaseComparator comparator)
    elements
    ~f:keepLatestOnly


let from_list = fromList

let isEmpty = Base.Map.is_empty

let is_empty = isEmpty

let includes = Base.Map.mem

let length = Base.Map.length

let minimum t = Base.Map.min_elt t |> Option.map fst

let maximum t = Base.Map.max_elt t |> Option.map fst

let extent t = TableclothOption.both (minimum t) (maximum t)

let add m ~key ~value = Base.Map.set m ~key ~data:value

let ( .?{}<- ) (map : ('key, 'value, 'id) t) (key : 'key) (value : 'value) :
    ('key, 'value, 'id) t =
  add map ~key ~value


let remove = Base.Map.remove

let get = Base.Map.find

let ( .?{} ) (map : ('key, 'value, _) t) (key : 'key) : 'value option =
  get map key


let update m ~key ~f = Base.Map.change m key ~f

let merge m1 m2 ~f =
  Base.Map.merge m1 m2 ~f:(fun ~key desc ->
      match desc with
      | `Left v1 ->
          f key (Some v1) None
      | `Right v2 ->
          f key None (Some v2)
      | `Both (v1, v2) ->
          f key (Some v1) (Some v2) )


let map = Base.Map.map

let mapWithIndex t ~f = Base.Map.mapi t ~f:(fun ~key ~data -> f key data)

let map_with_index = mapWithIndex

let filter = Base.Map.filter

let partition m ~f =
  Base.Map.partitioni_tf m ~f:(fun ~key ~data -> f ~key ~value:data)


let find m ~f =
  Base.Map.fold m ~init:None ~f:(fun ~key ~data matching ->
      match matching with
      | Some _ ->
          matching
      | None ->
          if f ~key ~value:data then Some (key, data) else None )


let any = Base.Map.exists

let all = Base.Map.for_all

let forEach = Base.Map.iter

let for_each = forEach

let forEachWithIndex
    (map : ('key, 'value, _) t) ~(f : key:'key -> value:'value -> unit) : unit =
  Base.Map.iteri map ~f:(fun ~key ~data -> f ~key ~value:data)


let for_each_with_index = forEachWithIndex

let fold m ~initial ~f =
  Base.Map.fold m ~init:initial ~f:(fun ~key ~data acc ->
      f acc ~key ~value:data )


let keys = Base.Map.keys

let values = Base.Map.data

let toArray m = Base.Map.to_alist m |> Base.List.to_array

let to_array = toArray

let toList m = Base.Map.to_alist m

let to_list = toList

module Poly = struct
  type identity = Base.Comparator.Poly.comparator_witness

  type nonrec ('k, 'v) t = ('k, 'v, identity) t

  let empty () = Base.Map.Poly.empty

  let singleton ~key ~value = Base.Map.Poly.singleton key value

  let fromList l = Base.Map.Poly.of_alist_reduce l ~f:(fun _ curr -> curr)

  let from_list = fromList

  let fromArray a = Base.Array.to_list a |> fromList

  let from_array = fromArray
end

module Int = struct
  type nonrec 'v t = (TableclothInt.t, 'v, TableclothInt.identity) t

  let empty = Obj.magic (Base.Map.empty (module Base.Int))

  let singleton ~key ~value =
    Obj.magic (Base.Map.singleton (module Base.Int) key value)


  let fromList l =
    Obj.magic
      (Base.Map.of_alist_reduce (module Base.Int) l ~f:(fun _ curr -> curr))


  let from_list = fromList

  let fromArray a = Obj.magic (Base.Array.to_list a |> fromList)

  let from_array = fromArray
end

module String = struct
  type nonrec 'value t =
    (TableclothString.t, 'value, TableclothString.identity) t

  let empty = Obj.magic (Base.Map.empty (module Base.String))

  let singleton ~key ~value =
    Obj.magic (Base.Map.singleton (module Base.String) key value)


  let fromList l =
    Obj.magic
      (Base.Map.of_alist_reduce (module Base.String) l ~f:(fun _ curr -> curr))


  let from_list = fromList

  let fromArray a = Obj.magic (Base.Array.to_list a |> fromList)

  let from_array = fromArray
end
