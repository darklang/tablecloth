open Tablecloth;
open AlcoJest;

let suite =
  suite("List", () => {
    open List;

    describe("filterMap", () => {
      test("keeps elements which return Some", () => {
        expect(List.filterMap([(-1), 80, 99], ~f=Char.fromCode))
        |> toEqual(Eq.(list(char)), ['P', 'c'])
      })
    });

    describe("drop", () => {
      test("from an empty list", () =>
        expect(drop([], ~count=1)) |> toEqual(Eq.(list(int)), [])
      );

      test("zero elements", () =>
        expect(drop([1, 2, 3], ~count=0))
        |> toEqual(Eq.(list(int)), [1, 2, 3])
      );

      test("the first element", () =>
        expect(drop([1, 2, 3], ~count=1))
        |> toEqual(Eq.(list(int)), [2, 3])
      );

      test("all elements", () =>
        expect(drop([1, 2, 3], ~count=3)) |> toEqual(Eq.(list(int)), [])
      );

      test("greater than the number of elements", () =>
        expect(drop([1, 2, 3], ~count=4)) |> toEqual(Eq.(list(int)), [])
      );
    });

    describe("findIndex", () => {
      test(
        "returns the first (index, element) tuple which f returns true for", () => {
        expect(
          findIndex(
            ~f=(index, number) => index > 2 && Int.isEven(number),
            [1, 3, 4, 8],
          ),
        )
        |> toEqual(Eq.(option(pair(int, int))), Some((3, 8)))
      });

      test("returns `None` if `f` returns false for all elements ", () => {
        expect(findIndex(~f=(_, _) => false, [0, 2, 4, 8]))
        |> toEqual(Eq.(option(pair(int, int))), None)
      });

      test("returns `None` for an empty array", () => {
        expect(
          findIndex(
            ~f=(index, number) => index > 2 && Int.isEven(number),
            [],
          ),
        )
        |> toEqual(Eq.(option(pair(int, int))), None)
      });
    });

    describe("reverse", () => {
      test("empty list", () => {
        expect(reverse([])) |> toEqual(Eq.(list(int)), [])
      });
      test("one element", () => {
        expect(reverse([0])) |> toEqual(Eq.(list(int)), [0])
      });
      test("two elements", () => {
        expect(reverse([0, 1])) |> toEqual(Eq.(list(int)), [1, 0])
      });
    });

    describe("map2", () => {
      test("map2 empty lists", () => {
        expect(map2(~f=(+), [], [])) |> toEqual(Eq.(list(int)), [])
      });
      test("map2 one element", () => {
        expect(map2(~f=(+), [1], [1])) |> toEqual(Eq.(list(int)), [2])
      });
      test("map2 two elements", () => {
        expect(map2(~f=(+), [1, 2], [1, 2]))
        |> toEqual(Eq.(list(int)), [2, 4])
      });
    });

    describe("mapWithIndex", () => {
      test("on an empty list", () => {
        expect(mapWithIndex(~f=(i, _) => i, []))
        |> toEqual(Eq.(list(int)), [])
      });
      test("with a single element", () => {
        expect(mapWithIndex(~f=(i, _) => i, ['a']))
        |> toEqual(Eq.(list(int)), [0])
      });
      test("with two elements", () => {
        expect(mapWithIndex(~f=(i, _) => i, ['a', 'b']))
        |> toEqual(Eq.(list(int)), [0, 1])
      });
    });

    describe("sliding", () => {
      test("size 1", () => {
        expect(sliding([1, 2, 3, 4, 5], ~size=1))
        |> toEqual(Eq.(list(list(int))), [[1], [2], [3], [4], [5]])
      });

      test("size 2", () => {
        expect(sliding([1, 2, 3, 4, 5], ~size=2))
        |> toEqual(
             Eq.(list(list(int))),
             [[1, 2], [2, 3], [3, 4], [4, 5]],
           )
      });

      test("step 3 ", () => {
        expect(sliding([1, 2, 3, 4, 5], ~size=3))
        |> toEqual(
             Eq.(list(list(int))),
             [[1, 2, 3], [2, 3, 4], [3, 4, 5]],
           )
      });

      test("size 2, step 2", () => {
        expect(sliding([1, 2, 3, 4, 5], ~size=2, ~step=2))
        |> toEqual(Eq.(list(list(int))), [[1, 2], [3, 4]])
      });

      test("size 1, step 3", () => {
        expect(sliding([1, 2, 3, 4, 5], ~size=1, ~step=3))
        |> toEqual(Eq.(list(list(int))), [[1], [4]])
      });

      test("size 2, step 3", () => {
        expect(sliding([1, 2, 3, 4, 5], ~size=2, ~step=3))
        |> toEqual(Eq.(list(list(int))), [[1, 2], [4, 5]])
      });

      test("step 7", () => {
        expect(sliding([1, 2, 3, 4, 5], ~size=7))
        |> toEqual(Eq.(list(list(int))), [])
      });
    });

    describe("partition", () => {
      test("empty list", () => {
        expect(partition(~f=Int.isEven, []))
        |> toEqual(Eq.(pair(list(int), list(int))), ([], []))
      });
      test("one element", () => {
        expect(partition(~f=Int.isEven, [1]))
        |> toEqual(Eq.(pair(list(int), list(int))), ([], [1]))
      });
      test("four elements", () => {
        expect(partition(~f=Int.isEven, [1, 2, 3, 4]))
        |> toEqual(Eq.(pair(list(int), list(int))), ([2, 4], [1, 3]))
      });
    });

    describe("minimum", () => {
      test("minimum non-empty list", () => {
        expect(minimum([7, 9, 15, 10, 3], ~compare=Int.compare))
        |> toEqual(Eq.(option(int)), Some(3))
      });
      test("minimum empty list", () => {
        expect(minimum([], ~compare=Int.compare))
        |> toEqual(Eq.(option(int)), None)
      });
    });

    describe("maximum", () => {
      test("maximum non-empty list", () => {
        expect(maximum([7, 9, 15, 10, 3], ~compare=Int.compare))
        |> toEqual(Eq.(option(int)), Some(15))
      });
      test("maximum empty list", () => {
        expect(maximum([], ~compare=Int.compare))
        |> toEqual(Eq.(option(int)), None)
      });
    });

    describe("splitAt", () => {
      test("empty list", () => {
        expect(splitAt([], ~index=1))
        |> toEqual(Eq.(pair(list(int), list(int))), ([], []))
      });
      test("at evens", () => {
        expect(splitAt(~index=0, [2, 4, 6]))
        |> toEqual(Eq.(pair(list(int), list(int))), ([], [2, 4, 6]))
      });
      test("four elements", () => {
        expect(splitAt(~index=2, [1, 3, 2, 4]))
        |> toEqual(Eq.(pair(list(int), list(int))), ([1, 3], [2, 4]))
      });
      test("at end", () => {
        expect(splitAt(~index=3, [1, 3, 5]))
        |> toEqual(Eq.(pair(list(int), list(int))), ([1, 3, 5], []))
      });

      test("past end", () => {
        expect(splitAt(~index=6, [1, 3, 5]))
        |> toEqual(Eq.(pair(list(int), list(int))), ([1, 3, 5], []))
      });
    });

    describe("splitWhen", () => {
      test("empty list", () => {
        expect(splitWhen(~f=Int.isEven, []))
        |> toEqual(Eq.(pair(list(int), list(int))), ([], []))
      });
      test("the first element satisfies f", () => {
        expect(splitWhen(~f=Int.isEven, [2, 4, 6]))
        |> toEqual(Eq.(pair(list(int), list(int))), ([], [2, 4, 6]))
      });
      test("the last element satisfies f", () => {
        expect(splitWhen(~f=Int.isEven, [1, 3, 2, 4]))
        |> toEqual(Eq.(pair(list(int), list(int))), ([1, 3], [2, 4]))
      });
      test("no element satisfies f", () => {
        expect(splitWhen(~f=Int.isEven, [1, 3, 5]))
        |> toEqual(Eq.(pair(list(int), list(int))), ([1, 3, 5], []))
      });
    });

    describe("intersperse", () => {
      test("intersperse empty list", () => {
        expect(intersperse([], ~sep="on"))
        |> toEqual(Eq.(list(string)), [])
      });
      test("intersperse one turtle", () => {
        expect(intersperse(~sep="on", ["turtles"]))
        |> toEqual(Eq.(list(string)), ["turtles"])
      });
      test("intersperse three turtles", () => {
        expect(intersperse(~sep="on", ["turtles", "turtles", "turtles"]))
        |> toEqual(
             Eq.(list(string)),
             ["turtles", "on", "turtles", "on", "turtles"],
           )
      });
    });

    describe("initial", () => {
      test("empty list", () => {
        expect(initial([])) |> toEqual(Eq.(option(list(int))), None)
      });
      test("one element", () => {
        expect(initial(['a']))
        |> toEqual(Eq.(option(list(char))), Some([]))
      });
      test("two elements", () => {
        expect(initial(['a', 'b']))
        |> toEqual(Eq.(option(list(char))), Some(['a']))
      });
    });

    describe("append", () => {
      test("append empty lists", () => {
        expect(append([], [])) |> toEqual(Eq.(list(string)), [])
      });
      test("append empty list", () => {
        expect(append([], ["turtles"]))
        |> toEqual(Eq.(list(string)), ["turtles"])
      });
      test("append empty list", () => {
        expect(append(["turtles"], []))
        |> toEqual(Eq.(list(string)), ["turtles"])
      });
      test("append two lists", () => {
        expect(append(["on"], ["turtles"]))
        |> toEqual(Eq.(list(string)), ["on", "turtles"])
      });
    });

    describe("folds", () => {
      test("empty list", () => {
        expect(fold(~f=cons, ~initial=[], []))
        |> toEqual(Eq.(list(int)), [])
      });
      test("one element", () => {
        expect(fold(~f=cons, ~initial=[], [1]))
        |> toEqual(Eq.(list(int)), [1])
      });
      test("three elements", () => {
        expect(fold(~f=cons, ~initial=[], [1, 2, 3]))
        |> toEqual(Eq.(list(int)), [3, 2, 1])
      });
      test("foldr empty list", () => {
        expect(foldRight(~f=cons, ~initial=[], []))
        |> toEqual(Eq.(list(int)), [])
      });
      test("foldr one element", () => {
        expect(foldRight(~f=cons, ~initial=[], [1]))
        |> toEqual(Eq.(list(int)), [1])
      });
      test("foldr three elements", () => {
        expect(foldRight(~f=cons, ~initial=[], [1, 2, 3]))
        |> toEqual(Eq.(list(int)), [1, 2, 3])
      });
      test("-", () => {
        expect(fold(~f=(-), ~initial=0, [1, 2, 3])) |> toEqual(Eq.int, -6)
      });
      test("- foldRight", () => {
        expect(foldRight(~f=(-), ~initial=0, [1, 2, 3]))
        |> toEqual(Eq.int, -6)
      });
    });

    describe("insertAt", () => {
      test("empty list", () => {
        expect(insertAt(~index=0, ~value=1, []))
        |> toEqual(Eq.(list(int)), [1])
      });
      test("in the middle", () => {
        expect(insertAt(~index=1, ~value=2, [1, 3]))
        |> toEqual(Eq.(list(int)), [1, 2, 3])
      });
      test("in the front", () => {
        expect(insertAt(~index=0, ~value=2, [1, 3]))
        |> toEqual(Eq.(list(int)), [2, 1, 3])
      });

      test("after end of list", () => {
        expect(insertAt(~index=4, ~value=2, [1, 3]) |> toArray)
        |> toEqual(Eq.(array(int)), [|1, 3, 2|])
      });
    });

    describe("updateAt", () => {
      test("updateAt index smaller 0", () => {
        expect(updateAt(~index=-1, ~f=x => x + 1, [1, 3]))
        |> toEqual(Eq.(list(int)), [1, 3])
      });
      test("updateAt empty list", () => {
        expect(updateAt(~index=0, ~f=x => x + 1, []))
        |> toEqual(Eq.(list(int)), [])
      });
      test("updateAt empty list", () => {
        expect(updateAt(~index=2, ~f=x => x + 1, []))
        |> toEqual(Eq.(list(int)), [])
      });
      test("updateAt inside the list", () => {
        expect(updateAt(~index=1, ~f=x => x + 1, [1, 3]))
        |> toEqual(Eq.(list(int)), [1, 4])
      });
      test("updateAt in the front", () => {
        expect(updateAt(~index=0, ~f=x => x + 1, [1, 3]))
        |> toEqual(Eq.(list(int)), [2, 3])
      });
      test("updateAt after end of list", () => {
        expect(updateAt(~index=4, ~f=x => x + 1, [1, 3]))
        |> toEqual(Eq.(list(int)), [1, 3])
      });
    });

    describe("flatten", () => {
      test("two empty lists", () => {
        expect(flatten([[], []])) |> toEqual(Eq.(list(int)), [])
      });
      test("one empty list", () => {
        expect(flatten([[1], []])) |> toEqual(Eq.(list(int)), [1])
      });
      test("one empty list", () => {
        expect(flatten([[], [1]])) |> toEqual(Eq.(list(int)), [1])
      });
      test("several lists", () => {
        expect(flatten([[1], [2], [3]]))
        |> toEqual(Eq.(list(int)), [1, 2, 3])
      });
      test("several lists", () => {
        expect(flatten([[1], [], [2], [], [3]]))
        |> toEqual(Eq.(list(int)), [1, 2, 3])
      });
    });

    describe("initialize", () => {
      test("initialize length 0", () => {
        expect(initialize(0, ~f=i => i)) |> toEqual(Eq.(list(int)), [])
      });
      test("initialize length 1", () => {
        expect(initialize(1, ~f=i => i)) |> toEqual(Eq.(list(int)), [0])
      });
      test("initialize length 2", () => {
        expect(initialize(2, ~f=i => i)) |> toEqual(Eq.(list(int)), [0, 1])
      });
    });

    describe("removeAt", () => {
      test("removeAt index smaller 0", () => {
        expect(removeAt(~index=-1, [1, 3]))
        |> toEqual(Eq.(list(int)), [1, 3])
      });
      test("removeAt empty list", () => {
        expect(removeAt(~index=0, [])) |> toEqual(Eq.(list(int)), [])
      });
      test("removeAt empty list", () => {
        expect(removeAt(~index=2, [])) |> toEqual(Eq.(list(int)), [])
      });
      test("removeAt index 1", () => {
        expect(removeAt(~index=1, [1, 3]))
        |> toEqual(Eq.(list(int)), [1])
      });
      test("removeAt index 0", () => {
        expect(removeAt(~index=0, [1, 3]))
        |> toEqual(Eq.(list(int)), [3])
      });
      test("removeAt after end of list", () => {
        expect(removeAt(~index=4, [1, 3]))
        |> toEqual(Eq.(list(int)), [1, 3])
      });
    });

    describe("groupBy", () => {
      test("returns an empty map for an empty array", () => {
        expect(
          List.groupBy([], (module Int), ~f=String.length) |> Map.length,
        )
        |> toEqual(Eq.int, 0)
      });

      test("example test case", () => {
        let animals = ["Ant", "Bear", "Cat", "Dewgong"];
        expect(
          List.groupBy(animals, (module Int), ~f=String.length) |> Map.toList,
        )
        |> toEqual(
             Eq.(list(pair(int, list(string)))),
             [(3, ["Cat", "Ant"]), (4, ["Bear"]), (7, ["Dewgong"])],
           );
      });
    });
  });
