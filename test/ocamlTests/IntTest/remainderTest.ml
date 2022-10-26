test "remainder(-4,3)" (fun () -> expect (Int.remainder -4 3) |> toEqual Eq.int -1) ; 
test "remainder(-2,3)" (fun () -> expect (Int.remainder -2 3) |> toEqual Eq.int -2) ; 
test "remainder(-1,3)" (fun () -> expect (Int.remainder -1 3) |> toEqual Eq.int -1) ; 
test "remainder(0,3)" (fun () -> expect (Int.remainder 0 3) |> toEqual Eq.int 0) ; 
test "remainder(1,3)" (fun () -> expect (Int.remainder 1 3) |> toEqual Eq.int 1) ; 
test "remainder(2,3)" (fun () -> expect (Int.remainder 2 3) |> toEqual Eq.int 2) ; 
test "remainder(3,3)" (fun () -> expect (Int.remainder 3 3) |> toEqual Eq.int 0) ; 
test "remainder(4,3)" (fun () -> expect (Int.remainder 4 3) |> toEqual Eq.int 1) ; 
