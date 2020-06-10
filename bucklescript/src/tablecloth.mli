(** *)

(** Functions for working with boolean ([true] or [false]) values. *)
module Bool : module type of Bool

module Char : module type of TableclothChar

module String : module type of TableclothString

(** Fixed precision integers *)
module Int : module type of Int

module Float : module type of Float

module Option : module type of TableclothOption

module Result : module type of TableclothResult

module Array : module type of TableclothArray

module List : module type of TableclothList

module Tuple2 : module type of Tuple2

module Tuple3 : module type of Tuple3

module IntSet : sig
  type t = Belt.Set.Int.t

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
  type t = Belt.Set.String.t

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
  type key = Belt.Map.String.key

  type 'value t = 'value Belt.Map.String.t

  val toList : 'a t -> (key * 'a) list

  val to_list : 'a t -> (key * 'a) list

  val empty : 'a t

  val fromList : (key * 'value) list -> 'value t

  val from_list : (key * 'value) list -> 'value t

  val get : key:key -> 'value t -> 'value option

  val insert : key:key -> value:'value -> 'value t -> 'value t

  val keys : 'a t -> key list

  val update :
    key:key -> f:('value option -> 'value option) -> 'value t -> 'value t

  val map : 'a t -> f:('a -> 'b) -> 'b t

  val toString : 'a t -> string

  val to_string : 'a t -> string

  val pp :
    (Format.formatter -> 'value -> unit) -> Format.formatter -> 'value t -> unit

  val merge :
    f:(key -> 'v1 option -> 'v2 option -> 'v3 option) -> 'v1 t -> 'v2 t -> 'v3 t
end

module IntDict : sig
  type key = Belt.Map.Int.key

  type 'value t = 'value Belt.Map.Int.t

  val toList : 'a t -> (key * 'a) list

  val to_list : 'a t -> (key * 'a) list

  val empty : 'a t

  val fromList : (key * 'value) list -> 'value t

  val from_list : (key * 'value) list -> 'value t

  val get : key:key -> 'value t -> 'value option

  val insert : key:key -> value:'value -> 'value t -> 'value t

  val update :
    key:key -> f:('value option -> 'value option) -> 'value t -> 'value t

  val keys : 'a t -> key list

  val map : 'a t -> f:('a -> 'b) -> 'b t

  val toString : 'a t -> string

  val to_string : 'a t -> string

  val pp :
    (Format.formatter -> 'value -> unit) -> Format.formatter -> 'value t -> unit

  val merge :
    f:(key -> 'v1 option -> 'v2 option -> 'v3 option) -> 'v1 t -> 'v2 t -> 'v3 t
end

(** Functions for working with functions. *)
module Fun : module type of Fun
