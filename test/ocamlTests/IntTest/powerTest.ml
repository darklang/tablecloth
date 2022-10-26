test "power(7,3)" (fun () -> expect (Int.power 7 3) |> toEqual Eq.int 343) ; 
test "power(0,3)" (fun () -> expect (Int.power 0 3) |> toEqual Eq.int 0) ; 
test "power(7,0)" (fun () -> expect (Int.power 7 0) |> toEqual Eq.int 1) ; 
