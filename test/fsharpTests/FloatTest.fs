testCase "absolute(8.)" 
<| fun _ -> 
    let expected = 8.
    Expect.equal expected (Float.absolute 8.) "error"
testCase "absolute(-7.)" 
<| fun _ -> 
    let expected = 7.
    Expect.equal expected (Float.absolute -7.) "error"
testCase "absolute(0.)" 
<| fun _ -> 
    let expected = 0.
    Expect.equal expected (Float.absolute 0.) "error"
testCase "add(3.14,3.14)" 
<| fun _ -> 
    let expected = 6.28
    Expect.equal expected (Float.add 3.14 3.14) "error"
testCase "atan(0.)" 
<| fun _ -> 
    let expected = 0.
    Expect.equal expected (Float.atan 0.) "error"
testCase "atan(1. /. 1.)" 
<| fun _ -> 
    let expected = 0.7853981633974483
    Expect.equal expected (Float.atan 1. /. 1.) "error"
testCase "atan(1. /. -1.)" 
<| fun _ -> 
    let expected = -0.7853981633974483
    Expect.equal expected (Float.atan 1. /. -1.) "error"
testCase "atan(-1. /. -1.)" 
<| fun _ -> 
    let expected = 0.7853981633974483
    Expect.equal expected (Float.atan -1. /. -1.) "error"
testCase "atan(-1. /. 1.)" 
<| fun _ -> 
    let expected = -0.7853981633974483
    Expect.equal expected (Float.atan -1. /. 1.) "error"
testCase "ceiling(1.2)" 
<| fun _ -> 
    let expected = 2.
    Expect.equal expected (Float.ceiling 1.2) "error"
testCase "ceiling(1.5)" 
<| fun _ -> 
    let expected = 2.
    Expect.equal expected (Float.ceiling 1.5) "error"
testCase "ceiling(1.8)" 
<| fun _ -> 
    let expected = 2.
    Expect.equal expected (Float.ceiling 1.8) "error"
testCase "ceiling(-1.2)" 
<| fun _ -> 
    let expected = -1.
    Expect.equal expected (Float.ceiling -1.2) "error"
testCase "ceiling(-1.5)" 
<| fun _ -> 
    let expected = -1.
    Expect.equal expected (Float.ceiling -1.5) "error"
testCase "ceiling(-1.8)" 
<| fun _ -> 
    let expected = -1.
    Expect.equal expected (Float.ceiling -1.8) "error"
testCase "cos(degrees(60.))" 
<| fun _ -> 
    let expected = 0.5
    Expect.equal expected (Float.cos degrees(60.)) "error"
testCase "cos(radians(pi /. 3.))" 
<| fun _ -> 
    let expected = 0.5
    Expect.equal expected (Float.cos radians(pi /. 3.)) "error"

testCase "degrees(180.)" 
<| fun _ -> 
    let expected = pi
    Expect.equal expected (Float.degrees 180.) "error"
testCase "floor(1.2)" 
<| fun _ -> 
    let expected = 1.
    Expect.equal expected (Float.floor 1.2) "error"
testCase "floor(1.5)" 
<| fun _ -> 
    let expected = 1.
    Expect.equal expected (Float.floor 1.5) "error"
testCase "floor(1.8)" 
<| fun _ -> 
    let expected = 1.
    Expect.equal expected (Float.floor 1.8) "error"
testCase "floor(-1.2)" 
<| fun _ -> 
    let expected = -2.
    Expect.equal expected (Float.floor -1.2) "error"
testCase "floor(-1.5)" 
<| fun _ -> 
    let expected = -2.
    Expect.equal expected (Float.floor -1.5) "error"
testCase "floor(-1.8)" 
<| fun _ -> 
    let expected = -2.
    Expect.equal expected (Float.floor -1.8) "error"
testCase "fromInt(5)" 
<| fun _ -> 
    let expected = 5.0
    Expect.equal expected (Float.fromInt 5) "error"
testCase "fromInt(0)" 
<| fun _ -> 
    let expected = 0.0
    Expect.equal expected (Float.fromInt 0) "error"
testCase "fromInt(-7)" 
<| fun _ -> 
    let expected = -7.0
    Expect.equal expected (Float.fromInt -7) "error"
testCase "fromString("NaN")" 
<| fun _ -> 
    let expected = Some(Js.Float._NaN),
    Expect.equal expected (Float.fromString "NaN") "error"
testCase "fromString("nan")" 
<| fun _ -> 
    let expected = Some(Js.Float._NaN)
    Expect.equal expected (Float.fromString "nan") "error"
testCase "fromString("Infinity")" 
<| fun _ -> 
    let expected = Some(infinity)
    Expect.equal expected (Float.fromString "Infinity") "error"
testCase "fromString("infinity")" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Float.fromString "infinity") "error"
testCase "fromString("55")" 
<| fun _ -> 
    let expected = Some(55.)
    Expect.equal expected (Float.fromString "55") "error"
testCase "fromString("-100")" 
<| fun _ -> 
    let expected = Some(-100.)
    Expect.equal expected (Float.fromString "-100") "error"
