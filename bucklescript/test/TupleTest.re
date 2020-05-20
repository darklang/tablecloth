open Tablecloth;
open AlcoJest;

let suite =
  suite("Tuple", () => {
    test("make", () => {
      expect(Tuple.make(3, 4)) |> toEqual(Eq.(pair(int, int)), (3, 4))
    });

    test("first", () => {
      expect(Tuple.first((3, 4))) |> toEqual(Eq.(int), 3)
    });

    test("second", () => {
      expect(Tuple.second((3, 4))) |> toEqual(Eq.(int), 4)
    });

    test("mapFirst", () => {
      expect(Tuple.mapFirst(~f=String.reverse, ("stressed", 16)))
      |> toEqual(Eq.(pair(string, int)), ("desserts", 16))
    });

    test("mapSecond", () => {
      expect(Tuple.mapSecond(~f=Float.squareRoot, ("stressed", 16.)))
      |> toEqual(Eq.(pair(string, float)), ("stressed", 4.))
    });

    test("mapEach", () => {
      expect(
        Tuple.mapEach(
          ~f=String.reverse,
          ~g=Float.squareRoot,
          ("stressed", 16.),
        ),
      )
      |> toEqual(Eq.(pair(string, float)), ("desserts", 4.))
    });

    test("mapAll", () => {
      expect(Tuple.mapAll(~f=String.reverse, ("was", "stressed")))
      |> toEqual(Eq.(pair(string, string)), ("saw", "desserts"))
    });

    test("swap", () => {
      expect(Tuple.swap((3, 4))) |> toEqual(Eq.(pair(int, int)), (4, 3))
    });

    test("toArray", () => {
      expect(Tuple.toArray((3, 4))) |> toEqual(Eq.(array(int)), [|3, 4|])
    });

    test("toList", () => {
      expect(Tuple.toList((3, 4))) |> toEqual(Eq.(list(int)), [3, 4])
    });
  });
