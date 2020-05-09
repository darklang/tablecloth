module Fun = struct
  external identity : 'a -> 'a = "%identity"

  external ignore : _ -> unit = "%ignore"

  let constant a _ = a

  let sequence _ b = b

  let flip f x y = f y x

  let apply f a = f a

  let ( <| ) a b = a b

  external pipe : 'a -> ('a -> 'b) -> 'b = "%revapply"

  external ( |> ) : 'a -> ('a -> 'b) -> 'b = "%revapply"

  let compose g f a = g (f a)

  let ( << ) = compose

  let composeRight g f a = f (g a)

  let ( >> ) = composeRight

  let tap a ~f =
    f a ;
    a
end

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
    let rec findIndexHelper ~(i : int) ~(predicate : 'a -> bool) (l : 'a list)
        : int option =
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
end

module Result = struct
  type ('err, 'ok) t = ('ok, 'err) Belt.Result.t

  let succeed a = Belt.Result.Ok a

  let fail e = Belt.Result.Error e

  let withDefault ~(default : 'ok) (r : ('err, 'ok) t) : 'ok =
    Belt.Result.getWithDefault r default


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
    List.foldRight ~f:(map2 ~f:(fun a b -> a :: b)) ~initial:(Ok []) l


  let map (f : 'ok -> 'value) (r : ('err, 'ok) t) : ('err, 'value) t =
    Belt.Result.map r f


  let fromOption ~error ma =
    match ma with None -> fail error | Some right -> succeed right


  let from_option = fromOption

  let toOption (r : ('err, 'ok) t) : 'ok option =
    match r with Ok v -> Some v | _ -> None


  let to_option = toOption

  let andThen ~(f : 'ok -> ('err, 'value) t) (r : ('err, 'ok) t) :
      ('err, 'value) t =
    Belt.Result.flatMap r f


  let and_then = andThen

  let pp
      (errf : Format.formatter -> 'err -> unit)
      (okf : Format.formatter -> 'ok -> unit)
      (fmt : Format.formatter)
      (r : ('err, 'ok) t) =
    match r with
    | Ok ok ->
        Format.pp_print_string fmt "<ok: " ;
        okf fmt ok ;
        Format.pp_print_string fmt ">"
    | Error err ->
        Format.pp_print_string fmt "<error: " ;
        errf fmt err ;
        Format.pp_print_string fmt ">"
end

module Option = struct
  type 'a t = 'a option

  let some a = Some a

  let andThen ~(f : 'a -> 'b option) (o : 'a option) : 'b option =
    match o with None -> None | Some x -> f x


  let and_then = andThen

  let or_ (ma : 'a option) (mb : 'a option) : 'a option =
    match ma with None -> mb | Some _ -> ma


  let orElse (ma : 'a option) (mb : 'a option) : 'a option =
    match mb with None -> ma | Some _ -> mb


  let or_else = orElse

  let map ~(f : 'a -> 'b) (o : 'a option) : 'b option = Belt.Option.map o f

  let withDefault ~(default : 'a) (o : 'a option) : 'a =
    Belt.Option.getWithDefault o default


  let with_default = withDefault

  let values (l : 'a option list) : 'a list =
    let valuesHelper (item : 'a option) (l : 'a list) : 'a list =
      match item with None -> l | Some v -> v :: l
    in
    List.foldRight ~f:valuesHelper ~initial:[] l


  let toList (o : 'a option) : 'a list =
    match o with None -> [] | Some o -> [ o ]


  let to_list = toList

  let isSome = Belt.Option.isSome

  let is_some = isSome

  let toOption ~(sentinel : 'a) (value : 'a) : 'a option =
    if value = sentinel then None else Some value


  let to_option = toOption

  let getExn (x : 'a option) =
    match x with
    | None ->
        raise (Invalid_argument "option is None")
    | Some x ->
        x


  let get_exn = getExn
end

module Char = struct
  let toCode (c : char) : int = Char.code c

  let to_code = toCode

  let fromCode (i : int) : char option =
    if 0 <= i && i <= 255 then Some (Char.chr i) else None


  let from_code = fromCode

  let toString c = String.make 1 c

  let to_string = toString

  let fromString (str : string) : char option =
    match String.length str with 1 -> Some str.[0] | _ -> None


  let from_string = fromString

  let toDigit char =
    match char with '0' .. '9' -> Some (toCode char - toCode '0') | _ -> None


  let to_digit = toDigit

  let toLowercase char =
    match char with
    | 'A' .. 'Z' ->
        Char.chr (toCode 'a' + (toCode char - toCode 'A'))
    | _ ->
        char


  let to_lowercase = toLowercase

  let toUppercase char =
    match char with
    | 'a' .. 'z' ->
        Char.chr (toCode 'A' + (toCode char - toCode 'a'))
    | _ ->
        char


  let to_uppercase = toUppercase

  let isLowercase = function 'a' .. 'z' -> true | _ -> false

  let is_lowercase = isLowercase

  let isUppercase = function 'A' .. 'Z' -> true | _ -> false

  let is_uppercase = isUppercase

  let isLetter = function 'a' .. 'z' | 'A' .. 'Z' -> true | _ -> false

  let is_letter = isLetter

  let isDigit = function '0' .. '9' -> true | _ -> false

  let is_digit = isDigit

  let isAlphanumeric = function
    | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' ->
        true
    | _ ->
        false


  let is_alphanumeric = isAlphanumeric

  let isPrintable = function ' ' .. '~' -> true | _ -> false

  let is_printable = isPrintable

  let isWhitespace = function
    | '\t'
    | '\n'
    | '\011' (* vertical tab *)
    | '\012' (* form feed *)
    | '\r'
    | ' ' ->
        true
    | _ ->
        false


  let is_whitespace = isWhitespace
end

module Float = struct
  type t = float

  let add = ( +. )

  let ( + ) = ( +. )

  let subtract = ( -. )

  let ( - ) = ( -. )

  let multiply = ( *. )

  let ( * ) = ( *. )

  let divide n ~by = n /. by

  let ( / ) = ( /. )

  let power ~base ~exponent = Js.Math.pow_float ~base ~exp:exponent

  let ( ** ) base exponent = power ~base ~exponent

  let negate = ( ~-. )

  let ( ~- ) = ( ~-. )

  let absolute = Js.Math.abs_float

  let clamp n ~lower ~upper =
    if upper < lower
    then
      raise
        (Invalid_argument
           ( "~lower:"
           ^ Js.Float.toString lower
           ^ " must be less than or equal to ~upper:"
           ^ Js.Float.toString upper ))
    else if Js.Float.isNaN lower || Js.Float.isNaN upper || Js.Float.isNaN n
    then nan
    else max lower (min upper n)


  let inRange n ~lower ~upper =
    if upper < lower
    then
      raise
        (Invalid_argument
           ( "~lower:"
           ^ Js.Float.toString lower
           ^ " must be less than or equal to ~upper:"
           ^ Js.Float.toString upper ))
    else n >= lower && n < upper


  let in_range = inRange

  let squareRoot = sqrt

  let square_root = squareRoot

  let log n ~base = Js.Math.log n / Js.Math.log base

  let zero = 0.0

  let one = 1.0

  let nan = Js.Float._NaN

  let infinity = infinity

  let negativeInfinity = neg_infinity

  let negative_infinity = negativeInfinity

  let e = Js.Math._E

  let pi = Js.Math._PI

  let isNaN = Js.Float.isNaN

  let is_nan = isNaN

  let isFinite = Js.Float.isFinite

  let is_finite = isFinite

  let isInfinite n = (not (Js.Float.isFinite n)) && not (isNaN n)

  let is_infinite = isInfinite

  let maximum x y = if isNaN x || isNaN y then nan else if y > x then y else x

  let minimum x y = if isNaN x || isNaN y then nan else if y < x then y else x

  let hypotenuse = Js.Math.hypot

  let degrees n = n * (pi / 180.0)

  let radians = Fun.identity

  let turns n = n * 2. * pi

  let cos = Js.Math.cos

  let acos = Js.Math.acos

  let sin = Js.Math.sin

  let asin = Js.Math.asin

  let tan = Js.Math.tan

  let atan = Js.Math.atan

  let atan2 ~y ~x = Js.Math.atan2 ~y ~x ()

  type direction =
    [ `Zero
    | `AwayFromZero
    | `Up
    | `Down
    | `Closest of [ `Zero | `AwayFromZero | `Up | `Down | `ToEven ]
    ]

  let round ?(direction = `Closest `Up) n =
    match direction with
    | `Up ->
        Js.Math.ceil_float n
    | `Down ->
        Js.Math.floor_float n
    | `Zero ->
        Js.Math.trunc n
    | `AwayFromZero ->
        if n > 0. then Js.Math.ceil_float n else Js.Math.floor_float n
    | `Closest `Zero ->
        if n > 0.
        then Js.Math.ceil_float (n -. 0.5)
        else Js.Math.floor_float (n +. 0.5)
    | `Closest `AwayFromZero ->
        if n > 0.
        then Js.Math.floor_float (n +. 0.5)
        else Js.Math.ceil_float (n -. 0.5)
    | `Closest `Down ->
        Js.Math.ceil_float (n -. 0.5)
    | `Closest `Up ->
        Js.Math.round n
    | `Closest `ToEven ->
        (* Outside of the range (roundNearestLowerBound..roundNearestUpperBound), all representable doubles
           are integers in the mathematical sense, and [round_nearest] should be identity.

           However, for odd numbers with the absolute value between 2**52 and 2**53, the formula
           [round x = floor (x + 0.5)] does not hold:

           {v
             # let naiveRoundNearest x = floor (x +. 0.5);;
             # let x = 2. ** 52. +. 1.;;
             val x : float = 4503599627370497.
             # naive_round_nearest x;;
             - :     float = 4503599627370498.
           v}
        *)
        let roundNearestLowerBound = -.(2. ** 52.) in
        let roundNearestUpperBound = 2. ** 52. in
        if n <= roundNearestLowerBound || n >= roundNearestUpperBound
        then n +. 0.
        else
          let floor = floor n in
          let ceil_or_succ = floor +. 1. in
          let diff_floor = n -. floor in
          let diff_ceil = ceil_or_succ -. n in
          if diff_floor < diff_ceil
          then floor
          else if diff_floor > diff_ceil
          then ceil_or_succ
          else if mod_float floor 2. = 0.
          then floor
          else ceil_or_succ


  let floor = Js.Math.floor_float

  let ceiling = Js.Math.ceil_float

  let truncate = Js.Math.trunc

  let fromPolar (r, theta) = (r * cos theta, r * sin theta)

  let from_polar = fromPolar

  let toPolar (x, y) = (hypotenuse x y, atan2 ~x ~y)

  let to_polar = toPolar

  let fromInt = Js.Int.toFloat

  let from_int = fromInt

  let toInt f =
    if Js.Float.isFinite f then Some (Js.Math.unsafe_trunc f) else None


  let to_int = toInt
end

module Int = struct
  type t = int

  let minimumValue = Js.Int.min

  let minimum_value = minimumValue

  let maximumValue = Js.Int.max

  let maximum_value = maximumValue

  let zero = 0

  let one = 1

  let add = ( + )

  let ( + ) = ( + )

  let subtract = ( - )

  let ( - ) = ( - )

  let multiply = ( * )

  let ( * ) = multiply

  let divide n ~by = n / by

  let ( / ) = ( / )

  let ( // ) n by = Js.Int.toFloat n /. Js.Int.toFloat by

  let power ~base ~exponent = Js.Math.pow_int ~base ~exp:exponent

  let ( ** ) base exponent = Js.Math.pow_int ~base ~exp:exponent

  let negate = ( ~- )

  let ( ~- ) = ( ~- )

  let modulo n ~by = n mod by

  let remainder n ~by = n mod by

  let maximum = Js.Math.max_int

  let minimum = Js.Math.min_int

  let absolute n = if n < 0 then n * -1 else n

  let isEven n = n mod 2 = 0

  let is_even = isEven

  let isOdd n = n mod 2 <> 0

  let is_odd = isOdd

  let clamp n ~lower ~upper =
    if upper < lower
    then raise (Invalid_argument "~lower must be less than or equal to ~upper")
    else max lower (min upper n)


  let inRange n ~lower ~upper =
    if upper < lower
    then raise (Invalid_argument "~lower must be less than or equal to ~upper")
    else n >= lower && n < upper


  let in_range = inRange

  let toFloat = Js.Int.toFloat

  let to_float = toFloat

  let toString = Js.Int.toString

  let to_string = toString

  let fromString s =
    match int_of_string s with i -> Some i | exception Failure _ -> None


  let from_string = fromString
end

module Tuple2 = struct
  let create a b = (a, b)

  let first ((a, _) : 'a * 'b) : 'a = a

  let second ((_, b) : 'a * 'b) : 'b = b

  let mapFirst ~(f : 'a -> 'x) ((a, b) : 'a * 'b) : 'x * 'b = (f a, b)

  let map_first = mapFirst

  let mapSecond ~(f : 'b -> 'y) ((a, b) : 'a * 'b) : 'a * 'y = (a, f b)

  let map_second = mapSecond

  let mapEach ~(f : 'a -> 'x) ~(g : 'b -> 'y) ((a, b) : 'a * 'b) : 'x * 'y =
    (f a, g b)


  let map_each = mapEach

  let mapAll ~(f : 'a -> 'b) (a1, a2) = (f a1, f a2)

  let map_all = mapAll

  let swap (a, b) = (b, a)

  let curry (f : 'a * 'b -> 'c) (a : 'a) (b : 'b) : 'c = f (a, b)

  let uncurry (f : 'a -> 'b -> 'c) ((a, b) : 'a * 'b) : 'c = f a b

  let toList (a, b) = [ a; b ]

  let to_list = toList
end

module Tuple3 = struct
  let create a b c = (a, b, c)

  let first ((a, _, _) : 'a * 'b * 'c) : 'a = a

  let second ((_, b, _) : 'a * 'b * 'c) : 'b = b

  let third ((_, _, c) : 'a * 'b * 'c) : 'c = c

  let init ((a, b, _) : 'a * 'b * 'c) : 'a * 'b = (a, b)

  let tail ((_, b, c) : 'a * 'b * 'c) : 'b * 'c = (b, c)

  let mapFirst ~(f : 'a -> 'x) ((a, b, c) : 'a * 'b * 'c) : 'x * 'b * 'c =
    (f a, b, c)


  let map_first = mapFirst

  let mapSecond ~(f : 'b -> 'y) ((a, b, c) : 'a * 'b * 'c) : 'a * 'y * 'c =
    (a, f b, c)


  let map_second = mapSecond

  let mapThird ~(f : 'c -> 'z) ((a, b, c) : 'a * 'b * 'c) : 'a * 'b * 'z =
    (a, b, f c)


  let map_third = mapThird

  let mapEach
      ~(f : 'a -> 'x)
      ~(g : 'b -> 'y)
      ~(h : 'c -> 'z)
      ((a, b, c) : 'a * 'b * 'c) : 'x * 'y * 'z =
    (f a, g b, h c)


  let map_each = mapEach

  let mapAll ~(f : 'a -> 'b) (a1, a2, a3) = (f a1, f a2, f a3)

  let map_all = mapAll

  let rotateLeft ((a, b, c) : 'a * 'b * 'c) : 'b * 'c * 'a = (b, c, a)

  let rotate_left = rotateLeft

  let rotateRight ((a, b, c) : 'a * 'b * 'c) : 'c * 'a * 'b = (c, a, b)

  let rotate_right = rotateRight

  let curry (f : 'a * 'b * 'c -> 'd) (a : 'a) (b : 'b) (c : 'c) : 'd =
    f (a, b, c)


  let uncurry (f : 'a -> 'b -> 'c -> 'd) ((a, b, c) : 'a * 'b * 'c) : 'd =
    f a b c


  let toList ((a, b, c) : 'a * 'a * 'a) : 'a list = [ a; b; c ]

  let to_list = toList
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
    Js.String.substr ~from:count s


  let drop_left = dropLeft

  let dropRight ~(count : int) (s : string) : string =
    if count < 1 then s else Js.String.slice ~from:0 ~to_:(-count) s


  let drop_right = dropRight

  let split ~(on : string) (s : string) : string list =
    Js.String.split on s |> Belt.List.fromArray


  let join ~(sep : string) (l : string list) : string = String.concat sep l

  let endsWith ~(suffix : string) (s : string) = Js.String.endsWith suffix s

  let ends_with = endsWith

  let startsWith ~(prefix : string) (s : string) =
    Js.String.startsWith prefix s


  let starts_with = startsWith

  include Compat.String

  let to_lower = toLower

  let to_upper = toUpper

  let is_capitalized = isCapitalized

  let contains ~(substring : string) (s : string) : bool =
    Js.String.includes substring s


  let repeat ~(count : int) (s : string) : string = Js.String.repeat count s

  let reverse (s : string) =
    s
    |> Js.String.castToArrayLike
    |> Js.Array.from
    |> Js.Array.reverseInPlace
    |> Belt.List.fromArray
    |> String.concat ""


  let fromList (l : char list) : string =
    l
    |> List.map ~f:Char.toCode
    |> List.map ~f:Js.String.fromCharCode
    |> String.concat ""


  let from_list = fromList

  let toList (s : string) : char list =
    s |> Js.String.castToArrayLike |> Js.Array.from |> Belt.List.fromArray


  let to_list = toList

  let fromInt (i : int) : string = Printf.sprintf "%d" i

  let from_int = fromInt

  let concat = String.concat ""

  let fromChar (c : char) : string = c |> Char.toCode |> Js.String.fromCharCode

  let from_char = fromChar

  let slice ~from ~to_ str = Js.String.slice ~from ~to_ str

  let trim = Js.String.trim

  let insertAt ~(insert : string) ~(index : int) (s : string) : string =
    Js.String.slice ~from:0 ~to_:index s
    ^ insert
    ^ Js.String.sliceToEnd ~from:index s


  let insert_at = insertAt
end

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
    |> List.map ~f:(fun (k, v) ->
           "\"" ^ k ^ "\": \"" ^ Js.String.make v ^ "\"")
    |> String.join ~sep:", "
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
    |> String.join ~sep:", "
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
