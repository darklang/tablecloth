open Tablecloth;
open AlcoJest;

let suite =
  suite("Tuple2", () => {
    test("make", () => {
      expect(Tuple2.make(3, 4)) |> toEqual(Eq.(pair(int, int)), (3, 4))
    });

    test("first", () => {
      expect(Tuple2.first((3, 4))) |> toEqual(Eq.(int), 3)
    });

    test("second", () => {
      expect(Tuple2.second((3, 4))) |> toEqual(Eq.(int), 4)
    });

    test("mapFirst", () => {
      expect(Tuple2.mapFirst(~f=String.reverse, ("stressed", 16)))
      |> toEqual(Eq.(pair(string, int)), ("desserts", 16))
    });

    test("mapSecond", () => {
      expect(Tuple2.mapSecond(~f=Float.squareRoot, ("stressed", 16.)))
      |> toEqual(Eq.(pair(string, float)), ("stressed", 4.))
    });

    test("mapEach", () => {
      expect(
        Tuple2.mapEach(
          ~f=String.reverse,
          ~g=Float.squareRoot,
          ("stressed", 16.),
        ),
      )
      |> toEqual(Eq.(pair(string, float)), ("desserts", 4.))
    });

    test("mapAll", () => {
      expect(Tuple2.mapAll(~f=String.reverse, ("was", "stressed")))
      |> toEqual(Eq.(pair(string, string)), ("saw", "desserts"))
    });

    test("swap", () => {
      expect(Tuple2.swap((3, 4))) |> toEqual(Eq.(pair(int, int)), (4, 3))
    });

    test("toArray", () => {
      expect(Tuple2.toArray((3, 4))) |> toEqual(Eq.(array(int)), [|3, 4|])
    });

    test("toList", () => {
      expect(Tuple2.toList((3, 4))) |> toEqual(Eq.(list(int)), [3, 4])
    });
  });
