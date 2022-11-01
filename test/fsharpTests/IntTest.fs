testCase "absolute(8)"
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

testCase "clamp(5,0,8)"
<| fun _ ->
    let expected = 5
    Expect.equal expected (Int.clamp 5 0 8) "error"

testCase "clamp(9,0,8)"
<| fun _ ->
    let expected = 8
    Expect.equal expected (Int.clamp 9 0 8) "error"

testCase "clamp(1,2,8)"
<| fun _ ->
    let expected = 2
    Expect.equal expected (Int.clamp 1 2 8) "error"

testCase "clamp(5,-10,-5)"
<| fun _ ->
    let expected = -5
    Expect.equal expected (Int.clamp 5 -10 -5) "error"

testCase "clamp(-15,-10,-5)"
<| fun _ ->
    let expected = -10
    Expect.equal expected (Int.clamp -15 -10 -5) "error"

testCase "clamp(3,7,1)"
<| fun _ -> Expect.equal (Int.clamp 3 7 1) |> failwith "error"

testCase "divideFloat(3,2)"
<| fun _ ->
    let expected = 1.5
    Expect.equal expected (Int.divideFloat 3 2) "error"

testCase "divideFloat(27,5)"
<| fun _ ->
    let expected = 5.4
    Expect.equal expected (Int.divideFloat 27 5) "error"

testCase "divideFloat(8,4)"
<| fun _ ->
    let expected = 2
    Expect.equal expected (Int.divideFloat 8 4) "error"

testCase "divideFloat(8,0)"
<| fun _ ->
    let expected = Float.infinity
    Expect.equal expected (Int.divideFloat 8 0) "error"

testCase "divideFloat(-8,0)"
<| fun _ ->
    let expected = Float.negativeInfinity
    Expect.equal expected (Int.divideFloat -8 0) "error"

testCase "divide(3,2)"
<| fun _ ->
    let expected = 1
    Expect.equal expected (Int.divide 3 2) "error"

testCase "divide(3,0)"
<| fun _ -> Expect.equal (Int.divide 3 0) |> failwith "error"

testCase "divide(27,5)"
<| fun _ ->
    let expected = 5
    Expect.equal expected (Int.divide 27 5) "error"

testCase "fromString(" 0 ")"
<| fun _ ->
    let expected = Some(0)
    Expect.equal expected (Int.fromString "0") "error"

testCase "fromString(" - 0 ")"
<| fun _ ->
    let expected = Some(-0)
    Expect.equal expected (Int.fromString "-0") "error"

testCase "fromString(" 42 ")"
<| fun _ ->
    let expected = Some(42)
    Expect.equal expected (Int.fromString "42") "error"

testCase "fromString(" 123_456 ")"
<| fun _ ->
    let expected = Some(123_456)
    Expect.equal expected (Int.fromString "123_456") "error"

testCase "fromString(" - 42 ")"
<| fun _ ->
    let expected = Some(-42)
    Expect.equal expected (Int.fromString "-42") "error"

testCase "fromString(" 0XFF ")"
<| fun _ ->
    let expected = Some(255)
    Expect.equal expected (Int.fromString "0XFF") "error"

testCase "fromString(" 0X000A ")"
<| fun _ ->
    let expected = Some(10)
    Expect.equal expected (Int.fromString "0X000A") "error"

testCase "fromString(" Infinity ")"
<| fun _ ->
    let expected = None
    Expect.equal expected (Int.fromString "Infinity") "error"

testCase "fromString(" - Infinity ")"
<| fun _ ->
    let expected = None
    Expect.equal expected (Int.fromString "-Infinity") "error"

testCase "fromString(" NaN ")"
<| fun _ ->
    let expected = None
    Expect.equal expected (Int.fromString "NaN") "error"

testCase "fromString(" abc ")"
<| fun _ ->
    let expected = None
    Expect.equal expected (Int.fromString "abc") "error"

testCase "fromString(" -- 4 ")"
<| fun _ ->
    let expected = None
    Expect.equal expected (Int.fromString "--4") "error"

