open Tablecloth
open AlcoJest

let suite =
  suite "String - OCaml Syntax" (fun () ->
      let animal = "Salmon" in
      describe ".[]" (fun () ->
          test
            "regular string syntax is the equivalent to String.get"
            (fun () -> expect animal.[0] |> toEqual Eq.char 'S') ) ;
      describe ".?[]" (fun () ->
          let open String in
          test "in bounds index returns Some" (fun () ->
              expect animal.?[1] |> toEqual Eq.(option char) (Some 'a') ) ;
          test "out of bounds index returns None" (fun () ->
              expect animal.?[9] |> toEqual Eq.(option char) None ) ) )
