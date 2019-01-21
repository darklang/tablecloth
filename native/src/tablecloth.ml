let ( <| ) a b = a b

let ( >> ) (f1 : 'a -> 'b) (f2 : 'b -> 'c) : 'a -> 'c = fun x -> x |> f1 |> f2

let ( << ) (f1 : 'b -> 'c) (f2 : 'a -> 'b) : 'a -> 'c = fun x -> x |> f2 |> f1

let identity (value : 'a) : 'a = value

module Tuple2 = struct
  let mapSecond (f : 'b -> 'c) ((a, b) : 'a * 'b) : 'a * 'c = (a, f b)

  let map_second = mapSecond

  let second ((_, b) : 'a * 'b) : 'b = b

  let first ((a, _) : 'a * 'b) : 'a = a

  let create a b = (a, b)
end

module List = struct
  let flatten = Base.List.concat

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
    match l with [] -> None | [a] -> Some a | _ :: tail -> last tail


  let member ~(value : 'a) (l : 'a list) : bool =
    Base.List.exists l ~f:(( = ) value)


  let uniqueBy ~(f : 'a -> string) (l : 'a list) : 'a list =
    let rec uniqueHelp
        ~(f : 'a -> string)
        (existing : Base.Set.M(Base.String).t)
        (remaining : 'a list)
        (accumulator : 'a list) : 'a list =
      match remaining with
      | [] ->
          List.rev accumulator
      | first :: rest ->
          let computedFirst = f first in
          if Base.Set.mem existing computedFirst
          then uniqueHelp ~f existing rest accumulator
          else
            uniqueHelp
              ~f
              (Base.Set.add existing computedFirst)
              rest
              (first :: accumulator)
    in
    uniqueHelp ~f (Base.Set.empty (module Base.String)) l []


  let unique_by = uniqueBy

  let getAt ~(index : int) (l : 'a list) : 'a option = Base.List.nth l index

  let get_at = getAt

  let any ~(f : 'a -> bool) (l : 'a list) : bool = List.exists f l

  let head (l : 'a list) : 'a option = Base.List.hd l

  let drop ~(count : int) (l : 'a list) : 'a list = Base.List.drop l count

  let init (l : 'a list) : 'a list option =
    match List.rev l with _ :: rest -> Some (List.rev rest) | [] -> None


  let filterMap ~(f : 'a -> 'b option) (l : 'a list) : 'b list =
    Base.List.filter_map l ~f


  let filter_map = filterMap

  let filter ~(f : 'a -> bool) (l : 'a list) : 'a list = Base.List.filter l ~f

  let concat (ls : 'a list list) : 'a list = Base.List.concat ls

  let partition ~(f : 'a -> bool) (l : 'a list) : 'a list * 'a list =
    Base.List.partition_tf ~f l


  let foldr ~(f : 'a -> 'b -> 'b) ~(init : 'b) (l : 'a list) : 'b =
    List.fold_right f l init


  let foldl ~(f : 'a -> 'b -> 'b) ~(init : 'b) (l : 'a list) : 'b =
    List.fold_right f (List.rev l) init


  let rec findIndexHelp
      (index : int) ~(predicate : 'a -> bool) (list : 'a list) : int option =
    match list with
    | [] ->
        None
    | x :: xs ->
        if predicate x
        then Some index
        else findIndexHelp (index + 1) ~predicate xs


  let findIndex ~(f : 'a -> bool) (l : 'a list) : int option =
    findIndexHelp 0 ~predicate:f l


  let find_index = findIndex

  let take ~(count : int) (l : 'a list) : 'a list = Base.List.take l count

  let updateAt ~(index : int) ~(f : 'a -> 'a) (list : 'a list) : 'a list =
    if index < 0
    then list
    else
      let head = take ~count:index list in
      let tail = drop ~count:index list in
      match tail with x :: xs -> head @ (f x :: xs) | _ -> list


  let update_at = updateAt

  let length (l : 'a list) : int = List.length l

  let reverse (l : 'a list) : 'a list = List.rev l

  let rec dropWhile ~(f : 'a -> bool) (list : 'a list) : 'a list =
    match list with
    | [] ->
        []
    | x :: xs ->
        if f x then dropWhile ~f xs else list


  let drop_while = dropWhile

  let isEmpty (l : 'a list) : bool = l = []

  let is_empty = isEmpty

  let cons (item : 'a) (l : 'a list) : 'a list = item :: l

  let takeWhile ~(f : 'a -> bool) (l : 'a list) : 'a list =
    let rec takeWhileMemo memo list =
      match list with
      | [] ->
          List.rev memo
      | x :: xs ->
          if f x then takeWhileMemo (x :: memo) xs else List.rev memo
    in
    takeWhileMemo [] l


  let take_while = takeWhile

  let all ~(f : 'a -> bool) (l : 'a list) : bool = Base.List.for_all l ~f

  let tail (l : 'a list) : 'a list option =
    match l with [] -> None | _ :: rest -> Some rest


  let append (l1 : 'a list) (l2 : 'a list) : 'a list = l1 @ l2

  let removeAt ~(index : int) (l : 'a list) : 'a list =
    if index < 0
    then l
    else
      let head = take ~count:index l in
      let tail = drop ~count:index l |> tail in
      match tail with None -> l | Some t -> append head t


  let remove_at = removeAt

  let minimumBy ~(f : 'a -> 'comparable) (ls : 'a list) : 'a option =
    let minBy x (y, fy) =
      let fx = f x in
      if fx < fy then (x, fx) else (y, fy)
    in
    match ls with
    | [l] ->
        Some l
    | l1 :: lrest ->
        Some (fst <| foldl ~f:minBy ~init:(l1, f l1) lrest)
    | _ ->
        None


  let minimum_by = minimumBy

  let maximumBy ~(f : 'a -> 'comparable) (ls : 'a list) : 'a option =
    let maxBy x (y, fy) =
      let fx = f x in
      if fx > fy then (x, fx) else (y, fy)
    in
    match ls with
    | [l_] ->
        Some l_
    | l_ :: ls_ ->
        Some (fst <| foldl ~f:maxBy ~init:(l_, f l_) ls_)
    | _ ->
        None


  let maximum_by = maximumBy

  let maximum ~(list : 'comparable list) : 'comparable option =
    match list with x :: xs -> Some (foldl ~f:max ~init:x xs) | _ -> None


  let sortBy ~(f : 'a -> 'b) (l : 'a list) : 'a list =
    Base.List.sort l ~compare:(fun a b ->
        let a' = f a in
        let b' = f b in
        if a' = b' then 0 else if a' < b' then -1 else 1 )


  let sort_by = sortBy

  let span ~(f : 'a -> bool) (xs : 'a list) : 'a list * 'a list =
    (takeWhile ~f xs, dropWhile ~f xs)


  let rec groupWhile ~(f : 'a -> 'a -> bool) (xs : 'a list) : 'a list list =
    match xs with
    | [] ->
        []
    | x :: xs ->
        let ys, zs = span ~f:(f x) xs in
        (x :: ys) :: groupWhile ~f zs


  let group_while = groupWhile

  let splitAt ~(index : int) (xs : 'a list) : 'a list * 'a list =
    (take ~count:index xs, drop ~count:index xs)


  let split_at = splitAt

  let insertAt ~(index : int) ~(value : 'a) (xs : 'a list) : 'a list =
    take ~count:index xs @ (value :: drop ~count:index xs)


  let insert_at = insertAt

  let splitWhen ~(f : 'a -> bool) (list : 'a list) : ('a list * 'a list) option
      =
    findIndex ~f list |> Base.Option.map ~f:(fun index -> splitAt ~index list)


  let split_when = splitWhen

  let intersperse (sep : 'a) (xs : 'a list) : 'a list =
    match xs with
    | [] ->
        []
    | hd :: tl ->
        let step x rest = sep :: x :: rest in
        let spersed = foldr ~f:step ~init:[] tl in
        hd :: spersed


  let initialize (n : int) (f : int -> 'a) : 'a list =
    let rec step i acc = if i < 0 then acc else step (i - 1) (f i :: acc) in
    step (n - 1) []


  let sortWith (f : 'a -> 'a -> int) (l : 'a list) : 'a list =
    Base.List.sort l ~compare:f


  let sort_with = sortWith

  let iter ~(f : 'a -> unit) (l : 'a list) : unit = List.iter f l
end

module Option = struct
  type 'a t = 'a option

  let andThen ~(f : 'a -> 'b option) (o : 'a option) : 'b option =
    match o with None -> None | Some x -> f x


  let and_then = andThen

  let or_ (ma : 'a option) (mb : 'a option) : 'a option =
    match ma with None -> mb | Some _ -> ma


  let orElse (ma : 'a option) (mb : 'a option) : 'a option =
    match mb with None -> ma | Some _ -> mb


  let or_else = orElse

  let map ~(f : 'a -> 'b) (o : 'a option) : 'b option = Base.Option.map o ~f

  let withDefault ~(default : 'a) (o : 'a option) : 'a =
    Base.Option.value o ~default


  let with_default = withDefault

  let foldrValues (item : 'a option) (list : 'a list) : 'a list =
    match item with None -> list | Some v -> v :: list


  let foldr_values = foldrValues

  let values (l : 'a option list) : 'a list =
    List.foldr ~f:foldrValues ~init:[] l


  let toList (o : 'a option) : 'a list =
    match o with None -> [] | Some o -> [o]


  let to_list = toList

  let isSome = Base.Option.is_some

  let is_some = isSome
end

module Result = struct
  type ('err, 'ok) t = ('ok, 'err) Base.Result.t

  let withDefault ~(default : 'ok) (r : ('err, 'ok) t) : 'ok =
    Base.Result.ok r |> Base.Option.value ~default


  let with_default = withDefault

  let map2 ~(f : 'a -> 'b -> 'c) (a : ('err, 'a) t) (b : ('err, 'b) t) :
      ('err, 'c) t =
    match (a, b) with
    | Ok a, Ok b ->
        Ok (f a b)
    | Error a, Ok _ ->
        Error a
    | Ok _, Error b ->
        Error b
    | Error a, Error _ ->
        Error a


  let combine (l : ('x, 'a) t list) : ('x, 'a list) t =
    List.foldr ~f:(map2 ~f:(fun a b -> a :: b)) ~init:(Ok []) l


  let map (f : 'ok -> 'value) (r : ('err, 'ok) t) : ('err, 'value) t =
    Base.Result.map r ~f


  let toOption (r : ('err, 'ok) t) : 'ok option =
    match r with Ok v -> Some v | _ -> None


  let to_option = toOption
end

module Char = struct
  let toCode (c : char) : int = Char.code c

  let to_code = toCode

  let fromCode (i : int) : char = Char.chr i

  let from_code = fromCode
end

module String = struct
  let length = String.length

  let toInt (s : string) : (string, int) Result.t =
    try Ok (int_of_string s) with e -> Error (Printexc.to_string e)


  let to_int = toInt

  let toFloat (s : string) : (string, float) Result.t =
    try Ok (float_of_string s) with e -> Error (Printexc.to_string e)


  let to_float = toFloat

  let uncons (s : string) : (char * string) option =
    match s with
    | "" ->
        None
    | s ->
        Some (s.[0], String.sub s 1 (String.length s - 1))


  let dropLeft ~(count : int) (s : string) : string =
    Base.String.drop_prefix s count


  let drop_left = dropLeft

  let dropRight ~(count : int) (s : string) : string =
    Base.String.drop_suffix s count


  let drop_right = dropRight

  let split ~(on : string) (s : string) : string list =
    let on = Str.regexp_string on in
    Str.split on s


  let join ~(sep : string) (l : string list) : string = String.concat sep l

  let endsWith ~(suffix : string) (s : string) =
    Base.String.is_suffix ~suffix s


  let ends_with = endsWith

  let startsWith ~(prefix : string) (s : string) =
    Base.String.is_prefix ~prefix s


  let starts_with = startsWith

  let toLower (s : string) : string = String.lowercase_ascii s

  let to_lower = toLower

  let toUpper (s : string) : string = String.uppercase_ascii s

  let to_upper = toUpper

  let uncapitalize (s : string) : string = String.uncapitalize_ascii s

  let capitalize (s : string) : string = String.capitalize_ascii s

  let isCapitalized (s : string) : bool = s = String.capitalize_ascii s

  let is_capitalized = isCapitalized

  let contains ~(substring : string) (s : string) : bool =
    Base.String.is_substring s ~substring


  let repeat ~(count : int) (s : string) : string =
    Base.List.init count ~f:(fun _ -> s) |> Base.String.concat


  let fromList (l : char list) : string = Base.String.of_char_list l

  let from_list = fromList

  let toList (s : string) : char list = Base.String.to_list s

  let to_list = toList

  let fromInt (i : int) : string = string_of_int i

  let from_int = fromInt

  let concat = String.concat ""

  let fromChar (c : char) : string = Base.String.of_char c

  let from_char = fromChar

  let slice ~from ~to_ str = String.sub str from (to_ - from)

  let trim = String.trim

  let insertAt ~(insert : string) ~(index : int) (s : string) : string =
    let length = String.length s in
    let startCount = index in
    let endCount = length - index in
    let start = dropRight ~count:endCount s in
    let end_ = dropLeft ~count:startCount s in
    join ~sep:"" [start; insert; end_]


  let insert_at = insertAt
end

module IntSet = struct
  module Set = Base.Set.M (Base.Int)

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

  let add (s : t) (value : value) : t = Base.Set.add s value

  let union (s1 : t) (s2 : t) : t = Base.Set.union s1 s2

  let empty = Base.Set.empty (module Base.Int)
end

module StrSet = struct
  module Set = Base.Set.M (Base.String)

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

  let add (s : t) (value : value) : t = Base.Set.add s value

  let union (s1 : t) (s2 : t) : t = Base.Set.union s1 s2

  let empty = Base.Set.empty (module Base.String)
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
end
