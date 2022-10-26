testCase "subtract(4,3)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.subtract 4 3) "error"
