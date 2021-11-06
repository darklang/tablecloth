module Comparator = TableclothComparator

let to_base_comparator (comparator : ('a, 'id) TableclothComparator.s) :
    ('a, 'id) Base.Map.comparator =
  Obj.magic comparator
