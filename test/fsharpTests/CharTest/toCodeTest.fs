testCase "toCode('a')" 
<| fun _ -> 
    let expected = 97
    Expect.equal expected (Char.toCode 'a') "error"
