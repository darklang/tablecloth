test ("fromInt(0)", () => expect(Bool.fromInt(0)) |> toEqual({open Eq
option(bool)}, Some(false))) 
test ("fromInt(1)", () => expect(Bool.fromInt(1)) |> toEqual({open Eq
option(bool)}, Some(true))) 
test ("fromInt(Int.minimumValue)", () => expect(Bool.fromInt(Int.minimumValue)) |> toEqual({open Eq
option(bool)}, None)) 
test ("fromInt(-2)", () => expect(Bool.fromInt(-2)) |> toEqual({open Eq
option(bool)}, None)) 
test ("fromInt(-1)", () => expect(Bool.fromInt(-1)) |> toEqual({open Eq
option(bool)}, None)) 
test ("fromInt(2)", () => expect(Bool.fromInt(2)) |> toEqual({open Eq
option(bool)}, None)) 
test ("fromInt(Int.maximumValue)", () => expect(Bool.fromInt(Int.maximumValue)) |> toEqual({open Eq
option(bool)}, None)) 
