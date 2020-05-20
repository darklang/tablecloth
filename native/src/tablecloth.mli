(**  *)

(** Functions for working with boolean ([true] or [false]) values. *)
module Bool : module type of Bool

(** Functions for working with single characters. *)
module Char : module type of TableclothChar

module String : module type of TableclothString

(** Fixed precision integers *)
module Int : module type of Int

(** Functions for working with floating point numbers. *)
module Float : module type of Float

module Array : module type of TableclothArray

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

  val forEachWithIndex : 'a list -> f:(int -> 'a -> unit) -> unit

  val repeat : count:int -> 'a -> 'a list
  (**
    [List.repeat ~count=n v] returns a list with the value [v] repeated [n] times.

    {[
    List.repeat ~count:3 99 = [99; 99; 99]
    List.repeat ~count:0 99 = []
    ]}
  *)
end

module Option : module type of TableclothOption

module Result : module type of TableclothResult

module Tuple2 : module type of Tuple2

module Tuple3 : module type of Tuple3

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
    (Format.formatter -> 'value -> unit) -> Format.formatter -> 'value t -> unit

  val merge :
    f:(key -> 'v1 option -> 'v2 option -> 'v3 option) -> 'v1 t -> 'v2 t -> 'v3 t
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
    (Format.formatter -> 'value -> unit) -> Format.formatter -> 'value t -> unit

  val merge :
    f:(key -> 'v1 option -> 'v2 option -> 'v3 option) -> 'v1 t -> 'v2 t -> 'v3 t
end

(** Functions for working with functions. *)
module Fun : module type of Fun
