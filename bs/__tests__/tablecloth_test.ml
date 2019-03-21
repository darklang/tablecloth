open Tablecloth
open Jest
open Expect

let () =
  describe "String" (fun () ->
    test "length" (fun () -> expect (String.length "123") |> toEqual 3);
    test "reverse" (fun () -> expect (String.reverse "stressed") |> toEqual "desserts");
  );

  ()
