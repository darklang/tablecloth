open Tablecloth
open AlcoJest

let suite= suite("Int", () => {
 test ("absolute(8)", () => expect(Int.absolute(8)) |> toEqual(Eq.int, 8)) 
test ("absolute(-7)", () => expect(Int.absolute(-7)) |> toEqual(Eq.int, 7)) 
test ("absolute(0)", () => expect(Int.absolute(0)) |> toEqual(Eq.int, 0)) 
test ("add(1,2)", () => expect(Int.add(1,2)) |> toEqual(Eq.int, 3)) 
test ("add(1,1)", () => expect(Int.add(1,1)) |> toEqual(Eq.int, 2)) 
test ("clamp(5,0,8)", () => expect(Int.clamp(5,0,8)) |> toEqual(Eq.int, 5)) 
test ("clamp(9,0,8)", () => expect(Int.clamp(9,0,8)) |> toEqual(Eq.int, 8)) 
test ("clamp(1,2,8)", () => expect(Int.clamp(1,2,8)) |> toEqual(Eq.int, 2)) 
test ("clamp(5,-10,-5)", () => expect(Int.clamp(5,-10,-5)) |> toEqual(Eq.int, -5)) 
test ("clamp(-15,-10,-5)", () => expect(Int.clamp(-15,-10,-5)) |> toEqual(Eq.int, -10)) 
test ("clamp(3,7,1)", () => expect(() => Int.clamp(3,7,1)) |> toThrow) 
test ("divide(3,2)", () => expect(Int.divide(3,2)) |> toEqual(Eq.int, 1)) 
test ("divide(3,0)", () => expect(() => Int.divide(3,0)) |> toThrow) 
test ("divide(27,5)", () => expect(Int.divide(27,5)) |> toEqual(Eq.int, 5)) 
test ("divideFloat(3,2)", () => expect(Int.divideFloat(3,2)) |> toEqual(Eq.float, 1.5)) 
test ("divideFloat(27,5)", () => expect(Int.divideFloat(27,5)) |> toEqual(Eq.float, 5.4)) 
test ("divideFloat(8,4)", () => expect(Int.divideFloat(8,4)) |> toEqual(Eq.float, 2)) 
test ("divideFloat(8,0)", () => expect(Int.divideFloat(8,0)) |> toEqual(Eq.float, Float.infinity)) 
test ("divideFloat(-8,0)", () => expect(Int.divideFloat(-8,0)) |> toEqual(Eq.float, Float.negativeInfinity)) 
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
test ("inRange(3,2,4)", () => expect(Int.inRange(3,2,4)) |> toEqual(Eq.bool, true)) 
test ("inRange(8,2,4)", () => expect(Int.inRange(8,2,4)) |> toEqual(Eq.bool, false)) 
test ("inRange(1,2,4)", () => expect(Int.inRange(1,2,4)) |> toEqual(Eq.bool, false)) 
test ("inRange(2,1,2)", () => expect(Int.inRange(2,1,2)) |> toEqual(Eq.bool, false)) 
test ("inRange(-6,-7,-5)", () => expect(Int.inRange(-6,-7,-5)) |> toEqual(Eq.bool, true)) 
test ("inRange(3,7,1)", () => expect(() => Int.inRange(3,7,1)) |> toThrow) 
test ("isEven(8)", () => expect(Int.isEven(8)) |> toEqual(Eq.bool, true)) 
test ("isEven(9)", () => expect(Int.isEven(9)) |> toEqual(Eq.bool, false)) 
test ("isEven(0)", () => expect(Int.isEven(0)) |> toEqual(Eq.bool, true)) 
test ("isOdd(8)", () => expect(Int.isOdd(8)) |> toEqual(Eq.bool, false)) 
test ("isOdd(9)", () => expect(Int.isOdd(9)) |> toEqual(Eq.bool, true)) 
test ("isOdd(0)", () => expect(Int.isOdd(0)) |> toEqual(Eq.bool, false)) 
test ("maximum(8,18)", () => expect(Int.maximum(8,18)) |> toEqual(Eq.int, 18)) 
test ("maximum(5,0)", () => expect(Int.maximum(5,0)) |> toEqual(Eq.int, 5)) 
test ("maximum(-4,-1)", () => expect(Int.maximum(-4,-1)) |> toEqual(Eq.int, -1)) 
test ("minimum(8,18)", () => expect(Int.minimum(8,18)) |> toEqual(Eq.int, 8)) 
test ("minimum(5,0)", () => expect(Int.minimum(5,0)) |> toEqual(Eq.int, 0)) 
test ("minimum(-4,-1)", () => expect(Int.minimum(-4,-1)) |> toEqual(Eq.int, -4)) 
test ("modulo(-4,3)", () => expect(Int.modulo(-4,3)) |> toEqual(Eq.int, 2)) 
test ("modulo(-3,3)", () => expect(Int.modulo(-3,3)) |> toEqual(Eq.int, 0)) 
test ("modulo(-2,3)", () => expect(Int.modulo(-2,3)) |> toEqual(Eq.int, 1)) 
test ("modulo(-1,3)", () => expect(Int.modulo(-1,3)) |> toEqual(Eq.int, 2)) 
test ("modulo(0,3)", () => expect(Int.modulo(0,3)) |> toEqual(Eq.int, 0)) 
test ("modulo(1,3)", () => expect(Int.modulo(1,3)) |> toEqual(Eq.int, 1)) 
test ("modulo(2,3)", () => expect(Int.modulo(2,3)) |> toEqual(Eq.int, 2)) 
test ("modulo(3,3)", () => expect(Int.modulo(3,3)) |> toEqual(Eq.int, 0)) 
test ("modulo(4,3)", () => expect(Int.modulo(4,3)) |> toEqual(Eq.int, 1)) 
test ("multiply(2,7)", () => expect(Int.multiply(2,7)) |> toEqual(Eq.int, 14)) 
test ("negate(8)", () => expect(Int.negate(8)) |> toEqual(Eq.int, -8)) 
test ("negate(-7)", () => expect(Int.negate(-7)) |> toEqual(Eq.int, 7)) 
test ("negate(0)", () => expect(Int.negate(0)) |> toEqual(Eq.int, 0)) 
test ("power(7,3)", () => expect(Int.power(7,3)) |> toEqual(Eq.int, 343)) 
test ("power(0,3)", () => expect(Int.power(0,3)) |> toEqual(Eq.int, 0)) 
test ("power(7,0)", () => expect(Int.power(7,0)) |> toEqual(Eq.int, 1)) 
test ("remainder(-4,3)", () => expect(Int.remainder(-4,3)) |> toEqual(Eq.int, -1)) 
test ("remainder(-2,3)", () => expect(Int.remainder(-2,3)) |> toEqual(Eq.int, -2)) 
test ("remainder(-1,3)", () => expect(Int.remainder(-1,3)) |> toEqual(Eq.int, -1)) 
test ("remainder(0,3)", () => expect(Int.remainder(0,3)) |> toEqual(Eq.int, 0)) 
test ("remainder(1,3)", () => expect(Int.remainder(1,3)) |> toEqual(Eq.int, 1)) 
test ("remainder(2,3)", () => expect(Int.remainder(2,3)) |> toEqual(Eq.int, 2)) 
test ("remainder(3,3)", () => expect(Int.remainder(3,3)) |> toEqual(Eq.int, 0)) 
test ("remainder(4,3)", () => expect(Int.remainder(4,3)) |> toEqual(Eq.int, 1)) 
test ("subtract(4,3)", () => expect(Int.subtract(4,3)) |> toEqual(Eq.int, 1)) 
test ("toFloat(5)", () => expect(Int.toFloat(5)) |> toEqual(Eq.float, 5.)) 
test ("toFloat(0)", () => expect(Int.toFloat(0)) |> toEqual(Eq.float, 0.)) 
test ("toFloat(-7)", () => expect(Int.toFloat(-7)) |> toEqual(Eq.float, -7.)) 
test ("toString(1)", () => expect(Int.toString(1)) |> toEqual(Eq.string, "1")) 
test ("toString(-1)", () => expect(Int.toString(-1)) |> toEqual(Eq.string, "-1")) 
})