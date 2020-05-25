type ('a, 'id) t = ('a, 'id) Belt.Set.t

module Of (M : Comparator.S) = struct
  type nonrec t = (M.t, M.identity) t
end

let empty comparator = Belt.Set.make ~id:(Internal.toBeltComparator comparator)

let singleton (comparator : ('a, 'identity) Comparator.s) (element : 'a) :
    ('a, 'identity) t =
  Belt.Set.fromArray ~id:(Internal.toBeltComparator comparator) [| element |]


let fromArray (comparator : ('a, 'identity) Comparator.s) (elements : 'a array)
    : ('a, 'identity) t =
  Belt.Set.fromArray ~id:(Internal.toBeltComparator comparator) elements


let from_array = fromArray

let fromList (comparator : ('a, 'identity) Comparator.s) (elements : 'a list) :
    ('a, 'identity) t =
  Belt.Set.fromArray
    ~id:(Internal.toBeltComparator comparator)
    (Array.of_list elements)


let from_list = fromList

let length = Belt.Set.size

let isEmpty = Belt.Set.isEmpty

let is_empty = isEmpty

let includes = Belt.Set.has

let ( .?{} ) (set : ('element, _) t) (element : 'element) : bool =
  includes set element


let add = Belt.Set.add

let remove = Belt.Set.remove

let difference = Belt.Set.diff

let intersection = Belt.Set.intersect

let union = Belt.Set.union

let filter s ~f = Belt.Set.keep s f

let partition s ~f = Belt.Set.partition s f

let find s ~f = (Belt.Set.toArray s |. Belt.Array.getBy) f

let all s ~f = Belt.Set.every s f

let any s ~f = Belt.Set.some s f

let forEach s ~f = Belt.Set.forEach s f

let for_each = forEach

let fold s ~initial ~f = Belt.Set.reduce s initial f

let toArray = Belt.Set.toArray

let to_array = toArray

let toList = Belt.Set.toList

let to_list = toList

module Poly = struct
  type identity

  type nonrec 'a t = ('a, identity) t

  let fromArray (type a) (a : a array) =
    ( Belt.Set.fromArray
        a
        ~id:
          ( module struct
            type t = a

            type nonrec identity = identity

            let cmp = Pervasives.compare |. Obj.magic
          end )
      : a t )


  let from_array = fromArray

  let fromList l = Array.of_list l |. fromArray

  let from_list = fromList

  let empty () = fromArray [||]

  let singleton a = fromArray [| a |]
end

module Int = struct
  type nonrec t = Of(Int).t

  let fromArray a = Poly.fromArray a |. Obj.magic

  let from_array = fromArray

  let empty = fromArray [||]

  let singleton a = fromArray [| a |]

  let fromList l = Array.of_list l |. fromArray

  let from_list = fromList
end

module String = struct
  type nonrec t = Of(TableclothString).t

  let fromArray a = Poly.fromArray a |. Obj.magic

  let from_array = fromArray

  let empty = fromArray [||]

  let singleton a = fromArray [| a |]

  let fromList l = Array.of_list l |. fromArray

  let from_list = fromList
end
