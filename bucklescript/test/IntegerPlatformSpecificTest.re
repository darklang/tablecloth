open Standard;
open AlcoJest;

let suite =
  suite("Integer - platform specific", () => {
    Integer.(
      describe("ofString", () => {
        testAll(
          "empty strings containing only spaces are parsed as Some(0)",
          [" ", "    "],
          string => {
          expect(ofString(string))
          |> toEqual(Eq.(option(integer)), Some(ofInt(0)))
        })
      })
    )
  });
