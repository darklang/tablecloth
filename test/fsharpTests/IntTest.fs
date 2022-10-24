testCase "absolute(8)"
<| fun _ ->
    let expected = 8
    Expect.equal expected (absolute 8)

testCase "absolute(-7)"
<| fun _ ->
    let expected = 7
    Expect.equal expected (absolute -7)

testCase "absolute(0)"
<| fun _ ->
    let expected = 0
    Expect.equal expected (absolute 0)

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
testCase "fromString("0")"
 <| fun _ -> 
    let expected = Some(0)
    Expect.equal expected (fromString "0")
testCase "fromString("-0")"
 <| fun _ -> 
    let expected = Some(-0)
    Expect.equal expected (fromString "-0")
testCase "fromString("42")"
 <| fun _ -> 
    let expected = Some(42)
    Expect.equal expected (fromString "42")
testCase "fromString("123_456")"
 <| fun _ -> 
    let expected = Some(123_456)
    Expect.equal expected (fromString "123_456")
testCase "fromString("-42")"
 <| fun _ -> 
    let expected = Some(-42)
    Expect.equal expected (fromString "-42")
testCase "fromString("0XFF")"
 <| fun _ -> 
    let expected = Some(255)
    Expect.equal expected (fromString "0XFF")
testCase "fromString("0X000A")"
 <| fun _ -> 
    let expected = Some(10)
    Expect.equal expected (fromString "0X000A")
testCase "fromString("Infinity")"
 <| fun _ -> 
    let expected = None
    Expect.equal expected (fromString "Infinity")
testCase "fromString("-Infinity")"
 <| fun _ -> 
    let expected = None
    Expect.equal expected (fromString "-Infinity")
testCase "fromString("NaN")"
 <| fun _ -> 
    let expected = None
    Expect.equal expected (fromString "NaN")
testCase "fromString("abc")"
 <| fun _ -> 
    let expected = None
    Expect.equal expected (fromString "abc")
testCase "fromString("--4")"
 <| fun _ -> 
    let expected = None
    Expect.equal expected (fromString "--4")
testCase "fromString(" ")"
 <| fun _ -> 
    let expected = None
    Expect.equal expected (fromString " ")
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
testCase "subtract(4,3)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.subtract 4 3) "error"
