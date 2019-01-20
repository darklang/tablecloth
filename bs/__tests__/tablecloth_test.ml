open Tablecloth
open Jest
open Expect

let () =
  describe "string" (fun () ->
      test "length works" (fun () -> expect (String.length "123") |> toEqual 3)
  ) ;
  ()
