test "inRange(3,2,4)" (fun () -> expect (Int.inRange 3 2 4) |> toEqual Eq.bool true) ; 
test "inRange(8,2,4)" (fun () -> expect (Int.inRange 8 2 4) |> toEqual Eq.bool false) ; 
test "inRange(1,2,4)" (fun () -> expect (Int.inRange 1 2 4) |> toEqual Eq.bool false) ; 
test "inRange(2,1,2)" (fun () -> expect (Int.inRange 2 1 2) |> toEqual Eq.bool false) ; 
test "inRange(-6,-7,-5)" (fun () -> expect (Int.inRange -6 -7 -5) |> toEqual Eq.bool true) ; 
test "inRange(3,7,1)" (fun () -> expect (fun () -> inRange 3 7 1) |> toThrow); 
