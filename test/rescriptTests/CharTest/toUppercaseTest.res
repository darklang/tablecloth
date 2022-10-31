test ("toUppercase('a')", () => expect(Char.toUppercase('a')) |> toEqual(Eq.char, 'A')) 
test ("toUppercase('A')", () => expect(Char.toUppercase('A')) |> toEqual(Eq.char, 'A')) 
test ("toUppercase('7')", () => expect(Char.toUppercase('7')) |> toEqual(Eq.char, '7')) 
test ("toUppercase('\233')", () => expect(Char.toUppercase('\233')) |> toEqual(Eq.char, '\233')) 
