val ( <| ) : ('a -> 'b) -> 'a -> 'b

val ( >> ) : ('a -> 'b) -> ('b -> 'c) -> 'a -> 'c

val ( << ) : ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c

val identity : 'a -> 'a

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

  val splitWhen : f:('a -> bool) -> 'a list -> ('a list * 'a list) option

  val split_when : f:('a -> bool) -> 'a list -> ('a list * 'a list) option

  val intersperse : 'a -> 'a list -> 'a list

  val initialize : int -> (int -> 'a) -> 'a list

  val sortWith : ('a -> 'a -> int) -> 'a list -> 'a list

  val sort_with : ('a -> 'a -> int) -> 'a list -> 'a list

  val iter : f:('a -> unit) -> 'a list -> unit
end

module Result : sig
  type ('err, 'ok) t = ('ok, 'err) Base.Result.t

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

  val andThen : f:('a -> 'b option) -> 'a option -> 'b option

  val and_then : f:('a -> 'b option) -> 'a option -> 'b option

  val or_ : 'a option -> 'a option -> 'a option

  val orElse : 'a option -> 'a option -> 'a option

  val or_else : 'a option -> 'a option -> 'a option

  val map : f:('a -> 'b) -> 'a option -> 'b option

  val withDefault : default:'a -> 'a option -> 'a

  val with_default : default:'a -> 'a option -> 'a

  val foldrValues : 'a option -> 'a list -> 'a list

  val foldr_values : 'a option -> 'a list -> 'a list

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

module Tuple2 : sig
  val create : 'a -> 'b -> 'a * 'b

  val first : ('a * 'b) -> 'a

  val second : ('a * 'b) -> 'b

  val mapFirst : f:('a -> 'x) -> ('a * 'b) -> ('x * 'b)

  val map_first : f:('a -> 'x) -> ('a * 'b) -> ('x * 'b)

  val mapSecond : f:('b -> 'y) -> ('a * 'b) -> ('a * 'y)

  val map_second : f:('b -> 'y) -> ('a * 'b) -> ('a * 'y)

  val mapEach : f:('a -> 'x) -> g:('b -> 'y) -> ('a * 'b) -> ('x * 'y)

  val map_each : f:('a -> 'x) -> g:('b -> 'y) -> ('a * 'b) -> ('x * 'y)

  val mapAll : f:('a -> 'b) -> ('a * 'a) -> ('b * 'b)

  val map_all : f:('a -> 'b) -> ('a * 'a) -> ('b * 'b)

  val swap : ('a * 'b) -> ('b * 'a)

  val toList : ('a * 'a) -> 'a list

  val to_list : ('a * 'a) -> 'a list
end

module Tuple3 : sig
  val create : 'a -> 'b -> 'c -> ('a * 'b * 'c)

  val first : ('a * 'b * 'c) -> 'a

  val second : ('a * 'b * 'c) -> 'b
  
  val third : ('a * 'b * 'c) -> 'c

  val init : ('a * 'b * 'c) -> ('a * 'b)

  val tail : ('a * 'b * 'c) -> ('b * 'c)

  val mapFirst : f:('a -> 'x) -> ('a * 'b * 'c) -> ('x * 'b *'c)

  val map_first : f:('a -> 'x) -> ('a * 'b * 'c) -> ('x * 'b *'c)

  val mapSecond : f:('b -> 'y) -> ('a * 'b * 'c) -> ('a * 'y * 'c)

  val map_second : f:('b -> 'y) -> ('a * 'b * 'c) -> ('a * 'y * 'c)

  val mapThird : f:('c -> 'z) -> ('a * 'b * 'c) -> ('a * 'b * 'z)

  val map_third : f:('c -> 'z) -> ('a * 'b * 'c) -> ('a * 'b * 'z)

  val mapEach : f:('a -> 'x) -> g:('b -> 'y) -> h:('c -> 'z) -> ('a * 'b * 'c) -> ('x * 'y * 'z)

  val map_each : f:('a -> 'x) -> g:('b -> 'y) -> h:('c -> 'z) -> ('a * 'b * 'c) -> ('x * 'y * 'z)

  val mapAll : f:('a -> 'b) -> ('a * 'a * 'a) -> ('b * 'b * 'b)

  val map_all : f:('a -> 'b) -> ('a * 'a * 'a) -> ('b * 'b * 'b)

  val rotateLeft : ('a * 'b * 'c) -> ('b * 'c * 'a)
  
  val rotate_left : ('a * 'b * 'c) -> ('b * 'c * 'a)

  val rotateRight : ('a * 'b * 'c) -> ('c * 'a * 'b)

  val rotate_right : ('a * 'b * 'c) -> ('c * 'a * 'b)
  
  val toList : ('a * 'a * 'a) -> 'a list

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
