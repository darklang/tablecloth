open Tablecloth;
open AlcoJest;

let suite =
  suite("String", () => {
    open String;

    testAll(
      "fromChar",
      [('a', "a"), ('z', "z"), (' ', " "), ('\n', "\n")],
      ((char, string)) => {
      expect(fromChar(char)) |> toEqual(Eq.string, string)
    });

    describe("fromArray", () => {
      test("creates an empty string from an empty array", () => {
        expect(fromArray([||])) |> toEqual(Eq.string, "")
      });

      test("creates a string of characters", () => {
        expect(fromArray([|'K', 'u', 'b', 'o'|]))
        |> toEqual(Eq.string, "Kubo")
      });

      test("creates a string of characters", () => {
        expect(fromArray([|' ', '\n', '\t'|]))
        |> toEqual(Eq.string, " \n\t")
      });
    });

    describe("fromList", () => {
      test("creates an empty string from an empty array", () => {
        expect(fromList([])) |> toEqual(Eq.string, "")
      });

      test("creates a string of characters", () => {
        expect(fromList(['K', 'u', 'b', 'o'])) |> toEqual(Eq.string, "Kubo")
      });

      test("creates a string of characters", () => {
        expect(fromList([' ', '\n', '\t'])) |> toEqual(Eq.string, " \n\t")
      });
    });

    describe("repeat", () => {
      test("returns an empty string for count zero", () => {
        expect(repeat("bun", ~count=0)) |> toEqual(Eq.string, "")
      });

      test("raises for negative count", () => {
        expect(() =>
          repeat("bun", ~count=-1)
        ) |> toThrow
      });

      test("returns the input string repeated count times", () => {
        expect(repeat("bun", ~count=3)) |> toEqual(Eq.string, "bunbunbun")
      });
    });

    describe("initialize", () => {
      test("returns an empty string for count zero", () => {
        expect(initialize(0, ~f=Fun.constant('A')))
        |> toEqual(Eq.string, "")
      });

      test("raises for negative count", () => {
        expect(() =>
          initialize(-1, ~f=Fun.constant('A'))
        ) |> toThrow
      });

      test("returns the input string repeated count times", () => {
        expect(initialize(3, ~f=Fun.constant('A')))
        |> toEqual(Eq.string, "AAA")
      });
    });

    describe("isEmpty", () => {
      test("true for zero length string", () => {
        expect(isEmpty("")) |> toEqual(Eq.bool, true)
      });

      testAll("false for length > 0 strings", ["abc", " ", "\n"], string => {
        expect(isEmpty(string)) |> toEqual(Eq.bool, false)
      });
    });

    test("length empty string", () => {
      expect(String.length("")) |> toEqual(Eq.int, 0)
    });
    test("length", () => {
      expect(String.length("123")) |> toEqual(Eq.int, 3)
    });
    test("reverse empty string", () => {
      expect(String.reverse("")) |> toEqual(Eq.string, "")
    });
    test("reverse", () => {
      expect(String.reverse("stressed")) |> toEqual(Eq.string, "desserts")
    });
    describe("split", () => {
      test("middle", () => {
        expect(String.split("abc", ~on="b"))
        |> toEqual(Eq.(list(string)), ["a", "c"])
      });
      test("start", () => {
        expect(String.split("ab", ~on="a"))
        |> toEqual(Eq.(list(string)), ["", "b"])
      });
      test("end", () => {
        expect(String.split("ab", ~on="b"))
        |> toEqual(Eq.(list(string)), ["a", ""])
      });
    });

    test("toArray", () => {
      expect(String.toArray("Standard"))
      |> toEqual(
           Eq.(array(char)),
           [|'S', 't', 'a', 'n', 'd', 'a', 'r', 'd'|],
         )
    });

    test("toList", () => {
      expect(String.toList("Standard"))
      |> toEqual(Eq.(list(char)), ['S', 't', 'a', 'n', 'd', 'a', 'r', 'd'])
    });
  });
