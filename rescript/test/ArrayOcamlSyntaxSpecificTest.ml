open Tablecloth
open AlcoJest

let suite =
  suite "Array - OCaml Syntax" (fun () ->
      let animals = [| "Bear"; "Wolf" |] in
      describe ".()" (fun () ->
          test "regular array syntax is the equivalent to Array.get" (fun () ->
              expect animals.(0) |> toEqual Eq.string "Bear" ) ) ;
      describe ".?()" (fun () ->
          let open Array in
          test "in bounds index returns Some" (fun () ->
              expect animals.?(1) |> toEqual Eq.(option string) (Some "Wolf") ) ;
          test "out of bounds index returns None" (fun () ->
              expect animals.?(3) |> toEqual Eq.(option string) None ) ) )
