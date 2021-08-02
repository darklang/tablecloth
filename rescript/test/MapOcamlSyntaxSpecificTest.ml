open Tablecloth
open AlcoJest

let suite =
  suite "Map - OCaml Syntax" (fun () ->
      let animals = Map.String.fromList [ ("Bears", 2) ] in
      test ".?{}" (fun () ->
          expect (Map.String.( .?{} ) animals "Bears")
          |> toEqual Eq.(option int) (Some 2) ) ;

      test ".?{}<-" (fun () ->
          let open Map.String in
          let withWolves = animals.?{"Wolves"} <- 15 in
          expect (toList withWolves)
          |> toEqual
               Eq.(list (pair string int))
               [ ("Bears", 2); ("Wolves", 15) ] ) )
