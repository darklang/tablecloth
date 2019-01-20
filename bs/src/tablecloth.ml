let ( <| ) a b = a b

let ( >> ) (f1 : 'a -> 'b) (f2 : 'b -> 'c) : 'a -> 'c = fun x -> x |> f1 |> f2

let ( << ) (f1 : 'b -> 'c) (f2 : 'a -> 'b) : 'a -> 'c = fun x -> x |> f2 |> f1

let identity (value : 'a) : 'a = value

module List = struct
  let flatten = Belt.List.flatten

  let sum (l : int list) : int = Belt.List.reduce l 0 ( + )

  let floatSum (l : float list) : float = Belt.List.reduce l 0.0 ( +. )

  let map ~(f : 'a -> 'b) (l : 'a list) : 'b list = Belt.List.map l f

  let indexedMap ~(f : 'int -> 'a -> 'b) (l : 'a list) : 'b list =
    Belt.List.mapWithIndex l f


  let map2 ~(f : 'a -> 'b -> 'c) (a : 'a list) (b : 'b list) : 'c list =
    Belt.List.mapReverse2 a b f |> Belt.List.reverse


  let getBy ~(f : 'a -> bool) (l : 'a list) : 'a option = Belt.List.getBy l f

  let elemIndex ~(value : 'a) (l : 'a list) : int option =
    let toOption ~(sentinel : 'a) (value : 'a) : 'a option =
      if value = sentinel then None else Some value
    in
    l
    |> Array.of_list
    |> Js.Array.findIndex (( = ) value)
    |> toOption ~sentinel:(-1)


  let rec last (l : 'a list) : 'a option =
    match l with [] -> None | [a] -> Some a | _ :: tail -> last tail


  let member ~(value : 'a) (l : 'a list) : bool = Belt.List.has l value ( = )

  let uniqueBy ~(f : 'a -> string) (l : 'a list) : 'a list =
    let rec uniqueHelp
        (f : 'a -> string)
        (existing : Belt.Set.String.t)
        (remaining : 'a list)
        (accumulator : 'a list) =
      match remaining with
      | [] ->
          List.rev accumulator
      | first :: rest ->
          let computedFirst = f first in
          if Belt.Set.String.has existing computedFirst
          then uniqueHelp f existing rest accumulator
          else
            uniqueHelp
              f
              (Belt.Set.String.add existing computedFirst)
              rest
              (first :: accumulator)
    in
    uniqueHelp f Belt.Set.String.empty l []


  let find ~(f : 'a -> bool) (l : 'a list) : 'a option = Belt.List.getBy l f

  let getAt ~(index : int) (l : 'a list) : 'a option = Belt.List.get l index

  let any ~(f : 'a -> bool) (l : 'a list) : bool = List.exists f l

  let head (l : 'a list) : 'a option = Belt.List.head l

  let drop ~(count : int) (l : 'a list) : 'a list =
    Belt.List.drop l count |. Belt.Option.getWithDefault []


  let init (l : 'a list) : 'a list option =
    match List.rev l with _ :: rest -> Some (List.rev rest) | [] -> None


  let filterMap ~(f : 'a -> 'b option) (l : 'a list) : 'b list =
    Belt.List.keepMap l f


  let filter ~(f : 'a -> bool) (l : 'a list) : 'a list = Belt.List.keep l f

  let concat (ls : 'a list list) : 'a list =
    ls |> Belt.List.toArray |> Belt.List.concatMany


  let partition ~(f : 'a -> bool) (l : 'a list) : 'a list * 'a list =
    List.partition f l


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


  let take ~(count : int) (l : 'a list) : 'a list =
    Belt.List.take l count |. Belt.Option.getWithDefault []


  let updateAt ~(index : int) ~(f : 'a -> 'a) (list : 'a list) : 'a list =
    if index < 0
    then list
    else
      let head = take ~count:index list in
      let tail = drop ~count:index list in
      match tail with x :: xs -> head @ (f x :: xs) | _ -> list


  let length (l : 'a list) : int = List.length l

  let reverse (l : 'a list) : 'a list = List.rev l

  let rec dropWhile ~(f : 'a -> bool) (list : 'a list) : 'a list =
    match list with
    | [] ->
        []
    | x :: xs ->
        if f x then dropWhile ~f xs else list


  let isEmpty (l : 'a list) : bool = l = []

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


  let all ~(f : 'a -> bool) (l : 'a list) : bool = Belt.List.every l f

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


  let maximum ~(list : 'comparable list) : 'comparable option =
    match list with x :: xs -> Some (foldl ~f:max ~init:x xs) | _ -> None


  let sortBy ~(f : 'a -> 'b) (l : 'a list) : 'a list =
    Belt.List.sort l (fun a b ->
        let a' = f a in
        let b' = f b in
        if a' = b' then 0 else if a' < b' then -1 else 1 )


  let span ~(f : 'a -> bool) (xs : 'a list) : 'a list * 'a list =
    (takeWhile ~f xs, dropWhile ~f xs)


  let rec groupWhile ~(f : 'a -> 'a -> bool) (xs : 'a list) : 'a list list =
    match xs with
    | [] ->
        []
    | x :: xs ->
        let ys, zs = span ~f:(f x) xs in
        (x :: ys) :: groupWhile ~f zs


  let splitAt ~(index : int) (xs : 'a list) : 'a list * 'a list =
    (take ~count:index xs, drop ~count:index xs)


  let insertAt ~(index : int) ~(value : 'a) (xs : 'a list) : 'a list =
    take ~count:index xs @ (value :: drop ~count:index xs)


  let splitWhen ~(f : 'a -> bool) (list : 'a list) : ('a list * 'a list) option
      =
    findIndex ~f list |. Belt.Option.map (fun index -> splitAt ~index list)


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
    Belt.List.sort l f


  let fromArray (arr : 'a Js.Array.t) : 'a list = Belt.List.fromArray arr

  let iter ~(f : 'a -> unit) (l : 'a list) : unit = List.iter f l

  let for_all2_exn (l1 : 'a list) (l2 : 'b list) (f : 'a -> 'b -> bool) : bool
      =
    let n1 = length l1 in
    let n2 = length l2 in
    if n1 <> n2
    then
      raise
        (Invalid_argument
           (Printf.sprintf "length mismatch in for_all2_exn: %d <> %d " n1 n2))
    else List.for_all2 f l1 l2


  let mapi = List.mapi
end

module Result = struct
  type ('err, 'ok) t = ('ok, 'err) Belt.Result.t

  let withDefault (default : 'ok) (r : ('err, 'ok) t) : 'ok =
    Belt.Result.getWithDefault r default


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
    Belt.Result.map r f


  let toOption (r : ('err, 'ok) t) : 'ok option =
    match r with Ok v -> Some v | _ -> None


  let pp
      (_ : Format.formatter -> 'err -> unit)
      (_ : Format.formatter -> 'ok -> unit)
      (_ : Format.formatter)
      (_ : ('err, 'ok) t) =
    ()
end

module Regex = struct
  let regex s : Js.Re.t = Js.Re.fromStringWithFlags ~flags:"g" s

  let contains ~(re : Js.Re.t) (s : string) : bool = Js.Re.test s re

  let replace (re : string) (repl : string) (str : string) =
    Js.String.replaceByRe (regex re) repl str


  let matches (re : Js.Re.t) (s : string) : Js.Re.result option =
    Js.Re.exec s re
end

module Option = struct
  type 'a t = 'a option

  let andThen (f : 'a -> 'b option) (o : 'a option) : 'b option =
    match o with None -> None | Some x -> f x


  let or_ (ma : 'a option) (mb : 'a option) : 'a option =
    match ma with None -> mb | Some _ -> ma


  let orElse (ma : 'a option) (mb : 'a option) : 'a option =
    match mb with None -> ma | Some _ -> mb


  let map (f : 'a -> 'b) (o : 'a option) : 'b option = Belt.Option.map o f

  let withDefault (a : 'a) (o : 'a option) : 'a =
    Belt.Option.getWithDefault o a


  let foldrValues (item : 'a option) (list : 'a list) : 'a list =
    match item with None -> list | Some v -> v :: list


  let values (l : 'a option list) : 'a list =
    List.foldr ~f:foldrValues ~init:[] l


  let toList (o : 'a option) : 'a list =
    match o with None -> [] | Some o -> [o]


  let isSome = Belt.Option.isSome
end

module Char = struct
  let toCode (c : char) : int = Char.code c

  let fromCode (i : int) : char = Char.chr i
end

module Tuple2 = struct
  let mapSecond (f : 'b -> 'c) ((a, b) : 'a * 'b) : 'a * 'c = (a, f b)

  let second ((_, b) : 'a * 'b) : 'b = b

  let first ((a, _) : 'a * 'b) : 'a = a

  let create a b = (a, b)
end

module String = struct
  let length = String.length

  let toInt (s : string) : (string, int) Result.t =
    try Ok (int_of_string s) with e -> Error (Printexc.to_string e)


  let toFloat (s : string) : (string, float) Result.t =
    try Ok (float_of_string s) with e -> Error (Printexc.to_string e)


  let uncons (s : string) : (char * string) option =
    match s with
    | "" ->
        None
    | s ->
        Some (s.[0], String.sub s 1 (String.length s - 1))


  let dropLeft (from : int) (s : string) : string = Js.String.substr ~from s

  let dropRight (num : int) (s : string) : string =
    if num < 1 then s else Js.String.slice ~from:0 ~to_:(-num) s


  let split ~(on : string) (s : string) : string list =
    Js.String.split on s |> Belt.List.fromArray


  let join (sep : string) (l : string list) : string = String.concat sep l

  let endsWith (needle : string) (haystack : string) =
    Js.String.endsWith needle haystack


  let startsWith (needle : string) (haystack : string) =
    Js.String.startsWith needle haystack


  let toLower (s : string) : string = String.lowercase s

  let toUpper (s : string) : string = String.uppercase s

  let uncapitalize (s : string) : string = String.uncapitalize s

  let capitalize (s : string) : string = String.capitalize s

  let isCapitalized (s : string) : bool = s = String.capitalize s

  let contains (needle : string) (haystack : string) : bool =
    Js.String.includes needle haystack


  let repeat (count : int) (s : string) : string = Js.String.repeat count s

  let fromList (l : char list) : string =
    l
    |> List.map ~f:Char.toCode
    |> List.map ~f:Js.String.fromCharCode
    |> String.concat ""


  let toList (s : string) : char list =
    s |> Js.String.castToArrayLike |> Js.Array.from |> Belt.List.fromArray


  let fromInt (i : int) : string = Printf.sprintf "%d" i

  let concat = String.concat ""

  let fromChar (c : char) : string = c |> Char.toCode |> Js.String.fromCharCode

  let slice from to_ str = Js.String.slice ~from ~to_ str

  let trim = Js.String.trim

  let insertAt (newStr : string) (pos : int) (origStr : string) : string =
    Js.String.slice ~from:0 ~to_:pos origStr
    ^ newStr
    ^ Js.String.sliceToEnd ~from:pos origStr
end

module IntSet = struct
  module Set = Belt.Set.Int

  type t = Set.t

  type value = Set.value

  let fromList (l : value list) : t = l |> Belt.List.toArray |> Set.fromArray

  let member (i : value) (set : t) : bool = Set.has set i

  let diff (set1 : t) (set2 : t) : t = Set.diff set1 set2

  let isEmpty (s : t) : bool = Set.isEmpty s

  let toList (s : t) : value list = Set.toList s

  let ofList (s : value list) : t = s |> Array.of_list |> Set.fromArray

  let add = Set.add

  let union = Set.union

  let empty = Set.empty
end

module StrSet = struct
  module Set = Belt.Set.String

  type t = Set.t

  type value = Set.value

  let fromList (l : value list) : t = l |> Belt.List.toArray |> Set.fromArray

  let member (i : value) (set : t) : bool = Set.has set i

  let diff (set1 : t) (set2 : t) : t = Set.diff set1 set2

  let isEmpty (s : t) : bool = Set.isEmpty s

  let toList (s : t) : value list = Set.toList s

  let ofList (s : value list) : t = s |> Array.of_list |> Set.fromArray

  let add = Set.add

  let union = Set.union

  let empty = Set.empty
end

module StrDict = struct
  module Map = Belt.Map.String

  type key = Map.key

  type 'value t = 'value Map.t

  let toList = Map.toList

  let empty = Map.empty

  let fromList (l : ('key * 'value) list) : 'value t =
    l |> Belt.List.toArray |> Map.fromArray


  let get (k : key) (v : 'value t) : 'value option = Map.get v k

  let insert (k : key) (v : 'value) (dict : 'value t) : 'value t =
    Map.set dict k v


  let keys m : key list = Map.keysToArray m |> Belt.List.fromArray

  let update (k : key) (f : 'v option -> 'v option) (dict : 'value t) :
      'value t =
    Map.update dict k f


  let map = Map.map
end

module IntDict = struct
  module Map = Belt.Map.Int

  type key = Map.key

  type 'value t = 'value Map.t

  let toList = Map.toList

  let empty = Map.empty

  let fromList (l : ('key * 'value) list) : 'value t =
    l |> Belt.List.toArray |> Map.fromArray


  let get ~(key : key) (dict : 'value t) : 'value option = Map.get dict key

  let insert ~(key : key) ~(value : 'value) (dict : 'value t) : 'value t =
    Map.set dict key value


  let update ~(key : key) ~(f : 'v option -> 'v option) (dict : 'value t) :
      'value t =
    Map.update dict key f


  let keys m : key list = Map.keysToArray m |> Belt.List.fromArray

  let map = Map.map

  let fromStrDict ~(default : key) (d : 'value StrDict.t) : 'value t =
    d
    |> StrDict.toList
    |> List.map ~f:(fun (k, v) ->
           (k |> String.toInt |> Result.withDefault default, v) )
    |> Belt.List.toArray
    |> Map.fromArray
end
