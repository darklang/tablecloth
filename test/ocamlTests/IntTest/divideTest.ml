test "divide(3,2)" (fun () -> expect (Int.divide 3 2) |> toEqual Eq.int 1) ; 
test "divide(3,0)" (fun () -> expect (fun () -> divide 3 0) |> toThrow); 
test "divide(27,5)" (fun () -> expect (Int.divide 27 5) |> toEqual Eq.int 5) ; 
