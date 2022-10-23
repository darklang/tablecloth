testCase "power(7,3)" <| fun _ -> 
    let expected = 343
    Expect.equal expected (power 7 3)
testCase "power(0,3)" <| fun _ -> 
    let expected = 0
    Expect.equal expected (power 0 3)
testCase "power(7,0)" <| fun _ -> 
    let expected = 1
    Expect.equal expected (power 7 0)
