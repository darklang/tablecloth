val ( <| ) : ('a -> 'b) -> 'a -> 'b

val ( >> ) : ('a -> 'b) -> ('b -> 'c) -> 'a -> 'c

val ( << ) : ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c

val identity : 'a -> 'a

module Array : sig
  (** A mutable vector of elements which must have the same type with O(1) {!get} and {!set} operations.

   You can create an [array] in OCaml with the [[|1; 2; 3|]] syntax. *)

  val empty : 'a array
  (** An empty array.

    {[Array.empty = [||]]}

    {[Array.length Array.empty = 0]} *)

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

  val get : index:int -> 'a array -> 'a option
  (** [Array.get ~index:n a] returns, as an {!Option}, the element at index number [n] of array [a].

    The first element has index number 0.

    The last element has index number [Array.length a - 1].

    Returns [None] if [n] is outside the range [0] to [(Array.length a - 1)].

    You can also write [a.(n)] instead of [Array.get a n] but this raises [Invalid_argument "index out of bounds"] for index outside of the range of the array.

    {[Array.get ~index:2 [|"cat"; "dog"; "eel"|] = Some "eel"]}

    {[Array.get ~index:5 [|0; 1; 2|] = None]}

    {[Array.get ~index:0 [||] = None]} *)

  val set : index:int -> value:'a -> 'a array -> unit
  (** [Array.set a ~index:n ~value:x] modifies array [a] in place, replacing the element at index number [n] with [x].

    You can also write [a.(n) <- x] instead of [Array.set a ~index:n ~value:x].

    Raises [Invalid_argument "index out of bounds"] if [n] is outside the range [0] to [Array.length a - 1]. 
    
    {[let setZero = Array.set ~value:0 in
let numbers = [|1;2;3|] in
  
setZero numbers ~index:2;
setZero numbers ~index:1;

numbers = [|1;0;0|]]}

    {[let setZerothElement = Array.set ~index:0 in
let animals = [|"ant"; "bat"; "cat"|] in

setZerothElement animals ~value:"antelope";

animals = [|"antelope"; "bat"; "cat"|]]} *)

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

  val map : f:('a -> 'b) -> 'a array -> 'b array
  (** Create a new array which is the result of applying a function [f] to every element.

    {[Array.map ~f:sqrt [|1.0; 4.0; 9.0|] = [|1.0; 2.0; 3.0|]]} *)

  val mapWithIndex : f:(int -> 'a -> 'b) -> 'a array -> 'b array
  (** Apply a function [f] to every element with its index as the first argument.

   {[Array.mapWithIndex ~f:( * ) [|5; 5; 5|] = [|0; 5; 10|]]} *)

  val map_with_index : f:(int -> 'a -> 'b) -> 'a array -> 'b array

  val mapi : f:(int -> 'a -> 'b) -> 'a array -> 'b array

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

  val map3 : f:('a -> 'b -> 'c -> 'd) -> 'a array -> 'b array -> 'c array -> 'd array
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

  val flatMap : f:('a -> 'a array) -> 'a array -> 'a array
  (** Apply a function [f] onto an array and flatten the resulting array of arrays.

    {[Array.flatMap ~f xs = Array.map ~f xs |> Array.flatten]} 
    
    {[Array.flatMap ~f:(fun n -> [|n; n|]) [|1; 2; 3|] = [|1; 1; 2; 2; 3; 3|]]} *)

  val flat_map : f:('a -> 'a array) -> 'a array -> 'a array

  val find : f:('a -> bool) -> 'a array -> 'a option
  (** Returns as an option the first element for which f evaluates to true. If [f] doesn't return [true] for any of the elements [find] will return [None] 
    {[Array.find ~f:Int.isEven [|1; 3; 4; 8;|] = Some 4]}

    {[Array.find ~f:Int.isOdd [|0; 2; 4; 8;|] = None]}

    {[Array.find ~f:Int.isEven [||] = None]} *)

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

  val intersperse : sep : 'a -> 'a array -> 'a array
  (** Places [sep] between all elements of the given array.

    {[Array.intersperse ~sep:"on" [|"turtles"; "turtles"; "turtles"|] = [|"turtles"; "on"; "turtles"; "on"; "turtles"|]]}

    {[Array.intersperse ~sep:0 [||] = [||]]} *)

  val slice : from : int -> ?to_: int -> 'a array -> 'a array
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

  val foldLeft : f:('a -> 'b -> 'b)  -> initial:'b -> 'a array -> 'b
  (** Reduces collection to a value which is the accumulated result of running each element in the array through [f], 
      where each successive invocation is supplied the return value of the previous. 
    
    Read [foldLeft] as 'fold from the left'. 

    {[Array.foldLeft ~f:( * ) ~initial:1 (Array.repeat ~length:4 7) = 2401]}
    
    {[Array.foldLeft ~f:((fun element list -> element :: list)) ~initial:[] [|1; 2; 3|] = [3; 2; 1]]} *)

  val fold_left : f:('a -> 'b -> 'b)  -> initial:'b -> 'a array -> 'b

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
  val flatten : 'a list list -> 'a list

  val sum : int list -> int

  val floatSum : float list -> float

  val float_sum : float list -> float

  val map : f:('a -> 'b) -> 'a list -> 'b list

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

  val concat : 'a list list -> 'a list

  val partition : f:('a -> bool) -> 'a list -> 'a list * 'a list

  val foldr : f:('a -> 'b -> 'b) -> init:'b -> 'a list -> 'b

  val foldl : f:('a -> 'b -> 'b) -> init:'b -> 'a list -> 'b

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

module Int : sig
  val negate : int -> int
  (**
    [Int.negate 8 = (-8)]

    [Int.negate (-7) = 7]

    [Int.negate 0 = 0] *)

  val isEven : int -> bool
  (**
    [Int.isEven 8 = true]

    [Int.isEven 7 = false]

    [Int.isEven 0 = true] *)

  val is_even : int -> bool

  val isOdd : int -> bool
    (**
    [Int.isOdd 7 = true]

    [Int.isOdd 8 = false]

    [Int.isOdd 0 = false] *)

  val is_odd : int -> bool
end

module Tuple2 : sig
  val create : 'a -> 'b -> 'a * 'b
  (** Create a 2-tuple.

      [Tuple2.create 3 4 = (3, 4)]

      [let zip (xs : 'a list) (ys : 'b list) : ('a * 'b) list = List.map2 ~f:Tuple2.create xs ys]
  *)

  val first : ('a * 'b) -> 'a
  (** Extract the first value from a tuple.

      [Tuple2.first (3, 4) = 3]

      [Tuple2.first ("john", "doe") = "john"]
  *)

  val second : ('a * 'b) -> 'b
  (** Extract the second value from a tuple.

      [Tuple2.second (3, 4) = 4]

      [Tuple2.second ("john", "doe") = "doe"]
  *)

  val mapFirst : f:('a -> 'x) -> ('a * 'b) -> ('x * 'b)
  (** Transform the first value in a tuple.

      [Tuple2.mapFirst ~f:String.reverse ("stressed", 16) = ("desserts", 16)]

      [Tuple2.mapFirst ~f:String.length ("stressed", 16) = (8, 16)]
  *)

  val map_first : f:('a -> 'x) -> ('a * 'b) -> ('x * 'b)

  val mapSecond : f:('b -> 'y) -> ('a * 'b) -> ('a * 'y)
  (** Transform the second value in a tuple.

      [Tuple2.mapSecond ~f:sqrt ("stressed", 16.) = ("stressed", 4.)]

      [Tuple2.mapSecond ~f:(~-) ("stressed", 16) = ("stressed", -16)]
  *)

  val map_second : f:('b -> 'y) -> ('a * 'b) -> ('a * 'y)

  val mapEach : f:('a -> 'x) -> g:('b -> 'y) -> ('a * 'b) -> ('x * 'y)
  (** Transform each value of a tuple.

      [Tuple2.mapEach ~f:String.reverse ~g:sqrt ("stressed", 16.) = ("desserts", 4.)]

      [Tuple2.mapEach ~f:String.length ~g:(~-) ("stressed", 16) = (8, -16)]
  *)

  val map_each : f:('a -> 'x) -> g:('b -> 'y) -> ('a * 'b) -> ('x * 'y)

  val mapAll : f:('a -> 'b) -> ('a * 'a) -> ('b * 'b)
  (** Transform all the values of a tuple using the same function. [mapAll] can only be used on tuples which have the same type for each value.

      [Tuple2.mapAll ~f:succ (3, 4, 5) = (4, 5, 6)]

      [Tuple2.mapAll ~f:String.length ("was", "stressed") = (3, 8)]
  *)

  val map_all : f:('a -> 'b) -> ('a * 'a) -> ('b * 'b)

  val swap : ('a * 'b) -> ('b * 'a)
  (** Switches the first and second values of a tuple.

      [Tuple2.swap (3, 4) = (4, 3)]

      [Tuple2.swap ("stressed", 16) = (16, "stressed")]
  *)

  val curry : (('a * 'b) -> 'c) -> 'a -> 'b -> 'c 
  (** [curry f] takes a function [f] which takes a single argument of a tuple ['a * 'b] and returns a function which takes two arguments that can be partially applied.

      [let squareArea (width, height) = width * height]
    
      [let curriedArea : float -> float -> float = curry squareArea]

      [let heights = [3, 4, 5]]

      [List.map widths ~f:(curriedArea 4) = [12; 16; 20]]
  *)
  
  val uncurry : ('a -> 'b -> 'c) -> ('a * 'b) -> 'c
  (** [uncurry f] takes a function [f] which takes two arguments and returns a function which takes a single argument of a 2-tuple

      [let sum (a : int) (b: int) : int = a + b]

      [let uncurriedSum : (int * int) -> int = uncurry add]

      [uncurriedSum (3, 4) = 7]
  *)

  val toList : ('a * 'a) -> 'a list
  (** Turns a tuple into a list of length two. This function can only be used on tuples which have the same type for each value.
  
      [Tuple2.toList (3, 4) = [3; 4]]

      [Tuple2.toList ("was", "stressed") = ["was"; "stressed"]]
  *)

  val to_list : ('a * 'a) -> 'a list
end

module Tuple3 : sig
  val create : 'a -> 'b -> 'c -> ('a * 'b * 'c)
  (** Create a 3-tuple.

      [Tuple3.create 3 4 5 = (3, 4, 5)]

      [let zip3 (xs : 'a list) (ys : 'b list) (zs : 'c list) : ('a * 'b * 'c) list = List.map3 ~f:Tuple3.create xs ys zs]
  *)

  val first : ('a * 'b * 'c) -> 'a
  (** Extract the first value from a tuple.

      [Tuple3.first (3, 4, 5) = 3]

      [Tuple3.first ("john", "danger", "doe") = "john"]
  *)

  val second : ('a * 'b * 'c) -> 'b
  (** Extract the second value from a tuple.

      [Tuple2.second (3, 4, 5) = 4]

      [Tuple2.second ("john", "danger", "doe") = "danger"]
  *)
  
  val third : ('a * 'b * 'c) -> 'c
  (** Extract the third value from a tuple.

      [Tuple2.third (3, 4, 5) = 5]

      [Tuple2.third ("john", "danger", "doe") = "doe"]
  *)

  val init : ('a * 'b * 'c) -> ('a * 'b)
  (** Extract the first and second values of a 3-tuple as a 2-tuple.

      [Tuple2.init (3, "stressed", false) = (3, "stressed")]

      [Tuple2.init ("john", 16, "doe") = ("john", 16)]
  *)

  val tail : ('a * 'b * 'c) -> ('b * 'c)
  (** Extract the second and third values of a 3-tuple as a 2-tuple.

      [Tuple2.init (3, "stressed", false) = ("stressed", false)]

      [Tuple2.init ("john", 16, false) = (16, false)]
  *)

  val mapFirst : f:('a -> 'x) -> ('a * 'b * 'c) -> ('x * 'b *'c)
  (** Transform the first value in a tuple.

      [Tuple3.mapFirst ~f:String.reverse ("stressed", 16, false) = ("desserts", 16, false)]

      [Tuple3.mapFirst ~f:String.length ("stressed", 16, false) = (8, 16, false)]
  *)

  val map_first : f:('a -> 'x) -> ('a * 'b * 'c) -> ('x * 'b *'c)

  val mapSecond : f:('b -> 'y) -> ('a * 'b * 'c) -> ('a * 'y * 'c)
  (** Transform the second value in a tuple.

      [Tuple3.mapSecond ~f:sqrt ("stressed", 16., false) = ("stressed", 4., false)]
    
      [Tuple3.mapSecond ~f:(~-) ("stressed", 16, false) = ("stressed", -16, false)]
  *)

  val map_second : f:('b -> 'y) -> ('a * 'b * 'c) -> ('a * 'y * 'c)

  val mapThird : f:('c -> 'z) -> ('a * 'b * 'c) -> ('a * 'b * 'z)
  (** Transform the third value in a tuple.

      [Tuple3.mapThird ~f:not ("stressed", 16, false) ("stressed", 16, true)]
  *)

  val map_third : f:('c -> 'z) -> ('a * 'b * 'c) -> ('a * 'b * 'z)

  val mapEach : f:('a -> 'x) -> g:('b -> 'y) -> h:('c -> 'z) -> ('a * 'b * 'c) -> ('x * 'y * 'z)
  (** Transform the third value in a tuple.

      [Tuple3.mapEach ~f:String.reverse ~g:sqrt ~h:not ("stressed", 16., false) = ("desserts", 4., true)]
  *)

  val map_each : f:('a -> 'x) -> g:('b -> 'y) -> h:('c -> 'z) -> ('a * 'b * 'c) -> ('x * 'y * 'z)

  val mapAll : f:('a -> 'b) -> ('a * 'a * 'a) -> ('b * 'b * 'b)
  (** Transform all the values of a tuple using the same function. [mapAll] can only be used on tuples which have the same type for each value.    

      [Tuple2.mapAll ~f:sqrt (9., 16., 25.) = (3., 4., 5.)]

      [Tuple2.mapAll ~f:String.length ("was", "stressed", "then") = (3, 8, 4)]
  *)

  val map_all : f:('a -> 'b) -> ('a * 'a * 'a) -> ('b * 'b * 'b)

  val rotateLeft : ('a * 'b * 'c) -> ('b * 'c * 'a)
  (** Move each value in the tuple one position to the left, moving the value in the first position into the last position.

      [Tuple2.rotateLeft (3, 4, 5) = (4, 5, 3)]

      [Tuple2.rotateLeft ("was", "stressed", "then") = ("stressed", "then", "was")]
  *)
  
  val rotate_left : ('a * 'b * 'c) -> ('b * 'c * 'a)

  val rotateRight : ('a * 'b * 'c) -> ('c * 'a * 'b)
  (** Move each value in the tuple one position to the right, moving the value in the last position into the first position.

      [Tuple2.rotateRight (3, 4, 5) = (5, 3, 4)]

      [Tuple2.rotateRight ("was", "stressed", "then") = ("then", "was", "stressed")]
  *)

  val rotate_right : ('a * 'b * 'c) -> ('c * 'a * 'b)

  val curry : (('a * 'b * 'c) -> 'd) -> 'a -> 'b -> 'c -> 'd
  (** [curry f] takes a function [f] which takes a single argument of a tuple ['a * 'b *'c] and returns a function which takes three arguments that can be partially applied.

      [let cubeVolume (width, height, depth) = width * height * depth]

      [let curriedVolume : float -> float -> float = curry squareArea]

      [let depths = [3; 4; 5]]

      [List.map depths ~f:(curriedArea 3 4) = [36; 48; 60]]
  *)

  val uncurry : ('a -> 'b -> 'c -> 'd) -> ('a * 'b * 'c) -> 'd
  (** [uncurry f] takes a function [f] which takes three arguments and returns a function which takes a single argument of a 3-tuple

      [let sum (a : int) (b : int) (c : int) : int = a + b + c]

      [let uncurriedSum : (int * int * int) -> int = uncurry sum]

      [uncurriedSum (3, 4, 5) = 12] *)
  
  val toList : ('a * 'a * 'a) -> 'a list
   (** Turns a tuple into a list of length three. This function can only be used on tuples which have the same type for each value.
  
      [Tuple3.toList (3, 4, 5) = [3; 4; 5]]
    
      [Tuple3.toList ("was", "stressed", "then") = ["was"; "stressed"; "then"]]
  *)

  val to_list : ('a * 'a * 'a) -> 'a list
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
