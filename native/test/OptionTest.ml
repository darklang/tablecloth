open Tablecloth
open AlcoJest

let suite =
  suite "Option" (fun () ->
      describe "unwrap_unsafe" (fun () ->
          test "returns the wrapped value for a Some" (fun () ->
              expect (Option.unwrap_unsafe (Some 1)) |> toEqual Eq.int 1 ) ;
          test "raises for a None" (fun () ->
              expect (fun () -> ignore (Option.unwrap_unsafe None))
              |> toRaise
                   (Invalid_argument "Option.unwrap_unsafe called with None") ) ) )
