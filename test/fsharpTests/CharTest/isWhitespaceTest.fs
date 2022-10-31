testCase "isWhitespace(' ')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isWhitespace ' ') "error"
testCase "isWhitespace('a')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isWhitespace 'a') "error"
