testCase "isEven(8)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Int.isEven 8) "error"
testCase "isEven(9)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Int.isEven 9) "error"
testCase "isEven(0)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Int.isEven 0) "error"
