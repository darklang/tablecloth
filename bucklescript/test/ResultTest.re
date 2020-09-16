open Tablecloth;
open AlcoJest;

let suite =
  suite("Result", () => {
    open Result;

    describe("fromOption", () => {
      test("maps None into Error", () => {
        expect(fromOption(~error="error message", None))
        |> toEqual(Eq.(result(int, string)), Error("error message"))
      });

      test("maps Some into Ok", () => {
        expect(fromOption(~error="error message", Some(10)))
        |> toEqual(Eq.(result(int, string)), Ok(10))
      });
    });

    describe("orElse", () => {
      test("returns second value if Ok", () => {
        expect(orElse(Ok("This is default"), Ok("This is Ok")))
        |> toEqual(Eq.(result(string, string)), Ok("This is Ok"))
      });

      test("returns the first value if an Error", () => {
        expect(orElse(Ok("This is default"), Error("This is an Error")))
        |> toEqual(Eq.(result(string, string)), Ok("This is default"))
      });
    });
  });
