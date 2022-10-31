testCase "toString('a')" 
<| fun _ -> 
    let expected = "a"
    Expect.equal expected (Char.toString 'a') "error"
