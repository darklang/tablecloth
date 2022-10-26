test ("add(1,2)", () => expect(Int.add(1,2)) |> toEqual(Eq.int, 3)) 
test ("add(1,1)", () => expect(Int.add(1,1)) |> toEqual(Eq.int, 2)) 
