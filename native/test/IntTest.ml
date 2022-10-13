open Tablecloth
open AlcoJest

let suite =
  suite "Int" (fun () ->
      test "zero" (fun () -> expect Int.zero |> toEqual Eq.int 0) ;
      test "one" (fun () -> expect Int.one |> toEqual Eq.int 1) ;
      test "minimum_value" (fun () ->
          expect (Int.minimum_value - 1) |> toEqual Eq.int Int.maximum_value ) ;
      test "maximum_value" (fun () ->
          expect (Int.maximum_value + 1) |> toEqual Eq.int Int.minimum_value ) ;
      describe "add" (fun () ->
          test "add" (fun () ->
              expect (Int.add 3002 4004) |> toEqual Eq.int 7006 ) ;
          test "+" (fun () ->
              expect
                (let open Int in
                3002 + 4004)
              |> toEqual Eq.int 7006 ) ) ;
      describe "subtract" (fun () ->
          test "subtract" (fun () ->
              expect (Int.subtract 4 3) |> toEqual Eq.int 1 ) ;
          test "-" (fun () ->
              expect
                (let open Int in
                4 - 3)
              |> toEqual Eq.int 1 ) ) ;
      describe "multiply" (fun () ->
          test "multiply" (fun () ->
              expect (Int.multiply 2 7) |> toEqual Eq.int 14 ) ;
          test "*" (fun () ->
              expect
                (let open Int in
                2 * 7)
              |> toEqual Eq.int 14 ) ) ;
      describe "divide" (fun () ->
          test "divide" (fun () ->
              expect (Int.divide 3 ~by:2) |> toEqual Eq.int 1 ) ;
          test "division by zero" (fun () ->
              expect (fun () -> Int.divide 3 ~by:0) |> toThrow ) ;
          test "/" (fun () ->
              expect
                (let open Int in
                27 / 5)
              |> toEqual Eq.int 5 ) ;
          test "/." (fun () ->
              expect
                (let open Int in
                3 /. 2)
              |> toEqual Eq.float 1.5 ) ;
          test "/." (fun () ->
              expect
                (let open Int in
                27 /. 5)
              |> toEqual Eq.float 5.4 ) ;
          test "/." (fun () ->
              expect
                (let open Int in
                8 /. 4)
              |> toEqual Eq.float 2.0 ) ;
          test "x /. 0" (fun () ->
              expect
                ( (let open Int in
                  8 /. 0)
                = Float.infinity )
              |> toEqual Eq.bool true ) ;
          test "-x /. 0" (fun () ->
              expect
                ( (let open Int in
                  -8 /. 0)
                = Float.negative_infinity )
              |> toEqual Eq.bool true ) ) ;
      describe "power" (fun () ->
          test "power" (fun () ->
              expect (Int.power ~base:7 ~exponent:3) |> toEqual Eq.int 343 ) ;
          test "0 base" (fun () ->
              expect (Int.power ~base:0 ~exponent:3) |> toEqual Eq.int 0 ) ;
          test "0 exponent" (fun () ->
              expect (Int.power ~base:7 ~exponent:0) |> toEqual Eq.int 1 ) ;
          test "**" (fun () ->
              expect
                (let open Int in
                7 ** 3)
              |> toEqual Eq.int 343 ) ) ;
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
                   [| 2; 0; 1; 2; 0; 1; 2; 0; 1 |] ) ;
          test "mod operator" (fun () ->
              expect
                (Array.map [| -4; -2; -1; 0; 1; 2; 3; 4 |] ~f:(fun n ->
                     let open Int in
                     n mod 3 ) )
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 2; 1; 2; 0; 1; 2; 0; 1 |] ) ) ;
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
      describe "in_range" (fun () ->
          test "in range" (fun () ->
              expect (Int.in_range ~lower:2 ~upper:4 3) |> toEqual Eq.bool true ) ;
          test "above range" (fun () ->
              expect (Int.in_range ~lower:2 ~upper:4 8) |> toEqual Eq.bool false ) ;
          test "below range" (fun () ->
              expect (Int.in_range ~lower:2 ~upper:4 1) |> toEqual Eq.bool false ) ;
          test "equal to ~upper" (fun () ->
              expect (Int.in_range ~lower:1 ~upper:2 2) |> toEqual Eq.bool false ) ;
          test "negative range" (fun () ->
              expect (Int.in_range ~lower:(-7) ~upper:(-5) (-6))
              |> toEqual Eq.bool true ) ;
          test "invalid arguments" (fun () ->
              expect (fun () -> Int.in_range ~lower:7 ~upper:1 3) |> toThrow ) ) ;
      describe "to_float" (fun () ->
          test "5" (fun () -> expect (Int.to_float 5) |> toEqual Eq.float 5.) ;
          test "0" (fun () -> expect (Int.to_float 0) |> toEqual Eq.float 0.) ;
          test "-7" (fun () ->
              expect (Int.to_float (-7)) |> toEqual Eq.float (-7.) ) ) ;
      describe "from_string" (fun () ->
          test "0" (fun () ->
              expect (Int.from_string "0")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 0) ) ;
          test "-0" (fun () ->
              expect (Int.from_string "-0")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some (-0)) ) ;
          test "42" (fun () ->
              expect (Int.from_string "42")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 42) ) ;
          test "123_456" (fun () ->
              expect (Int.from_string "123_456")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 123_456) ) ;
          test "-42" (fun () ->
              expect (Int.from_string "-42")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some (-42)) ) ;
          test "0XFF" (fun () ->
              expect (Int.from_string "0XFF")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 255) ) ;
          test "0X000A" (fun () ->
              expect (Int.from_string "0X000A")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 10) ) ;
          test "Infinity" (fun () ->
              expect (Int.from_string "Infinity")
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "-Infinity" (fun () ->
              expect (Int.from_string "-Infinity")
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "NaN" (fun () ->
              expect (Int.from_string "NaN")
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "abc" (fun () ->
              expect (Int.from_string "abc")
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "--4" (fun () ->
              expect (Int.from_string "--4")
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "empty string" (fun () ->
              expect (Int.from_string " ")
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;
      describe "to_string" (fun () ->
          test "positive number" (fun () ->
              expect (Int.to_string 1) |> toEqual Eq.string "1" ) ;
          test "negative number" (fun () ->
              expect (Int.to_string (-1)) |> toEqual Eq.string "-1" ) ) )
