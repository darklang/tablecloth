testCase "add(1,2)" 
<| fun _ -> 
    let expected = 3
    Expect.equal expected (Int.add 1 2) "error"
testCase "add(1,1)" 
<| fun _ -> 
    let expected = 2
    Expect.equal expected (Int.add 1 1) "error"
