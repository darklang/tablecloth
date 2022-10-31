test ("isPrintable('~')", () => expect(Char.isPrintable('~')) |> toEqual(Eq.bool, true)) 
test ("isPrintable(fromCode(31) |> Option.map(~f=isPrintable))", () => expect(Char.isPrintable(fromCode(31) |> Option.map(~f=isPrintable))) |> toEqual({open Eq
bool()}, Some(false))) 
