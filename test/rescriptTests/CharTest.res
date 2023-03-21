open Tablecloth
open AlcoJest

let suite= suite("Char", () => {
   open Char
test ("fromCode(97)", () => expect(Char.fromCode(97)) |> toEqual({open Eq
option(char)}, Some('a'))) 
test ("fromCode(-1)", () => expect(Char.fromCode(-1)) |> toEqual({open Eq
option(char)}, None)) 
test ("fromCode(256)", () => expect(Char.fromCode(256)) |> toEqual({open Eq
option(char)}, None)) 
test ("fromString(a)", () => expect(Char.fromString("a")) |> toEqual({open Eq
option(char)}, Some('a'))) 
test ("fromString(abc)", () => expect(Char.fromString("abc")) |> toEqual({open Eq
option(char)}, None)) 
test ("fromString()", () => expect(Char.fromString("")) |> toEqual({open Eq
option(char)}, None)) 
test ("isAlphanumeric('A')", () => expect(Char.isAlphanumeric('A')) |> toEqual(Eq.bool, true)) 
test ("isAlphanumeric('?')", () => expect(Char.isAlphanumeric('?')) |> toEqual(Eq.bool, false)) 
test ("isDigit('0')", () => expect(Char.isDigit('0')) |> toEqual(Eq.bool, true)) 
test ("isDigit('1')", () => expect(Char.isDigit('1')) |> toEqual(Eq.bool, true)) 
test ("isDigit('2')", () => expect(Char.isDigit('2')) |> toEqual(Eq.bool, true)) 
test ("isDigit('3')", () => expect(Char.isDigit('3')) |> toEqual(Eq.bool, true)) 
test ("isDigit('4')", () => expect(Char.isDigit('4')) |> toEqual(Eq.bool, true)) 
test ("isDigit('5')", () => expect(Char.isDigit('5')) |> toEqual(Eq.bool, true)) 
test ("isDigit('6')", () => expect(Char.isDigit('6')) |> toEqual(Eq.bool, true)) 
test ("isDigit('7')", () => expect(Char.isDigit('7')) |> toEqual(Eq.bool, true)) 
test ("isDigit('8')", () => expect(Char.isDigit('8')) |> toEqual(Eq.bool, true)) 
test ("isDigit('9')", () => expect(Char.isDigit('9')) |> toEqual(Eq.bool, true)) 
test ("isDigit('a')", () => expect(Char.isDigit('a')) |> toEqual(Eq.bool, false)) 
test ("isLetter('A')", () => expect(Char.isLetter('A')) |> toEqual(Eq.bool, true)) 
test ("isLetter('7')", () => expect(Char.isLetter('7')) |> toEqual(Eq.bool, false)) 
test ("isLetter(' ')", () => expect(Char.isLetter(' ')) |> toEqual(Eq.bool, false)) 
test ("isLetter('\n')", () => expect(Char.isLetter('\n')) |> toEqual(Eq.bool, false)) 
test ("isLetter('\001')", () => expect(Char.isLetter('\001')) |> toEqual(Eq.bool, false)) 
test ("isLetter('\236')", () => expect(Char.isLetter('\236')) |> toEqual(Eq.bool, false)) 
test ("isLowercase('a')", () => expect(Char.isLowercase('a')) |> toEqual(Eq.bool, true)) 
test ("isLowercase('7')", () => expect(Char.isLowercase('7')) |> toEqual(Eq.bool, false)) 
test ("isLowercase('\236')", () => expect(Char.isLowercase('\236')) |> toEqual(Eq.bool, false)) 
test ("isPrintable('~')", () => expect(Char.isPrintable('~')) |> toEqual(Eq.bool, true)) 
test ("isUppercase('A')", () => expect(Char.isUppercase('A')) |> toEqual(Eq.bool, true)) 
test ("isUppercase('7')", () => expect(Char.isUppercase('7')) |> toEqual(Eq.bool, false)) 
test ("isUppercase('\237')", () => expect(Char.isUppercase('\237')) |> toEqual(Eq.bool, false)) 
test ("isWhitespace(' ')", () => expect(Char.isWhitespace(' ')) |> toEqual(Eq.bool, true)) 
test ("isWhitespace('a')", () => expect(Char.isWhitespace('a')) |> toEqual(Eq.bool, false)) 
test ("toCode('a')", () => expect(Char.toCode('a')) |> toEqual(Eq.int, 97)) 
test ("toDigit('0')", () => expect(Char.toDigit('0')) |> toEqual({open Eq
option(int)}, Some(0))) 
test ("toDigit('8')", () => expect(Char.toDigit('8')) |> toEqual({open Eq
option(int)}, Some(8))) 
test ("toDigit('a')", () => expect(Char.toDigit('a')) |> toEqual({open Eq
option(int)}, None)) 
test ("toLowercase('A')", () => expect(Char.toLowercase('A')) |> toEqual(Eq.char, 'a')) 
test ("toLowercase('a')", () => expect(Char.toLowercase('a')) |> toEqual(Eq.char, 'a')) 
test ("toLowercase('7')", () => expect(Char.toLowercase('7')) |> toEqual(Eq.char, '7')) 
test ("toLowercase('\233')", () => expect(Char.toLowercase('\233')) |> toEqual(Eq.char, '\233')) 
test ("toString('a')", () => expect(Char.toString('a')) |> toEqual(Eq.string, "a")) 
test ("toUppercase('a')", () => expect(Char.toUppercase('a')) |> toEqual(Eq.char, 'A')) 
test ("toUppercase('A')", () => expect(Char.toUppercase('A')) |> toEqual(Eq.char, 'A')) 
test ("toUppercase('7')", () => expect(Char.toUppercase('7')) |> toEqual(Eq.char, '7')) 
test ("toUppercase('\233')", () => expect(Char.toUppercase('\233')) |> toEqual(Eq.char, '\233')) 
})