testCase "fromString(" ")"
<| fun _ ->
    let expected = None
    Expect.equal expected (Int.fromString " ") "error"

testCase "inRange(3,2,4)"
<| fun _ ->
    let expected = true
    Expect.equal expected (Int.inRange 3 2 4) "error"

testCase "inRange(8,2,4)"
<| fun _ ->
    let expected = false
    Expect.equal expected (Int.inRange 8 2 4) "error"

testCase "inRange(1,2,4)"
<| fun _ ->
    let expected = false
    Expect.equal expected (Int.inRange 1 2 4) "error"

testCase "inRange(2,1,2)"
<| fun _ ->
    let expected = false
    Expect.equal expected (Int.inRange 2 1 2) "error"

testCase "inRange(-6,-7,-5)"
<| fun _ ->
    let expected = true
    Expect.equal expected (Int.inRange -6 -7 -5) "error"

testCase "inRange(3,7,1)"
<| fun _ -> Expect.equal (Int.inRange 3 7 1) |> failwith "error"

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

testCase "modulo(-4,3)"
<| fun _ ->
    let expected = 2
    Expect.equal expected (Int.modulo -4 3) "error"

testCase "modulo(-3,3)"
<| fun _ ->
    let expected = 0
    Expect.equal expected (Int.modulo -3 3) "error"

testCase "modulo(-2,3)"
<| fun _ ->
    let expected = 1
    Expect.equal expected (Int.modulo -2 3) "error"

testCase "modulo(-1,3)"
<| fun _ ->
    let expected = 2
    Expect.equal expected (Int.modulo -1 3) "error"

testCase "modulo(0,3)"
<| fun _ ->
    let expected = 0
    Expect.equal expected (Int.modulo 0 3) "error"

testCase "modulo(1,3)"
<| fun _ ->
    let expected = 1
    Expect.equal expected (Int.modulo 1 3) "error"

testCase "modulo(2,3)"
<| fun _ ->
    let expected = 2
    Expect.equal expected (Int.modulo 2 3) "error"

testCase "modulo(3,3)"
<| fun _ ->
    let expected = 0
    Expect.equal expected (Int.modulo 3 3) "error"

testCase "modulo(4,3)"
<| fun _ ->
    let expected = 1
    Expect.equal expected (Int.modulo 4 3) "error"

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

testCase "power(7,3)"
<| fun _ ->
    let expected = 343
    Expect.equal expected (Int.power 7 3) "error"

testCase "power(0,3)"
<| fun _ ->
    let expected = 0
    Expect.equal expected (Int.power 0 3) "error"

testCase "power(7,0)"
<| fun _ ->
    let expected = 1
    Expect.equal expected (Int.power 7 0) "error"

testCase "remainder(-4,3)"
<| fun _ ->
    let expected = -1
    Expect.equal expected (Int.remainder -4 3) "error"

testCase "remainder(-2,3)"
<| fun _ ->
    let expected = -2
    Expect.equal expected (Int.remainder -2 3) "error"

testCase "remainder(-1,3)"
<| fun _ ->
    let expected = -1
    Expect.equal expected (Int.remainder -1 3) "error"

testCase "remainder(0,3)"
<| fun _ ->
    let expected = 0
    Expect.equal expected (Int.remainder 0 3) "error"

testCase "remainder(1,3)"
<| fun _ ->
    let expected = 1
    Expect.equal expected (Int.remainder 1 3) "error"

testCase "remainder(2,3)"
<| fun _ ->
    let expected = 2
    Expect.equal expected (Int.remainder 2 3) "error"

testCase "remainder(3,3)"
<| fun _ ->
    let expected = 0
    Expect.equal expected (Int.remainder 3 3) "error"

testCase "remainder(4,3)"
<| fun _ ->
    let expected = 1
    Expect.equal expected (Int.remainder 4 3) "error"

testCase "subtract(4,3)"
<| fun _ ->
    let expected = 1
    Expect.equal expected (Int.subtract 4 3) "error"

testCase "toFloat(5)"
<| fun _ ->
    let expected = 5
    Expect.equal expected (Int.toFloat 5) "error"

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
