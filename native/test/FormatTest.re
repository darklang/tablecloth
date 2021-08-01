open Tablecloth;
open AlcoJest;

let suite =
  suite("pp", () => {
    test("pp formats result", () => {
      let result = Ok(5);
      let buffer = Buffer.create(100);
      let formatter = Format.formatter_of_buffer(buffer);
      Result.pp(
        Format.pp_print_int,
        Format.pp_print_string,
        formatter,
        result,
      );
      Format.pp_print_flush(formatter, ());
      expect(Buffer.contents(buffer)) |> toEqual(Eq.string, "<ok: 5>");
    })
  });
