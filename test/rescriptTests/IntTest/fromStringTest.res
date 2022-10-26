test ("fromString(0)", () => expect(Int.fromString("0")) |> toEqual({open Eq
option(int)}, Some(0))) 
test ("fromString(-0)", () => expect(Int.fromString("-0")) |> toEqual({open Eq
option(int)}, Some(-0))) 
test ("fromString(42)", () => expect(Int.fromString("42")) |> toEqual({open Eq
option(int)}, Some(42))) 
test ("fromString(123_456)", () => expect(Int.fromString("123_456")) |> toEqual({open Eq
option(int)}, Some(123_456))) 
test ("fromString(-42)", () => expect(Int.fromString("-42")) |> toEqual({open Eq
option(int)}, Some(-42))) 
test ("fromString(0XFF)", () => expect(Int.fromString("0XFF")) |> toEqual({open Eq
option(int)}, Some(255))) 
test ("fromString(0X000A)", () => expect(Int.fromString("0X000A")) |> toEqual({open Eq
option(int)}, Some(10))) 
test ("fromString(Infinity)", () => expect(Int.fromString("Infinity")) |> toEqual({open Eq
option(int)}, None)) 
test ("fromString(-Infinity)", () => expect(Int.fromString("-Infinity")) |> toEqual({open Eq
option(int)}, None)) 
test ("fromString(NaN)", () => expect(Int.fromString("NaN")) |> toEqual({open Eq
option(int)}, None)) 
test ("fromString(abc)", () => expect(Int.fromString("abc")) |> toEqual({open Eq
option(int)}, None)) 
test ("fromString(--4)", () => expect(Int.fromString("--4")) |> toEqual({open Eq
option(int)}, None)) 
test ("fromString( )", () => expect(Int.fromString(" ")) |> toEqual({open Eq
option(int)}, None)) 
