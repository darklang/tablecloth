open Tablecloth
open AlcoJest

module Coordinate : sig
  type t = int * int

  val compare : t -> t -> int

  type identity

  val comparator : (t, identity) Tablecloth.Comparator.comparator
end = struct
  module T = struct
    type t = int * int

    let compare = Tuple2.compare ~f:Int.compare ~g:Int.compare
  end

  include T
  include Tablecloth.Comparator.Make (T)
end

let suite =
  suite "Map" (fun () ->
      describe "empty" (fun () ->
          test "has length zero" (fun () ->
              expect (Tablecloth.Map.empty (module Char) |> Map.length)
              |> toEqual Eq.int 0 ) ) ;
      describe "Poly.from_list" (fun () ->
          test "creates a map from a list" (fun () ->
              let map = Map.Poly.from_list [ (`Ant, "Ant"); (`Bat, "Bat") ] in
              expect (Map.get map `Ant)
              |> toEqual
                   (let open Eq in
                   option string)
                   (Some "Ant") ) ) ;
      describe "Int.from_list" (fun () ->
          test "creates a map from a list" (fun () ->
              let map = Map.Int.from_list [ (1, "Ant"); (2, "Bat") ] in
              expect (Map.get map 1)
              |> toEqual
                   (let open Eq in
                   option string)
                   (Some "Ant") ) ) ;
      describe "String.from_list" (fun () ->
          test "creates a map from a list" (fun () ->
              let map = Map.String.from_list [ ("Ant", 1); ("Bat", 1) ] in
              expect (Map.get map "Ant")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 1) ) ) )
