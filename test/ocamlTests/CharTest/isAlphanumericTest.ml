test "isAlphanumeric('A')" (fun () -> expect (Char.isAlphanumeric 'A') |> toEqual Eq.bool true) ; 
test "isAlphanumeric('?')" (fun () -> expect (Char.isAlphanumeric '?') |> toEqual Eq.bool false) ; 
