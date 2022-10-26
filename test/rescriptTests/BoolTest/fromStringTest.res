test ("fromString(true)", () => expect(Bool.fromString("true")) |> toEqual({open Eq
option(bool)}, Some(true))) 
test ("fromString(false)", () => expect(Bool.fromString("false")) |> toEqual({open Eq
option(bool)}, Some(false))) 
test ("fromString(True)", () => expect(Bool.fromString("True")) |> toEqual({open Eq
option(bool)}, None)) 
test ("fromString(1)", () => expect(Bool.fromString("1")) |> toEqual({open Eq
option(bool)}, None)) 
