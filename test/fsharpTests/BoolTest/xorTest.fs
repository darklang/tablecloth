testCase "xor(true,true)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Bool.xor true true) "error"
testCase "xor(true,false)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Bool.xor true false) "error"
testCase "xor(false,true)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Bool.xor false true) "error"
testCase "xor(false,false)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Bool.xor false false) "error"
