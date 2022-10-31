testCase "isDigit('0')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '0') "error"
testCase "isDigit('1')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '1') "error"
testCase "isDigit('2')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '2') "error"
testCase "isDigit('3')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '3') "error"
testCase "isDigit('4')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '4') "error"
testCase "isDigit('5')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '5') "error"
testCase "isDigit('6')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '6') "error"
testCase "isDigit('7')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '7') "error"
testCase "isDigit('8')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '8') "error"
testCase "isDigit('9')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '9') "error"
testCase "isDigit('a')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isDigit 'a') "error"
