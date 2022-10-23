testCase "subtract(4,3)" <| fun _ -> 
    let expected = 1
    Expect.equal expected (subtract 4 3) "message" 
