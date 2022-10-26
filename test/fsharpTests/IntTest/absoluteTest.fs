testCase "absolute(8)" 
<| fun _ -> 
    let expected = 8
    Expect.equal expected (Int.absolute 8) "error"
testCase "absolute(-7)" 
<| fun _ -> 
    let expected = 7
    Expect.equal expected (Int.absolute -7) "error"
testCase "absolute(0)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.absolute 0) "error"
