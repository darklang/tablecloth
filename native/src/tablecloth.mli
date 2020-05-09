module Fun : sig
  (** Functions for working with functions. *)

  external identity : 'a -> 'a = "%identity"
  (** Given a value, returns exactly the same value. This may seem pointless at first glance but it can often be useful when an api offers you more control than you actually need.

    Perhaps you want to create an array of integers

    {[Array.initialize ~length:6 ~f:identity = [|0;1;2;3;4;5|]]}

    (In this particular case you probably want to use {!Array.range}.)

    Or maybe you need to register a callback, but dont want to do anything:

    {[
      let httpMiddleware = HttpLibrary.createMiddleWare {
        eventYouDoCareAbout=transformAndReturn;
        eventYouDontCareAbout=Fun.identity;
      }
    ]}
  *)

  external ignore : _ -> unit = "%ignore"
  (** Discards the value it is given and returns [()]

    This is primarily useful when working with imperative side-effecting code or to avoid "unused value" compiler warnings when you really meant it, and haven't just made a mistake.

    {[
      module PretendMutableQueue : sig
        type 'a t

        val pushReturningIndex : 'a t -> 'a -> int
      end

      let addListToQueue queue list =
        List.forEach list ~f:(fun element ->
          ignore (PretentMutableQueue.pushReturningIndex queue element)
        )
    ]}
  *)

  val constant : 'a -> 'b -> 'a
  (** Create a function that {b always} returns the same value.

    Useful with functions like {!List.map}:

    {[List.map ~f:(Fun.constant 0) [1;2;3;4;5] = [0;0;0;0;0]]}

    or {!Array.initialize}

    {[Array.initialize ~length:6 ~f:(Fun.constant 0) = [|0;0;0;0;0;0|]]}
  *)

  val sequence : 'a -> 'b -> 'b
  (** A function which always returns its second argument. *)

  val flip : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c
  (** [flip f] reverses the argument order of the binary function [f].
    For any arguments [x] and [y], [(flip f) x y] is [f y x].

    Perhaps you want to [fold] something, but the arguments of a function you already have access to are in the wrong order.
  *)

  val apply : ('a -> 'b) -> 'a -> 'b
  (** See {!Fun.(<|)} *)

  val ( <| ) : ('a -> 'b) -> 'a -> 'b
  (** [f <| x] is exactly the same as [f x].
    It can help you avoid parentheses, which can be nice sometimes.
    Maybe you want to apply a function to a [match] expression? That sort of thing.
  *)

  external pipe : 'a -> ('a -> 'b) -> 'b = "%revapply"
  (** See {!Fun.(|>)} *)

  external ( |> ) : 'a -> ('a -> 'b) -> 'b = "%revapply"
  (** Saying [x |> f] is exactly the same as [f x], just a bit longer.

    It is called the “pipe” operator because it lets you write “pipelined” code.
    For example, say we have a [sanitize] function for turning user input into
    integers:


    {[
      (* Before *)
      let sanitize (input: string) : int option =
        Int.fromString (String.trim input)
    ]}

    We can rewrite it like this:

    {[
      (* After *)
      let sanitize (input: string) : int option =
        input
        |> String.trim
        |> Int.fromString
    ]}

    This can be overused! When you have three or four steps, the code often gets clearer if you break things out into
    some smaller piplines assigned to variables. Now the transformation has a name, maybe it could have a type annotation.

    It can often be more self-documenting that way!
   *)

  val compose : ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c
  (** Function composition, passing results along in the suggested direction.
    For example, the following code (in a very roundabout way) checks if a number divided by two is odd:

    {[let isHalfOdd = Fun.(not << Int.isEven << Int.divide ~by:2)]}

    You can think of this operator as equivalent to the following:

    {[(g << f)  ==  (fun x -> g (f x))]}

    So our example expands out to something like this:

    {[let isHalfOdd = fun n -> not (Int.isEven (Int.divide ~by:2 n))]}
  *)

  val ( << ) : ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c
  (** See {!Fun.compose} *)

  val composeRight : ('a -> 'b) -> ('b -> 'c) -> 'a -> 'c
  (** Function composition, passing results along in the suggested direction.
    For example, the following code checks if the square root of a number is odd:

    {[Int.squareRoot >> Int.isEven >> not]}
  *)

  val ( >> ) : ('a -> 'b) -> ('b -> 'c) -> 'a -> 'c
  (** See {!Fun.composeRight} *)

  val tap : 'a -> f:('a -> unit) -> 'a
  (**
    Useful for performing some side affect in {!Fun.pipe}-lined code.

    Most commonly used to log a value in the middle of a pipeline of function calls.

    {[
      let sanitize (input: string) : int option =
        input
        |> String.trim
        |> Fun.tap ~f:(fun trimmedString -> print_endline trimmedString)
        |> Int.fromString
    ]}

    {[
      Array.filter [|1;3;2;5;4;|] ~f:Int.isEven
      |> Fun.tap ~f:(fun numbers -> numbers.(0) <- 0)
      |> Fun.tap ~f:Array.reverseInPlace
      = [|4;0|]
    ]}
  *)
end

