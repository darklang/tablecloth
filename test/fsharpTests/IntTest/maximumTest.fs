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
