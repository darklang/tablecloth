testCase "isOdd(8)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Int.isOdd 8) "error"
testCase "isOdd(9)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Int.isOdd 9) "error"
testCase "isOdd(0)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Int.isOdd 0) "error"
