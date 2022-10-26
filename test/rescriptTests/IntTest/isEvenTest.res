test ("isEven(8)", () => expect(Int.isEven(8)) |> toEqual(Eq.bool, true)) 
test ("isEven(9)", () => expect(Int.isEven(9)) |> toEqual(Eq.bool, false)) 
test ("isEven(0)", () => expect(Int.isEven(0)) |> toEqual(Eq.bool, true)) 
