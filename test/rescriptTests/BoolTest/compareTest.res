test ("compare(true,true)", () => expect(Bool.compare(true,true)) |> toEqual(Eq.int, 0)) 
test ("compare(true,false)", () => expect(Bool.compare(true,false)) |> toEqual(Eq.int, 1)) 
test ("compare(false,true)", () => expect(Bool.compare(false,true)) |> toEqual(Eq.int, -1)) 
test ("compare(false,false)", () => expect(Bool.compare(false,false)) |> toEqual(Eq.int, 0)) 
