module Comparator = TableclothComparator

type ('a, 'id) t = ('a, 'id) Base.Set.t

module Of (M : TableclothComparator.S) = struct
  type nonrec t = (M.t, M.identity) t
end

let empty comparator = Base.Set.empty (Internal.to_base_comparator comparator)

let singleton
    (comparator : ('a, 'identity) TableclothComparator.s) (element : 'a) :
    ('a, 'identity) t =
  Base.Set.of_list (Internal.to_base_comparator comparator) [ element ]


let from_array
    (comparator : ('a, 'identity) TableclothComparator.s) (elements : 'a array)
    : ('a, 'identity) t =
  Base.Set.of_list
    (Internal.to_base_comparator comparator)
    (Array.to_list elements)


let from_array = from_array

let from_list
    (comparator : ('a, 'identity) TableclothComparator.s) (elements : 'a list) :
    ('a, 'identity) t =
  Base.Set.of_list (Internal.to_base_comparator comparator) elements


let length = Base.Set.length

let is_empty = Base.Set.is_empty

let includes = Base.Set.mem

let ( .?{} ) (set : ('element, _) t) (element : 'element) : bool =
  includes set element


let add = Base.Set.add

let remove = Base.Set.remove

let difference = Base.Set.diff

let intersection = Base.Set.inter

let union = Base.Set.union

let filter = Base.Set.filter

let partition = Base.Set.partition_tf

let find = Base.Set.find

let all = Base.Set.for_all

let any = Base.Set.exists

let for_each = Base.Set.iter

let fold s ~initial ~f = Base.Set.fold s ~init:initial ~f

let to_array = Base.Set.to_array

let to_list = Base.Set.to_list

module Poly = struct
  type identity = Base.Comparator.Poly.comparator_witness

  type nonrec 'a t = ('a, identity) t

  let empty () = Base.Set.Poly.empty

  let singleton = Base.Set.Poly.singleton

  let from_array = Base.Set.Poly.of_array

  let from_list = Base.Set.Poly.of_list
end

module Int = struct
  type nonrec t = Of(TableclothInt).t

  let empty = empty (module TableclothInt)

  let singleton = singleton (module TableclothInt)

  let from_array = from_array (module TableclothInt)

  let from_list = from_list (module TableclothInt)
end

module String = struct
  type nonrec t = Of(TableclothString).t

  let empty = empty (module TableclothString)

  let singleton = singleton (module TableclothString)

  let from_array = from_array (module TableclothString)

  let from_list = from_list (module TableclothString)
end
