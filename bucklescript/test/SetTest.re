open Tablecloth;
open AlcoJest;

module Coordinate: {
  type t = (int, int);
  type identity;
  let compare: (t, t) => int;
  let comparator: Comparator.comparator(t, identity);
} = {
  type t = (int, int);
  let compare = Tuple2.compare(Int.compare, Int.compare);
  include Comparator.Make({
    type nonrec t = t;

    let compare: (t, t) => int = compare;
  });
};

let suite =
  suite("Set", () => {
    test("creates a set from a list", () => {
      let set = Set.fromList((module Int), [1, 2]);
      expect(Set.includes(set, 1)) |> toEqual(Eq.bool, true);
    });

    test("fromArray", () => {
      let set = Set.fromArray((module Coordinate), [|(0, 0), (0, 1)|]);
      expect(Set.includes(set, (0, 1))) |> toEqual(Eq.bool, true);
    });

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
