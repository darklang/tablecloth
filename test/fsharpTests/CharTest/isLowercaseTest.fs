testCase "isLowercase('a')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isLowercase 'a') "error"
testCase "isLowercase('7')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isLowercase '7') "error"
testCase "isLowercase('\236')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isLowercase '\236') "error"
