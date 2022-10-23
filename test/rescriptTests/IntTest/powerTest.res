test ("power(7,3)", () => expect(power(7,3)) |> toEqual(Eq.int, 343)) 
test ("power(0,3)", () => expect(power(0,3)) |> toEqual(Eq.int, 0)) 
test ("power(7,0)", () => expect(power(7,0)) |> toEqual(Eq.int, 1)) 
