testCase "compare(true,true)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Bool.compare true true) "error"
testCase "compare(true,false)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Bool.compare true false) "error"
testCase "compare(false,true)" 
<| fun _ -> 
    let expected = -1
    Expect.equal expected (Bool.compare false true) "error"
testCase "compare(false,false)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Bool.compare false false) "error"
