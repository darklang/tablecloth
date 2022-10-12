open Tablecloth
open AlcoJest

let suite =
  suite "Bool" (fun () ->
      let open Bool in
      describe "from_int" (fun () ->
          test "converts zero to Some(false)" (fun () ->
              expect (from_int 0)
              |> toEqual
                   (let open Eq in
                   option bool)
                   (Some false) ) ;
          test "converts one to Some(true)" (fun () ->
              expect (from_int 1)
              |> toEqual
                   (let open Eq in
                   option bool)
                   (Some true) ) ;
          testAll
            "converts everything else to None"
            [ Int.minimum_value; -2; -1; 2; Int.maximum_value ]
            (fun int ->
              expect (from_int int)
              |> toEqual
                   (let open Eq in
                   option bool)
                   None ) ) )
