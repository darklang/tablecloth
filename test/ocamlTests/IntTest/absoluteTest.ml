test "absolute(8)" (fun () -> expect (absolute 8) |> toEqual Eq.Int 8) ; 
test "absolute(-7)" (fun () -> expect (absolute -7) |> toEqual Eq.Int 7) ; 
test "absolute(0)" (fun () -> expect (absolute 0) |> toEqual Eq.Int 0) ; 