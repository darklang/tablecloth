test "maximum(8,18)" (fun () -> expect (maximum 8 18) |> toEqual Eq.Int 18) ; 
test "maximum(5,0)" (fun () -> expect (maximum 5 0) |> toEqual Eq.Int 5) ; 
test "maximum(-4,-1)" (fun () -> expect (maximum -4 -1) |> toEqual Eq.Int -1) ; 
