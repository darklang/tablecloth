test ("compare(true,true)", () => expect(Bool.compare(true,true)) |> toEqual(Eq.int, 0)) 
test ("compare(true,false)", () => expect(Bool.compare(true,false)) |> toEqual(Eq.int, 1)) 
test ("compare(false,true)", () => expect(Bool.compare(false,true)) |> toEqual(Eq.int, -1)) 
test ("compare(false,false)", () => expect(Bool.compare(false,false)) |> toEqual(Eq.int, 0)) 
test ("equal(true,true)", () => expect(Bool.equal(true,true)) |> toEqual(Eq.bool, true)) 
test ("equal(false,false)", () => expect(Bool.equal(false,false)) |> toEqual(Eq.bool, true)) 
test ("equal(true,false)", () => expect(Bool.equal(true,false)) |> toEqual(Eq.bool, false)) 
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
test ("fromString(true)", () => expect(Bool.fromString("true")) |> toEqual({open Eq
option(bool)}, Some(true))) 
test ("fromString(false)", () => expect(Bool.fromString("false")) |> toEqual({open Eq
option(bool)}, Some(false))) 
test ("fromString(True)", () => expect(Bool.fromString("True")) |> toEqual({open Eq
option(bool)}, None)) 
test ("fromString(1)", () => expect(Bool.fromString("1")) |> toEqual({open Eq
option(bool)}, None)) 
test ("toInt(true)", () => expect(Bool.toInt(true)) |> toEqual(Eq.int, 1)) 
test ("toInt(false)", () => expect(Bool.toInt(false)) |> toEqual(Eq.int, 0)) 
test ("toString(true)", () => expect(Bool.toString(true)) |> toEqual(Eq.string, "true")) 
test ("toString(false)", () => expect(Bool.toString(false)) |> toEqual(Eq.string, "false")) 
test ("xor(true,true)", () => expect(Bool.xor(true,true)) |> toEqual(Eq.bool, false)) 
test ("xor(true,false)", () => expect(Bool.xor(true,false)) |> toEqual(Eq.bool, true)) 
test ("xor(false,true)", () => expect(Bool.xor(false,true)) |> toEqual(Eq.bool, true)) 
test ("xor(false,false)", () => expect(Bool.xor(false,false)) |> toEqual(Eq.bool, false)) 
