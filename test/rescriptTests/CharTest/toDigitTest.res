test ("toDigit('0')", () => expect(Char.toDigit('0')) |> toEqual({open Eq
option(int)}, Some(0))) 
test ("toDigit('8')", () => expect(Char.toDigit('8')) |> toEqual({open Eq
option(int)}, Some(8))) 
test ("toDigit('a')", () => expect(Char.toDigit('a')) |> toEqual({open Eq
option(int)}, None)) 
