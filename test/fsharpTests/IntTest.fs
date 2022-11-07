open Tablecloth
open Expecto

[<Tests>]
let tests =
  testList
  "Int"
[testCase "absolute(8)" 
<| fun _ -> 
    let expected = 8
    Expect.equal expected (Int.absolute 8) "error"
testCase "absolute(-7)" 
<| fun _ -> 
    let expected = 7
    Expect.equal expected (Int.absolute -7) "error"
testCase "absolute(0)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.absolute 0) "error"
testCase "add(1,2)" 
<| fun _ -> 
    let expected = 3
    Expect.equal expected (Int.add 1 2) "error"
testCase "add(1,1)" 
<| fun _ -> 
    let expected = 2
    Expect.equal expected (Int.add 1 1) "error"
testCase "clamp(5,~lower=0,~upper=8)" 
<| fun _ -> 
    let expected = 5
    Expect.equal expected (Int.clamp 5 ~lower:0 ~upper:8) "error"
testCase "clamp(9,~lower=0,~upper=8)" 
<| fun _ -> 
    let expected = 8
    Expect.equal expected (Int.clamp 9 ~lower:0 ~upper:8) "error"
testCase "clamp(1,~lower=2,~upper=8)" 
<| fun _ -> 
    let expected = 2
    Expect.equal expected (Int.clamp 1 ~lower:2 ~upper:8) "error"
testCase "clamp(5,~lower=-10,~upper=-5)" 
<| fun _ -> 
    let expected = -5
    Expect.equal expected (Int.clamp 5 ~lower:-10 ~upper:-5) "error"
testCase "clamp(-15,~lower=-10,~upper=-5)" 
<| fun _ -> 
    let expected = -10
    Expect.equal expected (Int.clamp -15 ~lower:-10 ~upper:-5) "error"
testCase "clamp(3,~lower=7,~upper=1)" 
<| fun _ -> 
    Expect.equal (Int.clamp 3 ~lower:7 ~upper:1) |> failwith "error"
testCase "divide(3,~by=2)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.divide 3 ~by:2) "error"
testCase "divide(3,~by=0)" 
<| fun _ -> 
    Expect.equal (Int.divide 3 ~by:0) |> failwith "error"
testCase "divide(27,~by=5)" 
<| fun _ -> 
    let expected = 5
    Expect.equal expected (Int.divide 27 ~by:5) "error"
testCase "divideFloat(3,~by=2)" 
<| fun _ -> 
    let expected = 1.5
    Expect.equal expected (Int.divideFloat 3 ~by:2) "error"
testCase "divideFloat(27,~by=5)" 
<| fun _ -> 
    let expected = 5.4
    Expect.equal expected (Int.divideFloat 27 ~by:5) "error"
testCase "divideFloat(8,~by=4)" 
<| fun _ -> 
    let expected = 2
    Expect.equal expected (Int.divideFloat 8 ~by:4) "error"
testCase "divideFloat(8,~by=0)" 
<| fun _ -> 
    let expected = Float.infinity
    Expect.equal expected (Int.divideFloat 8 ~by:0) "error"
testCase "divideFloat(-8,~by=0)" 
<| fun _ -> 
    let expected = Float.negativeInfinity
    Expect.equal expected (Int.divideFloat -8 ~by:0) "error"
testCase "fromString("0")" 
<| fun _ -> 
    let expected = Some(0)
    Expect.equal expected (Int.fromString "0") "error"
testCase "fromString("-0")" 
<| fun _ -> 
    let expected = Some(-0)
    Expect.equal expected (Int.fromString "-0") "error"
testCase "fromString("42")" 
<| fun _ -> 
    let expected = Some(42)
    Expect.equal expected (Int.fromString "42") "error"
testCase "fromString("123_456")" 
<| fun _ -> 
    let expected = Some(123_456)
    Expect.equal expected (Int.fromString "123_456") "error"
testCase "fromString("-42")" 
<| fun _ -> 
    let expected = Some(-42)
    Expect.equal expected (Int.fromString "-42") "error"
testCase "fromString("0XFF")" 
<| fun _ -> 
    let expected = Some(255)
    Expect.equal expected (Int.fromString "0XFF") "error"
testCase "fromString("0X000A")" 
<| fun _ -> 
    let expected = Some(10)
    Expect.equal expected (Int.fromString "0X000A") "error"
testCase "fromString("Infinity")" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Int.fromString "Infinity") "error"
testCase "fromString("-Infinity")" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Int.fromString "-Infinity") "error"
testCase "fromString("NaN")" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Int.fromString "NaN") "error"
testCase "fromString("abc")" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Int.fromString "abc") "error"
testCase "fromString("--4")" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Int.fromString "--4") "error"
testCase "fromString(" ")" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Int.fromString " ") "error"
testCase "inRange(3,~lower=2,~upper=4)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Int.inRange 3 ~lower:2 ~upper:4) "error"
testCase "inRange(8,~lower=2,~upper=4)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Int.inRange 8 ~lower:2 ~upper:4) "error"
testCase "inRange(1,~lower=2,~upper=4)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Int.inRange 1 ~lower:2 ~upper:4) "error"
testCase "inRange(2,~lower=1,~upper=2)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Int.inRange 2 ~lower:1 ~upper:2) "error"
testCase "inRange(-6,~lower=-7,~upper=-5)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Int.inRange -6 ~lower:-7 ~upper:-5) "error"
testCase "inRange(3,~lower=7,~upper=1)" 
<| fun _ -> 
    Expect.equal (Int.inRange 3 ~lower:7 ~upper:1) |> failwith "error"
