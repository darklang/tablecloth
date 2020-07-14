module Comparator = TableclothComparator

let toBaseComparator (comparator : ('a, 'id) TableclothComparator.s) :
    ('a, 'id) Base.Map.comparator =
  Obj.magic comparator
