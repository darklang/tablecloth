test "fromString("true")" (fun () -> expect (Bool.fromString "true") |> toEqual (let open Eq in option bool) Some(true)) ; 
test "fromString("false")" (fun () -> expect (Bool.fromString "false") |> toEqual (let open Eq in option bool) Some(false)) ; 
test "fromString("True")" (fun () -> expect (Bool.fromString "True") |> toEqual (let open Eq in option bool) None) ; 
test "fromString("1")" (fun () -> expect (Bool.fromString "1") |> toEqual (let open Eq in option bool) None) ; 
