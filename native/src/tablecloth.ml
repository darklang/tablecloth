module Bool = Bool
module Char = TableclothChar
module String = TableclothString
module Int = Int
module Float = Float
module Array = TableclothArray
module Option = TableclothOption
module Result = TableclothResult
module Tuple2 = Tuple2
module Tuple3 = Tuple3

module List = struct
  type 'a t = 'a list

  let concat (ls : 'a list list) : 'a list = Base.List.concat ls

  let reverse (l : 'a list) : 'a list = Base.List.rev l

  let append (l1 : 'a list) (l2 : 'a list) : 'a list = Base.List.append l1 l2

  let sum (l : int list) : int =
    Base.List.reduce l ~f:( + ) |> Base.Option.value ~default:0


  let floatSum (l : float list) : float =
    Base.List.reduce l ~f:( +. ) |> Base.Option.value ~default:0.0


  let float_sum = floatSum

  let map ~(f : 'a -> 'b) (l : 'a list) : 'b list = Base.List.map l ~f

  let indexedMap ~(f : 'int -> 'a -> 'b) (l : 'a list) : 'b list =
    Base.List.mapi l ~f


  let indexed_map = indexedMap

  let mapi = indexedMap

  let map2 ~(f : 'a -> 'b -> 'c) (a : 'a list) (b : 'b list) : 'c list =
    Base.List.map2_exn a b ~f


  let getBy ~(f : 'a -> bool) (l : 'a list) : 'a option = Base.List.find l ~f

  let get_by = getBy

  let find = getBy

  let elemIndex ~(value : 'a) (l : 'a list) : int option =
    Base.List.findi l ~f:(fun _ v -> v = value)
    |> Base.Option.map ~f:Tuple2.first


  let elem_index = elemIndex

  let rec last (l : 'a list) : 'a option =
    match l with [] -> None | [ a ] -> Some a | _ :: tail -> last tail


  let member ~(value : 'a) (l : 'a list) : bool =
    Base.List.exists l ~f:(( = ) value)


  let uniqueBy ~(f : 'a -> string) (l : 'a list) : 'a list =
    let rec uniqueHelper
        ~(f : 'a -> string)
        (existing : Base.Set.M(Base.String).t)
        (remaining : 'a list)
        (accumulator : 'a list) : 'a list =
      match remaining with
      | [] ->
          reverse accumulator
      | first :: rest ->
          let computedFirst = f first in
          if Base.Set.mem existing computedFirst
          then uniqueHelper ~f existing rest accumulator
          else
            uniqueHelper
              ~f
              (Base.Set.add existing computedFirst)
              rest
              (first :: accumulator)
    in
    uniqueHelper ~f (Base.Set.empty (module Base.String)) l []


  let unique_by = uniqueBy

  let getAt ~(index : int) (l : 'a list) : 'a option = Base.List.nth l index

  let get_at = getAt

  let any ~(f : 'a -> bool) (l : 'a list) : bool = List.exists f l

  let head (l : 'a list) : 'a option = Base.List.hd l

  let drop ~(count : int) (l : 'a list) : 'a list = Base.List.drop l count

  let init (l : 'a list) : 'a list option =
    match reverse l with _ :: rest -> Some (reverse rest) | [] -> None


  let filterMap ~(f : 'a -> 'b option) (l : 'a list) : 'b list =
    Base.List.filter_map l ~f


  let filter_map = filterMap

  let filter ~(f : 'a -> bool) (l : 'a list) : 'a list = Base.List.filter l ~f

  let partition ~(f : 'a -> bool) (l : 'a list) : 'a list * 'a list =
    Base.List.partition_tf ~f l


  let foldRight ~(f : 'a -> 'b -> 'b) ~(initial : 'b) (l : 'a list) : 'b =
    Base.List.fold_right l ~init:initial ~f


  let fold_right = foldRight

  let foldLeft ~(f : 'a -> 'b -> 'b) ~(initial : 'b) (l : 'a list) : 'b =
    Base.List.fold l ~init:initial ~f:(Fun.flip f)


  let fold_left = foldLeft

  let findIndex ~(f : 'a -> bool) (l : 'a list) : int option =
    let rec findIndexHelper ~(i : int) ~(predicate : 'a -> bool) (l : 'a list) :
        int option =
      match l with
      | [] ->
          None
      | x :: rest ->
          if predicate x
          then Some i
          else findIndexHelper ~i:(i + 1) ~predicate rest
    in
    findIndexHelper ~i:0 ~predicate:f l


  let find_index = findIndex

  let take ~(count : int) (l : 'a list) : 'a list = Base.List.take l count

  let splitAt ~(index : int) (l : 'a list) : 'a list * 'a list =
    (take ~count:index l, drop ~count:index l)


  let split_at = splitAt

  let updateAt ~(index : int) ~(f : 'a -> 'a) (l : 'a list) : 'a list =
    if index < 0
    then l
    else
      let front, back = splitAt ~index l in
      match back with [] -> l | x :: rest -> append front (f x :: rest)


  let update_at = updateAt

  let length (l : 'a list) : int = List.length l

  let rec dropWhile ~(f : 'a -> bool) (l : 'a list) : 'a list =
    match l with [] -> [] | x :: rest -> if f x then dropWhile ~f rest else l


  let drop_while = dropWhile

  let isEmpty (l : 'a list) : bool = l = []

  let is_empty = isEmpty

  let sliding ?(step = 1) (t : 'a t) ~(size : int) : 'a t t =
    let rec takeAllOrEmpty t n (current, count) =
      if count = n
      then reverse current
      else
        match t with
        | [] ->
            []
        | x :: xs ->
            takeAllOrEmpty xs n (x :: current, count + 1)
    in
    let rec loop t =
      if isEmpty t
      then []
      else
        let sample = takeAllOrEmpty t size ([], 0) in
        if isEmpty sample then [] else sample :: loop (Base.List.drop t step)
    in
    loop t


  let cons (item : 'a) (l : 'a list) : 'a list = item :: l

  let takeWhile ~(f : 'a -> bool) (l : 'a list) : 'a list =
    let rec takeWhileHelper acc l' =
      match l' with
      | [] ->
          reverse acc
      | x :: rest ->
          if f x then takeWhileHelper (x :: acc) rest else reverse acc
    in
    takeWhileHelper [] l


  let take_while = takeWhile

  let all ~(f : 'a -> bool) (l : 'a list) : bool = Base.List.for_all l ~f

  let tail (l : 'a list) : 'a list option =
    match l with [] -> None | _ :: rest -> Some rest


  let removeAt ~(index : int) (l : 'a list) : 'a list =
    if index < 0
    then l
    else
      let front, back = splitAt ~index l in
      match tail back with None -> l | Some t -> append front t


  let remove_at = removeAt

  let minimumBy ~(f : 'a -> 'comparable) (ls : 'a list) : 'a option =
    let minBy x (y, fy) =
      let fx = f x in
      if fx < fy then (x, fx) else (y, fy)
    in
    match ls with
    | [ l ] ->
        Some l
    | l1 :: lrest ->
        Some (fst (foldLeft ~f:minBy ~initial:(l1, f l1) lrest))
    | _ ->
        None


  let minimum_by = minimumBy

  let minimum (l : 'comparable list) : 'comparable option =
    match l with
    | [] ->
        None
    | [ x ] ->
        Some x
    | x :: rest ->
        Some (foldLeft ~f:min ~initial:x rest)


  let maximumBy ~(f : 'a -> 'comparable) (ls : 'a list) : 'a option =
    let maxBy x (y, fy) =
      let fx = f x in
      if fx > fy then (x, fx) else (y, fy)
    in
    match ls with
    | [ l_ ] ->
        Some l_
    | l_ :: ls_ ->
        Some (fst (foldLeft ~f:maxBy ~initial:(l_, f l_) ls_))
    | _ ->
        None


  let maximum_by = maximumBy

  let maximum (l : 'comparable list) : 'comparable option =
    match l with
    | [] ->
        None
    | [ x ] ->
        Some x
    | x :: rest ->
        Some (foldLeft ~f:max ~initial:x rest)


  let sortBy ~(f : 'a -> 'b) (l : 'a list) : 'a list =
    Base.List.sort l ~compare:(fun a b ->
        let a' = f a in
        let b' = f b in
        if a' = b' then 0 else if a' < b' then -1 else 1)


  let sort_by = sortBy

  let span ~(f : 'a -> bool) (l : 'a list) : 'a list * 'a list =
    match l with [] -> ([], []) | _ -> (takeWhile ~f l, dropWhile ~f l)


  let rec groupWhile ~(f : 'a -> 'a -> bool) (l : 'a list) : 'a list list =
    match l with
    | [] ->
        []
    | x :: rest ->
        let ys, zs = span ~f:(f x) rest in
        (x :: ys) :: groupWhile ~f zs


  let group_while = groupWhile

  let insertAt ~(index : int) ~(value : 'a) (l : 'a list) : 'a list =
    let front, back = splitAt ~index l in
    append front (value :: back)


  let insert_at = insertAt

  let splitWhen ~(f : 'a -> bool) (l : 'a list) : 'a list * 'a list =
    match findIndex ~f l with Some index -> splitAt ~index l | None -> (l, [])


  let split_when = splitWhen

  let intersperse (sep : 'a) (l : 'a list) : 'a list =
    match l with
    | [] ->
        []
    | [ x ] ->
        [ x ]
    | x :: rest ->
        x :: foldRight rest ~initial:[] ~f:(fun x acc -> sep :: x :: acc)


  let initialize (n : int) (f : int -> 'a) : 'a list = Base.List.init n ~f

  let sortWith (f : 'a -> 'a -> int) (l : 'a list) : 'a list =
    Base.List.sort l ~compare:f


  let sort_with = sortWith

  let iter ~(f : 'a -> unit) (l : 'a list) : unit = Base.List.iter l ~f

  let forEachWithIndex (l : 'a list) ~(f : int -> 'a -> unit) : unit =
    Base.List.iteri l ~f


  let rec repeat ~(count : int) (value : 'a) : 'a list =
    if count > 0 then value :: repeat ~count:(count - 1) value else []
end

module IntSet = struct
  module Set = Base.Set.M (Base.Int)

  let __pp_value = Format.pp_print_int

  type t = Set.t

  type value = int

  let fromList (l : value list) : t = Base.Set.of_list (module Base.Int) l

  let from_list = fromList

  let member ~(value : value) (s : t) : bool = Base.Set.mem s value

  let diff (set1 : t) (set2 : t) : t = Base.Set.diff set1 set2

  let isEmpty (s : t) : bool = Base.Set.is_empty s

  let is_empty = isEmpty

  let toList (s : t) : value list = Base.Set.to_list s

  let to_list = toList

  let ofList (s : value list) : t = Base.Set.of_list (module Base.Int) s

  let of_list = ofList

  let union (s1 : t) (s2 : t) : t = Base.Set.union s1 s2

  let empty = Base.Set.empty (module Base.Int)

  let add ~(value : value) (s : t) : t = Base.Set.add s value

  let remove ~(value : value) (set : t) = Base.Set.remove set value

  let set ~(value : value) (set : t) = add ~value set

  let has = member

  let pp (fmt : Format.formatter) (set : t) =
    Format.pp_print_string fmt "{ " ;
    Base.Set.iter set ~f:(fun v ->
        __pp_value fmt v ;
        Format.pp_print_string fmt ", ") ;
    Format.pp_print_string fmt " }" ;
    ()
end

module StrSet = struct
  module Set = Base.Set.M (Base.String)

  let __pp_value = Format.pp_print_string

  type t = Set.t

  type value = string

  let fromList (l : value list) : t = Base.Set.of_list (module Base.String) l

  let from_list = fromList

  let member ~(value : value) (set : t) : bool = Base.Set.mem set value

  let diff (set1 : t) (set2 : t) : t = Base.Set.diff set1 set2

  let isEmpty (s : t) : bool = Base.Set.is_empty s

  let is_empty = isEmpty

  let toList (s : t) : value list = Base.Set.to_list s

  let to_list = toList

  let ofList (s : value list) : t = Base.Set.of_list (module Base.String) s

  let of_list = ofList

  let add ~(value : value) (s : t) : t = Base.Set.add s value

  let union (s1 : t) (s2 : t) : t = Base.Set.union s1 s2

  let empty = Base.Set.empty (module Base.String)

  let remove ~(value : value) (set : t) = Base.Set.remove set value

  let set ~(value : value) (set : t) = add ~value set

  let has = member

  let pp (fmt : Format.formatter) (set : t) =
    Format.pp_print_string fmt "{ " ;
    Base.Set.iter set ~f:(fun v ->
        __pp_value fmt v ;
        Format.pp_print_string fmt ", ") ;
    Format.pp_print_string fmt " }" ;
    ()
end

module StrDict = struct
  module Map = Base.Map.M (Base.String)

  type key = string

  type 'value t = 'value Map.t

  let toList t : ('key * 'value) list = Base.Map.to_alist t

  let to_list = toList

  let empty : 'value t = Base.Map.empty (module Base.String)

  let fromList (l : ('key * 'value) list) : 'value t =
    Base.Map.of_alist_reduce (module Base.String) ~f:(fun _ r -> r) l


  let from_list = fromList

  let get ~(key : key) (dict : 'value t) : 'value option =
    Base.Map.find dict key


  let insert ~(key : key) ~(value : 'value) (dict : 'value t) : 'value t =
    Base.Map.set dict ~key ~data:value


  let keys dict : key list = Base.Map.keys dict

  let update ~(key : key) ~(f : 'v option -> 'v option) (dict : 'value t) :
      'value t =
    Base.Map.change dict key ~f


  let map dict ~(f : 'a -> 'b) = Base.Map.map dict ~f

  let pp
      (valueFormatter : Format.formatter -> 'value -> unit)
      (fmt : Format.formatter)
      (map : 'value t) =
    Format.pp_print_string fmt "{ " ;
    Base.Map.iteri map ~f:(fun ~key ~data ->
        Format.pp_print_string fmt key ;
        Format.pp_print_string fmt ": " ;
        valueFormatter fmt data ;
        Format.pp_print_string fmt ",  ") ;
    Format.pp_print_string fmt "}" ;
    ()


  let merge
      ~(f : key -> 'v1 option -> 'v2 option -> 'v3 option)
      (dict1 : 'v1 t)
      (dict2 : 'v2 t) : 'v3 t =
    Base.Map.merge dict1 dict2 ~f:(fun ~key desc ->
        match desc with
        | `Left v1 ->
            f key (Some v1) None
        | `Right v2 ->
            f key None (Some v2)
        | `Both (v1, v2) ->
            f key (Some v1) (Some v2))
end

module IntDict = struct
  module Map = Base.Map.M (Base.Int)

  type key = int

  type 'value t = 'value Map.t

  let toList t : ('key * 'value) list = Base.Map.to_alist t

  let to_list = toList

  let empty : 'value t = Base.Map.empty (module Base.Int)

  let fromList (l : ('key * 'value) list) : 'value t =
    Base.Map.of_alist_reduce (module Base.Int) ~f:(fun _ r -> r) l


  let from_list = fromList

  let get ~(key : key) (dict : 'value t) : 'value option =
    Base.Map.find dict key


  let insert ~(key : key) ~(value : 'value) (dict : 'value t) : 'value t =
    Base.Map.set dict ~key ~data:value


  let keys dict : key list = Base.Map.keys dict

  let update ~(key : key) ~(f : 'v option -> 'v option) (dict : 'value t) :
      'value t =
    Base.Map.change dict key ~f


  let map dict ~(f : 'a -> 'b) = Base.Map.map dict ~f

  let pp
      (valueFormatter : Format.formatter -> 'value -> unit)
      (fmt : Format.formatter)
      (map : 'value t) =
    Format.pp_print_string fmt "{ " ;
    Base.Map.iteri map ~f:(fun ~key ~data ->
        Format.pp_print_int fmt key ;
        Format.pp_print_string fmt ": " ;
        valueFormatter fmt data ;
        Format.pp_print_string fmt ",  ") ;
    Format.pp_print_string fmt "}" ;
    ()


  let merge
      ~(f : key -> 'v1 option -> 'v2 option -> 'v3 option)
      (dict1 : 'v1 t)
      (dict2 : 'v2 t) : 'v3 t =
    Base.Map.merge dict1 dict2 ~f:(fun ~key desc ->
        match desc with
        | `Left v1 ->
            f key (Some v1) None
        | `Right v2 ->
            f key None (Some v2)
        | `Both (v1, v2) ->
            f key (Some v1) (Some v2))
end

module Fun = Fun
