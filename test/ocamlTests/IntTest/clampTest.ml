test "clamp(5,0,8)" (fun () -> expect (clamp 5 0 8) |> toEqual Eq.int 5) ; 
test "clamp(9,0,8)" (fun () -> expect (clamp 9 0 8) |> toEqual Eq.int 8) ; 
test "clamp(1,2,8)" (fun () -> expect (clamp 1 2 8) |> toEqual Eq.int 2) ; 
test "clamp(5,-10,-5)" (fun () -> expect (clamp 5 -10 -5) |> toEqual Eq.int -5) ; 
test "clamp(-15,-10,-5)" (fun () -> expect (clamp -15 -10 -5) |> toEqual Eq.int -10) ; 
test "clamp(3,-10,-5)" (fun () -> expect (fun () -> clamp 3 -10 -5) |> toThrow); 
