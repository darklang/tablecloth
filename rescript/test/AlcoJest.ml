open Jest
open Expect

module Coordinate = struct
  type t = int * int
end

module Student = struct
  type t =
    { id : int
    ; name : string
    }
end

module Eq : sig
  (** This module is purely to make the API match the one provided in native/test/AlcoJest.re
  All of the implementations are `ignore` since although Alcotest requires    
  matchers which can test for equality and pretty print types, Jest doesn't
  need these as it compares values structurally (which is fine for the     
  included types)*)
  type result

  type 'a t = 'a -> 'a -> result

  val make : ('a -> 'a -> bool) -> 'a t

  val bool : bool t

  val char : char t

  val int : int t

  val float : float t

  val coordinate : Coordinate.t t

  val student : Student.t t

  val string : string t

  val unit : unit t

  val array : 'a t -> 'a array t

  val list : 'a t -> 'a list t

  val option : 'a t -> 'a option t

  val result : 'ok t -> 'error t -> ('ok, 'error) Tablecloth.Result.t t

  val pair : 'a t -> 'b t -> ('a * 'b) t

  val trio : 'a t -> 'b t -> 'c t -> ('a * 'b * 'c) t
end = struct
  type result = unit

  type 'a t = 'a -> 'a -> unit

  let make _ _ = ignore

  let ignore _ = ignore

  let bool = ignore

  let char = ignore

  let int = ignore

  let float = ignore

  let coordinate = ignore

  let student = ignore

  let string = ignore

  let unit = ignore

  let array _ = ignore

  let list _ = ignore

  let option _ = ignore

  let result _ _ = ignore

  let pair _ _ = ignore

  let trio _ _ _ = ignore
end

let suite = describe

let describe = describe

let test = test

let testAll = testAll

module Skip = Skip

let expect = expect

let toEqual (_ : 'a Eq.t) (value : 'a) = toEqual value

let toBeCloseTo = toBeCloseTo

let toRaise _exn = toThrow

let toThrow = toThrow
