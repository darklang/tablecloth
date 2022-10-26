testCase "inRange(3,2,4)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Int.inRange 3 2 4) "error"
testCase "inRange(8,2,4)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Int.inRange 8 2 4) "error"
testCase "inRange(1,2,4)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Int.inRange 1 2 4) "error"
testCase "inRange(2,1,2)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Int.inRange 2 1 2) "error"
testCase "inRange(-6,-7,-5)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Int.inRange -6 -7 -5) "error"
testCase "inRange(3,7,1)" 
<| fun _ -> 
    Expect.equal (Int.inRange 3 7 1) |> failwith "error"
