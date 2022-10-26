test "divideFloat(3,2)" (fun () -> expect (Int.divideFloat 3 2) |> toEqual Eq.float 1.5) ; 
test "divideFloat(27,5)" (fun () -> expect (Int.divideFloat 27 5) |> toEqual Eq.float 5.4) ; 
test "divideFloat(8,4)" (fun () -> expect (Int.divideFloat 8 4) |> toEqual Eq.float 2) ; 
test "divideFloat(8,0)" (fun () -> expect (Int.divideFloat 8 0) |> toEqual Eq.float Float.infinity) ; 
test "divideFloat(-8,0)" (fun () -> expect (Int.divideFloat -8 0) |> toEqual Eq.float Float.negativeInfinity) ; 
