(** This module contains module signatures which are used in functions which
    accept first class modules.
*)

module type Sum = sig
  (** Modules which conform to this signature can be used with functions like
      {!Array.sum} or {!List.sum}.
  *)

  type t

  val zero : t

  val add : t -> t -> t
end
