test "isLowercase('a')" (fun () -> expect (Char.isLowercase 'a') |> toEqual Eq.bool true) ; 
test "isLowercase('7')" (fun () -> expect (Char.isLowercase '7') |> toEqual Eq.bool false) ; 
test "isLowercase('\236')" (fun () -> expect (Char.isLowercase '\236') |> toEqual Eq.bool false) ; 
