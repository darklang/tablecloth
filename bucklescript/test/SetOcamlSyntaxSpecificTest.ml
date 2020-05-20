open Tablecloth
open AlcoJest

let suite =
  suite "Set - OCaml Syntax" (fun () ->
      describe ".?[]" (fun () ->
          let animals = Set.String.fromList [ "Bear"; "Wolf" ] in
          test
            "custom index operators can be used in the ocaml syntax"
            (fun () -> expect animals.Set.?{"Bear"} |> toEqual Eq.(bool) true)))
