testCase "divideFloat(3,2)" <| fun _ -> 
    let expected = 1.5
    Expect.equal expected (divideFloat 3 2)
testCase "divideFloat(27,5)" <| fun _ -> 
    let expected = 5.4
    Expect.equal expected (divideFloat 27 5)
testCase "divideFloat(8,4)" <| fun _ -> 
    let expected = 2
    Expect.equal expected (divideFloat 8 4)
testCase "divideFloat(8,0)" <| fun _ -> 
    let expected = Float.infinity
    Expect.equal expected (divideFloat 8 0)
testCase "divideFloat(-8,0)" <| fun _ -> 
    let expected = Float.negativeInfinity
    Expect.equal expected (divideFloat -8 0)
