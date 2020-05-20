(**  *)

module Comparator : module type of Comparator

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

module List : module type of TableclothList

module Option : module type of TableclothOption

module Result : module type of TableclothResult

module Tuple2 : module type of Tuple2

module Tuple3 : module type of Tuple3

module Map : module type of TableclothMap

module Set : module type of TableclothSet

(** Functions for working with functions. *)
module Fun : module type of Fun
