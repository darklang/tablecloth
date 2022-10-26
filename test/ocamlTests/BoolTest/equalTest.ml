test "equal(true,true)" (fun () -> expect (Bool.equal true true) |> toEqual Eq.bool true) ; 
test "equal(false,false)" (fun () -> expect (Bool.equal false false) |> toEqual Eq.bool true) ; 
test "equal(true,false)" (fun () -> expect (Bool.equal true false) |> toEqual Eq.bool false) ; 
