testCase "clamp(5,0,8)" 
<| fun _ -> 
    let expected = 5
    Expect.equal expected (Int.clamp 5 0 8) "error"
testCase "clamp(9,0,8)" 
<| fun _ -> 
    let expected = 8
    Expect.equal expected (Int.clamp 9 0 8) "error"
testCase "clamp(1,2,8)" 
<| fun _ -> 
    let expected = 2
    Expect.equal expected (Int.clamp 1 2 8) "error"
testCase "clamp(5,-10,-5)" 
<| fun _ -> 
    let expected = -5
    Expect.equal expected (Int.clamp 5 -10 -5) "error"
testCase "clamp(-15,-10,-5)" 
<| fun _ -> 
    let expected = -10
    Expect.equal expected (Int.clamp -15 -10 -5) "error"
testCase "clamp(3,7,1)" 
<| fun _ -> 
    Expect.equal (Int.clamp 3 7 1) |> failwith "error"
