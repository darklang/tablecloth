open Tablecloth;
open AlcoJest;

module Coordinate = {
  include Coordinate;
  include Comparator.Make({
    type nonrec t = t;
    let compare = compare;
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

    test("union", () => {
      let xAxis = Set.fromList((module Coordinate), [(0, 0), (0, 1)]);
      let yAxis = Set.fromList((module Coordinate), [(0, 0), (1, 0)]);
      let union = Set.union(xAxis, yAxis);
      expect(union |> Set.toArray)
      |> toEqual(Eq.array(Eq.coordinate), [|(0, 0), (0, 1), (1, 0)|]);
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
