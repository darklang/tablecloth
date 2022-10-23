test "clamp(5,0,8)" (fun () -> expect (clamp 5 0 8) |> toEqual Eq.Int 5) ; 
test "clamp(9,0,8)" (fun () -> expect (clamp 9 0 8) |> toEqual Eq.Int 8) ; 
test "clamp(1,2,8)" (fun () -> expect (clamp 1 2 8) |> toEqual Eq.Int 2) ; 
test "clamp(5,-10,-5)" (fun () -> expect (clamp 5 -10 -5) |> toEqual Eq.Int -5) ; 
test "clamp(-15,-10,-5)" (fun () -> expect (clamp -15 -10 -5) |> toEqual Eq.Int -10) ; 
test "clamp(3,-10,-5)" (fun () -> expect (clamp 3 -10 -5) |> toEqual Eq.Int exception) ; 
