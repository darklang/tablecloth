testCase "toString(true)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Bool.toString true) "error"
testCase "toString(false)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Bool.toString false) "error"
