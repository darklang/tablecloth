open Tablecloth
open AlcoJest

let suite =
 suite "Char" (fun () ->
   let open Char in
test "fromCode(97)" (fun () -> expect (Char.fromCode 97) |> toEqual (let open Eq in option char) Some('a')) ; 
test "fromCode(-1)" (fun () -> expect (Char.fromCode -1) |> toEqual (let open Eq in option char) None) ; 
test "fromCode(256)" (fun () -> expect (Char.fromCode 256) |> toEqual (let open Eq in option char) None) ; 
test "fromString("a")" (fun () -> expect (Char.fromString "a") |> toEqual (let open Eq in option char) Some('a')) ; 
test "fromString("abc")" (fun () -> expect (Char.fromString "abc") |> toEqual (let open Eq in option char) None) ; 
test "fromString("")" (fun () -> expect (Char.fromString "") |> toEqual (let open Eq in option char) None) ; 
test "isAlphanumeric('A')" (fun () -> expect (Char.isAlphanumeric 'A') |> toEqual Eq.bool true) ; 
test "isAlphanumeric('?')" (fun () -> expect (Char.isAlphanumeric '?') |> toEqual Eq.bool false) ; 
test "isDigit('0')" (fun () -> expect (Char.isDigit '0') |> toEqual Eq.bool true) ; 
test "isDigit('1')" (fun () -> expect (Char.isDigit '1') |> toEqual Eq.bool true) ; 
test "isDigit('2')" (fun () -> expect (Char.isDigit '2') |> toEqual Eq.bool true) ; 
test "isDigit('3')" (fun () -> expect (Char.isDigit '3') |> toEqual Eq.bool true) ; 
test "isDigit('4')" (fun () -> expect (Char.isDigit '4') |> toEqual Eq.bool true) ; 
test "isDigit('5')" (fun () -> expect (Char.isDigit '5') |> toEqual Eq.bool true) ; 
test "isDigit('6')" (fun () -> expect (Char.isDigit '6') |> toEqual Eq.bool true) ; 
test "isDigit('7')" (fun () -> expect (Char.isDigit '7') |> toEqual Eq.bool true) ; 
test "isDigit('8')" (fun () -> expect (Char.isDigit '8') |> toEqual Eq.bool true) ; 
test "isDigit('9')" (fun () -> expect (Char.isDigit '9') |> toEqual Eq.bool true) ; 
test "isDigit('a')" (fun () -> expect (Char.isDigit 'a') |> toEqual Eq.bool false) ; 
test "isLetter('A')" (fun () -> expect (Char.isLetter 'A') |> toEqual Eq.bool true) ; 
test "isLetter('7')" (fun () -> expect (Char.isLetter '7') |> toEqual Eq.bool false) ; 
test "isLetter(' ')" (fun () -> expect (Char.isLetter ' ') |> toEqual Eq.bool false) ; 
test "isLetter('\n')" (fun () -> expect (Char.isLetter '\n') |> toEqual Eq.bool false) ; 
test "isLetter('\001')" (fun () -> expect (Char.isLetter '\001') |> toEqual Eq.bool false) ; 
test "isLetter('\236')" (fun () -> expect (Char.isLetter '\236') |> toEqual Eq.bool false) ; 
test "isLowercase('a')" (fun () -> expect (Char.isLowercase 'a') |> toEqual Eq.bool true) ; 
test "isLowercase('7')" (fun () -> expect (Char.isLowercase '7') |> toEqual Eq.bool false) ; 
test "isLowercase('\236')" (fun () -> expect (Char.isLowercase '\236') |> toEqual Eq.bool false) ; 
test "isPrintable('~')" (fun () -> expect (Char.isPrintable '~') |> toEqual Eq.bool true) ; 
test "isUppercase('A')" (fun () -> expect (Char.isUppercase 'A') |> toEqual Eq.bool true) ; 
test "isUppercase('7')" (fun () -> expect (Char.isUppercase '7') |> toEqual Eq.bool false) ; 
test "isUppercase('\237')" (fun () -> expect (Char.isUppercase '\237') |> toEqual Eq.bool false) ; 
test "isWhitespace(' ')" (fun () -> expect (Char.isWhitespace ' ') |> toEqual Eq.bool true) ; 
test "isWhitespace('a')" (fun () -> expect (Char.isWhitespace 'a') |> toEqual Eq.bool false) ; 
test "toCode('a')" (fun () -> expect (Char.toCode 'a') |> toEqual Eq.int 97) ; 
test "toDigit('0')" (fun () -> expect (Char.toDigit '0') |> toEqual (let open Eq in option int) Some(0)) ; 
test "toDigit('8')" (fun () -> expect (Char.toDigit '8') |> toEqual (let open Eq in option int) Some(8)) ; 
test "toDigit('a')" (fun () -> expect (Char.toDigit 'a') |> toEqual (let open Eq in option int) None) ; 
test "toLowercase('A')" (fun () -> expect (Char.toLowercase 'A') |> toEqual Eq.char 'a') ; 
test "toLowercase('a')" (fun () -> expect (Char.toLowercase 'a') |> toEqual Eq.char 'a') ; 
test "toLowercase('7')" (fun () -> expect (Char.toLowercase '7') |> toEqual Eq.char '7') ; 
test "toLowercase('\233')" (fun () -> expect (Char.toLowercase '\233') |> toEqual Eq.char '\233') ; 
test "toString('a')" (fun () -> expect (Char.toString 'a') |> toEqual Eq.string "a") ; 
test "toUppercase('a')" (fun () -> expect (Char.toUppercase 'a') |> toEqual Eq.char 'A') ; 
test "toUppercase('A')" (fun () -> expect (Char.toUppercase 'A') |> toEqual Eq.char 'A') ; 
test "toUppercase('7')" (fun () -> expect (Char.toUppercase '7') |> toEqual Eq.char '7') ; 
test "toUppercase('\233')" (fun () -> expect (Char.toUppercase '\233') |> toEqual Eq.char '\233') ; 
)