type ('a, 'identity) t = ('a, 'identity) Belt.Id.cmp

type ('a, 'identity) comparator = ('a, 'identity) t

module type T = sig
  type nonrec t

  val compare : t -> t -> int
end

module type S = sig
  type nonrec t

  type identity

  val comparator : (t, identity) comparator
end

type ('a, 'identity) s =
  (module S with type identity = 'identity and type t = 'a)

module Make (M : T) : S with type t = M.t = struct
  module BeltComparator = Belt.Id.MakeComparable (struct
    type t = M.t

    let cmp = M.compare
  end)

  type t = M.t

  type identity = BeltComparator.identity

  let comparator = BeltComparator.cmp
end
