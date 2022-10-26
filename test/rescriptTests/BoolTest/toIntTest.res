test ("toInt(true)", () => expect(Bool.toInt(true)) |> toEqual(Eq.int, 1)) 
test ("toInt(false)", () => expect(Bool.toInt(false)) |> toEqual(Eq.int, 0)) 
