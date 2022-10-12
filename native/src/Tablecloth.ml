(** Functions for working with boolean ([true] or [false]) values. *)
module Bool = TableclothBool

(** Functions for working with single characters. *)
module Char = TableclothChar

(** Functions for working with ["strings"] *)
module String = TableclothString

(** Fixed precision integers *)
module Int = TableclothInt

(** Functions for working with floating point numbers. *)
module Float = TableclothFloat

(** Interfaces for use with container types like {!Array} or {!List} *)
module Container = TableclothContainer

(** A fixed lenfth collection of values *)
module Array = TableclothArray

(** Arbitrary length, singly linked lists *)
module List = TableclothList

(** Functions for working with optional values. *)
module Option = TableclothOption

(** Functions for working with computations which may fail. *)
module Result = struct
  include TableclothResult

  (** [Result.pp err_format ok_format dest_format result] "pretty-prints"
      the [result], using [err_format] if the [result] is an [Error] value or
      [ok_format] if the [result] is an [Ok] value. [dest_format] is a formatter
      that tells where to send the output.

      {[
        let good: (int, string) Result.t = Ok 42 in
        let not_good: (int, string) Tablecloth.Result.t = Error "bad" in
        Result.pp Format.pp_print_int Format.pp_print_string Format.std_formatter good;
        Result.pp Format.pp_print_int Format.pp_print_string Format.std_formatter not_good;
        Format.pp_print_newline Format.std_formatter ();
        (* prints <ok: 42><error: bad>*)
      ]}
    *)
  let pp
      (okf : Format.formatter -> 'ok -> unit)
      (errf : Format.formatter -> 'error -> unit)
      (fmt : Format.formatter)
      (r : ('ok, 'error) t) : unit =
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

(** Functions for manipulating tuples of length two *)
module Tuple2 = TableclothTuple2

(** Functions for manipulating tuples of length three *)
module Tuple3 = TableclothTuple3

module Comparator = TableclothComparator

(** A collection of unique values *)
module Set = TableclothSet

(** A collection of key-value pairs *)
module Map = TableclothMap

(** Functions for working with functions. *)
module Fun = TableclothFun
