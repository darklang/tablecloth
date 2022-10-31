test ("isLowercase('a')", () => expect(Char.isLowercase('a')) |> toEqual(Eq.bool, true)) 
test ("isLowercase('7')", () => expect(Char.isLowercase('7')) |> toEqual(Eq.bool, false)) 
test ("isLowercase('\236')", () => expect(Char.isLowercase('\236')) |> toEqual(Eq.bool, false)) 
