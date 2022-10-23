testCase "divide(3,2)" <| fun _ -> 
    let expected = 1
    Expect.equal expected (divide 3 2) "message" 
testCase "divide(3,0)" <| fun _ -> 
    let expected = exception
    Expect.equal expected (divide 3 0) "message" 
testCase "divide(27,5)" <| fun _ -> 
    let expected = 5
    Expect.equal expected (divide 27 5) "message" 
