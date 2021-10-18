open Tablecloth
open AlcoJest

let suite =
  suite "Bool" (fun () ->
      let open Bool in
      describe "fromInt" (fun () ->
          test "converts zero to Some(false)" (fun () ->
              expect (fromInt 0)
              |> toEqual
                   (let open Eq in
                   option bool)
                   (Some false) ) ;
          test "converts one to Some(true)" (fun () ->
              expect (fromInt 1)
              |> toEqual
                   (let open Eq in
                   option bool)
                   (Some true) ) ;
          testAll
            "converts everything else to None"
            [ Int.minimumValue; -2; -1; 2; Int.maximumValue ]
            (fun int ->
              expect (fromInt int)
              |> toEqual
                   (let open Eq in
                   option bool)
                   None ) ) ;
      describe "fromString" (fun () ->
          test "converts string to Some(true)" (fun () ->
              expect (fromString "true")
              |> toEqual
                   (let open Eq in
                   option bool)
                   (Some true) ) ;
          test "converts string to Some(true)" (fun () ->
              expect (fromString "false")
              |> toEqual
                   (let open Eq in
                   option bool)
                   (Some false) ) ;
          test "converts string to Some(true)" (fun () ->
              expect (fromString "True")
              |> toEqual
                   (let open Eq in
                   option bool)
                   None ) ;
          test "converts string to Some(true)" (fun () ->
              expect (fromString "1")
              |> toEqual
                   (let open Eq in
                   option bool)
                   None ) ) )
