test ("absolute(8)", () => expect(absolute(8)) |> toEqual(Eq.int, 8)) 
test ("absolute(-7)", () => expect(absolute(-7)) |> toEqual(Eq.int, 7)) 
test ("absolute(0)", () => expect(absolute(0)) |> toEqual(Eq.int, 0)) 
