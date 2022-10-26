testCase "modulo(-4,3)" 
<| fun _ -> 
    let expected = 2
    Expect.equal expected (Int.modulo -4 3) "error"
testCase "modulo(-3,3)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.modulo -3 3) "error"
testCase "modulo(-2,3)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.modulo -2 3) "error"
testCase "modulo(-1,3)" 
<| fun _ -> 
    let expected = 2
    Expect.equal expected (Int.modulo -1 3) "error"
testCase "modulo(0,3)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.modulo 0 3) "error"
testCase "modulo(1,3)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.modulo 1 3) "error"
testCase "modulo(2,3)" 
<| fun _ -> 
    let expected = 2
    Expect.equal expected (Int.modulo 2 3) "error"
testCase "modulo(3,3)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.modulo 3 3) "error"
testCase "modulo(4,3)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.modulo 4 3) "error"
