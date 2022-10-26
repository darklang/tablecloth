test ("minimum(8,18)", () => expect(Int.minimum(8,18)) |> toEqual(Eq.int, 8)) 
test ("minimum(5,0)", () => expect(Int.minimum(5,0)) |> toEqual(Eq.int, 0)) 
test ("minimum(-4,-1)", () => expect(Int.minimum(-4,-1)) |> toEqual(Eq.int, -4)) 
