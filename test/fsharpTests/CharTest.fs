open Tablecloth
open Expecto

[<Tests>]
let tests =
  testList
  "Char"
[testCase "fromCode(97)" 
<| fun _ -> 
    let expected = Some('a')
    Expect.equal expected (Char.fromCode 97) "error"
testCase "fromCode(-1)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Char.fromCode -1) "error"
testCase "fromCode(256)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Char.fromCode 256) "error"
testCase "fromString("a")" 
<| fun _ -> 
    let expected = Some('a')
    Expect.equal expected (Char.fromString "a") "error"
testCase "fromString("abc")" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Char.fromString "abc") "error"
testCase "fromString("")" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Char.fromString "") "error"
testCase "isAlphanumeric('A')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isAlphanumeric 'A') "error"
testCase "isAlphanumeric('?')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isAlphanumeric '?') "error"
testCase "isDigit('0')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '0') "error"
testCase "isDigit('1')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '1') "error"
testCase "isDigit('2')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '2') "error"
testCase "isDigit('3')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '3') "error"
testCase "isDigit('4')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '4') "error"
testCase "isDigit('5')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '5') "error"
testCase "isDigit('6')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '6') "error"
testCase "isDigit('7')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '7') "error"
testCase "isDigit('8')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '8') "error"
testCase "isDigit('9')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isDigit '9') "error"
testCase "isDigit('a')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isDigit 'a') "error"
testCase "isLetter('A')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isLetter 'A') "error"
testCase "isLetter('7')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isLetter '7') "error"
testCase "isLetter(' ')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isLetter ' ') "error"
testCase "isLetter('\n')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isLetter '\n') "error"
testCase "isLetter('\001')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isLetter '\001') "error"
testCase "isLetter('\236')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isLetter '\236') "error"
testCase "isLowercase('a')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isLowercase 'a') "error"
testCase "isLowercase('7')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isLowercase '7') "error"
testCase "isLowercase('\236')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isLowercase '\236') "error"
testCase "isPrintable('~')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isPrintable '~') "error"
testCase "isPrintable(fromCode(31) |> Option.map(~f=isPrintable))" 
<| fun _ -> 
    let expected = Some(false)
    Expect.equal expected (Char.isPrintable fromCode(31) |> Option.map(~f=isPrintable)) "error"
testCase "isUppercase('A')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isUppercase 'A') "error"
testCase "isUppercase('7')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isUppercase '7') "error"
testCase "isUppercase('\237')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isUppercase '\237') "error"
testCase "isWhitespace(' ')" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Char.isWhitespace ' ') "error"
testCase "isWhitespace('a')" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Char.isWhitespace 'a') "error"
testCase "toCode('a')" 
<| fun _ -> 
    let expected = 97
    Expect.equal expected (Char.toCode 'a') "error"
testCase "toDigit('0')" 
<| fun _ -> 
    let expected = Some(0)
    Expect.equal expected (Char.toDigit '0') "error"
testCase "toDigit('8')" 
<| fun _ -> 
    let expected = Some(8)
    Expect.equal expected (Char.toDigit '8') "error"
testCase "toDigit('a')" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Char.toDigit 'a') "error"
testCase "toLowercase('A')" 
<| fun _ -> 
    let expected = 'a'
    Expect.equal expected (Char.toLowercase 'A') "error"
testCase "toLowercase('a')" 
<| fun _ -> 
    let expected = 'a'
    Expect.equal expected (Char.toLowercase 'a') "error"
testCase "toLowercase('7')" 
<| fun _ -> 
    let expected = '7'
    Expect.equal expected (Char.toLowercase '7') "error"
testCase "toLowercase('\233')" 
<| fun _ -> 
    let expected = '\233'
    Expect.equal expected (Char.toLowercase '\233') "error"
testCase "toString('a')" 
<| fun _ -> 
    let expected = "a"
    Expect.equal expected (Char.toString 'a') "error"
testCase "toUppercase('a')" 
<| fun _ -> 
    let expected = 'A'
    Expect.equal expected (Char.toUppercase 'a') "error"
testCase "toUppercase('A')" 
<| fun _ -> 
    let expected = 'A'
    Expect.equal expected (Char.toUppercase 'A') "error"
testCase "toUppercase('7')" 
<| fun _ -> 
    let expected = '7'
    Expect.equal expected (Char.toUppercase '7') "error"
testCase "toUppercase('\233')" 
<| fun _ -> 
    let expected = '\233'
    Expect.equal expected (Char.toUppercase '\233') "error"
]