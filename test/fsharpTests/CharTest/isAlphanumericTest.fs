testCase "isAlphanumeric('A')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isAlphanumeric 'A') "error"
testCase "isAlphanumeric('?')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isAlphanumeric '?') "error"
