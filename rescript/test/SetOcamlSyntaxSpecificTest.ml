open Tablecloth
open AlcoJest

let suite =
  suite "Set - OCaml Syntax" (fun () ->
      describe ".?{}" (fun () ->
          let animals = Set.String.fromList [ "Bear"; "Wolf" ] in
          test
            "custom index operators can be used in the ocaml syntax"
            (fun () ->
              let open Set.String in
              expect animals.?{"Bear"} |> toEqual Eq.bool true ) ;
          let numbers = Set.Int.fromList [ 1; 2 ] in
          test
            "custom index operators can be used in the ocaml syntax"
            (fun () ->
              let open Set.Int in
              expect numbers.?{2} |> toEqual Eq.bool true ) ) )