open Tablecloth
open AlcoJest

let suite =
  suite "Result" (fun () ->
      let open Result in
      describe "ok" (fun () ->
          test "returns ok type" (fun () ->
              expect (String.reverse "desserts" |> Result.ok)
              |> toEqual
                   (let open Eq in
                   result string string)
                   (Ok "stressed") ) ;
          test "returns ok type" (fun () ->
              expect (List.map [ 1; 2; 3 ] ~f:Result.ok)
              |> toEqual
                   (let open Eq in
                    list (result int string))
                   [ Ok 1; Ok 2; Ok 3 ] ) ) ;
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
