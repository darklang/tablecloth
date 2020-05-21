module Bool = Bool
module Char = TableclothChar
module Float = Float
module Int = Int
module Option = Option
module Result = Result

module Array = struct
  type 'a t = 'a array

  let empty () = [||]

  let singleton a = [| a |]

  let length (a : 'a array) : int = Belt.Array.length a

  let isEmpty (a : 'a array) : bool = length a = 0

  let is_empty = isEmpty

  let initialize ~length ~f = Belt.Array.makeBy length f

  let repeat ~length (e : 'a) : 'a array = Belt.Array.make length e

  let range ?(from = 0) (to_ : int) : int array =
    Belt.Array.makeBy (to_ - from) (fun i -> i + from)


  let fromList (l : 'a list) : 'a array = Belt.List.toArray l

  let from_list = fromList

  let toList (a : 'a array) : 'a list = Belt.List.fromArray a

  let to_list = toList

  let toIndexedList array =
    Belt.Array.reduceReverse
      array
      (length array - 1, [])
      (fun (i, acc) x -> (i - 1, (i, x) :: acc))
    |> snd


  let to_indexed_list = toIndexedList

  let get = Belt.Array.get

  let getAt ~index array = get array index

  let get_at = getAt

  let set array index value = array.(index) <- value

  let setAt ~index ~value array = set array index value

  let set_at = setAt

  let sum (a : int array) : int = Belt.Array.reduce a 0 ( + )

  let floatSum (a : float array) : float = Belt.Array.reduce a 0.0 ( +. )

  let float_sum = floatSum

  let filter ~(f : 'a -> bool) (a : 'a array) : 'a array = Belt.Array.keep a f

  let swap a i j =
    let temp = a.(i) in
    a.(i) <- a.(j) ;
    a.(j) <- temp


  let map ~(f : 'a -> 'b) (a : 'a array) : 'b array = Belt.Array.map a f

  let mapWithIndex ~(f : 'int -> 'a -> 'b) (a : 'a array) : 'b array =
    Belt.Array.mapWithIndex a f


  let map_with_index = mapWithIndex

  let map2 ~(f : 'a -> 'b -> 'c) (a : 'a array) (b : 'b array) : 'c array =
    Belt.Array.zipBy a b f


  let map3
      ~(f : 'a -> 'b -> 'c -> 'd)
      (arrayA : 'a array)
      (arrayB : 'b array)
      (arrayC : 'c array) : 'd array =
    let minLength : int =
      Belt.Array.reduce [| length arrayB; length arrayC |] (length arrayA) min
    in
    Belt.Array.makeBy minLength (fun i -> f arrayA.(i) arrayB.(i) arrayC.(i))


  let flatMap ~(f : 'a -> 'b array) (a : 'a array) : 'b array =
    Belt.Array.map a f |> Belt.Array.concatMany


  let flat_map = flatMap

  let sliding ?(step = 1) (a : 'a t) ~(size : int) : 'a t t =
    let n = Array.length a in
    if size > n
    then empty ()
    else
      initialize
        ~length:(1 + ((n - size) / step))
        ~f:(fun i -> initialize ~length:size ~f:(fun j -> a.((i * step) + j)))


  let find ~(f : 'a -> bool) (array : 'a array) : 'a option =
    let rec find_loop array ~f ~length i =
      if i >= length
      then None
      else if f array.(i)
      then Some array.(i)
      else find_loop array ~f ~length (i + 1)
    in
    find_loop array ~f ~length:(length array) 0


  let findIndex array ~f =
    let rec loop index =
      if index >= length array
      then None
      else if f index array.(index)
      then Some (index, array.(index))
      else loop (index + 1)
    in
    loop 0


  let find_index = findIndex

  let any ~(f : 'a -> bool) (a : 'a array) : bool = Belt.Array.some a f

  let all ~(f : 'a -> bool) (a : 'a array) : bool = Belt.Array.every a f

  let append (a : 'a array) (a' : 'a array) : 'a array = Belt.Array.concat a a'

  let concatenate (ars : 'a array array) : 'a array = Belt.Array.concatMany ars

  let intersperse ~(sep : 'a) (array : 'a array) : 'a array =
    Belt.Array.makeBy
      (max 0 ((length array * 2) - 1))
      (fun i -> if i mod 2 <> 0 then sep else array.(i / 2))


  let slice ~from ?to_ array =
    let defaultTo = match to_ with None -> length array | Some i -> i in
    let sliceFrom =
      if from >= 0
      then min (length array) from
      else max 0 (min (length array) (length array + from))
    in
    let sliceTo =
      if defaultTo >= 0
      then min (length array) defaultTo
      else max 0 (min (length array) (length array + defaultTo))
    in
    if sliceFrom >= sliceTo
    then empty ()
    else
      Belt.Array.makeBy (sliceTo - sliceFrom) (fun i -> array.(i + sliceFrom))


  let foldLeft ~(f : 'a -> 'b -> 'b) ~(initial : 'b) (a : 'a array) : 'b =
    Belt.Array.reduce a initial (Fun.flip f)


  let fold_left = foldLeft

  let foldRight ~(f : 'a -> 'b -> 'b) ~(initial : 'b) (a : 'a array) : 'b =
    Belt.Array.reduceReverse a initial (Fun.flip f)


  let fold_right = foldRight

  let reverse (a : 'a array) : 'a array = Belt.Array.reverse a

  let reverseInPlace (a : 'a array) = Belt.Array.reverseInPlace a

  let reverse_in_place = reverseInPlace

  let forEach ~(f : 'a -> unit) (a : 'a array) : unit = Belt.Array.forEach a f

  let for_each = forEach

  let join t ~sep = Js.Array.joinWith sep t


  let values t =
    foldLeft t ~initial:[] ~f:(fun element results ->
        match element with None -> results | Some value -> value :: results)
    |. fromList

end

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
