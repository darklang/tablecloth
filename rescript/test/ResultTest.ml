open Tablecloth
open AlcoJest

let suite =
  suite "Result" (fun () ->
      let open Result in
      describe "fromOption" (fun () ->
          test "maps None into Error" (fun () ->
              expect (fromOption ~error:"error message" None)
              |> toEqual
                   (let open Eq in
                   result int string)
                   (Error "error message") ) ;
          test "maps Some into Ok" (fun () ->
              expect (fromOption ~error:"error message" (Some 10))
              |> toEqual
                   (let open Eq in
                   result int string)
                   (Ok 10) ) ) )
