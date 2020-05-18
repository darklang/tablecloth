open AlcoJest;

let suite =
  suite("Float", () => {
    open Tablecloth.Float;

    test("zero", () => {
      expect(zero) |> toEqual(Eq.float, 0.)
    });

    test("one", () => {
      expect(one) |> toEqual(Eq.float, 1.)
    });

    test("nan", () => {
      expect(nan == nan) |> toEqual(Eq.bool, false)
    });

    test("infinity", () => {
      expect(infinity *. 2. == infinity) |> toEqual(Eq.bool, true)
    });

    test("negativeInfinity", () => {
      expect(negativeInfinity *. 2. == negativeInfinity)
      |> toEqual(Eq.bool, true)
    });

    describe("equals", () => {
      test("zero", () => {
        expect(0. == (-0.)) |> toEqual(Eq.bool, true)
      })
    });

    describe("add", () => {
      test("add", () => {
        expect(add(3.14, 3.14)) |> toEqual(Eq.float, 6.28)
      });
      test("+", () => {
        expect(3.14 + 3.14) |> toEqual(Eq.float, 6.28)
      });
    });

    describe("subtract", () => {
      test("subtract", () => {
        expect(subtract(4., 3.)) |> toEqual(Eq.float, 1.)
      });
      test("-", () => {
        expect(4. - 3.) |> toEqual(Eq.float, 1.)
      });
    });

    describe("multiply", () => {
      test("multiply", () => {
        expect(multiply(2., 7.)) |> toEqual(Eq.float, 14.)
      });
      test("*", () => {
        expect(2. * 7.) |> toEqual(Eq.float, 14.)
      });
    });

    describe("divide", () => {
      test("divide", () => {
        expect(divide(3.14, ~by=2.)) |> toEqual(Eq.float, 1.57)
      });
      test("divide by zero", () => {
        expect(divide(3.14, ~by=0.) == infinity) |> toEqual(Eq.bool, true)
      });
      test("divide by negative zero", () => {
        expect(divide(3.14, ~by=-0.) == negativeInfinity)
        |> toEqual(Eq.bool, true)
      });

      test("/", () => {
        expect(3.14 / 2.) |> toEqual(Eq.float, 1.57)
      });
    });

    describe("power", () => {
      test("power", () => {
        expect(power(~base=7., ~exponent=3.)) |> toEqual(Eq.float, 343.)
      });
      test("0 base", () => {
        expect(power(~base=0., ~exponent=3.)) |> toEqual(Eq.float, 0.)
      });
      test("0 exponent", () => {
        expect(power(~base=7., ~exponent=0.)) |> toEqual(Eq.float, 1.)
      });
      test("**", () => {
        expect(7. ** 3.) |> toEqual(Eq.float, 343.)
      });
    });

    describe("negate", () => {
      test("positive number", () => {
        expect(negate(8.)) |> toEqual(Eq.float, -8.)
      });
      test("negative number", () => {
        expect(negate(-7.)) |> toEqual(Eq.float, 7.)
      });
      test("zero", () => {
        expect(negate(0.)) |> toEqual(Eq.float, -0.)
      });
      test("~-", () => {
        expect(-7.) |> toEqual(Eq.float, -7.)
      });
    });

    describe("absolute", () => {
      test("positive number", () => {
        expect(absolute(8.)) |> toEqual(Eq.float, 8.)
      });
      test("negative number", () => {
        expect(absolute(-7.)) |> toEqual(Eq.float, 7.)
      });
      test("zero", () => {
        expect(absolute(0.)) |> toEqual(Eq.float, 0.)
      });
    });

    describe("maximum", () => {
      test("positive numbers", () => {
        expect(maximum(7., 9.)) |> toEqual(Eq.float, 9.)
      });
      test("negative numbers", () => {
        expect(maximum(-4., -1.)) |> toEqual(Eq.float, -1.)
      });
      test("nan", () => {
        expect(maximum(7., nan) |> isNaN) |> toEqual(Eq.bool, true)
      });
      test("infinity", () => {
        expect(maximum(7., infinity) == infinity) |> toEqual(Eq.bool, true)
      });
      test("negativeInfinity", () => {
        expect(maximum(7., negativeInfinity)) |> toEqual(Eq.float, 7.)
      });
    });

    describe("minimum", () => {
      test("positive numbers", () => {
        expect(minimum(7., 9.)) |> toEqual(Eq.float, 7.)
      });
      test("negative numbers", () => {
        expect(minimum(-4., -1.)) |> toEqual(Eq.float, -4.)
      });
      test("nan", () => {
        expect(minimum(7., nan) |> isNaN) |> toEqual(Eq.bool, true)
      });
      test("infinity", () => {
        expect(minimum(7., infinity)) |> toEqual(Eq.float, 7.)
      });
      test("negativeInfinity", () => {
        expect(minimum(7., negativeInfinity) == negativeInfinity)
        |> toEqual(Eq.bool, true)
      });
    });

    describe("clamp", () => {
      test("in range", () => {
        expect(clamp(~lower=0., ~upper=8., 5.)) |> toEqual(Eq.float, 5.)
      });
      test("above range", () => {
        expect(clamp(~lower=0., ~upper=8., 9.)) |> toEqual(Eq.float, 8.)
      });
      test("below range", () => {
        expect(clamp(~lower=2., ~upper=8., 1.)) |> toEqual(Eq.float, 2.)
      });
      test("above negative range", () => {
        expect(clamp(~lower=-10., ~upper=-5., 5.)) |> toEqual(Eq.float, -5.)
      });
      test("below negative range", () => {
        expect(clamp(~lower=-10., ~upper=-5., -15.))
        |> toEqual(Eq.float, -10.)
      });
      test("nan upper bound", () => {
        expect(clamp(~lower=-7.9, ~upper=nan, -6.6) |> isNaN)
        |> toEqual(Eq.bool, true)
      });
      test("nan lower bound", () => {
        expect(clamp(~lower=nan, ~upper=0., -6.6) |> isNaN)
        |> toEqual(Eq.bool, true)
      });
      test("nan value", () => {
        expect(clamp(~lower=2., ~upper=8., nan) |> isNaN)
        |> toEqual(Eq.bool, true)
      });
      test("invalid arguments", () => {
        expect(() => {
          clamp(~lower=7., ~upper=1., 3.)
        }) |> toThrow
      });
    });

    describe("squareRoot", () => {
      test("whole numbers", () => {
        expect(squareRoot(4.)) |> toEqual(Eq.float, 2.)
      });
      test("decimal numbers", () => {
        expect(squareRoot(20.25)) |> toEqual(Eq.float, 4.5)
      });
      test("negative number", () => {
        expect(squareRoot(-1.) |> isNaN) |> toEqual(Eq.bool, true)
      });
    });

    describe("log", () => {
      test("base 10", () => {
        expect(log(~base=10., 100.)) |> toEqual(Eq.float, 2.)
      });
      test("base 2", () => {
        expect(log(~base=2., 256.)) |> toEqual(Eq.float, 8.)
      });
      test("of zero", () => {
        expect(log(~base=10., 0.) == negativeInfinity)
        |> toEqual(Eq.bool, true)
      });
    });

    describe("isNaN", () => {
      test("nan", () => {
        expect(isNaN(nan)) |> toEqual(Eq.bool, true)
      });
      test("non-nan", () => {
        expect(isNaN(91.4)) |> toEqual(Eq.bool, false)
      });
    });

    describe("isFinite", () => {
      test("infinity", () => {
        expect(isFinite(infinity)) |> toEqual(Eq.bool, false)
      });
      test("negative infinity", () => {
        expect(isFinite(negativeInfinity)) |> toEqual(Eq.bool, false)
      });
      test("NaN", () => {
        expect(isFinite(nan)) |> toEqual(Eq.bool, false)
      });
      testAll("regular numbers", [(-5.), (-0.314), 0., 3.14], n =>
        expect(isFinite(n)) |> toEqual(Eq.bool, true)
      );
    });

    describe("isInfinite", () => {
      test("infinity", () => {
        expect(isInfinite(infinity)) |> toEqual(Eq.bool, true)
      });
      test("negative infinity", () => {
        expect(isInfinite(negativeInfinity)) |> toEqual(Eq.bool, true)
      });
      test("NaN", () => {
        expect(isInfinite(nan)) |> toEqual(Eq.bool, false)
      });
      testAll("regular numbers", [(-5.), (-0.314), 0., 3.14], n =>
        expect(isInfinite(n)) |> toEqual(Eq.bool, false)
      );
    });

    describe("inRange", () => {
      test("in range", () => {
        expect(inRange(~lower=2., ~upper=4., 3.)) |> toEqual(Eq.bool, true)
      });
      test("above range", () => {
        expect(inRange(~lower=2., ~upper=4., 8.)) |> toEqual(Eq.bool, false)
      });
      test("below range", () => {
        expect(inRange(~lower=2., ~upper=4., 1.)) |> toEqual(Eq.bool, false)
      });
      test("equal to ~upper", () => {
        expect(inRange(~lower=1., ~upper=2., 2.)) |> toEqual(Eq.bool, false)
      });
      test("negative range", () => {
        expect(inRange(~lower=-7.9, ~upper=-5.2, -6.6))
        |> toEqual(Eq.bool, true)
      });
      test("nan upper bound", () => {
        expect(inRange(~lower=-7.9, ~upper=nan, -6.6))
        |> toEqual(Eq.bool, false)
      });
      test("nan lower bound", () => {
        expect(inRange(~lower=nan, ~upper=0., -6.6))
        |> toEqual(Eq.bool, false)
      });
      test("nan value", () => {
        expect(inRange(~lower=2., ~upper=8., nan))
        |> toEqual(Eq.bool, false)
      });
      test("invalid arguments", () => {
        expect(() => {
          inRange(~lower=7., ~upper=1., 3.)
        }) |> toThrow
      });
    });

    test("hypotenuse", () => {
      expect(hypotenuse(3., 4.)) |> toEqual(Eq.float, 5.)
    });

    test("degrees", () => {
      expect(degrees(180.)) |> toEqual(Eq.float, pi)
    });

    test("radians", () => {
      expect(radians(pi)) |> toEqual(Eq.float, pi)
    });

    test("turns", () => {
      expect(turns(1.)) |> toEqual(Eq.float, 2. * pi)
    });

    describe("ofPolar", () => {
      let (x, y) = fromPolar((squareRoot(2.), degrees(45.)));
      test("x", () => {
        expect(x) |> toBeCloseTo(1.)
      });
      test("y", () => {
        expect(y) |> toEqual(Eq.float, 1.)
      });
    });

    describe("toPolar", () => {
      test("toPolar", () => {
        expect(toPolar((3.0, 4.0)))
        |> toEqual(Eq.(pair(float, float)), (5.0, 0.9272952180016122))
      });

      let (r, theta) = toPolar((5.0, 12.0));
      testAll(
        "toPolar", [(r, 13.0), (theta, 1.17601)], ((actual, expected)) => {
        expect(actual) |> toBeCloseTo(expected)
      });
    });

    describe("cos", () => {
      test("cos", () => {
        expect(cos(degrees(60.))) |> toBeCloseTo(0.5)
      });

      test("cos", () => {
        expect(cos(radians(pi / 3.))) |> toBeCloseTo(0.5)
      });
    });

    describe("acos", () => {
      test("1 / 2", () =>
        expect(acos(1. / 2.)) |> toBeCloseTo(1.0472)
      )
    });

    describe("sin", () => {
      test("30 degrees", () => {
        expect(sin(degrees(30.))) |> toBeCloseTo(0.5)
      });
      test("pi / 6", () => {
        expect(sin(radians(pi / 6.))) |> toBeCloseTo(0.5)
      });
    });

    describe("asin", () => {
      test("asin", () =>
        expect(asin(1. / 2.)) |> toBeCloseTo(0.523599)
      )
    });

    describe("tan", () => {
      test("45 degrees", () => {
        expect(tan(degrees(45.))) |> toEqual(Eq.float, 0.9999999999999999)
      });
      test("pi / 4", () => {
        expect(tan(radians(pi / 4.)))
        |> toEqual(Eq.float, 0.9999999999999999)
      });
      test("0", () => {
        expect(tan(0.)) |> toEqual(Eq.float, 0.)
      });
    });

    describe("atan", () => {
      test("0", () => {
        expect(atan(0.)) |> toEqual(Eq.float, 0.)
      });
      test("1 / 1", () => {
        expect(atan(1. / 1.)) |> toEqual(Eq.float, 0.7853981633974483)
      });
      test("1 / -1", () => {
        expect(atan(1. / (-1.))) |> toEqual(Eq.float, -0.7853981633974483)
      });
      test("-1 / -1", () => {
        expect(atan((-1.) / (-1.))) |> toEqual(Eq.float, 0.7853981633974483)
      });
      test("-1 / -1", () => {
        expect(atan((-1.) / 1.)) |> toEqual(Eq.float, -0.7853981633974483)
      });
    });

    describe("atan2", () => {
      test("0", () => {
        expect(atan2(~y=0., ~x=0.)) |> toEqual(Eq.float, 0.)
      });
      test("(1, 1)", () => {
        expect(atan2(~y=1., ~x=1.)) |> toEqual(Eq.float, 0.7853981633974483)
      });
      test("(-1, 1)", () => {
        expect(atan2(~y=1., ~x=-1.))
        |> toEqual(Eq.float, 2.3561944901923449)
      });
      test("(-1 -1)", () => {
        expect(atan2(~y=-1., ~x=-1.))
        |> toEqual(Eq.float, -2.3561944901923449)
      });
      test("(1, -1)", () => {
        expect(atan2(~y=-1., ~x=1.))
        |> toEqual(Eq.float, -0.7853981633974483)
      });
    });

    describe("round", () => {
      test("`Zero", () => {
        expect(round(~direction=`Zero, 1.2)) |> toEqual(Eq.float, 1.)
      });
      test("`Zero", () => {
        expect(round(~direction=`Zero, 1.5)) |> toEqual(Eq.float, 1.)
      });
      test("`Zero", () => {
        expect(round(~direction=`Zero, 1.8)) |> toEqual(Eq.float, 1.)
      });
      test("`Zero", () => {
        expect(round(~direction=`Zero, -1.2)) |> toEqual(Eq.float, -1.)
      });
      test("`Zero", () => {
        expect(round(~direction=`Zero, -1.5)) |> toEqual(Eq.float, -1.)
      });
      test("`Zero", () => {
        expect(round(~direction=`Zero, -1.8)) |> toEqual(Eq.float, -1.)
      });

      test("`AwayFromZero", () => {
        expect(round(~direction=`AwayFromZero, 1.2))
        |> toEqual(Eq.float, 2.)
      });
      test("`AwayFromZero", () => {
        expect(round(~direction=`AwayFromZero, 1.5))
        |> toEqual(Eq.float, 2.)
      });
      test("`AwayFromZero", () => {
        expect(round(~direction=`AwayFromZero, 1.8))
        |> toEqual(Eq.float, 2.)
      });
      test("`AwayFromZero", () => {
        expect(round(~direction=`AwayFromZero, -1.2))
        |> toEqual(Eq.float, -2.)
      });
      test("`AwayFromZero", () => {
        expect(round(~direction=`AwayFromZero, -1.5))
        |> toEqual(Eq.float, -2.)
      });
      test("`AwayFromZero", () => {
        expect(round(~direction=`AwayFromZero, -1.8))
        |> toEqual(Eq.float, -2.)
      });

      test("`Up", () => {
        expect(round(~direction=`Up, 1.2)) |> toEqual(Eq.float, 2.)
      });
      test("`Up", () => {
        expect(round(~direction=`Up, 1.5)) |> toEqual(Eq.float, 2.)
      });
      test("`Up", () => {
        expect(round(~direction=`Up, 1.8)) |> toEqual(Eq.float, 2.)
      });
      test("`Up", () => {
        expect(round(~direction=`Up, -1.2)) |> toEqual(Eq.float, -1.)
      });
      test("`Up", () => {
        expect(round(~direction=`Up, -1.5)) |> toEqual(Eq.float, -1.)
      });
      test("`Up", () => {
        expect(round(~direction=`Up, -1.8)) |> toEqual(Eq.float, -1.)
      });

      test("`Down", () => {
        expect(round(~direction=`Down, 1.2)) |> toEqual(Eq.float, 1.)
      });
      test("`Down", () => {
        expect(round(~direction=`Down, 1.5)) |> toEqual(Eq.float, 1.)
      });
      test("`Down", () => {
        expect(round(~direction=`Down, 1.8)) |> toEqual(Eq.float, 1.)
      });
      test("`Down", () => {
        expect(round(~direction=`Down, -1.2)) |> toEqual(Eq.float, -2.)
      });
      test("`Down", () => {
        expect(round(~direction=`Down, -1.5)) |> toEqual(Eq.float, -2.)
      });
      test("`Down", () => {
        expect(round(~direction=`Down, -1.8)) |> toEqual(Eq.float, -2.)
      });

      test("`Closest `Zero", () => {
        expect(round(~direction=`Closest(`Zero), 1.2))
        |> toEqual(Eq.float, 1.)
      });
      test("`Closest `Zero", () => {
        expect(round(~direction=`Closest(`Zero), 1.5))
        |> toEqual(Eq.float, 1.)
      });
      test("`Closest `Zero", () => {
        expect(round(~direction=`Closest(`Zero), 1.8))
        |> toEqual(Eq.float, 2.)
      });
      test("`Closest `Zero", () => {
        expect(round(~direction=`Closest(`Zero), -1.2))
        |> toEqual(Eq.float, -1.)
      });
      test("`Closest `Zero", () => {
        expect(round(~direction=`Closest(`Zero), -1.5))
        |> toEqual(Eq.float, -1.)
      });
      test("`Closest `Zero", () => {
        expect(round(~direction=`Closest(`Zero), -1.8))
        |> toEqual(Eq.float, -2.)
      });

      test("`Closest `AwayFromZero", () => {
        expect(round(~direction=`Closest(`AwayFromZero), 1.2))
        |> toEqual(Eq.float, 1.)
      });
      test("`Closest `AwayFromZero", () => {
        expect(round(~direction=`Closest(`AwayFromZero), 1.5))
        |> toEqual(Eq.float, 2.)
      });
      test("`Closest `AwayFromZero", () => {
        expect(round(~direction=`Closest(`AwayFromZero), 1.8))
        |> toEqual(Eq.float, 2.)
      });
      test("`Closest `AwayFromZero", () => {
        expect(round(~direction=`Closest(`AwayFromZero), -1.2))
        |> toEqual(Eq.float, -1.)
      });
      test("`Closest `AwayFromZero", () => {
        expect(round(~direction=`Closest(`AwayFromZero), -1.5))
        |> toEqual(Eq.float, -2.)
      });
      test("`Closest `AwayFromZero", () => {
        expect(round(~direction=`Closest(`AwayFromZero), -1.8))
        |> toEqual(Eq.float, -2.)
      });

      test("`Closest `Up", () => {
        expect(round(~direction=`Closest(`Up), 1.2))
        |> toEqual(Eq.float, 1.)
      });
      test("`Closest `Up", () => {
        expect(round(~direction=`Closest(`Up), 1.5))
        |> toEqual(Eq.float, 2.)
      });
      test("`Closest `Up", () => {
        expect(round(~direction=`Closest(`Up), 1.8))
        |> toEqual(Eq.float, 2.)
      });
      test("`Closest `Up", () => {
        expect(round(~direction=`Closest(`Up), -1.2))
        |> toEqual(Eq.float, -1.)
      });
      test("`Closest `Up", () => {
        expect(round(~direction=`Closest(`Up), -1.5))
        |> toEqual(Eq.float, -1.)
      });
      test("`Closest `Up", () => {
        expect(round(~direction=`Closest(`Up), -1.8))
        |> toEqual(Eq.float, -2.)
      });

      test("`Closest `Down", () => {
        expect(round(~direction=`Closest(`Down), 1.2))
        |> toEqual(Eq.float, 1.)
      });
      test("`Closest `Down", () => {
        expect(round(~direction=`Closest(`Down), 1.5))
        |> toEqual(Eq.float, 1.)
      });
      test("`Closest `Down", () => {
        expect(round(~direction=`Closest(`Down), 1.8))
        |> toEqual(Eq.float, 2.)
      });
      test("`Closest `Down", () => {
        expect(round(~direction=`Closest(`Down), -1.2))
        |> toEqual(Eq.float, -1.)
      });
      test("`Closest `Down", () => {
        expect(round(~direction=`Closest(`Down), -1.5))
        |> toEqual(Eq.float, -2.)
      });
      test("`Closest `Down", () => {
        expect(round(~direction=`Closest(`Down), -1.8))
        |> toEqual(Eq.float, -2.)
      });

      test("`Closest `ToEven", () => {
        expect(round(~direction=`Closest(`ToEven), 1.2))
        |> toEqual(Eq.float, 1.)
      });
      test("`Closest `ToEven", () => {
        expect(round(~direction=`Closest(`ToEven), 1.5))
        |> toEqual(Eq.float, 2.)
      });
      test("`Closest `ToEven", () => {
        expect(round(~direction=`Closest(`ToEven), 1.8))
        |> toEqual(Eq.float, 2.)
      });
      test("`Closest `ToEven", () => {
        expect(round(~direction=`Closest(`ToEven), 2.2))
        |> toEqual(Eq.float, 2.)
      });
      test("`Closest `ToEven", () => {
        expect(round(~direction=`Closest(`ToEven), 2.5))
        |> toEqual(Eq.float, 2.)
      });
      test("`Closest `ToEven", () => {
        expect(round(~direction=`Closest(`ToEven), 2.8))
        |> toEqual(Eq.float, 3.)
      });
      test("`Closest `ToEven", () => {
        expect(round(~direction=`Closest(`ToEven), -1.2))
        |> toEqual(Eq.float, -1.)
      });
      test("`Closest `ToEven", () => {
        expect(round(~direction=`Closest(`ToEven), -1.5))
        |> toEqual(Eq.float, -2.)
      });
      test("`Closest `ToEven", () => {
        expect(round(~direction=`Closest(`ToEven), -1.8))
        |> toEqual(Eq.float, -2.)
      });
      test("`Closest `ToEven", () => {
        expect(round(~direction=`Closest(`ToEven), -2.2))
        |> toEqual(Eq.float, -2.)
      });
      test("`Closest `ToEven", () => {
        expect(round(~direction=`Closest(`ToEven), -2.5))
        |> toEqual(Eq.float, -2.)
      });
      test("`Closest `ToEven", () => {
        expect(round(~direction=`Closest(`ToEven), -2.8))
        |> toEqual(Eq.float, -3.)
      });
    });

    describe("floor", () => {
      test("floor", () => {
        expect(floor(1.2)) |> toEqual(Eq.float, 1.)
      });
      test("floor", () => {
        expect(floor(1.5)) |> toEqual(Eq.float, 1.)
      });
      test("floor", () => {
        expect(floor(1.8)) |> toEqual(Eq.float, 1.)
      });
      test("floor", () => {
        expect(floor(-1.2)) |> toEqual(Eq.float, -2.)
      });
      test("floor", () => {
        expect(floor(-1.5)) |> toEqual(Eq.float, -2.)
      });
      test("floor", () => {
        expect(floor(-1.8)) |> toEqual(Eq.float, -2.)
      });
    });

    describe("ceiling", () => {
      test("ceiling", () => {
        expect(ceiling(1.2)) |> toEqual(Eq.float, 2.)
      });
      test("ceiling", () => {
        expect(ceiling(1.5)) |> toEqual(Eq.float, 2.)
      });
      test("ceiling", () => {
        expect(ceiling(1.8)) |> toEqual(Eq.float, 2.)
      });
      test("ceiling", () => {
        expect(ceiling(-1.2)) |> toEqual(Eq.float, -1.)
      });
      test("ceiling", () => {
        expect(ceiling(-1.5)) |> toEqual(Eq.float, -1.)
      });
      test("ceiling", () => {
        expect(ceiling(-1.8)) |> toEqual(Eq.float, -1.)
      });
    });

    describe("truncate", () => {
      test("truncate", () => {
        expect(truncate(1.2)) |> toEqual(Eq.float, 1.)
      });
      test("truncate", () => {
        expect(truncate(1.5)) |> toEqual(Eq.float, 1.)
      });
      test("truncate", () => {
        expect(truncate(1.8)) |> toEqual(Eq.float, 1.)
      });
      test("truncate", () => {
        expect(truncate(-1.2)) |> toEqual(Eq.float, -1.)
      });
      test("truncate", () => {
        expect(truncate(-1.5)) |> toEqual(Eq.float, -1.)
      });
      test("truncate", () => {
        expect(truncate(-1.8)) |> toEqual(Eq.float, -1.)
      });
    });

    describe("fromInt", () => {
      test("5", () => {
        expect(fromInt(5)) |> toEqual(Eq.float, 5.0)
      });
      test("0", () => {
        expect(zero) |> toEqual(Eq.float, 0.0)
      });
      test("-7", () => {
        expect(fromInt(-7)) |> toEqual(Eq.float, -7.0)
      });
    });

    describe("toInt", () => {
      test("5.", () => {
        expect(toInt(5.)) |> toEqual(Eq.(option(int)), Some(5))
      });
      test("5.3", () => {
        expect(toInt(5.3)) |> toEqual(Eq.(option(int)), Some(5))
      });
      test("0.", () => {
        expect(toInt(0.)) |> toEqual(Eq.(option(int)), Some(0))
      });
      test("-7.", () => {
        expect(toInt(-7.)) |> toEqual(Eq.(option(int)), Some(-7))
      });
      test("nan", () => {
        expect(toInt(nan)) |> toEqual(Eq.(option(int)), None)
      });
      test("infinity", () => {
        expect(toInt(infinity)) |> toEqual(Eq.(option(int)), None)
      });
      test("negativeInfinity", () => {
        expect(toInt(negativeInfinity)) |> toEqual(Eq.(option(int)), None)
      });
    });
  });
