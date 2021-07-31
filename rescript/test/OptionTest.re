open Tablecloth;
open AlcoJest;

let suite =
  suite("Option", () => {
    describe("unwrapUnsafe", () => {
      test("returns the wrapped value for a Some", () => {
        expect(Option.unwrapUnsafe(Some(1))) |> toEqual(Eq.int, 1)
      });

      test("raises for a None", () => {
        expect(() =>
          ignore(Option.unwrapUnsafe(None))
        )
        |> toRaise(Invalid_argument("Option.unwrapUnsafe called with None"))
      });
    })
  });
