test ("clamp(5,0,8)", () => expect(5,0,8) |> toEqual(5)) 
test ("clamp(9,0,8)", () => expect(9,0,8) |> toEqual(8)) 
test ("clamp(1,2,8)", () => expect(1,2,8) |> toEqual(2)) 
test ("clamp(5,-10,-5)", () => expect(5,-10,-5) |> toEqual(-5)) 
test ("clamp(-15,-10,-5)", () => expect(-15,-10,-5) |> toEqual(-10)) 
test ("clamp(3,-10,-5)", () => expect(3,-10,-5) |> toEqual(exception)) 