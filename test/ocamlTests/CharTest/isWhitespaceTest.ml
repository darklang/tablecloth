test "isWhitespace(' ')" (fun () -> expect (Char.isWhitespace ' ') |> toEqual Eq.bool true) ; 
test "isWhitespace('a')" (fun () -> expect (Char.isWhitespace 'a') |> toEqual Eq.bool false) ; 
