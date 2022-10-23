test ("divide(3,2)", () => expect(divide(3,2)) |> toEqual(Eq.int, 1)) 
test ("divide(3,0)", () => expect(() => divide(3,0)) |> toThrow) 
test ("divide(27,5)", () => expect(divide(27,5)) |> toEqual(Eq.int, 5)) 
