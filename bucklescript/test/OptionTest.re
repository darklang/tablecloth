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
    });

    describe("andThen2", () => {
      test("Take 2 inputs and a function which returns a Some type if both are of Some type", () => {
        expect(Option.andThen2(
          ~f=(a,b) => Some(Int.add(a,b)),
          Some(1),
          Some(2),
          ),
        )
        |> toEqual(Eq.(option(int)), Some(3))
      });

      test("Take 2 inputs and a function which returns a None type if both are of None type", () => {
        expect(Option.andThen2(
          ~f=(a,b) => Some(Int.add(a,b)),
          Some(1),
          None,
          ),
        )
        |> toEqual(Eq.(option(int)), None)
      });

      test("Take 2 inputs and a function which returns a None type if both are of None type", () => {
        expect(Option.andThen2(
          ~f=(a,b) => Some(Int.add(a,b)),
          None,
          Some(1),
          ),
        )
        |> toEqual(Eq.(option(int)), None)
      });

      test("Take 2 inputs and a function which returns a None type if both are of None type", () => {
        expect(Option.andThen2(
          ~f=(a,b) => Some(Int.add(a,b)),
          None,
          None,
          ),
        )
        |> toEqual(Eq.(option(int)), None)
      });
    });
  });
