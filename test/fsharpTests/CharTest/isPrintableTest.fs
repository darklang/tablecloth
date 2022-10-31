testCase "isPrintable('~')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isPrintable '~') "error"
testCase "isPrintable(fromCode(31) |> Option.map(~f=isPrintable))" 
<| fun _ -> 
    let expected = Some(false)
    Expect.equal expected (Char.isPrintable fromCode(31) |> Option.map(~f=isPrintable)) "error"
