open Standard;
open AlcoJest;

let suite =
  suite("Integer", () => {
    open Integer;

    describe("add", () => {
      testAll("add", [add, (+)], op => {
        expect(op(ofInt(3002), ofInt(4004)))
        |> toEqual(Eq.integer, ofInt(7006))
      })
    });

    describe("subtract", () => {
      testAll("subtract", [subtract, (-)], op => {
        expect(op(ofInt(4), ofInt(3))) |> toEqual(Eq.integer, one)
      })
    });

    describe("multiply", () => {
      testAll("multiply", [multiply, ( * )], op => {
        expect(op(ofInt(2), ofInt(7))) |> toEqual(Eq.integer, ofInt(14))
      })
    });

    describe("divide", () => {
      test("divide", () => {
        expect(divide(ofInt(3), ~by=ofInt(2))) |> toEqual(Eq.integer, one)
      });

      test("division by zero", () => {
        expect(() => {
          divide(ofInt(3), ~by=zero)
        }) |> toThrow
      });

      test("/", () => {
        expect(ofInt(27) / ofInt(5)) |> toEqual(Eq.integer, ofInt(5))
      });
    });

    describe("power", () => {
      test("**", () => {
        expect(ofInt(7) ** 3) |> toEqual(Eq.integer, ofInt(343))
      })
    });

    describe("negate", () => {
      test("positive number", () => {
        expect(negate(ofInt(8))) |> toEqual(Eq.integer, ofInt(-8))
      });
      test("negative number", () => {
        expect(negate(ofInt(-7))) |> toEqual(Eq.integer, ofInt(7))
      });
      test("zero", () => {
        expect(negate(zero)) |> toEqual(Eq.integer, zero)
      });
    });

    describe("absolute", () => {
      test("positive numbers stay positive", () => {
        expect(absolute(ofInt(8))) |> toEqual(Eq.integer, ofInt(8))
      });

      test("negative numbers become positive", () => {
        expect(absolute(ofInt(-7))) |> toEqual(Eq.integer, ofInt(7))
      });

      test("zero is left as it is", () => {
        expect(absolute(zero)) |> toEqual(Eq.integer, zero)
      });
    });

    describe("clamp", () => {
      test("in range", () => {
        expect(clamp(~lower=zero, ~upper=ofInt(8), ofInt(5)))
        |> toEqual(Eq.integer, ofInt(5))
      });
      test("above range", () => {
        expect(clamp(~lower=zero, ~upper=ofInt(8), ofInt(9)))
        |> toEqual(Eq.integer, ofInt(8))
      });
      test("below range", () => {
        expect(clamp(~lower=ofInt(2), ~upper=ofInt(8), one))
        |> toEqual(Eq.integer, ofInt(2))
      });
      test("above negative range", () => {
        expect(clamp(~lower=ofInt(-10), ~upper=ofInt(-5), ofInt(5)))
        |> toEqual(Eq.integer, ofInt(-5))
      });
      test("below negative range", () => {
        expect(clamp(~lower=ofInt(-10), ~upper=ofInt(-5), ofInt(-15)))
        |> toEqual(Eq.integer, ofInt(-10))
      });
      test("invalid arguments", () => {
        expect(() => {
          clamp(~lower=ofInt(7), ~upper=one, ofInt(3))
        })
        |> toThrow
      });
    });

    describe("inRange", () => {
      test("in range", () => {
        expect(inRange(~lower=ofInt(2), ~upper=ofInt(4), ofInt(3)))
        |> toEqual(Eq.bool, true)
      });
      test("above range", () => {
        expect(inRange(~lower=ofInt(2), ~upper=ofInt(4), ofInt(8)))
        |> toEqual(Eq.bool, false)
      });
      test("below range", () => {
        expect(inRange(~lower=ofInt(2), ~upper=ofInt(4), ofInt(1)))
        |> toEqual(Eq.bool, false)
      });
      test("equal to ~upper", () => {
        expect(inRange(~lower=ofInt(1), ~upper=ofInt(2), ofInt(2)))
        |> toEqual(Eq.bool, false)
      });
      test("negative range", () => {
        expect(inRange(~lower=ofInt(-7), ~upper=ofInt(-5), ofInt(-6)))
        |> toEqual(Eq.bool, true)
      });
      test("invalid arguments", () => {
        expect(() => {
          inRange(~lower=ofInt(7), ~upper=one, ofInt(3))
        })
        |> toThrow
      });
    });

    describe("toFloat", () => {
      test("5", () => {
        expect(toFloat(ofInt(5))) |> toEqual(Eq.(float), 5.)
      });
      test("0", () => {
        expect(toFloat(zero)) |> toEqual(Eq.(float), 0.)
      });
      test("-7", () => {
        expect(toFloat(ofInt(-7))) |> toEqual(Eq.(float), -7.)
      });
    });

    describe("ofString", () => {
      test("0", () => {
        expect(ofString("0")) |> toEqual(Eq.(option(integer)), Some(zero))
      });
      test("-0", () => {
        expect(ofString("-0"))
        |> toEqual(Eq.(option(integer)), Some(zero))
      });
      test("42", () => {
        expect(ofString("42"))
        |> toEqual(Eq.(option(integer)), Some(ofInt(42)))
      });
      test("123_456", () => {
        expect(ofString("123_456")) |> toEqual(Eq.(option(integer)), None)
      });
      test("-42", () => {
        expect(ofString("-42"))
        |> toEqual(Eq.(option(integer)), Some(ofInt(-42)))
      });
      test("0XFF", () => {
        expect(ofString("0XFF"))
        |> toEqual(Eq.(option(integer)), Some(ofInt(255)))
      });
      test("0X000A", () => {
        expect(ofString("0X000A"))
        |> toEqual(Eq.(option(integer)), Some(ofInt(10)))
      });
      test("Infinity", () => {
        expect(ofString("Infinity")) |> toEqual(Eq.(option(integer)), None)
      });
      test("-Infinity", () => {
        expect(ofString("-Infinity"))
        |> toEqual(Eq.(option(integer)), None)
      });
      test("NaN", () => {
        expect(ofString("NaN")) |> toEqual(Eq.(option(integer)), None)
      });
      test("abc", () => {
        expect(ofString("abc")) |> toEqual(Eq.(option(integer)), None)
      });
      test("--4", () => {
        expect(ofString("--4")) |> toEqual(Eq.(option(integer)), None)
      });

      test("empty string", () => {
        expect(ofString("")) |> toEqual(Eq.(option(integer)), Some(zero))
      });
    });

    describe("toString", () => {
      test("positive number", () => {
        expect(toString(ofInt(1))) |> toEqual(Eq.string, "1")
      });
      test("negative number", () => {
        expect(toString(ofInt(-1))) |> toEqual(Eq.string, "-1")
      });
    });
  });
