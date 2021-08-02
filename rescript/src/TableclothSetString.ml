type nonrec t = Belt.Set.String.t

let fromArray = Belt.Set.String.fromArray

let from_array = fromArray

let empty = Belt.Set.String.empty

let singleton elem = Belt.Set.String.fromArray [|elem|]

let fromList a = a |> Array.of_list |> Belt.Set.String.fromArray

let from_list = fromList

let length = Belt.Set.String.size

let isEmpty = Belt.Set.String.isEmpty

let is_empty = isEmpty

let includes = Belt.Set.String.has

let ( .?{} ) (set : t) (element : string) : bool =
  includes set element

let add = Belt.Set.String.add

let remove = Belt.Set.String.remove

let difference = Belt.Set.String.diff

let intersection = Belt.Set.String.intersect

let union = Belt.Set.String.union

let filter s ~f = Belt.Set.String.keep s f

let partition s ~f = Belt.Set.String.partition s f

let find s ~f = (Belt.Set.String.toArray s |. Belt.Array.getBy) f

let all s ~f = Belt.Set.String.every s f

let any s ~f = Belt.Set.String.some s f

let forEach s ~f = Belt.Set.String.forEach s f

let for_each = forEach

let fold s ~initial ~f = Belt.Set.String.reduce s initial f

let toArray = Belt.Set.String.toArray

let to_array = toArray

let toList = Belt.Set.String.toList

let to_list = toList
