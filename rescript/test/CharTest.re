open Tablecloth;
open AlcoJest;

let suite =
  suite("Char", () => {
    open Char;

    test("toCode", () => {
      expect(toCode('a')) |> toEqual(Eq.int, 97)
    });

    describe("fromCode", () => {
      test("valid ASCII codes return the corresponding character", () => {
        expect(fromCode(97)) |> toEqual(Eq.(option(char)), Some('a'))
      });
      test("negative integers return None", () => {
        expect(fromCode(-1)) |> toEqual(Eq.(option(char)), None)
      });
      test("integers greater than 255 return None", () => {
        expect(fromCode(256)) |> toEqual(Eq.(option(char)), None)
      });
    });

    test("toString", () => {
      expect(toString('a')) |> toEqual(Eq.string, "a")
    });

    describe("fromString", () => {
      test("one-length string return Some", () => {
        expect(fromString("a")) |> toEqual(Eq.(option(char)), Some('a'))
      });
      test("multi character strings return None", () => {
        expect(fromString("abc")) |> toEqual(Eq.(option(char)), None)
      });
      test("zero length strings return None", () => {
        expect(fromString("")) |> toEqual(Eq.(option(char)), None)
      });
    });

    describe("toLowercase", () => {
      test("converts uppercase ASCII characters to lowercase", () => {
        expect(toLowercase('A')) |> toEqual(Eq.char, 'a')
      });
      test("perserves lowercase characters", () => {
        expect(toLowercase('a')) |> toEqual(Eq.char, 'a')
      });
      test("perserves non-alphabet characters", () => {
        expect(toLowercase('7')) |> toEqual(Eq.char, '7')
      });
      test("perserves non-ASCII characters", () => {
        expect(toLowercase('\233')) |> toEqual(Eq.char, '\233')
      });
    });

    describe("toUppercase", () => {
      test("converts lowercase ASCII characters to uppercase", () => {
        expect(toUppercase('a')) |> toEqual(Eq.char, 'A')
      });
      test("perserves uppercase characters", () => {
        expect(toUppercase('A')) |> toEqual(Eq.char, 'A')
      });
      test("perserves non-alphabet characters", () => {
        expect(toUppercase('7')) |> toEqual(Eq.char, '7')
      });
      test("perserves non-ASCII characters", () => {
        expect(toUppercase('\233')) |> toEqual(Eq.char, '\233')
      });
    });

    describe("toDigit", () => {
      test(
        "toDigit - converts ASCII characters representing digits into integers",
        () =>
        expect(toDigit('0')) |> toEqual(Eq.(option(int)), Some(0))
      );
      test(
        "toDigit - converts ASCII characters representing digits into integers",
        () =>
        expect(toDigit('8')) |> toEqual(Eq.(option(int)), Some(8))
      );
      test(
        "toDigit - converts ASCII characters representing digits into integers",
        () =>
        expect(toDigit('a')) |> toEqual(Eq.(option(int)), None)
      );
    });

    describe("isLowercase", () => {
      test("returns true for any lowercase character", () => {
        expect(isLowercase('a')) |> toEqual(Eq.bool, true)
      });
      test("returns false for all other characters", () => {
        expect(isLowercase('7')) |> toEqual(Eq.bool, false)
      });
      test("returns false for non-ASCII characters", () => {
        expect(isLowercase('\236')) |> toEqual(Eq.bool, false)
      });
    });

    describe("isUppercase", () => {
      test("returns true for any uppercase character", () => {
        expect(isUppercase('A')) |> toEqual(Eq.bool, true)
      });
      test("returns false for all other characters", () => {
        expect(isUppercase('7')) |> toEqual(Eq.bool, false)
      });
      test("returns false for non-ASCII characters", () => {
        expect(isLowercase('\237')) |> toEqual(Eq.bool, false)
      });
    });

    describe("isLetter", () => {
      test("returns true for any ASCII alphabet character", () => {
        expect(isLetter('A')) |> toEqual(Eq.bool, true)
      });

      testAll(
        "returns false for all other characters",
        ['7', ' ', '\n', '\011', '\236'],
        char =>
        expect(isLetter(char)) |> toEqual(Eq.bool, false)
      );
    });

    describe("isDigit", () => {
      testAll(
        "returns true for digits 0-9",
        ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
        digit =>
        expect(isDigit(digit)) |> toEqual(Eq.bool, true)
      );
      test("returns false for all other characters", () => {
        expect(isDigit('a')) |> toEqual(Eq.bool, false)
      });
    });

    describe("isAlphanumeric", () => {
      test("returns true for any alphabet or digit character", () => {
        expect(isAlphanumeric('A')) |> toEqual(Eq.bool, true)
      });
      test("returns false for all other characters", () => {
        expect(isAlphanumeric('?')) |> toEqual(Eq.bool, false)
      });
    });

    describe("isPrintable", () => {
      test("returns true for a printable character", () => {
        expect(isPrintable('~')) |> toEqual(Eq.bool, true)
      });

      test("returns false for non-printable character", () => {
        expect(fromCode(31) |> Option.map(~f=isPrintable))
        |> toEqual(Eq.(option(bool)), Some(false))
      });
    });

    describe("isWhitespace", () => {
      test("returns true for any whitespace character", () => {
        expect(isWhitespace(' ')) |> toEqual(Eq.bool, true)
      });
      test("returns false for a non-whitespace character", () => {
        expect(isWhitespace('a')) |> toEqual(Eq.bool, false)
      });
    });
  });