testCase "fromString("not number")" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Float.fromString "not number") "error"
testCase "isFinite(infinity)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Float.isFinite infinity) "error"
testCase "isFinite(negativeInfinity)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Float.isFinite negativeInfinity) "error"
testCase "isFinite(nan)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Float.isFinite nan) "error"
testCase "isFinite(-5.)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Float.isFinite -5.) "error"
testCase "isFinite(-0.314)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Float.isFinite -0.314) "error"
testCase "isFinite(0.)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Float.isFinite 0.) "error"
testCase "isFinite(3.14)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Float.isFinite 3.14) "error"
testCase "isInfinite(infinity)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Float.isInfinite infinity) "error"
testCase "isInfinite(negativeInfinity)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Float.isInfinite negativeInfinity) "error"
testCase "isInfinite(nan)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Float.isInfinite nan) "error"
testCase "isInfinite(-5.)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Float.isInfinite -5.) "error"
testCase "isInfinite(-0.314)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Float.isInfinite -0.314) "error"
testCase "isInfinite(0.)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Float.isInfinite 0.) "error"
testCase "isInfinite(3.14)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Float.isInfinite 3.14) "error"
testCase "isInteger(5.0)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Float.isInteger 5.0) "error"
testCase "isInteger(pi)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Float.isInteger pi) "error"
testCase "isNaN(nan)" 
<| fun _ -> 
    let expected = true
    Expect.equal expected (Float.isNaN nan) "error"
testCase "isNaN(91.4)" 
<| fun _ -> 
    let expected = false
    Expect.equal expected (Float.isNaN 91.4) "error"
testCase "negate(8.)" 
<| fun _ -> 
    let expected = -8.
    Expect.equal expected (Float.negate 8.) "error"
testCase "negate(-7.)" 
<| fun _ -> 
    let expected = 7.
    Expect.equal expected (Float.negate -7.) "error"
testCase "negate(0.)" 
<| fun _ -> 
    let expected = -0.
    Expect.equal expected (Float.negate 0.) "error"
testCase "radians(pi)" 
<| fun _ -> 
    let expected = pi
    Expect.equal expected (Float.radians pi) "error"
testCase "sin(degrees(30.))" 
<| fun _ -> 
    let expected = 0.5
    Expect.equal expected (Float.sin degrees(30.)) "error"
testCase "sin(radians(pi /. 6.))" 
<| fun _ -> 
    let expected = 0.5
    Expect.equal expected (Float.sin radians(pi /. 6.)) "error"
testCase "squareRoot(4.)" 
<| fun _ -> 
    let expected = 2.
    Expect.equal expected (Float.squareRoot 4.) "error"
testCase "squareRoot(20.25)" 
<| fun _ -> 
    let expected = 4.5
    Expect.equal expected (Float.squareRoot 20.25) "error"
testCase "squareRoot(-1.)" 
<| fun _ -> 
    let expected = NaN
    Expect.equal expected (Float.squareRoot -1.) "error"
testCase "tan(degrees(45.))" 
<| fun _ -> 
    let expected = 0.9999999999999999
    Expect.equal expected (Float.tan degrees(45.)) "error"
testCase "tan(radians(pi /. 4.))" 
<| fun _ -> 
    let expected = 0.9999999999999999
    Expect.equal expected (Float.tan radians(pi /. 4.)) "error"
testCase "tan(0.)" 
<| fun _ -> 
    let expected = 0.
    Expect.equal expected (Float.tan 0.) "error"
testCase "toInt(5.)" 
<| fun _ -> 
    let expected = Some(5)
    Expect.equal expected (Float.toInt 5.) "error"
testCase "toInt(5.3)" 
<| fun _ -> 
    let expected = Some(5)
    Expect.equal expected (Float.toInt 5.3) "error"
testCase "toInt(0.)" 
<| fun _ -> 
    let expected = Some(0)
    Expect.equal expected (Float.toInt 0.) "error"
testCase "toInt(-7.)" 
<| fun _ -> 
    let expected = Some(-7)
    Expect.equal expected (Float.toInt -7.) "error"
testCase "toInt(nan)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Float.toInt nan) "error"
testCase "toInt(infinity)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Float.toInt infinity) "error"
testCase "toInt(negativeInfinity)" 
<| fun _ -> 
    let expected = None
    Expect.equal expected (Float.toInt negativeInfinity) "error"
testCase "truncate(1.2)" 
<| fun _ -> 
    let expected = 1.
    Expect.equal expected (Float.truncate 1.2) "error"
testCase "truncate(1.5)" 
<| fun _ -> 
    let expected = 1.
    Expect.equal expected (Float.truncate 1.5) "error"
testCase "truncate(1.8)" 
<| fun _ -> 
    let expected = 1.
    Expect.equal expected (Float.truncate 1.8) "error"
testCase "truncate(-1.2)" 
<| fun _ -> 
    let expected = -1.
    Expect.equal expected (Float.truncate -1.2) "error"
testCase "truncate(-1.5)" 
<| fun _ -> 
    let expected = -1.
    Expect.equal expected (Float.truncate -1.5) "error"
testCase "truncate(-1.8)" 
<| fun _ -> 
    let expected = -1.
    Expect.equal expected (Float.truncate -1.8) "error"
testCase "turns(1.)" 
<| fun _ -> 
    let expected = 2. *. pi
    Expect.equal expected (Float.turns 1.) "error"
