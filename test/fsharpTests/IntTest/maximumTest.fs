testCase "maximum(8,18)" <| fun _ -> 
    let expected = 18
    Expect.equal expected (maximum 8 18) "message" 
testCase "maximum(5,0)" <| fun _ -> 
    let expected = 5
    Expect.equal expected (maximum 5 0) "message" 
testCase "maximum(-4,-1)" <| fun _ -> 
    let expected = -1
    Expect.equal expected (maximum -4 -1) "message" 
