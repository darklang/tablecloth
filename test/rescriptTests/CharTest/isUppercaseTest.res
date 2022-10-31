test ("isUppercase('A')", () => expect(Char.isUppercase('A')) |> toEqual(Eq.bool, true)) 
test ("isUppercase('7')", () => expect(Char.isUppercase('7')) |> toEqual(Eq.bool, false)) 
test ("isUppercase('\237')", () => expect(Char.isUppercase('\237')) |> toEqual(Eq.bool, false)) 
