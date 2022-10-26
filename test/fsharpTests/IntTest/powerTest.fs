testCase "power(7,3)" 
<| fun _ -> 
    let expected = 343
    Expect.equal expected (Int.power 7 3) "error"
testCase "power(0,3)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.power 0 3) "error"
testCase "power(7,0)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.power 7 0) "error"
