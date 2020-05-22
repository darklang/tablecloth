open Standard;
open AlcoJest;

let suite =
  suite("Integer - platform specific", () => {
    Integer.(
      describe("ofString", () => {
        testAll(
          "empty strings containing only spaces are parsed as None",
          [" ", "    "],
          string => {
          expect(ofString(string)) |> toEqual(Eq.(option(integer)), None)
        })
      })
    )
  });
