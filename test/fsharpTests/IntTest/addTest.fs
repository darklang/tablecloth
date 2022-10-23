testCase "add(1,2)" <| fun _ -> 
    let expected = 3
    Expect.equal expected (add 1 2)
testCase "add(1,1)" <| fun _ -> 
    let expected = 2
    Expect.equal expected (add 1 1)
