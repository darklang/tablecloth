testCase "fromString("true")" 
<| fun _ -> 
    let expected = Some(true)
    Expect.equal expected (Bool.fromString "true") "error"
testCase "fromString("false")" 
<| fun _ -> 
    let expected = Some(false)
    Expect.equal expected (Bool.fromString "false") "error"
testCase "fromString("True")" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Bool.fromString "True") "error"
testCase "fromString("1")" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Bool.fromString "1") "error"
