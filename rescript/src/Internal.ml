let toBeltComparator
    (type a id)
    (module M : TableclothComparator.S with type identity = id and type t = a) :
    (a, id) Belt.Id.comparable =
  ( module struct
    type t = M.t

    type identity = M.identity

    let cmp = Obj.magic M.comparator
  end )
