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

module Make (M : T) : S with type t = M.t = struct
  module BaseComparator = Base.Comparator.Make (struct
    type t = M.t

    let compare = M.compare

    let sexp_of_t = opaque
  end)

  type t = M.t

  type identity = BaseComparator.comparator_witness

  let comparator = BaseComparator.comparator
end
