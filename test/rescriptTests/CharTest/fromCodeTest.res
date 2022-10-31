test ("fromCode(97)", () => expect(Char.fromCode(97)) |> toEqual({open Eq
option(char)}, Some('a'))) 
test ("fromCode(-1)", () => expect(Char.fromCode(-1)) |> toEqual({open Eq
option(char)}, None)) 
test ("fromCode(256)", () => expect(Char.fromCode(256)) |> toEqual({open Eq
option(char)}, None)) 
