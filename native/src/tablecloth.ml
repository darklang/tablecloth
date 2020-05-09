module Fun = struct
  external identity : 'a -> 'a = "%identity"

  external ignore : _ -> unit = "%ignore"

  let constant a _ = a

  let sequence a b =
    ignore a ;
    b


  let flip f a b = f b a

  let apply f a = f a

  let ( <| ) f a = f a

  external pipe : 'a -> ('a -> 'b) -> 'b = "%revapply"

  external ( |> ) : 'a -> ('a -> 'b) -> 'b = "%revapply"

  let compose f g a = f (g a)

  let ( << ) = compose

  let composeRight f g a = g (f a)

  let ( >> ) = composeRight

  let tap value ~f =
    f value ;
    value
end

module Array = struct
  type 'a t = 'a array

  let empty () = [||]

  let singleton (a : 'a) : 'a array = [| a |]

  let length (a : 'a array) : int = Base.Array.length a

  let isEmpty (a : 'a array) : bool = length a = 0

  let is_empty = isEmpty

  let initialize ~(length : int) ~(f : int -> 'a) =
    if length <= 0 then empty () else Base.Array.init length ~f


  let repeat ~(length : int) (e : 'a) : 'a array =
    if length <= 0 then empty () else Base.Array.init length ~f:(fun _ -> e)


  let range ?(from = 0) (to_ : int) : int array =
    Base.Array.init (max 0 (to_ - from)) ~f:(fun i -> i + from)


  let fromList (l : 'a list) : 'a array = Base.List.to_array l

  let from_list = fromList

  let toList (a : 'a array) : 'a list = Base.Array.to_list a

  let to_list = toList

  let toIndexedList a =
    Base.Array.fold_right
      a
      ~init:(length a - 1, [])
      ~f:(fun x (i, acc) -> (i - 1, (i, x) :: acc))
    |> Base.snd


  let to_indexed_list = toIndexedList

  let get a index =
    if index >= 0 && index < length a
    then Some (Base.Array.get a index)
    else None


  let getAt ~index a = get a index

  let get_at = getAt

  let set = Base.Array.set

  let setAt ~index ~value a = set a index value

  let set_at = setAt

  let sum (a : int array) : int = Base.Array.fold a ~init:0 ~f:( + )

  let floatSum (a : float array) : float =
    Base.Array.fold a ~init:0.0 ~f:( +. )


  let float_sum = floatSum

  let filter ~(f : 'a -> bool) (a : 'a array) : 'a array =
    Base.Array.filter a ~f


  let swap = Base.Array.swap

  let map ~(f : 'a -> 'b) (a : 'a array) : 'b array = Base.Array.map a ~f

  let mapWithIndex ~(f : 'int -> 'a -> 'b) (a : 'a array) : 'b array =
    Base.Array.mapi a ~f


  let map_with_index = mapWithIndex

  let map2 ~(f : 'a -> 'b -> 'c) (a : 'a array) (b : 'b array) : 'c array =
    let minLength = min (length a) (length b) in
    Base.Array.init minLength ~f:(fun i -> f a.(i) b.(i))


  let map3
      ~(f : 'a -> 'b -> 'c -> 'd)
      (arrayA : 'a array)
      (arrayB : 'b array)
      (arrayC : 'c array) : 'd array =
    let minLength : int =
      Base.Array.fold
        ~f:Base.min
        ~init:(length arrayA)
        [| length arrayB; length arrayC |]
    in
    Base.Array.init minLength ~f:(fun i -> f arrayA.(i) arrayB.(i) arrayC.(i))


  let flatMap ~f a = Base.Array.concat_map a ~f

  let flat_map = flatMap

  let find = Base.Array.find

  let findIndex = Base.Array.findi

  let find_index = findIndex

  let append (a : 'a array) (a' : 'a array) : 'a array = Base.Array.append a a'

  let concatenate (al : 'a array array) : 'a array =
    Base.Array.concat (Base.Array.to_list al)


  let intersperse ~sep array =
    Base.Array.init
      (max 0 ((Array.length array * 2) - 1))
      ~f:(fun i -> if i mod 2 <> 0 then sep else array.(i / 2))


  let any ~(f : 'a -> bool) (a : 'a array) : bool = Base.Array.exists ~f a

  let all ~(f : 'a -> bool) (a : 'a array) : bool = Base.Array.for_all ~f a

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
      Base.Array.init (sliceTo - sliceFrom) ~f:(fun i -> array.(i + sliceFrom))


  let sliding ?(step = 1) (a : 'a t) ~(size : int) : 'a t t =
    let n = Array.length a in
    if size > n
    then empty ()
    else
      initialize
        ~length:(1 + ((n - size) / step))
        ~f:(fun i -> initialize ~length:size ~f:(fun j -> a.((i * step) + j)))


  let foldLeft ~(f : 'a -> 'b -> 'b) ~(initial : 'b) (a : 'a array) : 'b =
    Base.Array.fold ~f:(Fun.flip f) ~init:initial a


  let fold_left = foldLeft

  let foldRight ~(f : 'a -> 'b -> 'b) ~(initial : 'b) (a : 'a array) : 'b =
    Base.Array.fold_right ~f ~init:initial a


  let fold_right = foldRight

  let reverse (a : 'a array) : 'a array =
    let copy = Base.Array.copy a in
    Base.Array.rev_inplace copy ;
    copy


  let reverseInPlace (a : 'a array) = Base.Array.rev_inplace a

  let reverse_in_place = reverseInPlace

  let forEach ~(f : 'a -> unit) (a : 'a array) : unit = Base.Array.iter a ~f

  let for_each = forEach
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

  let rec repeat ~(count : int) (value : 'a) : 'a list =
    if count > 0 then value :: repeat ~count:(count - 1) value else []
end

module Option = struct
  type 'a t = 'a option

  let some = Base.Option.some

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

  let values (l : 'a option list) : 'a list =
    let valuesHelper (item : 'a option) (list : 'a list) : 'a list =
      match item with None -> list | Some v -> v :: list
    in
    List.foldRight ~f:valuesHelper ~initial:[] l


  let toList (o : 'a option) : 'a list =
    match o with None -> [] | Some o -> [ o ]


  let to_list = toList

  let isSome = Base.Option.is_some

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

module Result = struct
  type ('err, 'ok) t = ('ok, 'err) Base.Result.t

  let succeed = Base.Result.return

  let fail = Base.Result.fail

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
    List.foldRight ~f:(map2 ~f:(fun a b -> a :: b)) ~initial:(Ok []) l


  let map (f : 'ok -> 'value) (r : ('err, 'ok) t) : ('err, 'value) t =
    Base.Result.map r ~f


  let fromOption ~error ma =
    match ma with None -> fail error | Some right -> succeed right


  let from_option = fromOption

  let toOption (r : ('err, 'ok) t) : 'ok option =
    match r with Ok v -> Some v | _ -> None


  let to_option = toOption

  let andThen ~(f : 'ok -> ('err, 'value) t) (r : ('err, 'ok) t) :
      ('err, 'value) t =
    Base.Result.bind ~f r


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

module Char = struct
  let toCode (c : char) : int = Base.Char.to_int c

  let to_code = toCode

  let fromCode (i : int) : char option =
    if 0 <= i && i <= 255 then Some (Char.chr i) else None


  let from_code = fromCode

  let toString = Base.Char.to_string

  let to_string = toString

  let fromString (str : string) : char option =
    match String.length str with 1 -> Some str.[0] | _ -> None


  let from_string = fromString

  let toDigit char =
    match char with '0' .. '9' -> Some (toCode char - toCode '0') | _ -> None


  let to_digit = toDigit

  let toLowercase = Base.Char.lowercase

  let to_lowercase = toLowercase

  let toUppercase = Base.Char.uppercase

  let to_uppercase = toUppercase

  let isLowercase = Base.Char.is_lowercase

  let is_lowercase = isLowercase

  let isUppercase = Base.Char.is_uppercase

  let is_uppercase = isUppercase

  let isLetter = Base.Char.is_alpha

  let is_letter = isLetter

  let isDigit = Base.Char.is_digit

  let is_digit = isDigit

  let isAlphanumeric = Base.Char.is_alphanum

  let is_alphanumeric = isAlphanumeric

  let isPrintable = Base.Char.is_print

  let is_printable = isPrintable

  let isWhitespace = Base.Char.is_whitespace

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

  let power ~base ~exponent = base ** exponent

  let ( ** ) = ( ** )

  let negate = Base.Float.neg

  let ( ~- ) = negate

  let absolute = Base.Float.abs

  let clamp n ~lower ~upper =
    if upper < lower
    then
      raise
        (Invalid_argument
           ( "~lower:"
           ^ Base.Float.to_string lower
           ^ " must be less than or equal to ~upper:"
           ^ Base.Float.to_string upper ))
    else if Base.Float.is_nan lower
            || Base.Float.is_nan upper
            || Base.Float.is_nan n
    then Base.Float.nan
    else max lower (min upper n)


  let inRange n ~lower ~upper =
    if Base.Float.(upper < lower)
    then
      raise
        (Invalid_argument
           ( "~lower:"
           ^ Base.Float.to_string lower
           ^ " must be less than or equal to ~upper:"
           ^ Base.Float.to_string upper ))
    else n >= lower && n < upper


  let in_range = inRange

  let squareRoot = sqrt

  let square_root = squareRoot

  let log n ~base = Base.Float.(log10 n / log10 base)

  let zero = 0.0

  let one = 1.0

  let nan = Base.Float.nan

  let infinity = Base.Float.infinity

  let negativeInfinity = Base.Float.neg_infinity

  let negative_infinity = negativeInfinity

  let e = Base.Float.euler

  let pi = Base.Float.pi

  let isNaN = Base.Float.is_nan

  let is_nan = isNaN

  let isInfinite = Base.Float.is_inf

  let is_infinite = isInfinite

  let isFinite n = (not (isInfinite n)) && not (isNaN n)

  let is_finite = isFinite

  let maximum x y = if isNaN x || isNaN y then nan else if y > x then y else x

  let minimum x y = if isNaN x || isNaN y then nan else if y < x then y else x

  let hypotenuse x y = squareRoot ((x * x) + (y * y))

  let degrees n = n * (pi / 180.0)

  let radians = Fun.identity

  let turns n = n * 2. * pi

  let cos = Base.Float.cos

  let acos = Base.Float.acos

  let sin = Base.Float.sin

  let asin = Base.Float.asin

  let tan = Base.Float.tan

  let atan = Base.Float.atan

  let atan2 ~y ~x = Base.Float.atan2 y x

  type direction =
    [ `Zero
    | `AwayFromZero
    | `Up
    | `Down
    | `Closest of [ `Zero | `AwayFromZero | `Up | `Down | `ToEven ]
    ]

  let round ?(direction = `Closest `Up) n =
    match direction with
    | (`Up | `Down | `Zero) as dir ->
        Base.Float.round n ~dir
    | `AwayFromZero ->
        if n < 0.
        then Base.Float.round n ~dir:`Down
        else Base.Float.round n ~dir:`Up
    | `Closest `Zero ->
        if n > 0.
        then Base.Float.round (n -. 0.5) ~dir:`Up
        else Base.Float.round (n +. 0.5) ~dir:`Down
    | `Closest `AwayFromZero ->
        if n > 0.
        then Base.Float.round (n +. 0.5) ~dir:`Down
        else Base.Float.round (n -. 0.5) ~dir:`Up
    | `Closest `Down ->
        Base.Float.round (n -. 0.5) ~dir:`Up
    | `Closest `Up ->
        Base.Float.round_nearest n
    | `Closest `ToEven ->
        Base.Float.round_nearest_half_to_even n


  let floor = Base.Float.round_down

  let ceiling = Base.Float.round_up

  let truncate = Base.Float.round_towards_zero

  let fromPolar (r, theta) = (r * cos theta, r * sin theta)

  let from_polar = fromPolar

  let toPolar (x, y) = (hypotenuse x y, atan2 ~x ~y)

  let to_polar = toPolar

  let fromInt = Base.Float.of_int

  let from_int = fromInt

  let toInt = Base.Float.iround_towards_zero

  let to_int = toInt
end

module Int = struct
  type t = int

  let minimumValue = Base.Int.min_value

  let minimum_value = minimumValue

  let maximumValue = Base.Int.max_value

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

  let ( // ) = Base.Int.( // )

  let power ~base ~exponent = Base.Int.(base ** exponent)

  let ( ** ) = Base.Int.( ** )

  let negate = ( ~- )

  let ( ~- ) = ( ~- )

  let modulo n ~by = n mod by

  let remainder n ~by = Base.Int.rem n by

  let maximum = Base.Int.max

  let minimum = Base.Int.min

  let absolute n = if n < 0 then n * -1 else n

  let isEven n = n mod 2 = 0

  let is_even = isEven

  let isOdd n = n mod 2 <> 0

  let is_odd = isOdd

  let clamp n ~lower ~upper =
    if upper < lower
    then
      raise
        (Invalid_argument
           ( "~lower:"
           ^ Base.Int.to_string lower
           ^ " must be less than or equal to ~upper:"
           ^ Base.Int.to_string upper ))
    else max lower (min upper n)


  let inRange n ~lower ~upper =
    if upper < lower
    then
      raise
        (Invalid_argument
           ( "~lower:"
           ^ Base.Int.to_string lower
           ^ " must be less than or equal to ~upper:"
           ^ Base.Int.to_string upper ))
    else n >= lower && n < upper


  let in_range = inRange

  let toFloat = Base.Int.to_float

  let to_float = toFloat

  let toString = Base.Int.to_string

  let to_string = toString

  let fromString = int_of_string_opt

  let from_string = fromString
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


  let reverse (s : string) = Base.String.rev s

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
    join ~sep:"" [ start; insert; end_ ]


  let insert_at = insertAt
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
