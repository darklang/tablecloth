module BA = Base.Array

(* Helpers *)
let length (a : 'a array) : int = BA.length a

let isEmpty (a : 'a array) : bool = length a = 0
let is_empty = isEmpty

(*TODO find solution*)
(*let reverse (a : 'a array) : 'a array = *)

let reverseInPlace (a : 'a array) = BA.rev_inplace a

(*Creation*)
let fromList (l: 'a list) : 'a array = Base.List.to_array l
let from_list = fromList

let toList (a: 'a array) : 'a list = BA.to_list a
let to_list = toList

let empty:'a array = [||]

(* initialize n f creates an array of length n with the element at index i initialized to the result of (f i) *)
let initialize ~(n: int) ~(f: int -> 'a): 'a array = BA.init n ~f

(*repeat n e creates an array with a given length n, filled with element e. *)
let repeat  ~(n: int) (e: 'a): 'a array = BA.init n ~f:(fun _ -> e)

let sum (a : int array) : int = BA.fold a ~init:0 ~f:( + )

let floatSum (a : float array) : float = BA.fold a ~init:0.0 ~f:( +. )
let float_sum = floatSum


let head (a : 'a array) : 'a option =
    (fun () -> BA.get a 0) |> Base.Option.try_with

let last (a : 'a array) : 'a option =
    (fun () -> BA.last a) |> Base.Option.try_with

let concat  (al : 'a array list) : 'a array = BA.concat al

let append (a : 'a array) (a' : 'a array)  : 'a array = BA.append a a'


let map ~(f : 'a -> 'b) (a : 'a array) : 'b array = BA.map a ~f

let mapi  ~(f : 'int -> 'a -> 'b) (a : 'a array) : 'b array = BA.mapi a ~f
let indexed_map = mapi
let indexedMap = mapi

let map2 ~(f : 'a -> 'b -> 'c) (a : 'a array) (b : 'b array) : 'c array =
    BA.map2_exn a b ~f (* TODO Have another look *)

let filter ~(f : 'a -> bool) (a : 'a array) : 'a array = BA.filter a ~f

(* argument order of f is flipped in Belt version *)
let filteri ~(f : int -> 'a -> bool) (a : 'a array) : 'a array = BA.filteri a ~f
let indexed_filter = filteri
let indexedFilter = filteri

let filterMap ~(f : 'a -> 'b option) (a : 'a array) : 'b array = BA.filter_map a ~f
let filter_map = filterMap

let foldl ~(f : 'a -> 'b -> 'b) ~(init : 'b) (a : 'a array) : 'b =
  BA.fold ~f ~init a

let foldr ~(f : 'a -> 'b -> 'b) ~(init : 'b) (a : 'a array) : 'b =
  BA.fold_right ~f ~init a

let init (a : 'a array) : 'a array option =
  let l = length a in
  match l with
  | 0 -> None
  | 1 -> Some [||]
  | _ -> Some (filteri a ~f:(fun i _ -> i < (l - 1)) )


let member ~(value : 'a) (a : 'a array) : bool = BA.exists a ~f:(fun x -> x = value)

let any ~(f : 'a -> bool) (a : 'a array) : bool = BA.exists ~f a

let iter ~(f : 'a -> unit) (a : 'a array) : unit = BA.iter a ~f


(*

let elemIndex ~(value : 'a) (a : 'a array) : int option =
  a
  |> Js.Array.findIndex (( = ) value)
  |> function -1 -> None | index -> Some index

let elem_index = elemIndex

let rec findIndexHelp
  (index : int) ~(predicate : 'a -> bool) (a : 'a array) : int option =
match l with
| [] ->
    None
| x :: xs ->
    if predicate x
    then Some index
    else findIndexHelp (index + 1) ~predicate xs

let findIndex ~(f : 'a -> bool) (a : 'a array) : int option = findIndexHelp 0 ~predicate:f l

let find_index = findIndex


let getBy ~(f : 'a -> bool) (a : 'a array) : 'a option = BA.getBy l f

let get_by = getBy

let uniqueBy ~(f : 'a -> string) (a : 'a array) : 'a array =
let rec uniqueHelp
    (f : 'a -> string)
    (existing : Belt.Set.String.t)
    (remaining : 'a array)
    (accumulator : 'a array) =
  match remaining with
  | [] ->
      reverse accumulator
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

let unique_by = uniqueBy

let find ~(f : 'a -> bool) (a : 'a array) : 'a option = BA.getBy l f

let getAt ~(index : int) (a : 'a array) : 'a option = BA.get l index

let get_at = getAt

let drop ~(count : int) (a : 'a array) : 'a array =
BA.drop l count |. Belt.Option.getWithDefault []


let init (a : 'a array) : 'a array option =
match reverse l with
| [] -> None
| _ :: rest -> Some (reverse rest)



let partition ~(f : 'a -> bool) (a : 'a array) : 'a array * 'a array =
BA.partition l f



let take ~(count : int) (a : 'a array) : 'a array =
BA.take l count |. Belt.Option.getWithDefault []


let updateAt ~(index : int) ~(f : 'a -> 'a) (a : 'a array) : 'a array =
if index < 0
then l
else
  let head = take ~count:index l in
  let tail = drop ~count:index l in
  match tail with x :: xs -> head @ (f x :: xs) | _ -> l


let update_at = updateAt

let rec dropWhile ~(f : 'a -> bool) (a : 'a array) : 'a array =
match l with
| [] ->
    []
| x :: xs ->
    if f x then dropWhile ~f xs else l


let drop_while = dropWhile

let cons (item : 'a) (a : 'a array) : 'a array = item :: l

let takeWhile ~(f : 'a -> bool) (a : 'a array) : 'a array =
let rec takeWhileMemo memo array =
  match array with
  | [] ->
      reverse memo
  | x :: xs ->
      if f x then takeWhileMemo (x :: memo) xs else reverse memo
in
takeWhileMemo [] l


let take_while = takeWhile

let all ~(f : 'a -> bool) (a : 'a array) : bool = BA.every l f

let tail (a : 'a array) : 'a array option =
match l with [] -> None | _ :: rest -> Some rest


let removeAt ~(index : int) (a : 'a array) : 'a array =
if index < 0
then l
else
  let head = take ~count:index l in
  let tail = drop ~count:index l |> tail in
  match tail with None -> l | Some t -> append head t


let remove_at = removeAt

let minimumBy ~(f : 'a -> 'comparable) (ls : 'a array) : 'a option =
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

let maximumBy ~(f : 'a -> 'comparable) (ls : 'a array) : 'a option =
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

let maximum (a : 'comparable array) : 'comparable option =
match l with x :: xs -> Some (foldl ~f:max ~init:x xs) | _ -> None


let sortBy ~(f : 'a -> 'b) (a : 'a array) : 'a array =
BA.sort l (fun a b ->
    let a' = f a in
    let b' = f b in
    if a' = b' then 0 else if a' < b' then -1 else 1 )


let sort_by = sortBy

let span ~(f : 'a -> bool) (xs : 'a array) : 'a array * 'a array =
(takeWhile ~f xs, dropWhile ~f xs)


let rec groupWhile ~(f : 'a -> 'a -> bool) (xs : 'a array) : 'a array array =
match xs with
| [] ->
    []
| x :: xs ->
    let ys, zs = span ~f:(f x) xs in
    (x :: ys) :: groupWhile ~f zs


let group_while = groupWhile

let splitAt ~(index : int) (xs : 'a array) : 'a array * 'a array =
(take ~count:index xs, drop ~count:index xs)


let split_at = splitAt

let insertAt ~(index : int) ~(value : 'a) (xs : 'a array) : 'a array =
take ~count:index xs @ (value :: drop ~count:index xs)


let insert_at = insertAt

let splitWhen ~(f : 'a -> bool) (a : 'a array) : ('a array * 'a array) option =
findIndex ~f l |. Belt.Option.map (fun index -> splitAt ~index l)


let split_when = splitWhen

let intersperse (sep : 'a) (xs : 'a array) : 'a array =
match xs with
| [] ->
    []
| hd :: tl ->
    let step x rest = sep :: x :: rest in
    let spersed = foldr ~f:step ~init:[] tl in
    hd :: spersed


let initialize (n : int) (f : int -> 'a) : 'a array =
let rec step i acc = if i < 0 then acc else step (i - 1) (f i :: acc) in
step (n - 1) []


let sortWith (f : 'a -> 'a -> int) (a : 'a array) : 'a array =
BA.sort l f


let sort_with = sortWith

*)

