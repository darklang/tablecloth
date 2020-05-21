open Tablecloth;
open AlcoJest;

let suite =
  suite("Fun", () => {
    test("identity", () => {
      expect(Fun.identity(1)) |> toEqual(Eq.int, 1)
    });

    test("ignore", () => {
      expect(Fun.ignore(1)) |> toEqual(Eq.unit, ())
    });

    test("constant", () => {
      expect(Fun.constant(1, 2)) |> toEqual(Eq.int, 1)
    });

    test("sequence", () => {
      expect(Fun.sequence(1, 2)) |> toEqual(Eq.int, 2)
    });

    test("flip", () => {
      expect(Fun.flip(Int.(/), 2, 4)) |> toEqual(Eq.int, 2)
    });

    test("apply", () => {
      expect(Fun.apply(a => a + 1, 1)) |> toEqual(Eq.int, 2)
    });

    let increment = x => x + 1;
    let double = x => x * 2;
    test("compose", () => {
      expect(Fun.compose(increment, double, 1)) |> toEqual(Eq.int, 3)
    });

    test("<<", () => {
      expect(Fun.(increment << double)(1)) |> toEqual(Eq.int, 3)
    });

    test("composeRight", () => {
      expect(Fun.composeRight(increment, double, 1)) |> toEqual(Eq.int, 4)
    });

    test(">>", () => {
      expect(Fun.(increment >> double)(1)) |> toEqual(Eq.int, 4)
    });

    test("tap", () => {
      expect(
        Array.filter([|1, 3, 2, 5, 4|], ~f=Int.isEven)
        |> Fun.tap(~f=numbers => ignore(numbers[1] = 0))
        |> Fun.tap(~f=Array.reverseInPlace),
      )
      |> toEqual(Eq.(array(int)), [|0, 2|])
    });

    test("curry", () => {
      expect(Fun.curry(((a, b)) => a / b, 8, 4)) |> toEqual(Eq.(int), 2)
    });

    test("uncurry", () => {
      expect(Fun.uncurry((a, b) => a / b, (8, 4))) |> toEqual(Eq.(int), 2)
    });

    test("curry3", () => {
      let tupleAdder = ((a, b, c)) => a + b + c;
      expect(Fun.curry3(tupleAdder, 3, 4, 5)) |> toEqual(Eq.int, 12);
    });

    test("uncurry3", () => {
      let curriedAdder = (a, b, c) => a + b + c;
      expect(Fun.uncurry3(curriedAdder, (3, 4, 5))) |> toEqual(Eq.int, 12);
    });
  });
