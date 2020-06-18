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


let from_array = fromArray

let fromList (comparator : ('a, 'identity) Comparator.s) (elements : 'a list) :
    ('a, 'identity) t =
  Base.Set.of_list (Internal.toBaseComparator comparator) elements


let from_list = fromList

let length = Base.Set.length

let isEmpty = Base.Set.is_empty

let is_empty = isEmpty

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

let for_each = forEach

let fold s ~initial ~f = Base.Set.fold s ~init:initial ~f

let toArray = Base.Set.to_array

let to_array = toArray

let toList = Base.Set.to_list

let to_list = toList

module Poly = struct
  type identity = Base.Comparator.Poly.comparator_witness

  type nonrec 'a t = ('a, identity) t

  let empty () = Base.Set.Poly.empty

  let singleton = Base.Set.Poly.singleton

  let fromArray = Base.Set.Poly.of_array

  let from_array = fromArray

  let fromList = Base.Set.Poly.of_list

  let from_list = fromList
end

module Int = struct
  type nonrec t = Of(Int).t

  let empty = empty (module Int)

  let singleton = singleton (module Int)

  let fromArray = fromArray (module Int)

  let from_array = fromArray

  let fromList = fromList (module Int)

  let from_list = fromList
end

module String = struct
  type nonrec t = Of(TableclothString).t

  let empty = empty (module TableclothString)

  let singleton = singleton (module TableclothString)

  let fromArray = fromArray (module TableclothString)

  let from_array = fromArray

  let fromList = fromList (module TableclothString)

  let from_list = fromList
end
