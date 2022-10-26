testCase "fromInt(0)" 
<| fun _ -> 
    let expected = Some(false)
    Expect.equal expected (Bool.fromInt 0) "error"
testCase "fromInt(1)" 
<| fun _ -> 
    let expected = Some(true)
    Expect.equal expected (Bool.fromInt 1) "error"
testCase "fromInt(Int.minimumValue)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Bool.fromInt Int.minimumValue) "error"
testCase "fromInt(-2)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Bool.fromInt -2) "error"
testCase "fromInt(-1)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Bool.fromInt -1) "error"
testCase "fromInt(2)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Bool.fromInt 2) "error"
testCase "fromInt(Int.maximumValue)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Bool.fromInt Int.maximumValue) "error"
