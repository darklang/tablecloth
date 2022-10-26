testCase "multiply(2,7)" 
<| fun _ -> 
    let expected = 14
    Expect.equal expected (Int.multiply 2 7) "error"
