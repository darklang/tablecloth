let toBaseComparator (comparator : ('a, 'id) Comparator.s) :
    ('a, 'id) Base.Map.comparator =
  Obj.magic comparator
