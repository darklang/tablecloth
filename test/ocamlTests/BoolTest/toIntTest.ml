test "toInt(true)" (fun () -> expect (Bool.toInt true) |> toEqual Eq.int 1) ; 
test "toInt(false)" (fun () -> expect (Bool.toInt false) |> toEqual Eq.int 0) ; 
