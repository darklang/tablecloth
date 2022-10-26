test "xor(true,true)" (fun () -> expect (Bool.xor true true) |> toEqual Eq.bool false) ; 
test "xor(true,false)" (fun () -> expect (Bool.xor true false) |> toEqual Eq.bool true) ; 
test "xor(false,true)" (fun () -> expect (Bool.xor false true) |> toEqual Eq.bool true) ; 
test "xor(false,false)" (fun () -> expect (Bool.xor false false) |> toEqual Eq.bool false) ; 
