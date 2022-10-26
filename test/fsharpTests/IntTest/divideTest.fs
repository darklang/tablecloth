testCase "divide(3,2)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Int.divide 3 2) "error"
testCase "divide(3,0)" 
<| fun _ -> 
    Expect.equal (Int.divide 3 0) |> failwith "error"
testCase "divide(27,5)" 
<| fun _ -> 
    let expected = 5
    Expect.equal expected (Int.divide 27 5) "error"
