open Tablecloth;
open AlcoJest;

let suite =
  suite("Option", () => {
    Option.(
      describe("getUnsafe", () => {
        test("returns the wrapped value for a Some", () => {
          expect(getUnsafe(Some(1))) |> toEqual(Eq.int, 1)
        });

        test("raises for a None", () => {
          expect(() =>
            ignore(getUnsafe(None))
          )
          |> toRaise(Invalid_argument("Option.getUnsafe called with None"))
        });
      })
    )
  });
