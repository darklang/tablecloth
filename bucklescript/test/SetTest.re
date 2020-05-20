open Tablecloth;
open AlcoJest;

let suite =
  suite("Set", () => {
    describe("Int", () => {
      test("creates a set from a list", () => {
        let set = Set.Int.fromList([1, 2]);
        expect(Set.includes(set, 1)) |> toEqual(Eq.bool, true);
      })
    });

    describe("String", () => {
      test("creates a set from a list", () => {
        let set = Set.String.fromList(["Ant", "Bat"]);
        expect(Set.includes(set, "Ant")) |> toEqual(Eq.bool, true);
      })
    });
  });
