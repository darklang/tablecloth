open Tablecloth;
open AlcoJest;

module Coordinate: {
  type t = (int, int);
  let compare: (t, t) => int;
  type identity;
  let comparator: Tablecloth.Comparator.comparator(t, identity);
} = {
  module T = {
    type t = (int, int);
    let compare = Tuple2.compare(Int.compare, Int.compare);
  };
  include T;
  include Tablecloth.Comparator.Make(T);
};

let suite =
  suite("Map", () => {
    describe("empty", () =>
      test("has length zero", () =>
        expect(Tablecloth.Map.empty((module Char)) |> Map.length)
        |> toEqual(Eq.int, 0)
      )
    );
    //    describe("empty", () =>
    //      test("has length zero", () =>
    //        expect(Tablecloth.Map.empty((module Coordinate)) |> Map.length)
    //        |> toEqual(Eq.int, 0)
    //      )
    //    );
    //
    //    describe("fromArray", () =>
    //      test("has length zero", () =>
    //        expect(
    //          Tablecloth.Map.fromArray((module Coordinate), [||]) |> Map.length,
    //        )
    //        |> toEqual(Eq.int, 0)
    //      )
    //    );
    //
    //    describe("fromList", () =>
    //      test("has length zero", () =>
    //        expect(Map.fromList((module Coordinate), []) |> Map.length)
    //        |> toEqual(Eq.int, 0)
    //      )
    //    );

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
