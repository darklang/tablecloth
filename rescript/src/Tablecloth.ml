module Bool = TableclothBool
(** Functions for working with boolean ([true] or [false]) values. *)

module Char = TableclothChar
(** Functions for working with single characters. *)

module String = TableclothString
(** Functions for working with ["strings"] *)

module Int = TableclothInt
(** Fixed precision integers *)

module Float = TableclothFloat
(** Functions for working with floating point numbers. *)

module Container = TableclothContainer
(** Interfaces for use with container types like {!Array} or {!List} *)

module Array = TableclothArray
(** A fixed lenfth collection of values *)

module List = TableclothList
(** Arbitrary length, singly linked lists *)

module Option = TableclothOption
(** Functions for working with optional values. *)

module Result = TableclothResult
(** Functions for working with computations which may fail. *)

module Tuple2 = TableclothTuple2
(** Functions for manipulating tuples of length two *)

module Tuple3 = TableclothTuple3
(** Functions for manipulating tuples of length three *)

module Comparator = TableclothComparator

module Set = TableclothSet
(** A collection of unique values *)

module Map = TableclothMap
(** A collection of key-value pairs *)

module Fun = TableclothFun
(** Functions for working with functions. *)
