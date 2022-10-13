module Comparator = TableclothComparator

type ('key, 'value, 'id) t = ('key, 'value, 'id) Base.Map.t

module Of (M : TableclothComparator.S) = struct
  type nonrec 'value t = (M.t, 'value, M.identity) t
end

let keep_latest_only _ latest = latest

let empty (comparator : ('key, 'identity) TableclothComparator.s) :
    ('key, 'value, 'identity) t =
  Base.Map.empty (Internal.to_base_comparator comparator)


let singleton
    (comparator : ('key, 'identity) TableclothComparator.s) ~key ~value :
    ('key, 'value, 'identity) t =
  Base.Map.of_alist_reduce
    (Internal.to_base_comparator comparator)
    [ (key, value) ]
    ~f:keep_latest_only


let from_array
    (comparator : ('key, 'identity) TableclothComparator.s)
    (elements : ('key * 'value) array) : ('key, 'value, 'identity) t =
  Base.Map.of_alist_reduce
    (Internal.to_base_comparator comparator)
    (Array.to_list elements)
    ~f:keep_latest_only


let from_list
    (comparator : ('key, 'identity) TableclothComparator.s)
    (elements : ('key * 'value) list) : ('key, 'value, 'identity) t =
  Base.Map.of_alist_reduce
    (Internal.to_base_comparator comparator)
    elements
    ~f:keep_latest_only


let is_empty = Base.Map.is_empty

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

let map_with_index t ~f = Base.Map.mapi t ~f:(fun ~key ~data -> f key data)

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

let for_each = Base.Map.iter

let for_each_with_index
    (map : ('key, 'value, _) t) ~(f : key:'key -> value:'value -> unit) : unit =
  Base.Map.iteri map ~f:(fun ~key ~data -> f ~key ~value:data)


let fold m ~initial ~f =
  Base.Map.fold m ~init:initial ~f:(fun ~key ~data acc ->
      f acc ~key ~value:data )


let keys = Base.Map.keys

let values = Base.Map.data

let to_array m = Base.Map.to_alist m |> Base.List.to_array

let to_list m = Base.Map.to_alist m

module Poly = struct
  type identity = Base.Comparator.Poly.comparator_witness

  type nonrec ('k, 'v) t = ('k, 'v, identity) t

  let empty () = Base.Map.Poly.empty

  let singleton ~key ~value = Base.Map.Poly.singleton key value

  let from_list l = Base.Map.Poly.of_alist_reduce l ~f:(fun _ curr -> curr)

  let from_array a = Base.Array.to_list a |> from_list
end

module Int = struct
  type nonrec 'v t = (TableclothInt.t, 'v, TableclothInt.identity) t

  let empty = Obj.magic (Base.Map.empty (module Base.Int))

  let singleton ~key ~value =
    Obj.magic (Base.Map.singleton (module Base.Int) key value)


  let from_list l =
    Obj.magic
      (Base.Map.of_alist_reduce (module Base.Int) l ~f:(fun _ curr -> curr))


  let from_array a = Obj.magic (Base.Array.to_list a |> from_list)
end

module String = struct
  type nonrec 'value t =
    (TableclothString.t, 'value, TableclothString.identity) t

  let empty = Obj.magic (Base.Map.empty (module Base.String))

  let singleton ~key ~value =
    Obj.magic (Base.Map.singleton (module Base.String) key value)


  let from_list l =
    Obj.magic
      (Base.Map.of_alist_reduce (module Base.String) l ~f:(fun _ curr -> curr))


  let from_array a = Obj.magic (Base.Array.to_list a |> from_list)
end
