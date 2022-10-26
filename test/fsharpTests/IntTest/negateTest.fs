testCase "negate(8)" 
<| fun _ -> 
    let expected = -8
    Expect.equal expected (Int.negate 8) "error"
testCase "negate(-7)" 
<| fun _ -> 
    let expected = 7
    Expect.equal expected (Int.negate -7) "error"
testCase "negate(0)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.negate 0) "error"
