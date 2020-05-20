type ('a, 'id) t = ('a, 'id) Base.Set.t

module Of (M : Comparator.S) = struct
  type nonrec t = (M.t, M.identity) t
end

let empty comparator = Base.Set.empty (Internal.toBaseComparator comparator)

let singleton (comparator : ('a, 'identity) Comparator.s) (element : 'a) :
    ('a, 'identity) t =
  Base.Set.of_list (Internal.toBaseComparator comparator) [ element ]


let fromArray (comparator : ('a, 'identity) Comparator.s) (elements : 'a array)
    : ('a, 'identity) t =
  Base.Set.of_list
    (Internal.toBaseComparator comparator)
    (Array.to_list elements)


let fromList (comparator : ('a, 'identity) Comparator.s) (elements : 'a list) :
    ('a, 'identity) t =
  Base.Set.of_list (Internal.toBaseComparator comparator) elements


let length = Base.Set.length

let isEmpty = Base.Set.is_empty

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

let forEach = Base.Set.iter

let fold s ~initial ~f = Base.Set.fold s ~init:initial ~f

let toArray = Base.Set.to_array

let toList = Base.Set.to_list

module Poly = struct
  type identity = Base.Comparator.Poly.comparator_witness

  type nonrec 'a t = ('a, identity) t

  let empty () = Base.Set.Poly.empty

  let singleton = Base.Set.Poly.singleton

  let fromArray = Base.Set.Poly.of_array

  let fromList = Base.Set.Poly.of_list
end

module Int = struct
  type nonrec t = Of(Int).t

  let empty = empty (module Int)

  let singleton = singleton (module Int)

  let fromArray = fromArray (module Int)

  let fromList = fromList (module Int)
end

module String = struct
  type nonrec t = Of(TableclothString).t

  let empty = empty (module TableclothString)

  let singleton = singleton (module TableclothString)

  let fromArray = fromArray (module TableclothString)

  let fromList = fromList (module TableclothString)
end
