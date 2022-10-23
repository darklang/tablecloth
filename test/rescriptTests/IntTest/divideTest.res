test ("divide(3,2)", () => expect(3,2) |> toEqual(1)) 
test ("divide(3,0)", () => expect(3,0) |> toEqual(exception)) 
test ("divide(27,5)", () => expect(27,5) |> toEqual(5)) 
