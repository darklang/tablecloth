testCase "fromCode(97)" 
<| fun _ -> 
    let expected = Some('a')
    Expect.equal expected (Char.fromCode 97) "error"
testCase "fromCode(-1)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Char.fromCode -1) "error"
testCase "fromCode(256)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Char.fromCode 256) "error"
