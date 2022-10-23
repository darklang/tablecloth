test "divideFloat(3,2)" (fun () -> expect (divideFloat 3 2) |> toEqual Eq.int 1.5) ; 
test "divideFloat(27,5)" (fun () -> expect (divideFloat 27 5) |> toEqual Eq.int 5.4) ; 
test "divideFloat(8,4)" (fun () -> expect (divideFloat 8 4) |> toEqual Eq.int 2) ; 
test "divideFloat(8,0)" (fun () -> expect (divideFloat 8 0) |> toEqual Eq.int Float.infinity) ; 
test "divideFloat(-8,0)" (fun () -> expect (divideFloat -8 0) |> toEqual Eq.int Float.negativeInfinity) ; 
