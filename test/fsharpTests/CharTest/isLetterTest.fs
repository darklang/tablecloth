testCase "isLetter('A')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isLetter 'A') "error"
testCase "isLetter('7')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isLetter '7') "error"
testCase "isLetter(' ')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isLetter ' ') "error"
testCase "isLetter('\n')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isLetter '\n') "error"
testCase "isLetter('\001')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isLetter '\001') "error"
testCase "isLetter('\236')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isLetter '\236') "error"
