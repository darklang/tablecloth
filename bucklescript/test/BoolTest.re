open Tablecloth;
open AlcoJest;

let suite =
  suite("Bool", () => {
    Bool.(
      describe("ofInt", () => {
        test("converts zero to Some(false)", () => {
          expect(ofInt(0)) |> toEqual(Eq.(option(bool)), Some(false))
        });

        test("converts one to Some(true)", () => {
          expect(ofInt(1)) |> toEqual(Eq.(option(bool)), Some(true))
        });

        testAll(
          "converts everything else to None",
          [Int.minimumValue, (-2), (-1), 2, Int.maximumValue],
          int => {
          expect(ofInt(int)) |> toEqual(Eq.(option(bool)), None)
        });
      })
    )
  });
