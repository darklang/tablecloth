test "toUppercase('a')" (fun () -> expect (Char.toUppercase 'a') |> toEqual Eq.char 'A') ; 
test "toUppercase('A')" (fun () -> expect (Char.toUppercase 'A') |> toEqual Eq.char 'A') ; 
test "toUppercase('7')" (fun () -> expect (Char.toUppercase '7') |> toEqual Eq.char '7') ; 
test "toUppercase('\233')" (fun () -> expect (Char.toUppercase '\233') |> toEqual Eq.char '\233') ; 