module Array : sig
  (** A mutable vector of elements which must have the same type with O(1) {!get} and {!set} operations.

   You can create an [array] in OCaml with the [[|1; 2; 3|]] syntax. *)

  type 'a t = 'a array

  val empty : unit -> 'a array
  (** An empty array.

    {[Array.empty () = [||]]}

    {[Array.length (Array.empty ()) = 0]} *)

  val singleton : 'a -> 'a array
  (** Create an array with only one element.

    {[Array.singleton 1234 = [|1234|]]}

    {[Array.singleton "hi" = [|"hi"|]]} *)

  val length : 'a array -> int
  (** Return the length of an array.

    {[Array.length [|1; 2, 3|] = 3]}

    {[Array.length [||] = 0]} *)

  val isEmpty : 'a array -> bool
  (** Determine if an array is empty.

    {[Array.isEmpty Array.empty = true]}

    {[Array.isEmpty [||] = true]}

    {[Array.isEmpty [|1; 2; 3|] = false]} *)

  val is_empty : 'a array -> bool

  val initialize : length:int -> f:(int -> 'a) -> 'a array
  (** Initialize an array. [Array.initialize ~length:n ~f] creates an array of length [n] with
    the element at index [i] initialized to the result of [(f i)].

    {[Array.initialize ~length:4 ~f:identity = [|0; 1; 2; 3|]]}

    {[Array.initialize ~length:4 ~f:(fun n -> n * n) = [|0; 1; 4; 9|]]} *)

  val repeat : length:int -> 'a -> 'a array
  (** Creates an array of length [length] with the value [x] populated at each index.

    {[repeat ~length:5 'a' = [|'a'; 'a'; 'a'; 'a'; 'a'|]]}

    {[repeat ~length:0 7 = [||]]}

    {[repeat ~length:(-1) "Why?" = [||]]} *)

  val range : ?from:int -> int -> int array
  (** Creates an array containing all of the integers from [from] if it is provided or [0] if not, up to but not including [to]

    {[Array.range 5 = [|0; 1; 2; 3; 4|] ]}

    {[Array.range ~from: 2 5 = [|2; 3; 4|] ]}

    {[Array.range ~from:(-2) 3 = [|-2; -1; 0; 1; 2|] ]} *)

  val fromList : 'a list -> 'a array
  (** Create an array from a {!List}.

    {[Array.fromList [1;2;3] = [|1;2;3|]]} *)

  val from_list : 'a list -> 'a array

  val toList : 'a array -> 'a list
  (** Create a {!List} of elements from an array.

    {[Array.toList [|1;2;3|] = [1;2;3]]}

    {[Array.toList (Array.fromList [3; 5; 8]) = [3; 5; 8]]} *)

  val to_list : 'a array -> 'a list

  val toIndexedList : 'a array -> (int * 'a) list
  (**  Create an indexed {!List} from an array. Each element of the array will be paired with its index as a {!Tuple2}.

    {[Array.toIndexedList [|"cat"; "dog"|] = [(0, "cat"); (1, "dog")]]} *)

  val to_indexed_list : 'a array -> (int * 'a) list

  val get : 'a array -> int -> 'a option
  (** [Array.get a n] returns, as an {!Option}, the element at index number [n] of array [a].

    The first element has index number 0.

    The last element has index number [Array.length a - 1].

    Returns [None] if [n] is outside the range [0] to [(Array.length a - 1)].

    You can also write [a.(n)] instead of [Array.get n a]

    {[Array.get [|"cat"; "dog"; "eel"|] 2 = Some "eel"]}

    {[Array.get [|0; 1; 2|] 5 = None]}

    {[Array.get [||] 0 = None]} *)

  val getAt : index:int -> 'a array -> 'a option

  val get_at : index:int -> 'a array -> 'a option

  val set : 'a array -> int -> 'a -> unit
  (** [Array.set a i x] modifies array [a] in place, replacing the element at index number [i] with [x].

    You can also write [a.(n) <- x] instead of [Array.set a i x].

    Raises [Invalid_argument "index out of bounds"] if [i] is outside the range [0] to [Array.length a - 1]. *)

  val setAt : index:int -> value:'a -> 'a array -> unit

  val set_at : index:int -> value:'a -> 'a array -> unit

  val sum : int array -> int
  (** Get the total of adding all of the integers in an array.

    {[Array.sum [|1; 2; 3|] = 6]} *)

  val floatSum : float array -> float
  (** Get the total of adding all of the floating point numbers in an array.

    {[Array.floatSum [|1.0; 2.0; 3.0|] = 6.0]} *)

  val float_sum : float array -> float

  val filter : f:('a -> bool) -> 'a array -> 'a array
  (** Keep elements that [f] returns [true] for.

    {[Array.filter ~f:Int.isEven [|1; 2; 3; 4; 5; 6|] = [|2; 4; 6|]]} *)

  val swap : 'a t -> int -> int -> unit
  (** [Array.swap array i j] swaps the value at index [i] with the value at index [j].
    {[Array.swap [|1;2;3|] 1 2 = [|1;3;2|]]}
  *)

  val map : f:('a -> 'b) -> 'a array -> 'b array
  (** Create a new array which is the result of applying a function [f] to every element.

    {[Array.map ~f:sqrt [|1.0; 4.0; 9.0|] = [|1.0; 2.0; 3.0|]]} *)

  val mapWithIndex : f:(int -> 'a -> 'b) -> 'a array -> 'b array
  (** Apply a function [f] to every element with its index as the first argument.

   {[Array.mapWithIndex ~f:( * ) [|5; 5; 5|] = [|0; 5; 10|]]} *)

  val map_with_index : f:(int -> 'a -> 'b) -> 'a array -> 'b array

  val map2 : f:('a -> 'b -> 'c) -> 'a array -> 'b array -> 'c array
  (** Combine two arrays, using [f] to combine each pair of elements.
    If one array is longer, the extra elements are dropped.

    {[let totals (xs : int array) (ys : int array) : int array =
Array.map2 ~f:(+) xs ys in

totals [|1;2;3|] [|4;5;6|] = [|5;7;9|]

Array.map2
  ~f:Tuple2.create
  [|"alice"; "bob"; "chuck"|]
  [|2; 5; 7; 8|] =
    [|("alice",2); ("bob",5); ("chuck",7)|] ]} *)

  val map3 :
    f:('a -> 'b -> 'c -> 'd) -> 'a array -> 'b array -> 'c array -> 'd array
  (** Combine three arrays, using [f] to combine each {!Tuple3} of elements.
    If one array is longer, the extra elements are dropped.

    {[
  Array.map3
    ~f:Tuple3.create
    [|"alice"; "bob"; "chuck"|]
    [|2; 5; 7; 8;|]
    [|true; false; true; false|] =
      [|("alice", 2, true); ("bob", 5, false); ("chuck", 7, true)|]
    ]} *)

  val flatMap : f:('a -> 'b array) -> 'a array -> 'b array
  (** Apply a function [f] onto an array and flatten the resulting array of arrays.

    {[Array.flatMap ~f xs = Array.map ~f xs |> Array.flatten]}

    {[Array.flatMap ~f:(fun n -> [|n; n|]) [|1; 2; 3|] = [|1; 1; 2; 2; 3; 3|]]} *)

  val flat_map : f:('a -> 'b array) -> 'a array -> 'b array

  val find : 'a array -> f:('a -> bool) -> 'a option
  (** Returns as an option the first element for which f evaluates to true. If [f] doesn't return [true] for any of the elements [find] will return [None]
    {[Array.find ~f:Int.isEven [|1; 3; 4; 8;|] = Some 4]}

    {[Array.find ~f:Int.isOdd [|0; 2; 4; 8;|] = None]}

    {[Array.find ~f:Int.isEven [||] = None]} *)

  val findIndex : 'a array -> f:(int -> 'a -> bool) -> (int * 'a) option
  (** Similar to {!Array.find} but [f] is also called with the current index, and the return value will be a tuple of the index the passing value was found at and the passing value.
    {[Array.findIndex ~f:(fun index number -> index > 2 && Int.isEven number) [|1; 3; 4; 8;|] = Some (3, 8)]}
  *)

  val find_index : 'a array -> f:(int -> 'a -> bool) -> (int * 'a) option

  val any : f:('a -> bool) -> 'a array -> bool
  (**  Determine if [f] returns true for [any] values in an array.

    {[Array.any ~f:isEven [|2;3|] = true]}

    {[Array.any ~f:isEven [|1;3|] = false]}

    {[Array.any ~f:isEven [||] = false]} *)

  val all : f:('a -> bool) -> 'a array -> bool
  (** Determine if [f] returns true for [all] values in an array.

    {[Array.all ~f:Int.isEven [|2;4|] = true]}

    {[Array.all ~f:Int.isEven [|2;3|] = false]}

    {[Array.all ~f:Int.isEven [||] = true]} *)

  val append : 'a array -> 'a array -> 'a array
  (** Creates a new array which is the result of appending the second array onto the end of the first.

    {[let fortyTwos = Array.repeat ~length:2 42 in
let eightyOnes = Array.repeat ~length:3 81 in
Array.append fourtyTwos eightyOnes = [|42; 42; 81; 81; 81|];]} *)

  val concatenate : 'a array array -> 'a array
  (** Concatenate an array of arrays into a single array:

    {[Array.concatenate [|[|1; 2|]; [|3|]; [|4; 5|]|] = [|1; 2; 3; 4; 5|]]} *)

  val intersperse : sep:'a -> 'a array -> 'a array
  (** Places [sep] between all elements of the given array.

    {[Array.intersperse ~sep:"on" [|"turtles"; "turtles"; "turtles"|] = [|"turtles"; "on"; "turtles"; "on"; "turtles"|]]}

    {[Array.intersperse ~sep:0 [||] = [||]]} *)

  val slice : from:int -> ?to_:int -> 'a array -> 'a array
  (** Get a sub-section of an array. [from] is a zero-based index where we will start our slice.
    The [to_] is a zero-based index that indicates the end of the slice.

    The slice extracts up to but not including [to_].

    {[Array.slice ~from:0  ~to_:3 [|0; 1; 2; 3; 4|] = [|0; 1; 2|]]}

    {[Array.slice ~from:1  ~to_:4 [|0; 1; 2; 3; 4|] = [|1; 2; 3|]]}

    {[Array.slice ~from:5  ~to_:3 [|0; 1; 2; 3; 4|] = [||]]}

    Both the [from] and [to_] indexes can be negative, indicating an offset from the end of the array.

    {[Array.slice  ~from:1 ~to_:(-1) [|0; 1; 2; 3; 4|] = [|1; 2; 3|]]}

    {[Array.slice ~from:(-2)  ~to_:5 [|0; 1; 2; 3; 4|] = [|3; 4|]]}

    {[Array.slice ~from:(-2)  ~to_:(-1) [|0; 1; 2; 3; 4|] = [|3|]]} *)

  val sliding : ?step:int -> 'a t -> size:int -> 'a t t
  (** Provides a sliding 'window' of sub-arrays over an array.

    The first sub-array starts at index [0] of the array and takes the first [size] elements.

    The sub-array then advances the index [step] (which defaults to 1) positions before taking the next [size] elements.

    The sub-arrays are guaranteed to always be of length [size] and iteration stops once a sub-array would extend beyond the end of the array.

    {[Array.sliding [|1;2;3;4;5|] ~size:1 = [|[|1|]; [|2|]; [|3|]; [|4|]; [|5|]|] ]}

    {[Array.sliding [|1;2;3;4;5|] ~size:2 = [|[|1;2|]; [|2;3|]; [|3;4|]; [|4;5|]|] ]}

    {[Array.sliding [|1;2;3;4;5|] ~size:3 = [|[|1;2;3|]; [|2;3;4|]; [|3;4;5|]|] ]}

    {[Array.sliding [|1;2;3;4;5|] ~size:2 ~step:2 = [|[|1;2|]; [|3;4|]|] ]}

    {[Array.sliding [|1;2;3;4;5|] ~size:1 ~step:3 = [|[|1|]; [|4|]|] ]}
  *)

  val foldLeft : f:('a -> 'b -> 'b) -> initial:'b -> 'a array -> 'b
  (** Reduces collection to a value which is the accumulated result of running each element in the array through [f],
      where each successive invocation is supplied the return value of the previous.

    Read [foldLeft] as 'fold from the left'.

    {[Array.foldLeft ~f:( * ) ~initial:1 (Array.repeat ~length:4 7) = 2401]}

    {[Array.foldLeft ~f:((fun element list -> element :: list)) ~initial:[] [|1; 2; 3|] = [3; 2; 1]]} *)

  val fold_left : f:('a -> 'b -> 'b) -> initial:'b -> 'a array -> 'b

  val foldRight : f:('a -> 'b -> 'b) -> initial:'b -> 'a array -> 'b
  (** This method is like [foldLeft] except that it iterates over the elements of the array from right to left.

    {[Array.foldRight ~f:(+) ~initial:0 (Array.repeat ~length:3 5) = 15]}

    {[Array.foldRight ~f:(fun element list -> element :: list) ~initial:[] [|1; 2; 3|] = [1; 2; 3]]} *)

  val fold_right : f:('a -> 'b -> 'b) -> initial:'b -> 'a array -> 'b

  val reverse : 'a array -> 'a array
  (** Create a new reversed array leaving the original untouched

  {[let numbers = [|1; 2; 3|] in
Array.reverse numbers = [|3; 2; 1|];
numbers = [|1; 2; 3|]; ]} *)

  val reverseInPlace : 'a array -> unit
  (** Reverses array so that the first element becomes the last, the second element becomes the second to last, and so on.

  {[let numbers = [|1; 2; 3|] in
Array.reverseInPlace numbers;
numbers = [|3; 2; 1|]]} *)

  val reverse_in_place : 'a array -> unit

  val forEach : f:('a -> unit) -> 'a array -> unit
  (** Iterates over the elements of invokes [f] for each element.

    {[Array.forEach [|1; 2; 3|] ~f:(fun int -> print (Int.toString int))]} *)

  val for_each : f:('a -> unit) -> 'a array -> unit
end

module List : sig
  type 'a t = 'a list

  val concat : 'a list list -> 'a list

  val sum : int list -> int

  val floatSum : float list -> float

  val float_sum : float list -> float

  val map : f:('a -> 'b) -> 'a list -> 'b list

  val sliding : ?step:int -> 'a t -> size:int -> 'a t t
  (** Provides a sliding 'window' of sub-lists over a list.

    The first sub-list starts at the head of the list and takes the first [size] elements.

    The sub-list then advances [step] (which defaults to 1) positions before taking the next [size] elements.

    The sub-lists are guaranteed to always be of length [size] and iteration stops once a sub-list would extend beyond the end of the list.

    {[List.sliding [1;2;3;4;5] ~size:1 = [[1]; [2]; [3]; [4]; [5]] ]}

    {[List.sliding [1;2;3;4;5] ~size:2 = [[1;2]; [2;3]; [3;4]; [4;5]] ]}

    {[List.sliding [1;2;3;4;5] ~size:3 = [[1;2;3]; [2;3;4]; [3;4;5]] ]}

    {[List.sliding [1;2;3;4;5] ~size:2 ~step:2 = [[1;2]; [3;4]] ]}

    {[List.sliding [1;2;3;4;5] ~size:1 ~step:3 = [[1]; [4]] ]}

    {[List.sliding [1;2;3;4;5] ~size:2 ~step:3 = [[1; 2]; [4; 5]]]}

    {[List.sliding [1;2;3;4;5] ~size:7 = []]}
  *)

  val indexedMap : f:(int -> 'a -> 'b) -> 'a list -> 'b list

  val indexed_map : f:(int -> 'a -> 'b) -> 'a list -> 'b list

  val mapi : f:(int -> 'a -> 'b) -> 'a list -> 'b list

  val map2 : f:('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list

  val getBy : f:('a -> bool) -> 'a list -> 'a option

  val get_by : f:('a -> bool) -> 'a list -> 'a option

  val find : f:('a -> bool) -> 'a list -> 'a option

  val elemIndex : value:'a -> 'a list -> int option

  val elem_index : value:'a -> 'a list -> int option

  val last : 'a list -> 'a option

  val member : value:'a -> 'a list -> bool

  val uniqueBy : f:('a -> string) -> 'a list -> 'a list

  val unique_by : f:('a -> string) -> 'a list -> 'a list

  val getAt : index:int -> 'a list -> 'a option

  val get_at : index:int -> 'a list -> 'a option

  val any : f:('a -> bool) -> 'a list -> bool

  val head : 'a list -> 'a option

  val drop : count:int -> 'a list -> 'a list

  val init : 'a list -> 'a list option

  val filterMap : f:('a -> 'b option) -> 'a list -> 'b list

  val filter_map : f:('a -> 'b option) -> 'a list -> 'b list

  val filter : f:('a -> bool) -> 'a list -> 'a list

  val partition : f:('a -> bool) -> 'a list -> 'a list * 'a list

  val foldRight : f:('a -> 'b -> 'b) -> initial:'b -> 'a list -> 'b

  val fold_right : f:('a -> 'b -> 'b) -> initial:'b -> 'a list -> 'b

  val foldLeft : f:('a -> 'b -> 'b) -> initial:'b -> 'a list -> 'b

  val fold_left : f:('a -> 'b -> 'b) -> initial:'b -> 'a list -> 'b

  val findIndex : f:('a -> bool) -> 'a list -> int option

  val find_index : f:('a -> bool) -> 'a list -> int option

  val take : count:int -> 'a list -> 'a list

  val updateAt : index:int -> f:('a -> 'a) -> 'a list -> 'a list

  val update_at : index:int -> f:('a -> 'a) -> 'a list -> 'a list

  val length : 'a list -> int

  val reverse : 'a list -> 'a list

  val dropWhile : f:('a -> bool) -> 'a list -> 'a list

  val drop_while : f:('a -> bool) -> 'a list -> 'a list

  val isEmpty : 'a list -> bool

  val is_empty : 'a list -> bool

  val cons : 'a -> 'a list -> 'a list

  val takeWhile : f:('a -> bool) -> 'a list -> 'a list

  val take_while : f:('a -> bool) -> 'a list -> 'a list

  val all : f:('a -> bool) -> 'a list -> bool

  val tail : 'a list -> 'a list option

  val append : 'a list -> 'a list -> 'a list

  val removeAt : index:int -> 'a list -> 'a list

  val remove_at : index:int -> 'a list -> 'a list

  val minimumBy : f:('a -> 'comparable) -> 'a list -> 'a option

  val minimum_by : f:('a -> 'comparable) -> 'a list -> 'a option

  val minimum : 'comparable list -> 'comparable option

  val maximumBy : f:('a -> 'comparable) -> 'a list -> 'a option

  val maximum_by : f:('a -> 'comparable) -> 'a list -> 'a option

  val maximum : 'comparable list -> 'comparable option

  val sortBy : f:('a -> 'b) -> 'a list -> 'a list

  val sort_by : f:('a -> 'b) -> 'a list -> 'a list

  val span : f:('a -> bool) -> 'a list -> 'a list * 'a list

  val groupWhile : f:('a -> 'a -> bool) -> 'a list -> 'a list list

  val group_while : f:('a -> 'a -> bool) -> 'a list -> 'a list list

  val splitAt : index:int -> 'a list -> 'a list * 'a list

  val split_at : index:int -> 'a list -> 'a list * 'a list

  val insertAt : index:int -> value:'a -> 'a list -> 'a list

  val insert_at : index:int -> value:'a -> 'a list -> 'a list

  val splitWhen : f:('a -> bool) -> 'a list -> 'a list * 'a list

  val split_when : f:('a -> bool) -> 'a list -> 'a list * 'a list

  val intersperse : 'a -> 'a list -> 'a list

  val initialize : int -> (int -> 'a) -> 'a list

  val sortWith : ('a -> 'a -> int) -> 'a list -> 'a list

  val sort_with : ('a -> 'a -> int) -> 'a list -> 'a list

  val iter : f:('a -> unit) -> 'a list -> unit

  val repeat : count:int -> 'a -> 'a list
  (**
    [List.repeat ~count=n v] returns a list with the value [v] repeated [n] times.

    {[
    List.repeat ~count:3 99 = [99; 99; 99]
    List.repeat ~count:0 99 = []
    ]}
  *)
end

module Result : sig
  type ('err, 'ok) t = ('ok, 'err) Base.Result.t

  val succeed : 'ok -> ('err, 'ok) t

  val fail : 'err -> ('err, 'ok) t

  val withDefault : default:'ok -> ('err, 'ok) t -> 'ok

  val with_default : default:'ok -> ('err, 'ok) t -> 'ok

  val map2 : f:('a -> 'b -> 'c) -> ('err, 'a) t -> ('err, 'b) t -> ('err, 'c) t

  val combine : ('x, 'a) t list -> ('x, 'a list) t

  val map : ('ok -> 'value) -> ('err, 'ok) t -> ('err, 'value) t

  val fromOption : error:'err -> 'ok option -> ('err, 'ok) t

  val from_option : error:'err -> 'ok option -> ('err, 'ok) t

  val toOption : ('err, 'ok) t -> 'ok option

  val to_option : ('err, 'ok) t -> 'ok option

  val andThen :
    f:('ok -> ('err, 'value) t) -> ('err, 'ok) t -> ('err, 'value) t

  val and_then :
    f:('ok -> ('err, 'value) t) -> ('err, 'ok) t -> ('err, 'value) t

  val pp :
       (Format.formatter -> 'err -> unit)
    -> (Format.formatter -> 'ok -> unit)
    -> Format.formatter
    -> ('err, 'ok) t
    -> unit
end

module Option : sig
  type 'a t = 'a option

  val some : 'a -> 'a option

  val andThen : f:('a -> 'b option) -> 'a option -> 'b option

  val and_then : f:('a -> 'b option) -> 'a option -> 'b option

  val or_ : 'a option -> 'a option -> 'a option

  val orElse : 'a option -> 'a option -> 'a option

  val or_else : 'a option -> 'a option -> 'a option

  val map : f:('a -> 'b) -> 'a option -> 'b option

  val withDefault : default:'a -> 'a option -> 'a

  val with_default : default:'a -> 'a option -> 'a

  val values : 'a option list -> 'a list

  val toList : 'a option -> 'a list

  val to_list : 'a option -> 'a list

  val isSome : 'a option -> bool

  val is_some : 'a option -> bool

  val toOption : sentinel:'a -> 'a -> 'a option

  val to_option : sentinel:'a -> 'a -> 'a option

  val getExn : 'a option -> 'a
  (**
    Same as {!Option.get_exn}
  *)

  val get_exn : 'a option -> 'a
  (** [get_exn optional_value]
    Returns [value] if [optional_value] is [Some value], otherwise raises [Invalid_argument]

    {[
      get_exn (Some 3) = 3;;
      get_exn None (* Raises Invalid_argument error *)
    ]}
  *)
end

module Char : sig
  (** Functions for working with characters. Character literals are enclosed in ['a'] pair of single quotes. *)

  val toCode : char -> int
  (** Convert to the corresponding ASCII [code point][cp].

    [cp]: https://en.wikipedia.org/wiki/Code_point

    [toCode 'A' = 65]

    [toCode 'B' = 66]

    [toCode 'þ' = 254] *)

  val to_code : char -> int

  val fromCode : int -> char option
  (** Convert an ASCII [code point][cp] to a character.

    [fromCode 65 = Some 'A']

    [fromCode 66 = Some 'B']

    [fromCode 3000 = None]

    [fromCode (-1) = None]

    The full range of extended ASCII is from [0] to [255]. For numbers outside that range, you get [None].

    [cp]: https://en.wikipedia.org/wiki/Code_point *)

  val from_code : int -> char option

  val toString : char -> string
  (** Convert a character into a string.
      [toString 'A' = "A"]

      [toString '{' = "{"]

      [toString '7' = "7"] *)

  val to_string : char -> string

  val fromString : string -> char option
  (** Converts a string to character. Returns None when the string isn't of length one.
      [fromString "A" = Some 'A']

      [fromString " " = Some ' ']

      [fromString "" = None]

      [fromString "abc" = None]

      [fromString " a" = None] *)

  val from_string : string -> char option

  val toDigit : char -> int option
  (** Converts a digit character to its corresponding integer. Returns None when the character isn't a digit.
      [toDigit "7" = Some 7]

      [toDigit "0" = Some 0]

      [toDigit "A" = None]

      [toDigit "" = None] *)

  val to_digit : char -> int option

  val toLowercase : char -> char
  (** Converts an ASCII character to lower case, preserving non alphabetic ASCII characters.
      [toLowercase 'A' = 'a']

      [toLowercase 'B' = 'b']

      [toLowercase '7' = '7'] *)

  val to_lowercase : char -> char

  val toUppercase : char -> char
  (** Convert an ASCII character to upper case, preserving non alphabetic ASCII characters.
      [toUppercase 'a' = 'A']

      [toUppercase 'b' = 'B']

      [toUppercase '7' = '7'] *)

  val to_uppercase : char -> char

  val isLowercase : char -> bool
  (** Detect lower case ASCII characters.

    [isLowercase 'a' = true]

    [isLowercase 'b' = true]

    ...

    [isLowercase 'z' = true]

    [isLowercase '0' = false]

    [isLowercase 'A' = false]

    [isLowercase '-' = false]

    [isLowercase 'ã' = false] *)

  val is_lowercase : char -> bool

  val isUppercase : char -> bool
  (** Detect upper case ASCII characters.

    [isUppercase 'A' = true]

    [isUppercase 'B' = true]

    [...]

    [isUppercase 'Z' = true]

    [isUppercase '0' = false]

    [isUppercase 'Ý' = false]

    [isUppercase '-' = false] *)

  val is_uppercase : char -> bool

  val isLetter : char -> bool
  (** Detect upper and lower case ASCII alphabetic characters.

      [isLetter 'a' = true]

      [isLetter 'b' = true]

      [isLetter 'E' = true]

      [isLetter 'Y' = true]

      [isLetter '0' = false]

      [isLetter 'ý' = false]

      [isLetter '-' = false] *)

  val is_letter : char -> bool

  val isDigit : char -> bool
  (** Detect when a character is a number

    [isDigit '0' = true]

    [isDigit '1' = true]
    ...
    [isDigit '9' = true]

    [isDigit 'a' = false]

    [isDigit 'b' = false]

    [isDigit 'ý' = false] *)

  val is_digit : char -> bool

  val isAlphanumeric : char -> bool
  (** Detect upper case, lower case and digit ASCII characters.

    [isAlphanumeric 'a' = true]

    [isAlphanumeric 'b' = true]

    [isAlphanumeric 'E' = true]

    [isAlphanumeric 'Y' = true]

    [isAlphanumeric '0' = true]

    [isAlphanumeric '7' = true]

    [isAlphanumeric '-' = false] *)

  val is_alphanumeric : char -> bool

  val isPrintable : char -> bool
  (** Detect if a character is a [printable] character
    https://en.wikipedia.org/wiki/ASCII#Printable_characters

    [isPrintable ' ' = true] *)

  val is_printable : char -> bool

  val isWhitespace : char -> bool
  (** Detect ' ', '\t', '\r' or '\n' characters.

    [isWhitespace ' ' = true]

    [isWhitespace 'b' = false] *)

  val is_whitespace : char -> bool
end

module Float : sig
  (** A module for working with {{: https://en.wikipedia.org/wiki/Floating-point_arithmetic } floating-point numbers}. Valid syntax for [float]s includes:
    {[
      0.
      0.0
      42.
      42.0
      3.14
      0.1234
      123_456.123_456
      6.022e23   (* = (6.022 * 10^23) *)
      6.022e+23  (* = (6.022 * 10^23) *)
      1.602e−19  (* = (1.602 * 10^-19) *)
      1e3        (* = (1 * 10 ** 3) = 1000. *)
    ]}

    Without opening this module you can use the [.] suffixed operators e.g

    {[ 1. +. 2. /. 0.25 *. 2. = 17. ]}

    But by opening this module locally you can use the un-suffixed operators

    {[Float.((10.0 - 1.5 / 0.5) ** 3.0) = 2401.0]}

    {b Historical Note: } The particular details of floats (e.g. [NaN]) are
    specified by {{: https://en.wikipedia.org/wiki/IEEE_754 } IEEE 754 } which is literally hard-coded into almost all
    CPUs in the world.
  *)

  type t = float

  (** {1 Constants} *)

  val zero : t
  (** The literal [0.0] as a named value *)

  val one : t
  (** The literal [1.0] as a named value *)

  val nan : t
  (** [NaN] as a named value. NaN stands for {{: https://en.wikipedia.org/wiki/NaN } not a number}.

      {b Note } comparing values with {!Float.nan} will {b always return } [false] even if the value you are comparing against is also [NaN].

      e.g

      {[
let isNotANmber x = Float.(x = nan) in
isNotANumber nan = false


]}

      For detecting [Nan] you should use {!Float.isNaN}

  *)

  val infinity : t
  (** Positive {{: https://en.wikipedia.org/wiki/IEEE_754-1985#Positive_and_negative_infinity } infinity }

    {[Float.log ~base:10.0 0.0 = Float.infinity]} *)

  val negativeInfinity : t
  (** Negative infinity, see {!Float.infinity} *)

  val negative_infinity : t

  val e : t
  (** An approximation of {{: https://en.wikipedia.org/wiki/E_(mathematical_constant) } Euler's number }. *)

  val pi : t
  (** An approximation of {{: https://en.wikipedia.org/wiki/Pi } pi }. *)

  (** {1 Basic arithmetic and operators} *)

  val add : t -> t -> t
  (** Addition for floating point numbers.

    {[Float.add 3.14 3.14 = 6.28]}

    {[Float.(3.14 + 3.14 = 6.28)]}

    Although [int]s and [float]s support many of the same basic operations such as
    addition and subtraction you {b cannot} [add] an [int] and a [float] directly which
    means you need to use functions like {!Int.toFloat} or {!Float.roundToInt} to convert both values to the same type.

    So if you needed to add a {!List.length} to a [float] for some reason, you
    could:

    {[Float.add 3.14 (Int.toFloat (List.length [1,2,3])) = 6.14]}

    or

    {[Float.roundToInt 3.14 + List.length [1,2,3] = 6]}

    Languages like Java and JavaScript automatically convert [int] values
    to [float] values when you mix and match. This can make it difficult to be sure
    exactly what type of number you are dealing with and cause unexpected behavior.

    OCaml has opted for a design that makes all conversions explicit.
  *)

  val ( + ) : t -> t -> t
  (** See {!Float.add} *)

  val subtract : t -> t -> t
  (** Subtract numbers
    {[Float.subtract 4.0 3.0 = 1.0]}

    Alternatively the [-] operator can be used:

    {[Float.(4.0 - 3.0) = 1.0]}
  *)

  val ( - ) : t -> t -> t
  (** See {!Float.subtract} *)

  val multiply : t -> t -> t
  (** Multiply numbers like

    {[Float.multiply 2.0 7.0 = 14.0]}

    Alternatively the operator [*] can be used:

    {[Float.(2.0 * 7.0) = 14.0]}
  *)

  val ( * ) : t -> t -> t
  (** See {!Float.multiply} *)

  val divide : t -> by:t -> t
  (** Floating-point division:

    {[Float.divide 3.14 ~by:2.0 = 1.57]}

    Alternatively the [/] operator can be used:

    {[Float.(3.14 / 2.0) = 1.57]} *)

  val ( / ) : t -> t -> t
  (** See {!Float.divide} *)

  val power : base:t -> exponent:t -> t
  (** Exponentiation, takes the base first, then the exponent.

    {[Float.power ~base:7.0 ~exponent:3.0 = 343.0]}

    Alternatively the [**] operator can be used:

    {[Float.(7.0 ** 3.0) = 343.0]}
  *)

  val ( ** ) : t -> t -> t
  (** See {!Float.power} *)

  val negate : t -> t
  (** Flips the 'sign' of a [float] so that positive floats become negative and negative integers become positive. Zero stays as it is.

    {[Float.negate 8 = (-8)]}

    {[Float.negate (-7) = 7]}

    {[Float.negate 0 = 0]}

    Alternatively an operator is available:

    {[Float.(~- 4.0) = (-4.0)]}
  *)

  val ( ~- ) : t -> t
  (** See {!Float.negate} *)

  val absolute : t -> t
  (** Get the {{: https://en.wikipedia.org/wiki/Absolute_value } absolute value} of a number.

    {[Float.absolute 8. = 8.]}

    {[Float.absolute (-7) = 7]}

    {[Float.absolute 0 = 0]}
  *)

  val maximum : t -> t -> t
  (** Returns the larger of two [float]s, if both arguments are equal, returns the first argument

    {[Float.maximum 7. 9. = 9.]}

    {[Float.maximum (-4.) (-1.) = (-1.)]}

    If either (or both) of the arguments are [NaN], returns [NaN]

    {[Float.(isNaN (maximum 7. nan) = true]}
  *)

  val minimum : t -> t -> t
  (** Returns the smaller of two [float]s, if both arguments are equal, returns the first argument

    {[Float.minimum 7.0 9.0 = 7.0]}

    {[Float.minimum (-4.0) (-1.0) = (-4.0)]}

    If either (or both) of the arguments are [NaN], returns [NaN]

    {[Float.(isNaN (minimum 7. nan) = true]}
  *)

  val clamp : t -> lower:t -> upper:t -> t
  (** Clamps [n] within the inclusive [lower] and [upper] bounds.

    {[Float.clamp ~lower:0. ~upper:8. 5. = 5.]}

    {[Float.clamp ~lower:0. ~upper:8. 9. = 8.]}

    {[Float.clamp ~lower:(-10.) ~upper:(-5.) 5. = -5.]}

    Throws an [Invalid_argument] exception if [lower > upper]
  *)

  (** {1 Fancier math} *)

  val squareRoot : t -> t
  (** Take the square root of a number.
    {[Float.squareRoot 4.0 = 2.0]}

    {[Float.squareRoot 9.0 = 3.0]}

    [squareRoot] returns [NaN] when its argument is negative. See {!Float.nan} for more.
  *)

  val square_root : t -> t

  val log : t -> base:t -> t
  (** Calculate the logarithm of a number with a given base.

    {[Float.log ~base:10. 100. = 2.]}

    {[Float.log ~base:2. 256. = 8.]}
  *)

  (** {1 Checks} *)

  val isNaN : t -> bool
  (** Determine whether a float is an undefined or unrepresentable number.

    {[Float.isNaN (0.0 / 0.0) = true]}

    {[Float.(isNaN (squareRoot (-1.0)) = true]}

    {[Float.isNaN (1.0 / 0.0) = false  (* Float.infinity {b is} a number *)]}

    {[Float.isNaN 1. = false]}

    {b Note } this function is more useful than it might seem since [NaN] {b does not } equal [Nan]:

    {[Float.(nan = nan) = false]}
  *)

  val is_nan : t -> bool

  val isFinite : t -> bool
  (** Determine whether a float is finite number. True for any float except [Infinity], [-Infinity] or [NaN]

    {[Float.isFinite (0. / 0.) = false]}

    {[Float.(isFinite (squareRoot (-1.)) = false]}

    {[Float.isFinite (1. / 0.) = false]}

    {[Float.isFinite 1. = true]}

    {[Float.(isFinite nan) = false]}

    Notice that [NaN] is not finite!

    For a [float] [n] to be finite implies that [Float.(not (isInfinite n || isNaN n))] evaluates to [true].
  *)

  val is_finite : t -> bool

  val isInfinite : t -> bool
  (** Determine whether a float is positive or negative infinity.

    {[Float.isInfinite (0. / 0.) = false]}

    {[Float.(isInfinite (squareRoot (-1.)) = false]}

    {[Float.isInfinite (1. / 0.) = true]}

    {[Float.isInfinite 1. = false]}

    {[Float.(isInfinite nan) = false]}

    Notice that [NaN] is not infinite!

    For a [float] [n] to be finite implies that [Float.(not (isInfinite n || isNaN n))] evaluates to [true].
  *)

  val is_infinite : t -> bool

  val inRange : t -> lower:t -> upper:t -> bool
  (** Checks if [n] is between [lower] and up to, but not including, [upper].
    If [lower] is not specified, it's set to to [0.0].

    {[Float.inRange ~lower:2. ~upper:4. 3. = true]}

    {[Float.inRange ~lower:1. ~upper:2. 2. = false]}

    {[Float.inRange ~lower:5.2 ~upper:7.9 9.6 = false]}

    Throws an [Invalid_argument] exception if [lower > upper]
  *)

  val in_range : t -> lower:t -> upper:t -> bool

  (** {1 Angles} *)

  val hypotenuse : t -> t -> t
  (** [hypotenuse x y] returns the length of the hypotenuse of a right-angled triangle with sides of length [x] and [y], or, equivalently, the distance of the point [(x, y)] to [(0, 0)].

    {[Float.hypotenuse 3. 4. = 5.]}
  *)

  val degrees : t -> t
  (** Converts an angle in {{: https://en.wikipedia.org/wiki/Degree_(angle) } degrees} to {!Float.radians}.

    {[Float.degrees 180. = v]}
  *)

  val radians : t -> t
  (** Convert a {!Float.t} to {{: https://en.wikipedia.org/wiki/Radian } radians }.

    {[Float.(radians pi) = 3.141592653589793]}

    {b Note } This function doesn't actually do anything to its argument, but can be useful to indicate intent when inter-mixing angles of different units within the same function.
  *)

  val turns : t -> t
  (** Convert an angle in {{: https://en.wikipedia.org/wiki/Turn_(geometry) } turns } into {!Float.radians}.

    One turn is equal to 360°.

    {[Float.(turns (1. / 2.)) = pi]}

    {[Float.(turns 1. = degrees 360.)]}
  *)

  (** {1 Polar coordinates} *)

  val fromPolar : float * float -> float * float
  (** Convert {{: https://en.wikipedia.org/wiki/Polar_coordinate_system } polar coordinates } (r, θ) to {{: https://en.wikipedia.org/wiki/Cartesian_coordinate_system } Cartesian coordinates } (x,y).

    {[Float.(fromPolar (squareRoot 2., degrees 45.)) = (1., 1.)]}
  *)

  val from_polar : float * float -> float * float

  val toPolar : float * float -> float * float
  (** Convert {{: https://en.wikipedia.org/wiki/Cartesian_coordinate_system } Cartesian coordinates } (x,y) to {{: https://en.wikipedia.org/wiki/Polar_coordinate_system } polar coordinates } (r, θ).

    {[Float.toPolar (3.0, 4.0) = (5.0, 0.9272952180016122)]}

    {[Float.toPolar (5.0, 12.0) = (13.0, 1.1760052070951352)]}
  *)

  val to_polar : float * float -> float * float

  val cos : t -> t
  (** Figure out the cosine given an angle in {{: https://en.wikipedia.org/wiki/Radian } radians }.

    {[Float.(cos (degrees 60.)) = 0.5000000000000001]}

    {[Float.(cos (radians (pi / 3.))) = 0.5000000000000001]}
  *)

  val acos : t -> t
  (** Figure out the arccosine for [adjacent / hypotenuse] in {{: https://en.wikipedia.org/wiki/Radian } radians }:

    {[Float.(acos (radians 1.0 / 2.0)) = Float.radians 1.0471975511965979 (* 60° or pi/3 radians *)]}
  *)

  val sin : t -> t
  (** Figure out the sine given an angle in {{: https://en.wikipedia.org/wiki/Radian } radians }.

    {[Float.(sin (degrees 30.)) = 0.49999999999999994]}

    {[Float.(sin (radians (pi / 6.)) = 0.49999999999999994]}
  *)

  val asin : t -> t
  (** Figure out the arcsine for [opposite / hypotenuse] in {{: https://en.wikipedia.org/wiki/Radian } radians }:

    {[Float.(asin (1.0 / 2.0)) = 0.5235987755982989 (* 30° or pi / 6 radians *)]}
  *)

  val tan : t -> t
  (** Figure out the tangent given an angle in radians.

    {[Float.(tan (degrees 45.)) = 0.9999999999999999]}

    {[Float.(tan (radians (pi / 4.)) = 0.9999999999999999]}

    {[Float.(tan (pi / 4.)) = 0.9999999999999999]}
  *)

  val atan : t -> t
  (** This helps you find the angle (in radians) to an [(x, y)] coordinate, but
    in a way that is rarely useful in programming.

    {b You probably want } {!atan2} instead!

    This version takes [y / x] as its argument, so there is no way to know whether
    the negative signs comes from the [y] or [x] value. So as we go counter-clockwise
    around the origin from point [(1, 1)] to [(1, -1)] to [(-1,-1)] to [(-1,1)] we do
    not get angles that go in the full circle:

    {[Float.atan (1. /. 1.) = 0.7853981633974483  (* 45° or pi/4 radians *)]}

    {[Float.atan (1. /. -1.) = -0.7853981633974483  (* 315° or 7 * pi / 4 radians *)]}

    {[Float.atan (-1. /. -1.) = 0.7853981633974483 (* 45° or pi/4 radians *)]}

    {[Float.atan (-1. /.  1.) = -0.7853981633974483 (* 315° or 7 * pi/4 radians *)]}

    Notice that everything is between [pi / 2] and [-pi/2]. That is pretty useless
    for figuring out angles in any sort of visualization, so again, check out
    {!Float.atan2} instead!
  *)

  val atan2 : y:t -> x:t -> t
  (** This helps you find the angle (in radians) to an [(x, y)] coordinate. So rather than saying [Float.(atan (y / x))] you can [Float.atan2 ~y ~x] and you can get a full range of angles:

    {[Float.atan2 ~y:1. ~x:1. = 0.7853981633974483  (* 45° or pi/4 radians *)]}

    {[Float.atan2 ~y:1. ~x:(-1.) = 2.3561944901923449  (* 135° or 3 * pi/4 radians *)]}

    {[Float.atan2 ~y:(-1.) ~x:(-1.) = -(2.3561944901923449) (* 225° or 5 * pi/4 radians *)]}

    {[Float.atan2 ~y:(-1.) ~x:1.) = -(0.7853981633974483) (* 315° or 7 * pi/4 radians *)]}
  *)

  (** {1 Conversion} *)

  type direction =
    [ `Zero
    | `AwayFromZero
    | `Up
    | `Down
    | `Closest of [ `Zero | `AwayFromZero | `Up | `Down | `ToEven ]
    ]

  val round : ?direction:direction -> t -> t
  (** Round a number, by default to the to the closest [int] with halves rounded [`Up] (towards positive infinity)

    {[
Float.round 1.2 = 1.0
Float.round 1.5 = 2.0
Float.round 1.8 = 2.0
Float.round -1.2 = -1.0
Float.round -1.5 = -1.0
Float.round -1.8 = -2.0
    ]}

    Other rounding strategies are available by using the optional [~direction] label.

    {2 Towards zero}

    {[
Float.round ~direction:`Zero 1.2 = 1.0
Float.round ~direction:`Zero 1.5 = 1.0
Float.round ~direction:`Zero 1.8 = 1.0
Float.round ~direction:`Zero (-1.2) = -1.0
Float.round ~direction:`Zero (-1.5) = -1.0
Float.round ~direction:`Zero (-1.8) = -1.0
    ]}

    {2 Away from zero}

    {[
Float.round ~direction:`AwayFromZero 1.2 = 1.0
Float.round ~direction:`AwayFromZero 1.5 = 1.0
Float.round ~direction:`AwayFromZero 1.8 = 1.0
Float.round ~direction:`AwayFromZero (-1.2) = -1.0
Float.round ~direction:`AwayFromZero (-1.5) = -1.0
Float.round ~direction:`AwayFromZero (-1.8) = -1.0
    ]}

    {2 Towards infinity}

    This is also known as {!Float.ceiling}

    {[
Float.round ~direction:`Up 1.2 = 1.0
Float.round ~direction:`Up 1.5 = 1.0
Float.round ~direction:`Up 1.8 = 1.0
Float.round ~direction:`Up (-1.2) = -1.0
Float.round ~direction:`Up (-1.5) = -1.0
Float.round ~direction:`Up (-1.8) = -1.0
    ]}

    {2 Towards negative infinity}

    This is also known as {!Float.floor}

    {[List.map  ~f:(Float.round ~direction:`Down) [-1.8; -1.5; -1.2; 1.2; 1.5; 1.8] = [-2.0; -2.0; -2.0; 1.0 1.0 1.0]]}

    {2 To the closest integer}

    Rounding a number [x] to the closest integer requires some tie-breaking for when the [fraction] part of [x] is exactly [0.5].

    {3 Halves rounded towards zero}

    {[List.map  ~f:(Float.round ~direction:(`Closest `AwayFromZero)) [-1.8; -1.5; -1.2; 1.2; 1.5; 1.8] = [-2.0; -1.0; -1.0; 1.0 1.0 2.0]]}

    {3 Halves rounded away from zero}

    This method is often known as {b commercial rounding }

    {[List.map  ~f:(Float.round ~direction:(`Closest `AwayFromZero)) [-1.8; -1.5; -1.2; 1.2; 1.5; 1.8] = [-2.0; -2.0; -1.0; 1.0 2.0 2.0]]}

    {3 Halves rounded down}

    {[List.map  ~f:(Float.round ~direction:(`Closest `Down)) [-1.8; -1.5; -1.2; 1.2; 1.5; 1.8] = [-2.0; -2.0; -1.0; 1.0 1.0 2.0]]}

    {3 Halves rounded up}

    This is the default.

    [Float.round 1.5] is the same as [Float.round ~direction:(`Closest `Up) 1.5]

    {3 Halves rounded towards the closest even number}

    This tie-breaking rule is the default rounding mode using in

    {[Float.round ~direction:(`Closest `ToEven) -1.5 = -2.0]}

    {[Float.round ~direction:(`Closest `ToEven) -2.5 = -2.0]}
  *)

  val floor : t -> t
  (** Floor function, equivalent to [Float.round ~direction:`Down].

    {[Float.floor 1.2 = 1.0]}

    {[Float.floor 1.5 = 1.0]}

    {[Float.floor 1.8 = 1.0]}

    {[Float.floor -1.2 = -2.0]}

    {[Float.floor -1.5 = -2.0]}

    {[Float.floor -1.8 = -2.0]}
  *)

  val ceiling : t -> t
  (** Ceiling function, equivalent to [Float.round ~direction:`Up].

    {[Float.ceiling 1.2 = 2.0]}

    {[Float.ceiling 1.5 = 2.0]}

    {[Float.ceiling 1.8 = 2.0]}

    {[Float.ceiling -1.2 = (-1.0)]}

    {[Float.ceiling -1.5 = (-1.0)]}

    {[Float.ceiling -1.8 = (-1.0)]}
  *)

  val truncate : t -> t
  (** Ceiling function, equivalent to [Float.round ~direction:`Zero].

    {[Float.truncate 1.0 = 1]}

    {[Float.truncate 1.2 = 1]}

    {[Float.truncate 1.5 = 1]}

    {[Float.truncate 1.8 = 1]}

    {[Float.truncate (-1.2) = -1]}

    {[Float.truncate (-1.5) = -1]}

    {[Float.truncate (-1.8) = -1]}
  *)

  val fromInt : int -> float
  (** Convert an [int] to a [float]

    {[Float.fromInt 5 = 5.0]}

    {[Float.fromInt 0 = 0.0]}

    {[Float.fromInt -7 = -7.0]}
  *)

  val from_int : int -> float

  val toInt : t -> int option
  (** Converts a [float] to an {!Int} by {b ignoring the decimal portion}. See {!Float.truncate} for examples.

    Returns [None] when trying to round a [float] which can't be represented as an [int] such as {!Float.nan} or {!Float.infinity} or numbers which are too large or small.

    {[Float.(toInt nan) = None]}

    {[Float.(toInt infinity) = None]}

    You probably want to use some form of {!Float.round} prior to using this function.

    {[Float.(round 1.6 |> toInt) = Some 2]}
  *)

  val to_int : t -> int option
end

module Int : sig
  (** The platform-dependant {{: https://en.wikipedia.org/wiki/Integer } signed } {{: https://en.wikipedia.org/wiki/Integer } integer} type. An [int] is a whole number.
    Valid syntax for [int]s includes:
    {[
      0
      42
      9000
      1_000_000
      1_000_000
      0xFF (* 255 in hexadecimal *)
      0x000A (* 10 in hexadecimal *)
    ]}

    {b Note:} The number of bits used for an [int] is platform dependent.

    When targeting native OCaml uses 31-bits on a 32-bit platforms and 63-bits on a 64-bit platforms
    which means that [int] math is well-defined in the range [-2 ** 30] to [2 ** 30 - 1] for 32bit platforms [-2 ** 62] to [2 ** 62 - 1] for 64bit platforms.

    You can read about the reasons for OCamls unusual integer sizes {{: https://v1.realworldocaml.org/v1/en/html/memory-representation-of-values.html} here }.

    When targeting JavaScript, that range is [-2 ** 53] to [2 ** 53 - 1].

    Outside of that range, the behavior is determined by the compilation target.

    [int]s are subject to {{: https://en.wikipedia.org/wiki/Integer_overflow } overflow }, meaning that [Int.maximumValue + 1 = Int.minimumValue].

    {e Historical Note: } The name [int] comes from the term {{: https://en.wikipedia.org/wiki/Integer } integer}). It appears
    that the [int] abbreviation was introduced in the programming language ALGOL 68.

    Today, almost all programming languages use this abbreviation.
  *)

  type t = int

  (** {1 Constants } *)

  val zero : t
  (** The literal [0] as a named value *)

  val one : t
  (** The literal [1] as a named value *)

  val maximumValue : t
  (** The maximum representable [int] on the current platform *)

  val maximum_value : t

  val minimumValue : t
  (** The minimum representable [int] on the current platform *)

  val minimum_value : t

  (** {1 Operators }
    {b Note } You do not need to open the {!Int} module to use the {!( + )}, {!( - )}, {!( * )} or {!( / )} operators, these are available as soon as you [open Tablecloth]
  *)

  val add : t -> t -> t
  (** Add two {!Int} numbers.

    {[Int.add 3002 4004 = 7006]}

    Or using the globally available operator:

    {[3002 + 4004 = 7006]}

    You {e cannot } add an [int] and a [float] directly though.

    See {!Float.add} for why, and how to overcome this limitation.
  *)

  val ( + ) : t -> t -> t
  (** See {!Int.add} *)

  val subtract : t -> t -> t
  (** Subtract numbers
    {[Int.subtract 4 3 = 1]}

    Alternatively the operator can be used:

    {[4 - 3 = 1]}
  *)

  val ( - ) : t -> t -> t
  (** See {!Int.subtract} *)

  val multiply : t -> t -> t
  (** Multiply [int]s like

    {[Int.multiply 2 7 = 14]}

    Alternatively the operator can be used:

    {[(2 * 7) = 14]}
  *)

  val ( * ) : t -> t -> t
  (** See {!Int.multiply} *)

  val divide : t -> by:t -> t
  (** Integer division:

    {[Int.divide 3 ~by:2 = 1]}

    {[27 / 5 = 5]}

    Notice that the remainder is discarded.

    Throws [Division_by_zero] when the [by] (the divisor) is [0].
  *)

  val ( / ) : t -> t -> t
  (** See {!Int.divide} *)

  val ( // ) : t -> t -> float
  (** Floating point division
    {[3 // 2 = 1.5]}

    {[27 // 5 = 5.25]}

    {[8 // 4 = 2.0]}
  *)

  val power : base:t -> exponent:t -> t
  (** Exponentiation, takes the base first, then the exponent.

    {[Int.power ~base:7 ~exponent:3 = 343]}

    Alternatively the [**] operator can be used:

    {[7 ** 3 = 343]}
  *)

  val ( ** ) : t -> t -> t
  (** See {!Int.power} *)

  val negate : t -> t
  (** Flips the 'sign' of an integer so that positive integers become negative and negative integers become positive. Zero stays as it is.

    {[Int.negate 8 = (-8)]}

    {[Int.negate (-7) = 7]}

    {[Int.negate 0 = 0]}

    Alternatively the operator can be used:

    {[~-(7) = (-7)]}
  *)

  val ( ~- ) : t -> t
  (** See {!Int.negate} *)

  val absolute : t -> t
  (** Get the {{: https://en.wikipedia.org/wiki/Absolute_value } absolute value } of a number.

    {[Int.absolute 8 = 8]}

    {[Int.absolute (-7) = 7]}

    {[Int.absolute 0 = 0]} *)

  val modulo : t -> by:t -> t
  (** Perform {{: https://en.wikipedia.org/wiki/Modular_arithmetic } modular arithmetic }.

    If you intend to use [modulo] to detect even and odd numbers consider using {!Int.isEven} or {!Int.isOdd}.

    {[Int.modulo ~by:2 0 = 0]}

    {[Int.modulo ~by:2 1 = 1]}

    {[Int.modulo ~by:2 2 = 0]}

    {[Int.modulo ~by:2 3 = 1]}

    Our [modulo] function works in the typical mathematical way when you run into negative numbers:

    {[
      List.map ~f:(Int.modulo ~by:4) [(-5); (-4); -3; -2; -1;  0;  1;  2;  3;  4;  5 ] =
        [3; 0; 1; 2; 3; 0; 1; 2; 3; 0; 1]
    ]}

    Use {!Int.remainder} for a different treatment of negative numbers.
  *)

  val remainder : t -> by:t -> t
  (** Get the remainder after division. Here are bunch of examples of dividing by four:

    {[
      List.map ~f:(Int.remainder ~by:4) [(-5); (-4); (-3); (-2); (-1); 0; 1; 2; 3; 4; 5] =
        [(-1); 0; (-3); (-2); (-1); 0; 1; 2; 3; 0; 1]
    ]}


    Use {!Int.modulo} for a different treatment of negative numbers.
  *)

  val maximum : t -> t -> t
  (** Returns the larger of two [int]s

    {[Int.maximum 7 9 = 9]}

    {[Int.maximum (-4) (-1) = (-1)]} *)

  val minimum : t -> t -> t
  (** Returns the smaller of two [int]s

    {[Int.minimum 7 9 = 7]}

    {[Int.minimum (-4) (-1) = (-4)]} *)

  (** {1 Checks} *)

  val isEven : t -> bool
  (** Check if an [int] is even

    {[Int.isEven 8 = true]}

    {[Int.isEven 7 = false]}

    {[Int.isEven 0 = true]} *)

  val is_even : t -> bool

  val isOdd : t -> bool
  (** Check if an [int] is odd

    {[Int.isOdd 7 = true]}

    {[Int.isOdd 8 = false]}

    {[Int.isOdd 0 = false]} *)

  val is_odd : t -> bool

  val clamp : t -> lower:t -> upper:t -> t
  (** Clamps [n] within the inclusive [lower] and [upper] bounds.

    {[Int.clamp ~lower:0 ~upper:8 5 = 5]}

    {[Int.clamp ~lower:0 ~upper:8 9 = 8]}

    {[Int.clamp ~lower:(-10) ~upper:(-5) 5 = (-5)]}

    Throws an [Invalid_argument] exception if [lower > upper]
  *)

  val inRange : t -> lower:t -> upper:t -> bool
  (** Checks if [n] is between [lower] and up to, but not including, [upper].

    {[Int.inRange ~lower:2 ~upper:4 3 = true]}

    {[Int.inRange ~lower:5 ~upper:8 4 = false]}

    {[Int.inRange ~lower:(-6) ~upper:(-2) (-3) = true]}

    Throws an [Invalid_argument] exception if [lower > upper]
  *)

  val in_range : t -> lower:t -> upper:t -> bool

  (** {1 Conversion } *)

  val toFloat : t -> float
  (** Convert an integer into a float. Useful when mixing {!Int} and {!Float} values like this:

    {[
let halfOf (number : int) : float =
  Float.((Int.toFloat number) / 2)

halfOf 7 = 3.5
    ]}
    Note that locally opening the {!Float} module here allows us to use the floating point division operator
  *)

  val to_float : t -> float

  val toString : t -> string
  (** Convert an [int] into a [string] representation.

    {[Int.toString 3 = "3"]}

    {[Int.toString (-3) = "-3"]}

    {[Int.toString 0 = "0"]}

    Guarantees that

    {[Int.(fromString (toString n)) = Some n ]}
 *)

  val to_string : t -> string

  val fromString : string -> t option
  (** Attempt to parse a [string] into a [int].

    {[Int.fromString "0" = Some 0.]}

    {[Int.fromString "42" = Some 42.]}

    {[Int.fromString "-3" = Some (-3)]}

    {[Int.fromString "123_456" = Some 123_456]}

    {[Int.fromString "0xFF" = Some 255]}

    {[Int.fromString "0x00A" = Some 10]}

    {[Int.fromString "Infinity" = None]}

    {[Int.fromString "NaN" = None]}
  *)

  val from_string : string -> t option
end

module Tuple2 : sig
  val create : 'a -> 'b -> 'a * 'b
  (** Create a 2-tuple.

      [Tuple2.create 3 4 = (3, 4)]

      [let zip (xs : 'a list) (ys : 'b list) : ('a * 'b) list = List.map2 ~f:Tuple2.create xs ys]
  *)

  val first : 'a * 'b -> 'a
  (** Extract the first value from a tuple.

      [Tuple2.first (3, 4) = 3]

      [Tuple2.first ("john", "doe") = "john"]
  *)

  val second : 'a * 'b -> 'b
  (** Extract the second value from a tuple.

      [Tuple2.second (3, 4) = 4]

      [Tuple2.second ("john", "doe") = "doe"]
  *)

  val mapFirst : f:('a -> 'x) -> 'a * 'b -> 'x * 'b
  (** Transform the first value in a tuple.

      [Tuple2.mapFirst ~f:String.reverse ("stressed", 16) = ("desserts", 16)]

      [Tuple2.mapFirst ~f:String.length ("stressed", 16) = (8, 16)]
  *)

  val map_first : f:('a -> 'x) -> 'a * 'b -> 'x * 'b

  val mapSecond : f:('b -> 'y) -> 'a * 'b -> 'a * 'y
  (** Transform the second value in a tuple.

      [Tuple2.mapSecond ~f:sqrt ("stressed", 16.) = ("stressed", 4.)]

      [Tuple2.mapSecond ~f:(~-) ("stressed", 16) = ("stressed", -16)]
  *)

  val map_second : f:('b -> 'y) -> 'a * 'b -> 'a * 'y

  val mapEach : f:('a -> 'x) -> g:('b -> 'y) -> 'a * 'b -> 'x * 'y
  (** Transform each value of a tuple.

      [Tuple2.mapEach ~f:String.reverse ~g:sqrt ("stressed", 16.) = ("desserts", 4.)]

      [Tuple2.mapEach ~f:String.length ~g:(~-) ("stressed", 16) = (8, -16)]
  *)

  val map_each : f:('a -> 'x) -> g:('b -> 'y) -> 'a * 'b -> 'x * 'y

  val mapAll : f:('a -> 'b) -> 'a * 'a -> 'b * 'b
  (** Transform all the values of a tuple using the same function. [mapAll] can only be used on tuples which have the same type for each value.

      [Tuple2.mapAll ~f:succ (3, 4, 5) = (4, 5, 6)]

      [Tuple2.mapAll ~f:String.length ("was", "stressed") = (3, 8)]
  *)

  val map_all : f:('a -> 'b) -> 'a * 'a -> 'b * 'b

  val swap : 'a * 'b -> 'b * 'a
  (** Switches the first and second values of a tuple.

      [Tuple2.swap (3, 4) = (4, 3)]

      [Tuple2.swap ("stressed", 16) = (16, "stressed")]
  *)

  val curry : ('a * 'b -> 'c) -> 'a -> 'b -> 'c
  (** [curry f] takes a function [f] which takes a single argument of a tuple ['a * 'b] and returns a function which takes two arguments that can be partially applied.

      [let squareArea (width, height) = width * height]

      [let curriedArea : float -> float -> float = curry squareArea]

      [let heights = [3, 4, 5]]

      [List.map widths ~f:(curriedArea 4) = [12; 16; 20]]
  *)

  val uncurry : ('a -> 'b -> 'c) -> 'a * 'b -> 'c
  (** [uncurry f] takes a function [f] which takes two arguments and returns a function which takes a single argument of a 2-tuple

      [let sum (a : int) (b: int) : int = a + b]

      [let uncurriedSum : (int * int) -> int = uncurry add]

      [uncurriedSum (3, 4) = 7]
  *)

  val toList : 'a * 'a -> 'a list
  (** Turns a tuple into a list of length two. This function can only be used on tuples which have the same type for each value.

      [Tuple2.toList (3, 4) = [3; 4]]

      [Tuple2.toList ("was", "stressed") = ["was"; "stressed"]]
  *)

  val to_list : 'a * 'a -> 'a list
end

module Tuple3 : sig
  val create : 'a -> 'b -> 'c -> 'a * 'b * 'c
  (** Create a 3-tuple.

      [Tuple3.create 3 4 5 = (3, 4, 5)]

      [let zip3 (xs : 'a list) (ys : 'b list) (zs : 'c list) : ('a * 'b * 'c) list = List.map3 ~f:Tuple3.create xs ys zs]
  *)

  val first : 'a * 'b * 'c -> 'a
  (** Extract the first value from a tuple.

      [Tuple3.first (3, 4, 5) = 3]

      [Tuple3.first ("john", "danger", "doe") = "john"]
  *)

  val second : 'a * 'b * 'c -> 'b
  (** Extract the second value from a tuple.

      [Tuple2.second (3, 4, 5) = 4]

      [Tuple2.second ("john", "danger", "doe") = "danger"]
  *)

  val third : 'a * 'b * 'c -> 'c
  (** Extract the third value from a tuple.

      [Tuple2.third (3, 4, 5) = 5]

      [Tuple2.third ("john", "danger", "doe") = "doe"]
  *)

  val init : 'a * 'b * 'c -> 'a * 'b
  (** Extract the first and second values of a 3-tuple as a 2-tuple.

      [Tuple2.init (3, "stressed", false) = (3, "stressed")]

      [Tuple2.init ("john", 16, "doe") = ("john", 16)]
  *)

  val tail : 'a * 'b * 'c -> 'b * 'c
  (** Extract the second and third values of a 3-tuple as a 2-tuple.

      [Tuple2.init (3, "stressed", false) = ("stressed", false)]

      [Tuple2.init ("john", 16, false) = (16, false)]
  *)

  val mapFirst : f:('a -> 'x) -> 'a * 'b * 'c -> 'x * 'b * 'c
  (** Transform the first value in a tuple.

      [Tuple3.mapFirst ~f:String.reverse ("stressed", 16, false) = ("desserts", 16, false)]

      [Tuple3.mapFirst ~f:String.length ("stressed", 16, false) = (8, 16, false)]
  *)

  val map_first : f:('a -> 'x) -> 'a * 'b * 'c -> 'x * 'b * 'c

  val mapSecond : f:('b -> 'y) -> 'a * 'b * 'c -> 'a * 'y * 'c
  (** Transform the second value in a tuple.

      [Tuple3.mapSecond ~f:sqrt ("stressed", 16., false) = ("stressed", 4., false)]

      [Tuple3.mapSecond ~f:(~-) ("stressed", 16, false) = ("stressed", -16, false)]
  *)

  val map_second : f:('b -> 'y) -> 'a * 'b * 'c -> 'a * 'y * 'c

  val mapThird : f:('c -> 'z) -> 'a * 'b * 'c -> 'a * 'b * 'z
  (** Transform the third value in a tuple.

      [Tuple3.mapThird ~f:not ("stressed", 16, false) ("stressed", 16, true)]
  *)

  val map_third : f:('c -> 'z) -> 'a * 'b * 'c -> 'a * 'b * 'z

  val mapEach :
       f:('a -> 'x)
    -> g:('b -> 'y)
    -> h:('c -> 'z)
    -> 'a * 'b * 'c
    -> 'x * 'y * 'z
  (** Transform the third value in a tuple.

      [Tuple3.mapEach ~f:String.reverse ~g:sqrt ~h:not ("stressed", 16., false) = ("desserts", 4., true)]
  *)

  val map_each :
       f:('a -> 'x)
    -> g:('b -> 'y)
    -> h:('c -> 'z)
    -> 'a * 'b * 'c
    -> 'x * 'y * 'z

  val mapAll : f:('a -> 'b) -> 'a * 'a * 'a -> 'b * 'b * 'b
  (** Transform all the values of a tuple using the same function. [mapAll] can only be used on tuples which have the same type for each value.

      [Tuple2.mapAll ~f:sqrt (9., 16., 25.) = (3., 4., 5.)]

      [Tuple2.mapAll ~f:String.length ("was", "stressed", "then") = (3, 8, 4)]
  *)

  val map_all : f:('a -> 'b) -> 'a * 'a * 'a -> 'b * 'b * 'b

  val rotateLeft : 'a * 'b * 'c -> 'b * 'c * 'a
  (** Move each value in the tuple one position to the left, moving the value in the first position into the last position.

      [Tuple2.rotateLeft (3, 4, 5) = (4, 5, 3)]

      [Tuple2.rotateLeft ("was", "stressed", "then") = ("stressed", "then", "was")]
  *)

  val rotate_left : 'a * 'b * 'c -> 'b * 'c * 'a

  val rotateRight : 'a * 'b * 'c -> 'c * 'a * 'b
  (** Move each value in the tuple one position to the right, moving the value in the last position into the first position.

      [Tuple2.rotateRight (3, 4, 5) = (5, 3, 4)]

      [Tuple2.rotateRight ("was", "stressed", "then") = ("then", "was", "stressed")]
  *)

  val rotate_right : 'a * 'b * 'c -> 'c * 'a * 'b

  val curry : ('a * 'b * 'c -> 'd) -> 'a -> 'b -> 'c -> 'd
  (** [curry f] takes a function [f] which takes a single argument of a tuple ['a * 'b *'c] and returns a function which takes three arguments that can be partially applied.

      [let cubeVolume (width, height, depth) = width * height * depth]

      [let curriedVolume : float -> float -> float = curry squareArea]

      [let depths = [3; 4; 5]]

      [List.map depths ~f:(curriedArea 3 4) = [36; 48; 60]]
  *)

  val uncurry : ('a -> 'b -> 'c -> 'd) -> 'a * 'b * 'c -> 'd
  (** [uncurry f] takes a function [f] which takes three arguments and returns a function which takes a single argument of a 3-tuple

      [let sum (a : int) (b : int) (c : int) : int = a + b + c]

      [let uncurriedSum : (int * int * int) -> int = uncurry sum]

      [uncurriedSum (3, 4, 5) = 12] *)

  val toList : 'a * 'a * 'a -> 'a list
  (** Turns a tuple into a list of length three. This function can only be used on tuples which have the same type for each value.

      [Tuple3.toList (3, 4, 5) = [3; 4; 5]]

      [Tuple3.toList ("was", "stressed", "then") = ["was"; "stressed"; "then"]]
  *)

  val to_list : 'a * 'a * 'a -> 'a list
end

module String : sig
  val length : string -> int

  val toInt : string -> (string, int) Result.t

  val to_int : string -> (string, int) Result.t

  val toFloat : string -> (string, float) Result.t

  val to_float : string -> (string, float) Result.t

  val uncons : string -> (char * string) option

  (* Drop ~count characters from the beginning of a string. *)
  val dropLeft : count:int -> string -> string

  (* Drop ~count characters from the beginning of a string. *)
  val drop_left : count:int -> string -> string

  (* Drop ~count characters from the end of a string. *)
  val dropRight : count:int -> string -> string

  (* Drop ~count characters from the beginning of a string. *)
  val drop_right : count:int -> string -> string

  val split : on:string -> string -> string list

  val join : sep:string -> string list -> string

  val endsWith : suffix:string -> string -> bool

  val ends_with : suffix:string -> string -> bool

  val startsWith : prefix:string -> string -> bool

  val starts_with : prefix:string -> string -> bool

  val toLower : string -> string

  val to_lower : string -> string

  val toUpper : string -> string

  val to_upper : string -> string

  val uncapitalize : string -> string

  val capitalize : string -> string

  val isCapitalized : string -> bool

  val is_capitalized : string -> bool

  val contains : substring:string -> string -> bool

  val repeat : count:int -> string -> string

  val reverse : string -> string

  val fromList : char list -> string

  val from_list : char list -> string

  val toList : string -> char list

  val to_list : string -> char list

  val fromInt : int -> string

  val from_int : int -> string

  val concat : string list -> string

  val fromChar : char -> string

  val from_char : char -> string

  val slice : from:int -> to_:int -> string -> string

  val trim : string -> string

  val insertAt : insert:string -> index:int -> string -> string

  val insert_at : insert:string -> index:int -> string -> string
end

module IntSet : sig
  type t = Base.Set.M(Base.Int).t

  type value = int

  val fromList : value list -> t

  val from_list : value list -> t

  val member : value:value -> t -> bool

  val diff : t -> t -> t

  val isEmpty : t -> bool

  val is_empty : t -> bool

  val toList : t -> value list

  val to_list : t -> value list

  val ofList : value list -> t

  val of_list : value list -> t

  val union : t -> t -> t

  val remove : value:value -> t -> t

  val add : value:value -> t -> t

  val set : value:value -> t -> t

  val has : value:value -> t -> bool

  val empty : t

  val pp : Format.formatter -> t -> unit
end

module StrSet : sig
  type t = Base.Set.M(Base.String).t

  type value = string

  val fromList : value list -> t

  val from_list : value list -> t

  val member : value:value -> t -> bool

  val diff : t -> t -> t

  val isEmpty : t -> bool

  val is_empty : t -> bool

  val toList : t -> value list

  val to_list : t -> value list

  val ofList : value list -> t

  val of_list : value list -> t

  val union : t -> t -> t

  val remove : value:value -> t -> t

  val add : value:value -> t -> t

  val set : value:value -> t -> t

  val has : value:value -> t -> bool

  val empty : t

  val pp : Format.formatter -> t -> unit
end

module StrDict : sig
  type key = string

  type 'value t = 'value Base.Map.M(Base.String).t

  val toList : 'a t -> (key * 'a) list

  val to_list : 'a t -> (key * 'a) list

  val empty : 'a t

  (* If there are multiple list items with the same key, the last one wins *)
  val fromList : (key * 'value) list -> 'value t

  (* If there are multiple list items with the same key, the last one wins *)
  val from_list : (key * 'value) list -> 'value t

  val get : key:key -> 'value t -> 'value option

  val insert : key:key -> value:'value -> 'value t -> 'value t

  val keys : 'a t -> key list

  val update :
    key:key -> f:('value option -> 'value option) -> 'value t -> 'value t

  val map : 'a t -> f:('a -> 'b) -> 'b t

  val pp :
       (Format.formatter -> 'value -> unit)
    -> Format.formatter
    -> 'value t
    -> unit

  val merge :
       f:(key -> 'v1 option -> 'v2 option -> 'v3 option)
    -> 'v1 t
    -> 'v2 t
    -> 'v3 t
end

module IntDict : sig
  type key = int

  type 'value t = 'value Base.Map.M(Base.Int).t

  val toList : 'a t -> (key * 'a) list

  val to_list : 'a t -> (key * 'a) list

  val empty : 'a t

  (* If there are multiple list items with the same key, the last one wins *)
  val fromList : (key * 'value) list -> 'value t

  (* If there are multiple list items with the same key, the last one wins *)
  val from_list : (key * 'value) list -> 'value t

  val get : key:key -> 'value t -> 'value option

  val insert : key:key -> value:'value -> 'value t -> 'value t

  val update :
    key:key -> f:('value option -> 'value option) -> 'value t -> 'value t

  val keys : 'a t -> key list

  val map : 'a t -> f:('a -> 'b) -> 'b t

  val pp :
       (Format.formatter -> 'value -> unit)
    -> Format.formatter
    -> 'value t
    -> unit

  val merge :
       f:(key -> 'v1 option -> 'v2 option -> 'v3 option)
    -> 'v1 t
    -> 'v2 t
    -> 'v3 t
end

(* module Regex : sig *)
(*   type t *)
(*  *)
(*   type result *)
(*  *)
(*   val regex : string -> t *)
(*  *)
(*   val contains : re:t -> string -> bool *)
(*  *)
(*   val replace : re:t -> repl:string -> string -> string *)
(*  *)
(*   val matches : re:t -> string -> result option *)
(* end *)
