test "power(7,3)" (fun () -> expect (power 7 3) |> toEqual Eq.Int 343) ; 
test "power(0,3)" (fun () -> expect (power 0 3) |> toEqual Eq.Int 0) ; 
test "power(7,0)" (fun () -> expect (power 7 0) |> toEqual Eq.Int 1) ; 
