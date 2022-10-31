testCase "fromString("a")" 
<| fun _ -> 
    let expected = Some('a')
    Expect.equal expected (Char.fromString "a") "error"
testCase "fromString("abc")" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Char.fromString "abc") "error"
testCase "fromString("")" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Char.fromString "") "error"
