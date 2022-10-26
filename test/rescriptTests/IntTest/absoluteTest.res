test ("absolute(8)", () => expect(Int.absolute(8)) |> toEqual(Eq.int, 8)) 
test ("absolute(-7)", () => expect(Int.absolute(-7)) |> toEqual(Eq.int, 7)) 
test ("absolute(0)", () => expect(Int.absolute(0)) |> toEqual(Eq.int, 0)) 
