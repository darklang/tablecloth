testCase "toDigit('0')" 
<| fun _ -> 
    let expected = Some(0)
    Expect.equal expected (Char.toDigit '0') "error"
testCase "toDigit('8')" 
<| fun _ -> 
    let expected = Some(8)
    Expect.equal expected (Char.toDigit '8') "error"
testCase "toDigit('a')" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Char.toDigit 'a') "error"
