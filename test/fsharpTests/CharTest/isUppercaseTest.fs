testCase "isUppercase('A')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isUppercase 'A') "error"
testCase "isUppercase('7')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isUppercase '7') "error"
testCase "isUppercase('\237')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isUppercase '\237') "error"
