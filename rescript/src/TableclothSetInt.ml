type nonrec t = Belt.Set.Int.t

let fromArray = Belt.Set.Int.fromArray

let from_array = fromArray

let empty = Belt.Set.Int.empty

let singleton elem = Belt.Set.Int.fromArray [|elem|]

let fromList a = a |> Array.of_list |> Belt.Set.Int.fromArray

let from_list = fromList

let length = Belt.Set.Int.size

let isEmpty = Belt.Set.Int.isEmpty

let is_empty = isEmpty

let includes = Belt.Set.Int.has

let ( .?{} ) (set : t) (element : int) : bool =
  includes set element

let add = Belt.Set.Int.add

let remove = Belt.Set.Int.remove

let difference = Belt.Set.Int.diff

let intersection = Belt.Set.Int.intersect

let union = Belt.Set.Int.union

let filter s ~f = Belt.Set.Int.keep s f

let partition s ~f = Belt.Set.Int.partition s f

let find s ~f = (Belt.Set.Int.toArray s |. Belt.Array.getBy) f

let all s ~f = Belt.Set.Int.every s f

let any s ~f = Belt.Set.Int.some s f

let forEach s ~f = Belt.Set.Int.forEach s f

let for_each = forEach

let fold s ~initial ~f = Belt.Set.Int.reduce s initial f

let toArray = Belt.Set.Int.toArray

let to_array = toArray

let toList = Belt.Set.Int.toList

let to_list = toList
