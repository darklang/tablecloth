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
      test("the first value is the default and if second value is an Ok we get the second value", () => {
        expect(orElse(Ok("This is default"), Ok("This is Ok")))
        |> toEqual(Eq.(result(string, string)), Ok("This is Ok"))
      });

      test("if the second is an Error then choose the default value", () => {
        expect(orElse(Ok("This is default"), Error("This is an Error")))
        |> toEqual(Eq.(result(string,string)), Ok("This is default"))
      });
    });

  });
