test "divide(3,2)" (fun () -> expect (divide 3 2) |> toEqual Eq.Int 1) ; 
test "divide(3,0)" (fun () -> expect (divide 3 0) |> toEqual Eq.Int exception) ; 
test "divide(27,5)" (fun () -> expect (divide 27 5) |> toEqual Eq.Int 5) ; 
