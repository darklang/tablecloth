testCase "toInt(true)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Bool.toInt true) "error"
testCase "toInt(false)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Bool.toInt false) "error"
