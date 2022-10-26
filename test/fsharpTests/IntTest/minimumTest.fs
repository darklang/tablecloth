testCase "minimum(8,18)" 
<| fun _ -> 
    let expected = 8
    Expect.equal expected (Int.minimum 8 18) "error"
testCase "minimum(5,0)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.minimum 5 0) "error"
testCase "minimum(-4,-1)" 
<| fun _ -> 
    let expected = -4
    Expect.equal expected (Int.minimum -4 -1) "error"
