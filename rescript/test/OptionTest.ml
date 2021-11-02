open Tablecloth
open AlcoJest

let suite =
  suite "Option" (fun () ->
      describe "unwrapUnsafe" (fun () ->
          test "returns the wrapped value for a Some" (fun () ->
              expect (Option.unwrapUnsafe (Some 1)) |> toEqual Eq.int 1 ) ;
          test "raises for a None" (fun () ->
              expect (fun () -> ignore (Option.unwrapUnsafe None))
              |> toRaise
                   (Invalid_argument "Option.unwrapUnsafe called with None") ) ) ;
      describe "and_" (fun () ->
          test "returns second argument" (fun () ->
              expect (Option.and_ (Some 1) (Some 15))
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 15) ) ;

          test "returns none" (fun () ->
              expect (Option.and_ None (Some 15))
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;

          test "returns none" (fun () ->
              expect (Option.and_ (Some 1) None)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;

          test "returns none" (fun () ->
              expect (Option.and_ None None)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "or_" (fun () ->
          test "returns first argument" (fun () ->
              expect (Option.or_ (Some 1) (Some 15))
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 1) ) ;

          test "returns second argument some" (fun () ->
              expect (Option.or_ None (Some 15))
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 15) ) ;

          test "returns first argument some" (fun () ->
              expect (Option.or_ (Some 1) None)
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 1) ) ;

          test "returns none" (fun () ->
              expect (Option.or_ None None)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "orElse" (fun () ->
          test "returns second argument" (fun () ->
              expect (Option.orElse (Some 1) (Some 15))
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 15) ) ;

          test "returns second argument" (fun () ->
              expect (Option.orElse None (Some 15))
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 15) ) ;

          test "returns first argument some" (fun () ->
              expect (Option.orElse (Some 1) None)
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 1) ) ;

          test "returns none" (fun () ->
              expect (Option.orElse None None)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) )
