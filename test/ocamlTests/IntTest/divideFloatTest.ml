test "divideFloat(3,2)" (fun () -> expect (divideFloat 3 2) |> toEqual Eq.Int 1.5) ; 
test "divideFloat(27,5)" (fun () -> expect (divideFloat 27 5) |> toEqual Eq.Int 5.4) ; 
test "divideFloat(8,4)" (fun () -> expect (divideFloat 8 4) |> toEqual Eq.Int 2) ; 
test "divideFloat(8,0)" (fun () -> expect (divideFloat 8 0) |> toEqual Eq.Int Float.infinity) ; 
test "divideFloat(-8,0)" (fun () -> expect (divideFloat -8 0) |> toEqual Eq.Int Float.negativeInfinity) ; 
