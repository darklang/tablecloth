test "toString(true)" (fun () -> expect (Bool.toString true) |> toEqual Eq.string true) ; 
test "toString(false)" (fun () -> expect (Bool.toString false) |> toEqual Eq.string false) ; 
