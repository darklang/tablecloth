module Bool = Bool
module Char = TableclothChar
module Float = Float
module Int = Int
module Array = TableclothArray
module Option = TableclothOption
module Result = TableclothResult

module List = struct
  type 'a t = 'a list

  let concat (ls : 'a list list) : 'a list = Belt.List.flatten ls

  let reverse (l : 'a list) : 'a list = Belt.List.reverse l

  let append (l1 : 'a list) (l2 : 'a list) : 'a list = Belt.List.concat l1 l2

  let sum (l : int list) : int = Belt.List.reduce l 0 ( + )

  let floatSum (l : float list) : float = Belt.List.reduce l 0.0 ( +. )

  let float_sum = floatSum

  let map ~(f : 'a -> 'b) (l : 'a list) : 'b list = Belt.List.map l f

  let indexedMap ~(f : 'int -> 'a -> 'b) (l : 'a list) : 'b list =
    Belt.List.mapWithIndex l f


  let indexed_map = indexedMap

  let mapi = indexedMap

  let map2 ~(f : 'a -> 'b -> 'c) (a : 'a list) (b : 'b list) : 'c list =
    Belt.List.zipBy a b f


  let getBy ~(f : 'a -> bool) (l : 'a list) : 'a option = Belt.List.getBy l f

  let get_by = getBy

  let elemIndex ~(value : 'a) (l : 'a list) : int option =
    l
    |> Belt.List.toArray
    |> Js.Array.findIndex (( = ) value)
    |> function -1 -> None | index -> Some index


  let elem_index = elemIndex

  let rec last (l : 'a list) : 'a option =
    match l with [] -> None | [ x ] -> Some x | _ :: rest -> last rest


  let member ~(value : 'a) (l : 'a list) : bool = Belt.List.has l value ( = )

  let uniqueBy ~(f : 'a -> string) (l : 'a list) : 'a list =
    let rec uniqueHelper
        (f : 'a -> string)
        (existing : Belt.Set.String.t)
        (remaining : 'a list)
        (accumulator : 'a list) =
      match remaining with
      | [] ->
          reverse accumulator
      | first :: rest ->
          let computedFirst = f first in
          if Belt.Set.String.has existing computedFirst
          then uniqueHelper f existing rest accumulator
          else
            uniqueHelper
              f
              (Belt.Set.String.add existing computedFirst)
              rest
              (first :: accumulator)
    in
    uniqueHelper f Belt.Set.String.empty l []


  let unique_by = uniqueBy

  let find ~(f : 'a -> bool) (l : 'a list) : 'a option = Belt.List.getBy l f

  let getAt ~(index : int) (l : 'a list) : 'a option = Belt.List.get l index

  let get_at = getAt

  let any ~(f : 'a -> bool) (l : 'a list) : bool = List.exists f l

  let head (l : 'a list) : 'a option = Belt.List.head l

  let drop ~(count : int) (l : 'a list) : 'a list =
    Belt.List.drop l count |. Belt.Option.getWithDefault []


  let init (l : 'a list) : 'a list option =
    match reverse l with [] -> None | _ :: rest -> Some (reverse rest)


  let filterMap ~(f : 'a -> 'b option) (l : 'a list) : 'b list =
    Belt.List.keepMap l f


  let filter_map = filterMap

  let filter ~(f : 'a -> bool) (l : 'a list) : 'a list = Belt.List.keep l f

  let partition ~(f : 'a -> bool) (l : 'a list) : 'a list * 'a list =
    Belt.List.partition l f


  let foldLeft ~(f : 'a -> 'b -> 'b) ~(initial : 'b) (l : 'a list) : 'b =
    Belt.List.reduce l initial (Fun.flip f)


  let fold_left = foldLeft

  let foldRight ~(f : 'a -> 'b -> 'b) ~(initial : 'b) (l : 'a list) : 'b =
    Belt.List.reduceReverse l initial (Fun.flip f)


  let fold_right = foldRight

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

  let take ~(count : int) (l : 'a list) : 'a list =
    Belt.List.take l count |. Belt.Option.getWithDefault []


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

  let length (l : 'a list) : int = Belt.List.length l

  let rec dropWhile ~(f : 'a -> bool) (l : 'a list) : 'a list =
    match l with [] -> [] | x :: rest -> if f x then dropWhile ~f rest else l


  let drop_while = dropWhile

  let isEmpty (l : 'a list) : bool = l = []

  let is_empty = isEmpty

  let sliding ?(step = 1) (t : 'a t) ~(size : int) : 'a t t =
    let rec loop t =
      if isEmpty t
      then []
      else
        let sample = Belt.List.take t size in
        let rest = Belt.List.drop t step in
        match (sample, rest) with
        | None, _ ->
            []
        | Some x, None ->
            [ x ]
        | Some x, Some xs ->
            x :: loop xs
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

  let all ~(f : 'a -> bool) (l : 'a list) : bool = Belt.List.every l f

  let tail (l : 'a list) : 'a list option =
    match l with [] -> None | _ :: rest -> Some rest


  let removeAt ~(index : int) (l : 'a list) : 'a list =
    if index < 0
    then l
    else
      let front, back = splitAt ~index l in
      match tail back with None -> l | Some t -> append front t


  let remove_at = removeAt

  let minimumBy ~(f : 'a -> 'comparable) (l : 'a list) : 'a option =
    let minBy x (y, fy) =
      let fx = f x in
      if fx < fy then (x, fx) else (y, fy)
    in
    match l with
    | [] ->
        None
    | [ x ] ->
        Some x
    | x :: rest ->
        Some (fst (foldLeft ~f:minBy ~initial:(x, f x) rest))


  let minimum_by = minimumBy

  let minimum (l : 'comparable list) : 'comparable option =
    match l with
    | [] ->
        None
    | [ x ] ->
        Some x
    | x :: rest ->
        Some (foldLeft ~f:min ~initial:x rest)


  let maximumBy ~(f : 'a -> 'comparable) (l : 'a list) : 'a option =
    let maxBy x (y, fy) =
      let fx = f x in
      if fx > fy then (x, fx) else (y, fy)
    in
    match l with
    | [] ->
        None
    | [ x ] ->
        Some x
    | x :: rest ->
        Some (fst (foldLeft ~f:maxBy ~initial:(x, f x) rest))


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
    Belt.List.sort l (fun a b ->
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

  (* TODO: what about index > length l??? *)
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


  let initialize (n : int) (f : int -> 'a) : 'a list = Belt.List.makeBy n f

  let sortWith (f : 'a -> 'a -> int) (l : 'a list) : 'a list =
    Belt.List.sort l f


  let sort_with = sortWith

  let iter ~(f : 'a -> unit) (l : 'a list) : unit = Belt.List.forEach l f

  let rec repeat ~(count : int) (value : 'a) : 'a list =
    if count > 0 then value :: repeat ~count:(count - 1) value else []


  let join strings ~sep = Js.Array.joinWith sep (Belt.List.toArray strings)

  let values t =
    foldLeft t ~initial:[] ~f:(fun element results ->
        match element with None -> results | Some value -> value :: results)
end

module Tuple2 = Tuple2
module Tuple3 = Tuple3
module String = TableclothString

module StrSet = struct
  module Set = Belt.Set.String

  let __pp_value = Format.pp_print_string

  type t = Set.t

  type value = Set.value

  let fromList (l : value list) : t = l |> Belt.List.toArray |> Set.fromArray

  let from_list = fromList

  let member ~(value : value) (set : t) : bool = Set.has set value

  let diff (set1 : t) (set2 : t) : t = Set.diff set1 set2

  let isEmpty (s : t) : bool = Set.isEmpty s

  let is_empty = isEmpty

  let toList (s : t) : value list = Set.toList s

  let to_list = toList

  let ofList (s : value list) : t = s |> Belt.List.toArray |> Set.fromArray

  let of_list = ofList

  let union = Set.union

  let empty = Set.empty

  let remove ~(value : value) (set : t) = Set.remove set value

  let add ~(value : value) (set : t) = Set.add set value

  let set ~(value : value) (set : t) = Set.add set value

  let has = member

  let pp (fmt : Format.formatter) (set : t) =
    Format.pp_print_string fmt "{ " ;
    Set.forEach set (fun v ->
        __pp_value fmt v ;
        Format.pp_print_string fmt ", ") ;
    Format.pp_print_string fmt " }" ;
    ()
end

module IntSet = struct
  module Set = Belt.Set.Int

  let __pp_value = Format.pp_print_int

  type t = Set.t

  type value = Set.value

  let fromList (l : value list) : t = l |> Belt.List.toArray |> Set.fromArray

  let from_list = fromList

  let member ~(value : value) (set : t) : bool = Set.has set value

  let diff (set1 : t) (set2 : t) : t = Set.diff set1 set2

  let isEmpty (s : t) : bool = Set.isEmpty s

  let is_empty = isEmpty

  let toList (s : t) : value list = Set.toList s

  let to_list = toList

  let ofList (s : value list) : t = s |> Belt.List.toArray |> Set.fromArray

  let of_list = ofList

  let union = Set.union

  let empty = Set.empty

  let remove ~(value : value) (set : t) = Set.remove set value

  let add ~(value : value) (set : t) = Set.add set value

  let set ~(value : value) (set : t) = Set.add set value

  let has = member

  let pp (fmt : Format.formatter) (set : t) =
    Format.pp_print_string fmt "{ " ;
    Set.forEach set (fun v ->
        __pp_value fmt v ;
        Format.pp_print_string fmt ", ") ;
    Format.pp_print_string fmt " }" ;
    ()
end

module StrDict = struct
  module Map = Belt.Map.String

  type key = Map.key

  type 'value t = 'value Map.t

  let toList = Map.toList

  let to_list = toList

  let empty = Map.empty

  let fromList (l : ('key * 'value) list) : 'value t =
    l |> Belt.List.toArray |> Map.fromArray


  let from_list = fromList

  let get ~(key : key) (dict : 'value t) : 'value option = Map.get dict key

  let insert ~(key : key) ~(value : 'value) (dict : 'value t) : 'value t =
    Map.set dict key value


  let keys m : key list = Map.keysToArray m |> Belt.List.fromArray

  let update ~(key : key) ~(f : 'v option -> 'v option) (dict : 'value t) :
      'value t =
    Map.update dict key f


  let map dict ~f = Map.map dict f

  (* Js.String.make gives us "[object Object]", so we actually want our own
     toString. Not perfect, but slightly nicer (e.g., for App.ml's
     DisplayAndReportHttpError, info's values are all strings, which this
     handles) *)
  let toString (d : 'value t) =
    d
    |> toList
    |> List.map ~f:(fun (k, v) -> "\"" ^ k ^ "\": \"" ^ Js.String.make v ^ "\"")
    |> List.join ~sep:", "
    |> fun s -> "{" ^ s ^ "}"


  let to_string = toString

  let pp
      (valueFormatter : Format.formatter -> 'value -> unit)
      (fmt : Format.formatter)
      (map : 'value t) =
    Format.pp_print_string fmt "{ " ;
    Map.forEach map (fun k v ->
        Format.pp_print_string fmt k ;
        Format.pp_print_string fmt ": " ;
        valueFormatter fmt v ;
        Format.pp_print_string fmt ",  ") ;
    Format.pp_print_string fmt "}" ;
    ()


  let merge
      ~(f : key -> 'v1 option -> 'v2 option -> 'v3 option)
      (dict1 : 'v1 t)
      (dict2 : 'v2 t) : 'v3 t =
    Map.merge dict1 dict2 f
end

module IntDict = struct
  module Map = Belt.Map.Int

  type key = Map.key

  type 'value t = 'value Map.t

  let toList = Map.toList

  let to_list = toList

  let empty = Map.empty

  let fromList (l : ('key * 'value) list) : 'value t =
    l |> Belt.List.toArray |> Map.fromArray


  let from_list = fromList

  let get ~(key : key) (dict : 'value t) : 'value option = Map.get dict key

  let insert ~(key : key) ~(value : 'value) (dict : 'value t) : 'value t =
    Map.set dict key value


  let update ~(key : key) ~(f : 'v option -> 'v option) (dict : 'value t) :
      'value t =
    Map.update dict key f


  let keys m : key list = Map.keysToArray m |> Belt.List.fromArray

  let map dict ~f = Map.map dict f

  (* Js.String.make gives us "[object Object]", so we actually want our own
     toString. Not perfect, but slightly nicer (e.g., for App.ml's
     DisplayAndReportHttpError, info's values are all strings, which this
     handles) *)
  let toString (d : 'value t) : string =
    d
    |> toList
    |> List.map ~f:(fun (k, v) ->
           "\"" ^ string_of_int k ^ "\": \"" ^ Js.String.make v ^ "\"")
    |> List.join ~sep:", "
    |> fun s -> "{" ^ s ^ "}"


  let to_string = toString

  let pp
      (valueFormatter : Format.formatter -> 'value -> unit)
      (fmt : Format.formatter)
      (map : 'value t) =
    Format.pp_print_string fmt "{ " ;
    Map.forEach map (fun k v ->
        Format.pp_print_int fmt k ;
        Format.pp_print_string fmt ": " ;
        valueFormatter fmt v ;
        Format.pp_print_string fmt ",  ") ;
    Format.pp_print_string fmt "}" ;
    ()


  let merge
      ~(f : key -> 'v1 option -> 'v2 option -> 'v3 option)
      (dict1 : 'v1 t)
      (dict2 : 'v2 t) : 'v3 t =
    Map.merge dict1 dict2 f
end

module Fun = Fun
