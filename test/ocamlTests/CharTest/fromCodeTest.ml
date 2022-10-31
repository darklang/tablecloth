test "fromCode(97)" (fun () -> expect (Char.fromCode 97) |> toEqual (let open Eq in option char) Some('a')) ; 
test "fromCode(-1)" (fun () -> expect (Char.fromCode -1) |> toEqual (let open Eq in option char) None) ; 
test "fromCode(256)" (fun () -> expect (Char.fromCode 256) |> toEqual (let open Eq in option char) None) ; 