testCase "isEven(8)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Int.isEven 8) "error"
testCase "isEven(9)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Int.isEven 9) "error"
testCase "isEven(0)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Int.isEven 0) "error"
testCase "isOdd(8)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Int.isOdd 8) "error"
testCase "isOdd(9)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Int.isOdd 9) "error"
testCase "isOdd(0)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Int.isOdd 0) "error"
testCase "maximum(8,18)" 
<| fun _ -> 
    let expected = 18
    Expect.equal expected (Int.maximum 8 18) "error"
testCase "maximum(5,0)" 
<| fun _ -> 
    let expected = 5
    Expect.equal expected (Int.maximum 5 0) "error"
testCase "maximum(-4,-1)" 
<| fun _ -> 
    let expected = -1
    Expect.equal expected (Int.maximum -4 -1) "error"
testCase "minimum(8,18)" 
<| fun _ -> 
    let expected = 8
    Expect.equal expected (Int.minimum 8 18) "error"
testCase "minimum(5,0)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.minimum 5 0) "error"
testCase "minimum(-4,-1)" 
<| fun _ -> 
    let expected = -4
    Expect.equal expected (Int.minimum -4 -1) "error"
testCase "modulo(-4,~by=3)" 
<| fun _ -> 
    let expected = 2
    Expect.equal expected (Int.modulo -4 ~by:3) "error"
testCase "modulo(-3,~by=3)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.modulo -3 ~by:3) "error"
testCase "modulo(-2,~by=3)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.modulo -2 ~by:3) "error"
testCase "modulo(-1,~by=3)" 
<| fun _ -> 
    let expected = 2
    Expect.equal expected (Int.modulo -1 ~by:3) "error"
testCase "modulo(0,~by=3)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.modulo 0 ~by:3) "error"
testCase "modulo(1,~by=3)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.modulo 1 ~by:3) "error"
testCase "modulo(2,~by=3)" 
<| fun _ -> 
    let expected = 2
    Expect.equal expected (Int.modulo 2 ~by:3) "error"
testCase "modulo(3,~by=3)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.modulo 3 ~by:3) "error"
testCase "modulo(4,~by=3)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.modulo 4 ~by:3) "error"
testCase "multiply(2,7)" 
<| fun _ -> 
    let expected = 14
    Expect.equal expected (Int.multiply 2 7) "error"
testCase "negate(8)" 
<| fun _ -> 
    let expected = -8
    Expect.equal expected (Int.negate 8) "error"
testCase "negate(-7)" 
<| fun _ -> 
    let expected = 7
    Expect.equal expected (Int.negate -7) "error"
testCase "negate(0)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.negate 0) "error"
testCase "power(~base=7,~exponent=3)" 
<| fun _ -> 
    let expected = 343
    Expect.equal expected (Int.power ~base:7 ~exponent:3) "error"
testCase "power(~base=0,~exponent=3)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.power ~base:0 ~exponent:3) "error"
testCase "power(~base=7,~exponent=0)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.power ~base:7 ~exponent:0) "error"
testCase "remainder(-4,~by=3)" 
<| fun _ -> 
    let expected = -1
    Expect.equal expected (Int.remainder -4 ~by:3) "error"
testCase "remainder(-2,~by=3)" 
<| fun _ -> 
    let expected = -2
    Expect.equal expected (Int.remainder -2 ~by:3) "error"
testCase "remainder(-1,~by=3)" 
<| fun _ -> 
    let expected = -1
    Expect.equal expected (Int.remainder -1 ~by:3) "error"
testCase "remainder(0,~by=3)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.remainder 0 ~by:3) "error"
testCase "remainder(1,~by=3)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.remainder 1 ~by:3) "error"
testCase "remainder(2,~by=3)" 
<| fun _ -> 
    let expected = 2
    Expect.equal expected (Int.remainder 2 ~by:3) "error"
testCase "remainder(3,~by=3)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.remainder 3 ~by:3) "error"
testCase "remainder(4,~by=3)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.remainder 4 ~by:3) "error"
testCase "subtract(4,3)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.subtract 4 3) "error"
testCase "toFloat(5)" 
<| fun _ -> 
    let expected = 5.
    Expect.equal expected (Int.toFloat 5) "error"
testCase "toFloat(0)" 
<| fun _ -> 
    let expected = 0.
    Expect.equal expected (Int.toFloat 0) "error"
testCase "toFloat(-7)" 
<| fun _ -> 
    let expected = -7.
    Expect.equal expected (Int.toFloat -7) "error"
testCase "toString(1)" 
<| fun _ -> 
    let expected = "1"
    Expect.equal expected (Int.toString 1) "error"
testCase "toString(-1)" 
<| fun _ -> 
    let expected = "-1"
    Expect.equal expected (Int.toString -1) "error"
]