testCase "toFloat(5)" 
<| fun _ -> 
    let expected = 5
    Expect.equal expected (Int.toFloat 5) "error"
testCase "toFloat(0)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.toFloat 0) "error"
testCase "toFloat(-7)" 
<| fun _ -> 
    let expected = -7
    Expect.equal expected (Int.toFloat -7) "error"
