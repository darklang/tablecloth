testCase "remainder(-4,3)" 
<| fun _ -> 
    let expected = -1
    Expect.equal expected (Int.remainder -4 3) "error"
testCase "remainder(-2,3)" 
<| fun _ -> 
    let expected = -2
    Expect.equal expected (Int.remainder -2 3) "error"
testCase "remainder(-1,3)" 
<| fun _ -> 
    let expected = -1
    Expect.equal expected (Int.remainder -1 3) "error"
testCase "remainder(0,3)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.remainder 0 3) "error"
testCase "remainder(1,3)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.remainder 1 3) "error"
testCase "remainder(2,3)" 
<| fun _ -> 
    let expected = 2
    Expect.equal expected (Int.remainder 2 3) "error"
testCase "remainder(3,3)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Int.remainder 3 3) "error"
testCase "remainder(4,3)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.remainder 4 3) "error"
