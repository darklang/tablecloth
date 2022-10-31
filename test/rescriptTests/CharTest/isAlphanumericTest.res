test ("isAlphanumeric('A')", () => expect(Char.isAlphanumeric('A')) |> toEqual(Eq.bool, true)) 
test ("isAlphanumeric('?')", () => expect(Char.isAlphanumeric('?')) |> toEqual(Eq.bool, false)) 

