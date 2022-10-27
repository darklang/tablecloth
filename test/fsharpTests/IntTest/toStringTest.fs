testCase "toString(1)" 
<| fun _ -> 
    let expected = "1"
    Expect.equal expected (Int.toString 1) "error"
testCase "toString(-1)" 
<| fun _ -> 
    let expected = "-1"
    Expect.equal expected (Int.toString -1) "error"
