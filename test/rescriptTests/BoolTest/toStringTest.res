test ("toString(true)", () => expect(Bool.toString(true)) |> toEqual(Eq.string, true)) 
test ("toString(false)", () => expect(Bool.toString(false)) |> toEqual(Eq.string, false)) 
