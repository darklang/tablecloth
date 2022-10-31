testCase "toUppercase('a')" 
<| fun _ -> 
    let expected = 'A'
    Expect.equal expected (Char.toUppercase 'a') "error"
testCase "toUppercase('A')" 
<| fun _ -> 
    let expected = 'A'
    Expect.equal expected (Char.toUppercase 'A') "error"
testCase "toUppercase('7')" 
<| fun _ -> 
    let expected = '7'
    Expect.equal expected (Char.toUppercase '7') "error"
testCase "toUppercase('\233')" 
<| fun _ -> 
    let expected = '\233'
    Expect.equal expected (Char.toUppercase '\233') "error"
