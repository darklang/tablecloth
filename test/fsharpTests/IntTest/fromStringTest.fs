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
