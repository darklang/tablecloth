open Tablecloth
open Expecto

[<Tests>]
let tests =
  testList
  "Bool"
[testCase "compare(true,true)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Bool.compare true true) "error"
testCase "compare(true,false)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Bool.compare true false) "error"
testCase "compare(false,true)" 
<| fun _ -> 
    let expected = -1
    Expect.equal expected (Bool.compare false true) "error"
testCase "compare(false,false)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Bool.compare false false) "error"
testCase "equal(true,true)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Bool.equal true true) "error"
testCase "equal(false,false)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Bool.equal false false) "error"
testCase "equal(true,false)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Bool.equal true false) "error"
testCase "fromInt(0)" 
<| fun _ -> 
    let expected = Some(false)
    Expect.equal expected (Bool.fromInt 0) "error"
testCase "fromInt(1)" 
<| fun _ -> 
    let expected = Some(true)
    Expect.equal expected (Bool.fromInt 1) "error"
testCase "fromInt(Int.minimumValue)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Bool.fromInt Int.minimumValue) "error"
testCase "fromInt(-2)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Bool.fromInt -2) "error"
testCase "fromInt(-1)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Bool.fromInt -1) "error"
testCase "fromInt(2)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Bool.fromInt 2) "error"
testCase "fromInt(Int.maximumValue)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Bool.fromInt Int.maximumValue) "error"
testCase "fromString("true")" 
<| fun _ -> 
    let expected = Some(true)
    Expect.equal expected (Bool.fromString "true") "error"
testCase "fromString("false")" 
<| fun _ -> 
    let expected = Some(false)
    Expect.equal expected (Bool.fromString "false") "error"
testCase "fromString("True")" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Bool.fromString "True") "error"
testCase "fromString("1")" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Bool.fromString "1") "error"
testCase "toInt(true)" 
<| fun _ -> 
    let expected = 1
    Expect.equal expected (Bool.toInt true) "error"
testCase "toInt(false)" 
<| fun _ -> 
    let expected = 0
    Expect.equal expected (Bool.toInt false) "error"
testCase "toString(true)" 
<| fun _ -> 
    let expected = "true"
    Expect.equal expected (Bool.toString true) "error"
testCase "toString(false)" 
<| fun _ -> 
    let expected = "false"
    Expect.equal expected (Bool.toString false) "error"
testCase "xor(true,true)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Bool.xor true true) "error"
testCase "xor(true,false)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Bool.xor true false) "error"
testCase "xor(false,true)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Bool.xor false true) "error"
testCase "xor(false,false)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Bool.xor false false) "error"
]