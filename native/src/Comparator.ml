type ('a, 'identity) t = ('a, 'identity) Base.Comparator.t

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

let opaque _ = Base.Sexp.Atom "<opaque>"

module Make (M : T) = struct
  module BaseComparator = Base.Comparator.Make (struct
    include M

    let compare = M.compare

    let sexp_of_t = opaque
  end)

  include BaseComparator

  type identity = BaseComparator.comparator_witness

  let comparator = BaseComparator.comparator
end

let make ~compare = Obj.magic (Base.Comparator.make ~compare ~sexp_of_t:opaque)
