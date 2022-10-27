test "toString(1)" (fun () -> expect (Int.toString 1) |> toEqual Eq.string "1") ; 
test "toString(-1)" (fun () -> expect (Int.toString -1) |> toEqual Eq.string "-1") ; 
