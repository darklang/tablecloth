test ("xor(true,true)", () => expect(Bool.xor(true,true)) |> toEqual(Eq.bool, false)) 
test ("xor(true,false)", () => expect(Bool.xor(true,false)) |> toEqual(Eq.bool, true)) 
test ("xor(false,true)", () => expect(Bool.xor(false,true)) |> toEqual(Eq.bool, true)) 
test ("xor(false,false)", () => expect(Bool.xor(false,false)) |> toEqual(Eq.bool, false)) 
