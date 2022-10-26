test "maximum(8,18)" (fun () -> expect (Int.maximum 8 18) |> toEqual Eq.int 18) ; 
test "maximum(5,0)" (fun () -> expect (Int.maximum 5 0) |> toEqual Eq.int 5) ; 
test "maximum(-4,-1)" (fun () -> expect (Int.maximum -4 -1) |> toEqual Eq.int -1) ; 
