test "absolute(8)" (fun () -> expect (Int.absolute 8) |> toEqual Eq.int 8) ; 
test "absolute(-7)" (fun () -> expect (Int.absolute -7) |> toEqual Eq.int 7) ; 
test "absolute(0)" (fun () -> expect (Int.absolute 0) |> toEqual Eq.int 0) ; 
test "add(1,2)" (fun () -> expect (Int.add 1 2) |> toEqual Eq.int 3) ; 
test "add(1,1)" (fun () -> expect (Int.add 1 1) |> toEqual Eq.int 2) ; 
test "clamp(5,0,8)" (fun () -> expect (Int.clamp 5 0 8) |> toEqual Eq.int 5) ; 
test "clamp(9,0,8)" (fun () -> expect (Int.clamp 9 0 8) |> toEqual Eq.int 8) ; 
test "clamp(1,2,8)" (fun () -> expect (Int.clamp 1 2 8) |> toEqual Eq.int 2) ; 
test "clamp(5,-10,-5)" (fun () -> expect (Int.clamp 5 -10 -5) |> toEqual Eq.int -5) ; 
test "clamp(-15,-10,-5)" (fun () -> expect (Int.clamp -15 -10 -5) |> toEqual Eq.int -10) ; 
test "clamp(3,7,1)" (fun () -> expect (fun () -> clamp 3 7 1) |> toThrow); 
test "divideFloat(3,2)" (fun () -> expect (Int.divideFloat 3 2) |> toEqual Eq.float 1.5) ; 
test "divideFloat(27,5)" (fun () -> expect (Int.divideFloat 27 5) |> toEqual Eq.float 5.4) ; 
test "divideFloat(8,4)" (fun () -> expect (Int.divideFloat 8 4) |> toEqual Eq.float 2) ; 
test "divideFloat(8,0)" (fun () -> expect (Int.divideFloat 8 0) |> toEqual Eq.float Float.infinity) ; 
test "divideFloat(-8,0)" (fun () -> expect (Int.divideFloat -8 0) |> toEqual Eq.float Float.negativeInfinity) ; 
test "divide(3,2)" (fun () -> expect (Int.divide 3 2) |> toEqual Eq.int 1) ; 
test "divide(3,0)" (fun () -> expect (fun () -> divide 3 0) |> toThrow); 
test "divide(27,5)" (fun () -> expect (Int.divide 27 5) |> toEqual Eq.int 5) ; 
test "fromString("0")" (fun () -> expect (Int.fromString "0") |> toEqual (let open Eq in option int) Some(0)) ; 
test "fromString("-0")" (fun () -> expect (Int.fromString "-0") |> toEqual (let open Eq in option int) Some(-0)) ; 
test "fromString("42")" (fun () -> expect (Int.fromString "42") |> toEqual (let open Eq in option int) Some(42)) ; 
test "fromString("123_456")" (fun () -> expect (Int.fromString "123_456") |> toEqual (let open Eq in option int) Some(123_456)) ; 
test "fromString("-42")" (fun () -> expect (Int.fromString "-42") |> toEqual (let open Eq in option int) Some(-42)) ; 
test "fromString("0XFF")" (fun () -> expect (Int.fromString "0XFF") |> toEqual (let open Eq in option int) Some(255)) ; 
test "fromString("0X000A")" (fun () -> expect (Int.fromString "0X000A") |> toEqual (let open Eq in option int) Some(10)) ; 
test "fromString("Infinity")" (fun () -> expect (Int.fromString "Infinity") |> toEqual (let open Eq in option int) None) ; 
test "fromString("-Infinity")" (fun () -> expect (Int.fromString "-Infinity") |> toEqual (let open Eq in option int) None) ; 
test "fromString("NaN")" (fun () -> expect (Int.fromString "NaN") |> toEqual (let open Eq in option int) None) ; 
test "fromString("abc")" (fun () -> expect (Int.fromString "abc") |> toEqual (let open Eq in option int) None) ; 
test "fromString("--4")" (fun () -> expect (Int.fromString "--4") |> toEqual (let open Eq in option int) None) ; 
test "fromString(" ")" (fun () -> expect (Int.fromString " ") |> toEqual (let open Eq in option int) None) ; 
test "inRange(3,2,4)" (fun () -> expect (Int.inRange 3 2 4) |> toEqual Eq.bool true) ; 
test "inRange(8,2,4)" (fun () -> expect (Int.inRange 8 2 4) |> toEqual Eq.bool false) ; 
test "inRange(1,2,4)" (fun () -> expect (Int.inRange 1 2 4) |> toEqual Eq.bool false) ; 
test "inRange(2,1,2)" (fun () -> expect (Int.inRange 2 1 2) |> toEqual Eq.bool false) ; 
test "inRange(-6,-7,-5)" (fun () -> expect (Int.inRange -6 -7 -5) |> toEqual Eq.bool true) ; 
test "inRange(3,7,1)" (fun () -> expect (fun () -> inRange 3 7 1) |> toThrow); 
test "isEven(8)" (fun () -> expect (Int.isEven 8) |> toEqual Eq.bool true) ; 
test "isEven(9)" (fun () -> expect (Int.isEven 9) |> toEqual Eq.bool false) ; 
test "isEven(0)" (fun () -> expect (Int.isEven 0) |> toEqual Eq.bool true) ; 
test "isOdd(8)" (fun () -> expect (Int.isOdd 8) |> toEqual Eq.bool false) ; 
test "isOdd(9)" (fun () -> expect (Int.isOdd 9) |> toEqual Eq.bool true) ; 
test "isOdd(0)" (fun () -> expect (Int.isOdd 0) |> toEqual Eq.bool false) ; 
test "maximum(8,18)" (fun () -> expect (Int.maximum 8 18) |> toEqual Eq.int 18) ; 
test "maximum(5,0)" (fun () -> expect (Int.maximum 5 0) |> toEqual Eq.int 5) ; 
test "maximum(-4,-1)" (fun () -> expect (Int.maximum -4 -1) |> toEqual Eq.int -1) ; 
test "minimum(8,18)" (fun () -> expect (Int.minimum 8 18) |> toEqual Eq.int 8) ; 
test "minimum(5,0)" (fun () -> expect (Int.minimum 5 0) |> toEqual Eq.int 0) ; 
test "minimum(-4,-1)" (fun () -> expect (Int.minimum -4 -1) |> toEqual Eq.int -4) ; 
test "modulo(-4,3)" (fun () -> expect (Int.modulo -4 3) |> toEqual Eq.int 2) ; 
test "modulo(-3,3)" (fun () -> expect (Int.modulo -3 3) |> toEqual Eq.int 0) ; 
test "modulo(-2,3)" (fun () -> expect (Int.modulo -2 3) |> toEqual Eq.int 1) ; 
test "modulo(-1,3)" (fun () -> expect (Int.modulo -1 3) |> toEqual Eq.int 2) ; 
test "modulo(0,3)" (fun () -> expect (Int.modulo 0 3) |> toEqual Eq.int 0) ; 
test "modulo(1,3)" (fun () -> expect (Int.modulo 1 3) |> toEqual Eq.int 1) ; 
test "modulo(2,3)" (fun () -> expect (Int.modulo 2 3) |> toEqual Eq.int 2) ; 
test "modulo(3,3)" (fun () -> expect (Int.modulo 3 3) |> toEqual Eq.int 0) ; 
test "modulo(4,3)" (fun () -> expect (Int.modulo 4 3) |> toEqual Eq.int 1) ; 
test "multiply(2,7)" (fun () -> expect (Int.multiply 2 7) |> toEqual Eq.int 14) ; 
test "negate(8)" (fun () -> expect (Int.negate 8) |> toEqual Eq.int -8) ; 
test "negate(-7)" (fun () -> expect (Int.negate -7) |> toEqual Eq.int 7) ; 
test "negate(0)" (fun () -> expect (Int.negate 0) |> toEqual Eq.int 0) ; 
test "power(7,3)" (fun () -> expect (Int.power 7 3) |> toEqual Eq.int 343) ; 
test "power(0,3)" (fun () -> expect (Int.power 0 3) |> toEqual Eq.int 0) ; 
test "power(7,0)" (fun () -> expect (Int.power 7 0) |> toEqual Eq.int 1) ; 
test "remainder(-4,3)" (fun () -> expect (Int.remainder -4 3) |> toEqual Eq.int -1) ; 
test "remainder(-2,3)" (fun () -> expect (Int.remainder -2 3) |> toEqual Eq.int -2) ; 
test "remainder(-1,3)" (fun () -> expect (Int.remainder -1 3) |> toEqual Eq.int -1) ; 
test "remainder(0,3)" (fun () -> expect (Int.remainder 0 3) |> toEqual Eq.int 0) ; 
test "remainder(1,3)" (fun () -> expect (Int.remainder 1 3) |> toEqual Eq.int 1) ; 
test "remainder(2,3)" (fun () -> expect (Int.remainder 2 3) |> toEqual Eq.int 2) ; 
test "remainder(3,3)" (fun () -> expect (Int.remainder 3 3) |> toEqual Eq.int 0) ; 
test "remainder(4,3)" (fun () -> expect (Int.remainder 4 3) |> toEqual Eq.int 1) ; 
test "subtract(4,3)" (fun () -> expect (Int.subtract 4 3) |> toEqual Eq.int 1) ; 
test "toFloat(5)" (fun () -> expect (Int.toFloat 5) |> toEqual Eq.float 5) ; 
test "toFloat(5)" (fun () -> expect (Int.toFloat 5) |> toEqual Eq.float 5.) ; 
test "toFloat(0)" (fun () -> expect (Int.toFloat 0) |> toEqual Eq.float 0.) ; 
test "toFloat(-7)" (fun () -> expect (Int.toFloat -7) |> toEqual Eq.float -7.) ; 
test "toString(1)" (fun () -> expect (Int.toString 1) |> toEqual Eq.string "1") ; 
test "toString(-1)" (fun () -> expect (Int.toString -1) |> toEqual Eq.string "-1") ; 
