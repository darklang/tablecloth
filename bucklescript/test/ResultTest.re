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
      test("if first is Ok then choose the first value", () => {
        expect(orElse(Ok("This is Ok"), Ok("This is default")))
        |> toEqual(Eq.(result(string, string)), Ok("This is Ok"))
      });

      test("if the first is an Error then choose the second value aka default value", () => {
        expect(orElse(Error("This is an Error"), Ok("This is default")))
        |> toEqual(Eq.(result(string,string)), Ok("This is default"))
      });
    });

  });
