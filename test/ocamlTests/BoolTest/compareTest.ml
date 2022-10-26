test "compare(true,true)" (fun () -> expect (Bool.compare true true) |> toEqual Eq.int 0) ; 
test "compare(true,false)" (fun () -> expect (Bool.compare true false) |> toEqual Eq.int 1) ; 
test "compare(false,true)" (fun () -> expect (Bool.compare false true) |> toEqual Eq.int -1) ; 
test "compare(false,false)" (fun () -> expect (Bool.compare false false) |> toEqual Eq.int 0) ; 
