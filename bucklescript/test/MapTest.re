open Tablecloth;
open AlcoJest;

module Coordinate = {
  include (
            val Comparator.make(
                  ~compare=Tuple.compare(Int.compare, Int.compare),
                )
          );
};

let suite =
  suite("Map", () => {
    describe("empty", () =>
      test("has length zero", () =>
        expect(Map.empty((module Coordinate)) |> Map.length)
        |> toEqual(Eq.int, 0)
      )
    );

    describe("fromArray", () =>
      test("has length zero", () =>
        expect(Map.fromArray((module Coordinate), [||]) |> Map.length)
        |> toEqual(Eq.int, 0)
      )
    );

    describe("fromList", () =>
      test("has length zero", () =>
        expect(Map.fromList((module Coordinate), []) |> Map.length)
        |> toEqual(Eq.int, 0)
      )
    );

    describe("Poly.fromList", () => {
      test("creates a map from a list", () => {
        let map = Map.Poly.fromList([(`Ant, "Ant"), (`Bat, "Bat")]);
        expect(Map.get(map, `Ant))
        |> toEqual(Eq.(option(string)), Some("Ant"));
      })
    });

    describe("Int.fromList", () => {
      test("creates a map from a list", () => {
        let map = Map.Int.fromList([(1, "Ant"), (2, "Bat")]);
        expect(Map.get(map, 1))
        |> toEqual(Eq.(option(string)), Some("Ant"));
      })
    });

    describe("String.fromList", () => {
      test("creates a map from a list", () => {
        let map = Map.String.fromList([("Ant", 1), ("Bat", 1)]);
        expect(Map.get(map, "Ant")) |> toEqual(Eq.(option(int)), Some(1));
      })
    });
  });
