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

      describe "error" (fun () ->
          test "returns error type" (fun () ->
              expect (Int.negate 3 |> Result.error)
              |> toEqual
                   (let open Eq in
                   result string int)
                   (Error (-3)) ) ;
          test "returns error type" (fun () ->
              expect (List.map [ 1; 2; 3 ] ~f:Result.error)
              |> toEqual
                   (let open Eq in
                   list (result string int))
                   [ Error 1; Error 2; Error 3 ] ) ) ;

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
                   (Ok 10) ) ) ;

      describe "isOk" (fun () ->
          test "returns true if result is Ok" (fun () ->
              expect (Result.isOk (Ok 3)) |> toEqual Eq.bool true ) ;
          test "returns false if result is Error" (fun () ->
              expect (Result.isOk (Error 3)) |> toEqual Eq.bool false ) ) ;

      describe "isError" (fun () ->
          test "returns false if result is Ok" (fun () ->
              expect (Result.isError (Ok 3)) |> toEqual Eq.bool false ) ;
          test "returns true if result is Error" (fun () ->
              expect (Result.isError (Error 3)) |> toEqual Eq.bool true ) ) ;

      describe "and_" (fun () ->
          test "returns second arg if both are Ok" (fun () ->
              expect (Result.and_ (Ok "Antelope") (Ok "Salmon"))
              |> toEqual
                   (let open Eq in
                   result string string)
                   (Ok "Salmon") ) ;
          test "returns first error arg" (fun () ->
              expect (Result.and_ (Error "Finch") (Ok "Salmon"))
              |> toEqual
                   (let open Eq in
                   result string string)
                   (Error "Finch") ) ;

          test "returns first error arg" (fun () ->
              expect (Result.and_ (Ok "Antelope") (Error "Finch"))
              |> toEqual
                   (let open Eq in
                   result string string)
                   (Error "Finch") ) ;

          test "returns first error arg" (fun () ->
              expect (Result.and_ (Error "Honey bee") (Error "Finch"))
              |> toEqual
                   (let open Eq in
                   result string string)
                   (Error "Honey bee") ) ) ;

      describe "or_" (fun () ->
          test "returns first arg if both are Ok" (fun () ->
              expect (Result.or_ (Ok "Boar") (Ok "Gecko"))
              |> toEqual
                   (let open Eq in
                   result string string)
                   (Ok "Boar") ) ;
          test "returns ok arg" (fun () ->
              expect (Result.or_ (Error "Periwinkle") (Ok "Gecko"))
              |> toEqual
                   (let open Eq in
                   result string string)
                   (Ok "Gecko") ) ;

          test "returns ok arg" (fun () ->
              expect (Result.or_ (Ok "Boar") (Error "Periwinkle"))
              |> toEqual
                   (let open Eq in
                   result string string)
                   (Ok "Boar") ) ;

          test "returns second arg" (fun () ->
              expect (Result.or_ (Error "Periwinkle") (Error "Robin"))
              |> toEqual
                   (let open Eq in
                   result string string)
                   (Error "Robin") ) ) )
