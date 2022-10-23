testCase "clamp(5,0,8)" <| fun _ -> 
    let expected = 5
    Expect.equal expected (clamp 5 0 8)
testCase "clamp(9,0,8)" <| fun _ -> 
    let expected = 8
    Expect.equal expected (clamp 9 0 8)
testCase "clamp(1,2,8)" <| fun _ -> 
    let expected = 2
    Expect.equal expected (clamp 1 2 8)
testCase "clamp(5,-10,-5)" <| fun _ -> 
    let expected = -5
    Expect.equal expected (clamp 5 -10 -5)
testCase "clamp(-15,-10,-5)" <| fun _ -> 
    let expected = -10
    Expect.equal expected (clamp -15 -10 -5)
testCase "clamp(3,-10,-5)" <| fun _ -> 
    let expected = exception
    Expect.equal expected (clamp 3 -10 -5)
