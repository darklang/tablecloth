open AlcoJest

let suite =
  suite "Float" (fun () ->
      let open Tablecloth.Float in
      test "zero" (fun () -> expect zero |> toEqual Eq.float 0.) ;
      test "one" (fun () -> expect one |> toEqual Eq.float 1.) ;
      test "nan" (fun () -> expect (nan = nan) |> toEqual Eq.bool false) ;
      test "infinity" (fun () ->
          expect (infinity *. 2. = infinity) |> toEqual Eq.bool true ) ;
      test "negativeInfinity" (fun () ->
          expect (negativeInfinity *. 2. = negativeInfinity)
          |> toEqual Eq.bool true ) ;
      describe "equals" (fun () ->
          test "zero" (fun () -> expect (0. = -0.) |> toEqual Eq.bool true) ) ;
      describe "fromString" (fun () ->
          test "NaN" (fun () ->
              expect (fromString "NaN")
              |> toEqual
                   (let open Eq in
                   option float)
                   (Some Js.Float._NaN) ) ;
          test "nan" (fun () ->
              expect (fromString "nan")
              |> toEqual
                   (let open Eq in
                   option float)
                   (Some Js.Float._NaN) ) ;
          test "Infinity" (fun () ->
              expect (fromString "Infinity")
              |> toEqual
                   (let open Eq in
                   option float)
                   (Some infinity) ) ;
          test "infinity" (fun () ->
              expect (fromString "infinity")
              |> toEqual
                   (let open Eq in
                   option float)
                   None ) ;

          test "infinity" (fun () ->
              expect (fromString "infinity")
              |> toEqual
                   (let open Eq in
                   option float)
                   None ) ;
          test "55" (fun () ->
              expect (fromString "55")
              |> toEqual
                   (let open Eq in
                   option float)
                   (Some 55.) ) ;
          test "-100" (fun () ->
              expect (fromString "-100")
              |> toEqual
                   (let open Eq in
                   option float)
                   (Some (-100.)) ) ;
          test "not number" (fun () ->
              expect (fromString "not number")
              |> toEqual
                   (let open Eq in
                   option float)
                   None ) ) ;
      describe "add" (fun () ->
          test "add" (fun () ->
              expect (add 3.14 3.14) |> toEqual Eq.float 6.28 ) ) ;
      describe "subtract" (fun () ->
          test "subtract" (fun () ->
              expect (subtract 4. 3.) |> toEqual Eq.float 1. ) ) ;
      describe "multiply" (fun () ->
          test "multiply" (fun () ->
              expect (multiply 2. 7.) |> toEqual Eq.float 14. ) ) ;
      describe "divide" (fun () ->
          test "divide" (fun () ->
              expect (divide 3.14 ~by:2.) |> toEqual Eq.float 1.57 ) ;
          test "divide by zero" (fun () ->
              expect (divide 3.14 ~by:0. = infinity) |> toEqual Eq.bool true ) ;
          test "divide by negative zero" (fun () ->
              expect (divide 3.14 ~by:(-0.) = negativeInfinity)
              |> toEqual Eq.bool true ) ) ;
      describe "power" (fun () ->
          test "power" (fun () ->
              expect (power ~base:7. ~exponent:3.) |> toEqual Eq.float 343. ) ;
          test "0 base" (fun () ->
              expect (power ~base:0. ~exponent:3.) |> toEqual Eq.float 0. ) ;
          test "0 exponent" (fun () ->
              expect (power ~base:7. ~exponent:0.) |> toEqual Eq.float 1. ) ) ;
      describe "negate" (fun () ->
          test "positive number" (fun () ->
              expect (negate 8.) |> toEqual Eq.float (-8.) ) ;
          test "negative number" (fun () ->
              expect (negate (-7.)) |> toEqual Eq.float 7. ) ;
          test "zero" (fun () -> expect (negate 0.) |> toEqual Eq.float (-0.)) ) ;
      describe "absolute" (fun () ->
          test "positive number" (fun () ->
              expect (absolute 8.) |> toEqual Eq.float 8. ) ;
          test "negative number" (fun () ->
              expect (absolute (-7.)) |> toEqual Eq.float 7. ) ;
          test "zero" (fun () -> expect (absolute 0.) |> toEqual Eq.float 0.) ) ;
      describe "maximum" (fun () ->
          test "positive numbers" (fun () ->
              expect (maximum 7. 9.) |> toEqual Eq.float 9. ) ;
          test "negative numbers" (fun () ->
              expect (maximum (-4.) (-1.)) |> toEqual Eq.float (-1.) ) ;
          test "nan" (fun () ->
              expect (maximum 7. nan |> isNaN) |> toEqual Eq.bool true ) ;
          test "infinity" (fun () ->
              expect (maximum 7. infinity = infinity) |> toEqual Eq.bool true ) ;
          test "negativeInfinity" (fun () ->
              expect (maximum 7. negativeInfinity) |> toEqual Eq.float 7. ) ) ;
      describe "minimum" (fun () ->
          test "positive numbers" (fun () ->
              expect (minimum 7. 9.) |> toEqual Eq.float 7. ) ;
          test "negative numbers" (fun () ->
              expect (minimum (-4.) (-1.)) |> toEqual Eq.float (-4.) ) ;
          test "nan" (fun () ->
              expect (minimum 7. nan |> isNaN) |> toEqual Eq.bool true ) ;
          test "infinity" (fun () ->
              expect (minimum 7. infinity) |> toEqual Eq.float 7. ) ;
          test "negativeInfinity" (fun () ->
              expect (minimum 7. negativeInfinity = negativeInfinity)
              |> toEqual Eq.bool true ) ) ;
      describe "clamp" (fun () ->
          test "in range" (fun () ->
              expect (clamp ~lower:0. ~upper:8. 5.) |> toEqual Eq.float 5. ) ;
          test "above range" (fun () ->
              expect (clamp ~lower:0. ~upper:8. 9.) |> toEqual Eq.float 8. ) ;
          test "below range" (fun () ->
              expect (clamp ~lower:2. ~upper:8. 1.) |> toEqual Eq.float 2. ) ;
          test "above negative range" (fun () ->
              expect (clamp ~lower:(-10.) ~upper:(-5.) 5.)
              |> toEqual Eq.float (-5.) ) ;
          test "below negative range" (fun () ->
              expect (clamp ~lower:(-10.) ~upper:(-5.) (-15.))
              |> toEqual Eq.float (-10.) ) ;
          test "nan upper bound" (fun () ->
              expect (clamp ~lower:(-7.9) ~upper:nan (-6.6) |> isNaN)
              |> toEqual Eq.bool true ) ;
          test "nan lower bound" (fun () ->
              expect (clamp ~lower:nan ~upper:0. (-6.6) |> isNaN)
              |> toEqual Eq.bool true ) ;
          test "nan value" (fun () ->
              expect (clamp ~lower:2. ~upper:8. nan |> isNaN)
              |> toEqual Eq.bool true ) ;
          test "invalid arguments" (fun () ->
              expect (fun () -> clamp ~lower:7. ~upper:1. 3.) |> toThrow ) ) ;
      describe "squareRoot" (fun () ->
          test "whole numbers" (fun () ->
              expect (squareRoot 4.) |> toEqual Eq.float 2. ) ;
          test "decimal numbers" (fun () ->
              expect (squareRoot 20.25) |> toEqual Eq.float 4.5 ) ;
          test "negative number" (fun () ->
              expect (squareRoot (-1.) |> isNaN) |> toEqual Eq.bool true ) ) ;
      describe "log" (fun () ->
          test "base 10" (fun () ->
              expect (log ~base:10. 100.) |> toEqual Eq.float 2. ) ;
          test "base 2" (fun () ->
              expect (log ~base:2. 256.) |> toEqual Eq.float 8. ) ;
          test "of zero" (fun () ->
              expect (log ~base:10. 0. = negativeInfinity)
              |> toEqual Eq.bool true ) ) ;
      describe "isNaN" (fun () ->
          test "nan" (fun () -> expect (isNaN nan) |> toEqual Eq.bool true) ;
          test "non-nan" (fun () ->
              expect (isNaN 91.4) |> toEqual Eq.bool false ) ) ;
      describe "isFinite" (fun () ->
          test "infinity" (fun () ->
              expect (isFinite infinity) |> toEqual Eq.bool false ) ;
          test "negative infinity" (fun () ->
              expect (isFinite negativeInfinity) |> toEqual Eq.bool false ) ;
          test "NaN" (fun () -> expect (isFinite nan) |> toEqual Eq.bool false) ;
          testAll "regular numbers" [ -5.; -0.314; 0.; 3.14 ] (fun n ->
              expect (isFinite n) |> toEqual Eq.bool true ) ) ;
      describe "isInfinite" (fun () ->
          test "infinity" (fun () ->
              expect (isInfinite infinity) |> toEqual Eq.bool true ) ;
          test "negative infinity" (fun () ->
              expect (isInfinite negativeInfinity) |> toEqual Eq.bool true ) ;
          test "NaN" (fun () ->
              expect (isInfinite nan) |> toEqual Eq.bool false ) ;
          testAll "regular numbers" [ -5.; -0.314; 0.; 3.14 ] (fun n ->
              expect (isInfinite n) |> toEqual Eq.bool false ) ) ;
      describe "inRange" (fun () ->
          test "in range" (fun () ->
              expect (inRange ~lower:2. ~upper:4. 3.) |> toEqual Eq.bool true ) ;
          test "above range" (fun () ->
              expect (inRange ~lower:2. ~upper:4. 8.) |> toEqual Eq.bool false ) ;
          test "below range" (fun () ->
              expect (inRange ~lower:2. ~upper:4. 1.) |> toEqual Eq.bool false ) ;
          test "equal to ~upper" (fun () ->
              expect (inRange ~lower:1. ~upper:2. 2.) |> toEqual Eq.bool false ) ;
          test "negative range" (fun () ->
              expect (inRange ~lower:(-7.9) ~upper:(-5.2) (-6.6))
              |> toEqual Eq.bool true ) ;
          test "nan upper bound" (fun () ->
              expect (inRange ~lower:(-7.9) ~upper:nan (-6.6))
              |> toEqual Eq.bool false ) ;
          test "nan lower bound" (fun () ->
              expect (inRange ~lower:nan ~upper:0. (-6.6))
              |> toEqual Eq.bool false ) ;
          test "nan value" (fun () ->
              expect (inRange ~lower:2. ~upper:8. nan) |> toEqual Eq.bool false ) ;
          test "invalid arguments" (fun () ->
              expect (fun () -> inRange ~lower:7. ~upper:1. 3.) |> toThrow ) ) ;
      test "hypotenuse" (fun () ->
          expect (hypotenuse 3. 4.) |> toEqual Eq.float 5. ) ;
      test "degrees" (fun () -> expect (degrees 180.) |> toEqual Eq.float pi) ;
      test "radians" (fun () -> expect (radians pi) |> toEqual Eq.float pi) ;
      test "turns" (fun () -> expect (turns 1.) |> toEqual Eq.float (2. *. pi)) ;
      describe "ofPolar" (fun () ->
          let x, y = fromPolar (squareRoot 2., degrees 45.) in
          test "x" (fun () -> expect x |> toBeCloseTo 1.) ;
          test "y" (fun () -> expect y |> toEqual Eq.float 1.) ) ;
      describe "toPolar" (fun () ->
          test "toPolar" (fun () ->
              expect (toPolar (3.0, 4.0))
              |> toEqual
                   (let open Eq in
                   pair float float)
                   (5.0, 0.9272952180016122) ) ;
          let r, theta = toPolar (5.0, 12.0) in
          testAll
            "toPolar"
            [ (r, 13.0); (theta, 1.17601) ]
            (fun (actual, expected) -> expect actual |> toBeCloseTo expected) ) ;
      describe "cos" (fun () ->
          test "cos" (fun () -> expect (cos (degrees 60.)) |> toBeCloseTo 0.5) ;
          test "cos" (fun () ->
              expect (cos (radians (pi /. 3.))) |> toBeCloseTo 0.5 ) ) ;
      describe "acos" (fun () ->
          test "1 / 2" (fun () ->
              expect (acos (1. /. 2.)) |> toBeCloseTo 1.0472 ) ) ;
      describe "sin" (fun () ->
          test "30 degrees" (fun () ->
              expect (sin (degrees 30.)) |> toBeCloseTo 0.5 ) ;
          test "pi / 6" (fun () ->
              expect (sin (radians (pi /. 6.))) |> toBeCloseTo 0.5 ) ) ;
      describe "asin" (fun () ->
          test "asin" (fun () ->
              expect (asin (1. /. 2.)) |> toBeCloseTo 0.523599 ) ) ;
      describe "tan" (fun () ->
          test "45 degrees" (fun () ->
              expect (tan (degrees 45.)) |> toEqual Eq.float 0.9999999999999999 ) ;
          test "pi / 4" (fun () ->
              expect (tan (radians (pi /. 4.)))
              |> toEqual Eq.float 0.9999999999999999 ) ;
          test "0" (fun () -> expect (tan 0.) |> toEqual Eq.float 0.) ) ;
      describe "atan" (fun () ->
          test "0" (fun () -> expect (atan 0.) |> toEqual Eq.float 0.) ;
          test "1 / 1" (fun () ->
              expect (atan (1. /. 1.)) |> toEqual Eq.float 0.7853981633974483 ) ;
          test "1 / -1" (fun () ->
              expect (atan (1. /. -1.)) |> toEqual Eq.float (-0.7853981633974483) ) ;
          test "-1 / -1" (fun () ->
              expect (atan (-1. /. -1.)) |> toEqual Eq.float 0.7853981633974483 ) ;
          test "-1 / -1" (fun () ->
              expect (atan (-1. /. 1.)) |> toEqual Eq.float (-0.7853981633974483) ) ) ;
      describe "atan2" (fun () ->
          test "0" (fun () ->
              expect (atan2 ~y:0. ~x:0.) |> toEqual Eq.float 0. ) ;
          test "(1, 1)" (fun () ->
              expect (atan2 ~y:1. ~x:1.) |> toEqual Eq.float 0.7853981633974483 ) ;
          test "(-1, 1)" (fun () ->
              expect (atan2 ~y:1. ~x:(-1.))
              |> toEqual Eq.float 2.3561944901923449 ) ;
          test "(-1 -1)" (fun () ->
              expect (atan2 ~y:(-1.) ~x:(-1.))
              |> toEqual Eq.float (-2.3561944901923449) ) ;
          test "(1, -1)" (fun () ->
              expect (atan2 ~y:(-1.) ~x:1.)
              |> toEqual Eq.float (-0.7853981633974483) ) ) ;
      describe "round" (fun () ->
          test "`Zero" (fun () ->
              expect (round ~direction:`Zero 1.2) |> toEqual Eq.float 1. ) ;
          test "`Zero" (fun () ->
              expect (round ~direction:`Zero 1.5) |> toEqual Eq.float 1. ) ;
          test "`Zero" (fun () ->
              expect (round ~direction:`Zero 1.8) |> toEqual Eq.float 1. ) ;
          test "`Zero" (fun () ->
              expect (round ~direction:`Zero (-1.2)) |> toEqual Eq.float (-1.) ) ;
          test "`Zero" (fun () ->
              expect (round ~direction:`Zero (-1.5)) |> toEqual Eq.float (-1.) ) ;
          test "`Zero" (fun () ->
              expect (round ~direction:`Zero (-1.8)) |> toEqual Eq.float (-1.) ) ;
          test "`AwayFromZero" (fun () ->
              expect (round ~direction:`AwayFromZero 1.2) |> toEqual Eq.float 2. ) ;
          test "`AwayFromZero" (fun () ->
              expect (round ~direction:`AwayFromZero 1.5) |> toEqual Eq.float 2. ) ;
          test "`AwayFromZero" (fun () ->
              expect (round ~direction:`AwayFromZero 1.8) |> toEqual Eq.float 2. ) ;
          test "`AwayFromZero" (fun () ->
              expect (round ~direction:`AwayFromZero (-1.2))
              |> toEqual Eq.float (-2.) ) ;
          test "`AwayFromZero" (fun () ->
              expect (round ~direction:`AwayFromZero (-1.5))
              |> toEqual Eq.float (-2.) ) ;
          test "`AwayFromZero" (fun () ->
              expect (round ~direction:`AwayFromZero (-1.8))
              |> toEqual Eq.float (-2.) ) ;
          test "`Up" (fun () ->
              expect (round ~direction:`Up 1.2) |> toEqual Eq.float 2. ) ;
          test "`Up" (fun () ->
              expect (round ~direction:`Up 1.5) |> toEqual Eq.float 2. ) ;
          test "`Up" (fun () ->
              expect (round ~direction:`Up 1.8) |> toEqual Eq.float 2. ) ;
          test "`Up" (fun () ->
              expect (round ~direction:`Up (-1.2)) |> toEqual Eq.float (-1.) ) ;
          test "`Up" (fun () ->
              expect (round ~direction:`Up (-1.5)) |> toEqual Eq.float (-1.) ) ;
          test "`Up" (fun () ->
              expect (round ~direction:`Up (-1.8)) |> toEqual Eq.float (-1.) ) ;
          test "`Down" (fun () ->
              expect (round ~direction:`Down 1.2) |> toEqual Eq.float 1. ) ;
          test "`Down" (fun () ->
              expect (round ~direction:`Down 1.5) |> toEqual Eq.float 1. ) ;
          test "`Down" (fun () ->
              expect (round ~direction:`Down 1.8) |> toEqual Eq.float 1. ) ;
          test "`Down" (fun () ->
              expect (round ~direction:`Down (-1.2)) |> toEqual Eq.float (-2.) ) ;
          test "`Down" (fun () ->
              expect (round ~direction:`Down (-1.5)) |> toEqual Eq.float (-2.) ) ;
          test "`Down" (fun () ->
              expect (round ~direction:`Down (-1.8)) |> toEqual Eq.float (-2.) ) ;
          test "`Closest `Zero" (fun () ->
              expect (round ~direction:(`Closest `Zero) 1.2)
              |> toEqual Eq.float 1. ) ;
          test "`Closest `Zero" (fun () ->
              expect (round ~direction:(`Closest `Zero) 1.5)
              |> toEqual Eq.float 1. ) ;
          test "`Closest `Zero" (fun () ->
              expect (round ~direction:(`Closest `Zero) 1.8)
              |> toEqual Eq.float 2. ) ;
          test "`Closest `Zero" (fun () ->
              expect (round ~direction:(`Closest `Zero) (-1.2))
              |> toEqual Eq.float (-1.) ) ;
          test "`Closest `Zero" (fun () ->
              expect (round ~direction:(`Closest `Zero) (-1.5))
              |> toEqual Eq.float (-1.) ) ;
          test "`Closest `Zero" (fun () ->
              expect (round ~direction:(`Closest `Zero) (-1.8))
              |> toEqual Eq.float (-2.) ) ;
          test "`Closest `AwayFromZero" (fun () ->
              expect (round ~direction:(`Closest `AwayFromZero) 1.2)
              |> toEqual Eq.float 1. ) ;
          test "`Closest `AwayFromZero" (fun () ->
              expect (round ~direction:(`Closest `AwayFromZero) 1.5)
              |> toEqual Eq.float 2. ) ;
          test "`Closest `AwayFromZero" (fun () ->
              expect (round ~direction:(`Closest `AwayFromZero) 1.8)
              |> toEqual Eq.float 2. ) ;
          test "`Closest `AwayFromZero" (fun () ->
              expect (round ~direction:(`Closest `AwayFromZero) (-1.2))
              |> toEqual Eq.float (-1.) ) ;
          test "`Closest `AwayFromZero" (fun () ->
              expect (round ~direction:(`Closest `AwayFromZero) (-1.5))
              |> toEqual Eq.float (-2.) ) ;
          test "`Closest `AwayFromZero" (fun () ->
              expect (round ~direction:(`Closest `AwayFromZero) (-1.8))
              |> toEqual Eq.float (-2.) ) ;
          test "`Closest `Up" (fun () ->
              expect (round ~direction:(`Closest `Up) 1.2)
              |> toEqual Eq.float 1. ) ;
          test "`Closest `Up" (fun () ->
              expect (round ~direction:(`Closest `Up) 1.5)
              |> toEqual Eq.float 2. ) ;
          test "`Closest `Up" (fun () ->
              expect (round ~direction:(`Closest `Up) 1.8)
              |> toEqual Eq.float 2. ) ;
          test "`Closest `Up" (fun () ->
              expect (round ~direction:(`Closest `Up) (-1.2))
              |> toEqual Eq.float (-1.) ) ;
          test "`Closest `Up" (fun () ->
              expect (round ~direction:(`Closest `Up) (-1.5))
              |> toEqual Eq.float (-1.) ) ;
          test "`Closest `Up" (fun () ->
              expect (round ~direction:(`Closest `Up) (-1.8))
              |> toEqual Eq.float (-2.) ) ;
          test "`Closest `Down" (fun () ->
              expect (round ~direction:(`Closest `Down) 1.2)
              |> toEqual Eq.float 1. ) ;
          test "`Closest `Down" (fun () ->
              expect (round ~direction:(`Closest `Down) 1.5)
              |> toEqual Eq.float 1. ) ;
          test "`Closest `Down" (fun () ->
              expect (round ~direction:(`Closest `Down) 1.8)
              |> toEqual Eq.float 2. ) ;
          test "`Closest `Down" (fun () ->
              expect (round ~direction:(`Closest `Down) (-1.2))
              |> toEqual Eq.float (-1.) ) ;
          test "`Closest `Down" (fun () ->
              expect (round ~direction:(`Closest `Down) (-1.5))
              |> toEqual Eq.float (-2.) ) ;
          test "`Closest `Down" (fun () ->
              expect (round ~direction:(`Closest `Down) (-1.8))
              |> toEqual Eq.float (-2.) ) ;
          test "`Closest `ToEven" (fun () ->
              expect (round ~direction:(`Closest `ToEven) 1.2)
              |> toEqual Eq.float 1. ) ;
          test "`Closest `ToEven" (fun () ->
              expect (round ~direction:(`Closest `ToEven) 1.5)
              |> toEqual Eq.float 2. ) ;
          test "`Closest `ToEven" (fun () ->
              expect (round ~direction:(`Closest `ToEven) 1.8)
              |> toEqual Eq.float 2. ) ;
          test "`Closest `ToEven" (fun () ->
              expect (round ~direction:(`Closest `ToEven) 2.2)
              |> toEqual Eq.float 2. ) ;
          test "`Closest `ToEven" (fun () ->
              expect (round ~direction:(`Closest `ToEven) 2.5)
              |> toEqual Eq.float 2. ) ;
          test "`Closest `ToEven" (fun () ->
              expect (round ~direction:(`Closest `ToEven) 2.8)
              |> toEqual Eq.float 3. ) ;
          test "`Closest `ToEven" (fun () ->
              expect (round ~direction:(`Closest `ToEven) (-1.2))
              |> toEqual Eq.float (-1.) ) ;
          test "`Closest `ToEven" (fun () ->
              expect (round ~direction:(`Closest `ToEven) (-1.5))
              |> toEqual Eq.float (-2.) ) ;
          test "`Closest `ToEven" (fun () ->
              expect (round ~direction:(`Closest `ToEven) (-1.8))
              |> toEqual Eq.float (-2.) ) ;
          test "`Closest `ToEven" (fun () ->
              expect (round ~direction:(`Closest `ToEven) (-2.2))
              |> toEqual Eq.float (-2.) ) ;
          test "`Closest `ToEven" (fun () ->
              expect (round ~direction:(`Closest `ToEven) (-2.5))
              |> toEqual Eq.float (-2.) ) ;
          test "`Closest `ToEven" (fun () ->
              expect (round ~direction:(`Closest `ToEven) (-2.8))
              |> toEqual Eq.float (-3.) ) ) ;
      describe "floor" (fun () ->
          test "floor" (fun () -> expect (floor 1.2) |> toEqual Eq.float 1.) ;
          test "floor" (fun () -> expect (floor 1.5) |> toEqual Eq.float 1.) ;
          test "floor" (fun () -> expect (floor 1.8) |> toEqual Eq.float 1.) ;
          test "floor" (fun () ->
              expect (floor (-1.2)) |> toEqual Eq.float (-2.) ) ;
          test "floor" (fun () ->
              expect (floor (-1.5)) |> toEqual Eq.float (-2.) ) ;
          test "floor" (fun () ->
              expect (floor (-1.8)) |> toEqual Eq.float (-2.) ) ) ;
      describe "ceiling" (fun () ->
          test "ceiling" (fun () ->
              expect (ceiling 1.2) |> toEqual Eq.float 2. ) ;
          test "ceiling" (fun () ->
              expect (ceiling 1.5) |> toEqual Eq.float 2. ) ;
          test "ceiling" (fun () ->
              expect (ceiling 1.8) |> toEqual Eq.float 2. ) ;
          test "ceiling" (fun () ->
              expect (ceiling (-1.2)) |> toEqual Eq.float (-1.) ) ;
          test "ceiling" (fun () ->
              expect (ceiling (-1.5)) |> toEqual Eq.float (-1.) ) ;
          test "ceiling" (fun () ->
              expect (ceiling (-1.8)) |> toEqual Eq.float (-1.) ) ) ;
      describe "truncate" (fun () ->
          test "truncate" (fun () ->
              expect (truncate 1.2) |> toEqual Eq.float 1. ) ;
          test "truncate" (fun () ->
              expect (truncate 1.5) |> toEqual Eq.float 1. ) ;
          test "truncate" (fun () ->
              expect (truncate 1.8) |> toEqual Eq.float 1. ) ;
          test "truncate" (fun () ->
              expect (truncate (-1.2)) |> toEqual Eq.float (-1.) ) ;
          test "truncate" (fun () ->
              expect (truncate (-1.5)) |> toEqual Eq.float (-1.) ) ;
          test "truncate" (fun () ->
              expect (truncate (-1.8)) |> toEqual Eq.float (-1.) ) ) ;
      describe "fromInt" (fun () ->
          test "5" (fun () -> expect (fromInt 5) |> toEqual Eq.float 5.0) ;
          test "0" (fun () -> expect zero |> toEqual Eq.float 0.0) ;
          test "-7" (fun () ->
              expect (fromInt (-7)) |> toEqual Eq.float (-7.0) ) ) ;
      describe "toInt" (fun () ->
          test "5." (fun () ->
              expect (toInt 5.)
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 5) ) ;
          test "5.3" (fun () ->
              expect (toInt 5.3)
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 5) ) ;
          test "0." (fun () ->
              expect (toInt 0.)
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 0) ) ;
          test "-7." (fun () ->
              expect (toInt (-7.))
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some (-7)) ) ;
          test "nan" (fun () ->
              expect (toInt nan)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "infinity" (fun () ->
              expect (toInt infinity)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "negativeInfinity" (fun () ->
              expect (toInt negativeInfinity)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "isInteger" (fun () ->
          test "true" (fun () -> expect (isInteger 5.0) |> toEqual Eq.bool true) ;
          test "false" (fun () ->
              expect (isInteger pi) |> toEqual Eq.bool false ) ) )
