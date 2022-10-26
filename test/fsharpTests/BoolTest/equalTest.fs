testCase "equal(true,true)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Bool.equal true true) "error"
testCase "equal(false,false)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Bool.equal false false) "error"
testCase "equal(true,false)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Bool.equal true false) "error"
