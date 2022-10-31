test "fromString("a")" (fun () -> expect (Char.fromString "a") |> toEqual (let open Eq in option char) Some('a')) ; 
test "fromString("abc")" (fun () -> expect (Char.fromString "abc") |> toEqual (let open Eq in option char) None) ; 
test "fromString("")" (fun () -> expect (Char.fromString "") |> toEqual (let open Eq in option char) None) ; 
