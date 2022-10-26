test ("equal(true,true)", () => expect(Bool.equal(true,true)) |> toEqual(Eq.bool, true)) 
test ("equal(false,false)", () => expect(Bool.equal(false,false)) |> toEqual(Eq.bool, true)) 
test ("equal(true,false)", () => expect(Bool.equal(true,false)) |> toEqual(Eq.bool, false)) 
