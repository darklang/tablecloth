test ("isWhitespace(' ')", () => expect(Char.isWhitespace(' ')) |> toEqual(Eq.bool, true)) 
test ("isWhitespace('a')", () => expect(Char.isWhitespace('a')) |> toEqual(Eq.bool, false)) 
