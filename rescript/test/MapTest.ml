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
      describe "fromArray" (fun () ->
          test
            "returns map of key value pairs from array of pairs with ordered type key String"
            (fun () ->
              let fromArrayMap =
                Map.fromArray
                  (module String)
                  [| ("Cat", 4)
                   ; ("Owl", 2)
                   ; ("Fox", 5)
                   ; ("Frog", 12)
                   ; ("Camel", 2)
                  |]
              in

              let ansList = Map.toList fromArrayMap in
              expect ansList
              |> toEqual
                   (let open Eq in
                   list (pair string int))
                   [ ("Camel", 2)
                   ; ("Cat", 4)
                   ; ("Fox", 5)
                   ; ("Frog", 12)
                   ; ("Owl", 2)
                   ] ) ;
          test
            "returns empty map from empty array of key value pairs"
            (fun () ->
              let fromArrayMap = Map.fromArray (module String) [||] in
              let ansList = Map.toList fromArrayMap in
              expect ansList
              |> toEqual
                   (let open Eq in
                   list (pair string int))
                   [] ) ) ;

      describe "singleton" (fun () ->
          test "key value pair" (fun () ->
              let singletonMap =
                Map.singleton (module Int) ~key:1 ~value:"Ant"
              in
              let ans = Map.toList singletonMap in
              expect ans
              |> toEqual
                   (let open Eq in
                   list (pair int string))
                   [ (1, "Ant") ] ) ) ;

      describe "empty" (fun () ->
          test "has length zero" (fun () ->
              expect (Tablecloth.Map.empty (module Char) |> Map.length)
              |> toEqual Eq.int 0 ) ) ;
      describe "Poly.fromList" (fun () ->
          test "creates a map from a list" (fun () ->
              let map = Map.Poly.fromList [ (`Ant, "Ant"); (`Bat, "Bat") ] in
              expect (Map.get map `Ant)
              |> toEqual
                   (let open Eq in
                   option string)
                   (Some "Ant") ) ) ;
      describe "Int.fromList" (fun () ->
          test "creates a map from a list" (fun () ->
              let map = Map.Int.fromList [ (1, "Ant"); (2, "Bat") ] in
              expect (Map.get map 1)
              |> toEqual
                   (let open Eq in
                   option string)
                   (Some "Ant") ) ) ;
      describe "String.fromList" (fun () ->
          test "creates a map from a list" (fun () ->
              let map = Map.String.fromList [ ("Ant", 1); ("Bat", 1) ] in
              expect (Map.get map "Ant")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 1) ) ) )
