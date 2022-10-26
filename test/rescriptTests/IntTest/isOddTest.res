test ("isOdd(8)", () => expect(Int.isOdd(8)) |> toEqual(Eq.bool, false)) 
test ("isOdd(9)", () => expect(Int.isOdd(9)) |> toEqual(Eq.bool, true)) 
test ("isOdd(0)", () => expect(Int.isOdd(0)) |> toEqual(Eq.bool, false)) 
