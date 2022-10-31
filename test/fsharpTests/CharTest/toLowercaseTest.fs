testCase "toLowercase('A')" 
<| fun _ -> 
    let expected = 'a'
    Expect.equal expected (Char.toLowercase 'A') "error"
testCase "toLowercase('a')" 
<| fun _ -> 
    let expected = 'a'
    Expect.equal expected (Char.toLowercase 'a') "error"
testCase "toLowercase('7')" 
<| fun _ -> 
    let expected = '7'
    Expect.equal expected (Char.toLowercase '7') "error"
testCase "toLowercase('\233')" 
<| fun _ -> 
    let expected = '\233'
    Expect.equal expected (Char.toLowercase '\233') "error"
