test ("toFloat(5)", () => expect(Int.toFloat(5)) |> toEqual(Eq.float, 5)) 
test ("toFloat(0)", () => expect(Int.toFloat(0)) |> toEqual(Eq.float, 0)) 
test ("toFloat(-7)", () => expect(Int.toFloat(-7)) |> toEqual(Eq.float, -7)) 
