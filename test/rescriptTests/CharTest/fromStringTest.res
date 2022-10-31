test ("fromString(a)", () => expect(Char.fromString("a")) |> toEqual({open Eq
option(char)}, Some('a'))) 
test ("fromString(abc)", () => expect(Char.fromString("abc")) |> toEqual({open Eq
option(char)}, None)) 
test ("fromString()", () => expect(Char.fromString("")) |> toEqual({open Eq
option(char)}, None)) 
