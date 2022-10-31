test "toDigit('0')" (fun () -> expect (Char.toDigit '0') |> toEqual (let open Eq in option int) Some(0)) ; 
test "toDigit('8')" (fun () -> expect (Char.toDigit '8') |> toEqual (let open Eq in option int) Some(8)) ; 
test "toDigit('a')" (fun () -> expect (Char.toDigit 'a') |> toEqual (let open Eq in option int) None) ; 
