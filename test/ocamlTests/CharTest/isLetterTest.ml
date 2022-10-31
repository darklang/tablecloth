test "isLetter('A')" (fun () -> expect (Char.isLetter 'A') |> toEqual Eq.bool true) ; 
test "isLetter('7')" (fun () -> expect (Char.isLetter '7') |> toEqual Eq.bool false) ; 
test "isLetter(' ')" (fun () -> expect (Char.isLetter ' ') |> toEqual Eq.bool false) ; 
test "isLetter('\n')" (fun () -> expect (Char.isLetter '\n') |> toEqual Eq.bool false) ; 
test "isLetter('\001')" (fun () -> expect (Char.isLetter '\001') |> toEqual Eq.bool false) ; 
test "isLetter('\236')" (fun () -> expect (Char.isLetter '\236') |> toEqual Eq.bool false) ; 
