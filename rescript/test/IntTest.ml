open Tablecloth
open AlcoJest

let suite =
  suite "Int" (fun () ->
      test "zero" (fun () -> expect Int.zero |> toEqual Eq.int 0) ;
      test "one" (fun () -> expect Int.one |> toEqual Eq.int 1) ;
      test "minimumValue" (fun () ->
          expect (Int.minimumValue - 1) |> toEqual Eq.int Int.maximumValue ) ;
      test "maximumValue" (fun () ->
          expect (Int.maximumValue + 1) |> toEqual Eq.int Int.minimumValue ) ;
      describe "add" (fun () ->
          test "add" (fun () ->
              expect (Int.add 3002 4004) |> toEqual Eq.int 7006 ) ) ;
      describe "subtract" (fun () ->
          test "subtract" (fun () ->
              expect (Int.subtract 4 3) |> toEqual Eq.int 1 ) ) ;
      describe "multiply" (fun () ->
          test "multiply" (fun () ->
              expect (Int.multiply 2 7) |> toEqual Eq.int 14 ) ) ;
      describe "divide" (fun () ->
          test "divide" (fun () ->
              expect (Int.divide 3 ~by:2) |> toEqual Eq.int 1 ) ;
          test "division by zero" (fun () ->
              expect (fun () -> Int.divide 3 ~by:0) |> toThrow ) ;
          test "divide" (fun () ->
              expect
                (let open Int in
                divide 27 ~by:5)
              |> toEqual Eq.int 5 ) ;
          test "divideFloat" (fun () ->
              expect
                (let open Int in
                divideFloat 3 ~by:2)
              |> toEqual Eq.float 1.5 ) ;
          test "divideFloat" (fun () ->
              expect
                (let open Int in
                divideFloat 27 ~by:5)
              |> toEqual Eq.float 5.4 ) ;
          test "divideFloat" (fun () ->
              expect
                (let open Int in
                divideFloat 8 ~by:4)
              |> toEqual Eq.float 2.0 ) ;
          test "divideFloat by 0" (fun () ->
              expect
                ( (let open Int in
                  divideFloat 8 ~by:0)
                = Float.infinity )
              |> toEqual Eq.bool true ) ;
          test "divideFloat 0" (fun () ->
              expect
                ( (let open Int in
                  divideFloat (-8) ~by:0)
                = Float.negativeInfinity )
              |> toEqual Eq.bool true ) ) ;
      describe "power" (fun () ->
          test "power" (fun () ->
              expect (Int.power ~base:7 ~exponent:3) |> toEqual Eq.int 343 ) ;
          test "0 base" (fun () ->
              expect (Int.power ~base:0 ~exponent:3) |> toEqual Eq.int 0 ) ;
          test "0 exponent" (fun () ->
              expect (Int.power ~base:7 ~exponent:0) |> toEqual Eq.int 1 ) ) ;
      describe "negate" (fun () ->
          test "positive number" (fun () ->
              expect (Int.negate 8) |> toEqual Eq.int (-8) ) ;
          test "negative number" (fun () ->
              expect (Int.negate (-7)) |> toEqual Eq.int 7 ) ;
          test "zero" (fun () -> expect (Int.negate 0) |> toEqual Eq.int (-0)) ) ;
      describe "modulo" (fun () ->
          test "documentation examples" (fun () ->
              expect
                (Array.map
                   [| -4; -3; -2; -1; 0; 1; 2; 3; 4 |]
                   ~f:(Int.modulo ~by:3) )
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 2; 0; 1; 2; 0; 1; 2; 0; 1 |] ) ) ;
      describe "remainder" (fun () ->
          test "documentation examples" (fun () ->
              expect
                (Array.map
                   [| -4; -2; -1; 0; 1; 2; 3; 4 |]
                   ~f:(Int.remainder ~by:3) )
              |> toEqual
                   (let open Eq in
                   array int)
                   [| -1; -2; -1; 0; 1; 2; 0; 1 |] ) ) ;
      describe "absolute" (fun () ->
          test "positive number" (fun () ->
              expect (Int.absolute 8) |> toEqual Eq.int 8 ) ;
          test "negative number" (fun () ->
              expect (Int.absolute (-7)) |> toEqual Eq.int 7 ) ;
          test "zero" (fun () -> expect (Int.absolute 0) |> toEqual Eq.int 0) ) ;

      describe "minimum" (fun () ->
          test "positive numbers" (fun () ->
              expect (Int.minimum 8 18) |> toEqual Eq.int 8 ) ;
          test "with zero" (fun () ->
              expect (Int.minimum 5 0) |> toEqual Eq.int 0 ) ;
          test "negative numbers" (fun () ->
              expect (Int.minimum (-4) (-1)) |> toEqual Eq.int (-4) ) ) ;

      describe "maximum" (fun () ->
          test "positive numbers" (fun () ->
              expect (Int.maximum 8 18) |> toEqual Eq.int 18 ) ;
          test "with zero" (fun () ->
              expect (Int.maximum 5 0) |> toEqual Eq.int 5 ) ;
          test "negative numbers" (fun () ->
              expect (Int.maximum (-4) (-1)) |> toEqual Eq.int (-1) ) ) ;

      describe "isEven" (fun () ->
          test "even number" (fun () ->
              expect (Int.isEven 8) |> toEqual Eq.bool true ) ;
          test "odd number" (fun () ->
              expect (Int.isEven 9) |> toEqual Eq.bool false ) ;
          test "zero even" (fun () ->
              expect (Int.isEven 0) |> toEqual Eq.bool true ) ) ;

      describe "isOdd" (fun () ->
          test "even number" (fun () ->
              expect (Int.isOdd 8) |> toEqual Eq.bool false ) ;
          test "odd number" (fun () ->
              expect (Int.isOdd 9) |> toEqual Eq.bool true ) ;
          test "zero even" (fun () ->
              expect (Int.isOdd 0) |> toEqual Eq.bool false ) ) ;

      describe "clamp" (fun () ->
          test "in range" (fun () ->
              expect (Int.clamp ~lower:0 ~upper:8 5) |> toEqual Eq.int 5 ) ;
          test "above range" (fun () ->
              expect (Int.clamp ~lower:0 ~upper:8 9) |> toEqual Eq.int 8 ) ;
          test "below range" (fun () ->
              expect (Int.clamp ~lower:2 ~upper:8 1) |> toEqual Eq.int 2 ) ;
          test "above negative range" (fun () ->
              expect (Int.clamp ~lower:(-10) ~upper:(-5) 5)
              |> toEqual Eq.int (-5) ) ;
          test "below negative range" (fun () ->
              expect (Int.clamp ~lower:(-10) ~upper:(-5) (-15))
              |> toEqual Eq.int (-10) ) ;
          test "invalid arguments" (fun () ->
              expect (fun () -> Int.clamp ~lower:7 ~upper:1 3) |> toThrow ) ) ;
      describe "inRange" (fun () ->
          test "in range" (fun () ->
              expect (Int.inRange ~lower:2 ~upper:4 3) |> toEqual Eq.bool true ) ;
          test "above range" (fun () ->
              expect (Int.inRange ~lower:2 ~upper:4 8) |> toEqual Eq.bool false ) ;
          test "below range" (fun () ->
              expect (Int.inRange ~lower:2 ~upper:4 1) |> toEqual Eq.bool false ) ;
          test "equal to ~upper" (fun () ->
              expect (Int.inRange ~lower:1 ~upper:2 2) |> toEqual Eq.bool false ) ;
          test "negative range" (fun () ->
              expect (Int.inRange ~lower:(-7) ~upper:(-5) (-6))
              |> toEqual Eq.bool true ) ;
          test "invalid arguments" (fun () ->
              expect (fun () -> Int.inRange ~lower:7 ~upper:1 3) |> toThrow ) ) ;
      describe "toFloat" (fun () ->
          test "5" (fun () -> expect (Int.toFloat 5) |> toEqual Eq.float 5.) ;
          test "0" (fun () -> expect (Int.toFloat 0) |> toEqual Eq.float 0.) ;
          test "-7" (fun () ->
              expect (Int.toFloat (-7)) |> toEqual Eq.float (-7.) ) ) ;
      describe "fromString" (fun () ->
          test "0" (fun () ->
              expect (Int.fromString "0")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 0) ) ;
          test "-0" (fun () ->
              expect (Int.fromString "-0")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some (-0)) ) ;
          test "42" (fun () ->
              expect (Int.fromString "42")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 42) ) ;
          test "123_456" (fun () ->
              expect (Int.fromString "123_456")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 123_456) ) ;
          test "-42" (fun () ->
              expect (Int.fromString "-42")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some (-42)) ) ;
          test "0XFF" (fun () ->
              expect (Int.fromString "0XFF")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 255) ) ;
          test "0X000A" (fun () ->
              expect (Int.fromString "0X000A")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 10) ) ;
          test "Infinity" (fun () ->
              expect (Int.fromString "Infinity")
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "-Infinity" (fun () ->
              expect (Int.fromString "-Infinity")
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "NaN" (fun () ->
              expect (Int.fromString "NaN")
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "abc" (fun () ->
              expect (Int.fromString "abc")
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "--4" (fun () ->
              expect (Int.fromString "--4")
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "empty string" (fun () ->
              expect (Int.fromString " ")
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;
      describe "toString" (fun () ->
          test "positive number" (fun () ->
              expect (Int.toString 1) |> toEqual Eq.string "1" ) ;
          test "negative number" (fun () ->
              expect (Int.toString (-1)) |> toEqual Eq.string "-1" ) ) )
