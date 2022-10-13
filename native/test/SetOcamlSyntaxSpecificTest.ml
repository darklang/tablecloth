open Tablecloth
open AlcoJest

let suite =
  suite "Set - OCaml Syntax" (fun () ->
      describe ".?{}" (fun () ->
          let animals = Set.String.from_list [ "Bear"; "Wolf" ] in
          test
            "custom index operators can be used in the ocaml syntax"
            (fun () ->
              let open Set in
              expect animals.?{"Bear"} |> toEqual Eq.(bool) true ) ) )
