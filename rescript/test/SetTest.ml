open Tablecloth
open AlcoJest

module Coordinate = struct
  include Coordinate

  include Comparator.Make (struct
    type nonrec t = t

    let compare = compare
  end)
end

let suite =
  suite "Set" (fun () ->
      test "creates a set from a list" (fun () ->
          let set = Set.fromList [ 1; 2 ] (module Int) in
          expect (Set.includes set 1) |> toEqual Eq.bool true ) ;
      test "fromArray" (fun () ->
          let set = Set.fromArray [| (0, 0); (0, 1) |] (module Coordinate) in
          expect (Set.includes set (0, 1)) |> toEqual Eq.bool true ) ;
      test "union" (fun () ->
          let xAxis = Set.fromList [ (0, 0); (0, 1) ] (module Coordinate) in
          let yAxis = Set.fromList [ (0, 0); (1, 0) ] (module Coordinate) in
          let union = Set.union xAxis yAxis in
          expect (union |> Set.toArray)
          |> toEqual (Eq.array Eq.coordinate) [| (0, 0); (0, 1); (1, 0) |] ) ;
      describe "Int" (fun () ->
          test "creates a set from a list" (fun () ->
              let set = Set.Int.fromList [ 1; 2 ] in
              expect (Set.includes set 1) |> toEqual Eq.bool true ) ) ;
      describe "String" (fun () ->
          test "creates a set from a list" (fun () ->
              let set = Set.String.fromList [ "Ant"; "Bat" ] in
              expect (Set.includes set "Ant") |> toEqual Eq.bool true ) ) )
