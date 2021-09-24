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
                   (Invalid_argument "Option.unwrapUnsafe called with None") ) ) )
