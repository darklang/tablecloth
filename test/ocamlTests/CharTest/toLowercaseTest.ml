test "toLowercase('A')" (fun () -> expect (Char.toLowercase 'A') |> toEqual Eq.char 'a') ; 
test "toLowercase('a')" (fun () -> expect (Char.toLowercase 'a') |> toEqual Eq.char 'a') ; 
test "toLowercase('7')" (fun () -> expect (Char.toLowercase '7') |> toEqual Eq.char '7') ; 
test "toLowercase('\233')" (fun () -> expect (Char.toLowercase '\233') |> toEqual Eq.char '\233') ; 
