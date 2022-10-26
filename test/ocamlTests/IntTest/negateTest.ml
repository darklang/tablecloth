test "negate(8)" (fun () -> expect (Int.negate 8) |> toEqual Eq.int -8) ; 
test "negate(-7)" (fun () -> expect (Int.negate -7) |> toEqual Eq.int 7) ; 
test "negate(0)" (fun () -> expect (Int.negate 0) |> toEqual Eq.int 0) ; 
