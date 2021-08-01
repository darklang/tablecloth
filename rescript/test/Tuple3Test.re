open Tablecloth;
open AlcoJest;

let suite =
  suite("Tuple3", () => {
    open Tuple3;

    test("make", () => {
      expect(make(3, 4, 5))
      |> toEqual(Eq.(trio(int, int, int)), (3, 4, 5))
    });

    test("first", () => {
      expect(first((3, 4, 5))) |> toEqual(Eq.int, 3)
    });

    test("second", () => {
      expect(second((3, 4, 5))) |> toEqual(Eq.int, 4)
    });

    test("third", () => {
      expect(third((3, 4, 5))) |> toEqual(Eq.int, 5)
    });

    test("initial", () => {
      expect(initial((3, 4, 5))) |> toEqual(Eq.(pair(int, int)), (3, 4))
    });

    test("tail", () => {
      expect(tail((3, 4, 5))) |> toEqual(Eq.(pair(int, int)), (4, 5))
    });

    test("mapFirst", () => {
      expect(mapFirst(~f=String.reverse, ("stressed", 16, false)))
      |> toEqual(Eq.(trio(string, int, bool)), ("desserts", 16, false))
    });

    test("mapSecond", () => {
      expect(mapSecond(~f=Float.squareRoot, ("stressed", 16., false)))
      |> toEqual(Eq.(trio(string, float, bool)), ("stressed", 4., false))
    });

    test("mapThird", () => {
      expect(mapThird(~f=(!), ("stressed", 16, false)))
      |> toEqual(Eq.(trio(string, int, bool)), ("stressed", 16, true))
    });

    test("mapEach", () => {
      expect(
        mapEach(
          ~f=String.reverse,
          ~g=Float.squareRoot,
          ~h=(!),
          ("stressed", 16., false),
        ),
      )
      |> toEqual(Eq.(trio(string, float, bool)), ("desserts", 4., true))
    });

    test("mapAll", () => {
      expect(mapAll(~f=String.reverse, ("was", "stressed", "now")))
      |> toEqual(
           Eq.(trio(string, string, string)),
           ("saw", "desserts", "won"),
         )
    });

    test("rotateLeft", () => {
      expect(rotateLeft((3, 4, 5)))
      |> toEqual(Eq.(trio(int, int, int)), (4, 5, 3))
    });

    test("rotateRight", () => {
      expect(rotateRight((3, 4, 5)))
      |> toEqual(Eq.(trio(int, int, int)), (5, 3, 4))
    });

    test("toArray", () => {
      expect(toArray((3, 4, 5))) |> toEqual(Eq.(array(int)), [|3, 4, 5|])
    });

    test("toList", () => {
      expect(toList((3, 4, 5))) |> toEqual(Eq.(list(int)), [3, 4, 5])
    });
  });
