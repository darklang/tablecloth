testCase "absolute(8)" <| fun _ -> 
    let expected = 8
    Expect.equal expected (absolute 8)
testCase "absolute(-7)" <| fun _ -> 
    let expected = 7
    Expect.equal expected (absolute -7)
testCase "absolute(0)" <| fun _ -> 
    let expected = 0
    Expect.equal expected (absolute 0)