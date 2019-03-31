open Tablecloth
open Jest
open Expect

let () =
  describe "List" (fun () ->
    test "reverse empty list" (fun () -> expect (List.reverse []) |> toEqual []);
    test "reverse one element" (fun () -> expect (List.reverse [0]) |> toEqual [0]);
    test "reverse two elements" (fun () -> expect (List.reverse [0;1]) |> toEqual [1;0]);

    test "map2 empty lists" (fun () -> expect (List.map2 ~f:(+) [] []) |> toEqual []);
    test "map2 one element" (fun () -> expect (List.map2 ~f:(+) [1] [1]) |> toEqual [2]);
    test "map2 two elements" (fun () -> expect (List.map2 ~f:(+) [1;2] [1;2]) |> toEqual [2;4]);

    test "indexedMap empty list" (fun () -> expect (List.indexedMap ~f:(fun i _ -> i) []) |> toEqual []);
    test "indexedMap one element" (fun () -> expect (List.indexedMap ~f:(fun i _ -> i) ['a']) |> toEqual [0]);
    test "indexedMap two elements" (fun () -> expect (List.indexedMap ~f:(fun i _ -> i) ['a';'b']) |> toEqual [0;1]);

    test "init empty list" (fun () -> expect (List.init []) |> toEqual None);
    test "init one element" (fun () -> expect (List.init ['a']) |> toEqual (Some []));
    test "init two elements" (fun () -> expect (List.init ['a';'b']) |> toEqual (Some ['a']));

    test "partition empty list" (fun () -> expect (List.partition ~f:(fun x -> x mod 2 = 0) []) |> toEqual ([], []));
    test "partition one element" (fun () -> expect (List.partition ~f:(fun x -> x mod 2 = 0) [1]) |> toEqual ([], [1]));
    test "partition four elements" (fun () -> expect (List.partition ~f:(fun x -> x mod 2 = 0) [1;2;3;4]) |> toEqual ([2;4], [1;3]));

    test "minimumBy empty list" (fun () -> expect (List.minimumBy ~f:identity []) |> toEqual None);
    test "minimumBy  one element" (fun () -> expect (List.minimumBy  ~f:identity [1]) |> toEqual (Some 1));
    test "minimumBy four elements" (fun () -> expect (List.minimumBy ~f:identity [1;2;3;4]) |> toEqual (Some 1));

    test "maximumBy empty list" (fun () -> expect (List.maximumBy ~f:identity []) |> toEqual None);
    test "maximumBy  one element" (fun () -> expect (List.maximumBy  ~f:identity [1]) |> toEqual (Some 1));
    test "maximumBy four elements" (fun () -> expect (List.maximumBy ~f:identity [1;2;3;4]) |> toEqual (Some 4));

    test "intersperse empty list" (fun () -> expect (List.intersperse ~sep:"on" []) |> toEqual []);
    test "intersperse one turtle" (fun () -> expect (List.intersperse ~sep:"on" ["turtles"]) |> toEqual ["turtles"]);
    test "intersperse three turtles" (fun () -> expect (List.intersperse ~sep:"on" ["turtles";"turtles";"turtles"]) |> toEqual ["turtles";"on";"turtles";"on";"turtles"]);

  );

  describe "Option" (fun () ->
    test "values empty list" (fun () -> expect (Option.values []) |> toEqual []);
    test "values one None" (fun () -> expect (Option.values [None]) |> toEqual []);
    test "values two Nones" (fun () -> expect (Option.values [None;None]) |> toEqual []);
    test "values one Some" (fun () -> expect (Option.values [Some 1]) |> toEqual [1]);
    test "values two Somes" (fun () -> expect (Option.values [Some 1;Some 1]) |> toEqual [1;1]);
    test "values mixed" (fun () -> expect (Option.values [None;Some 1]) |> toEqual [1]);
  );

  describe "String" (fun () ->
    test "length empty string" (fun () -> expect (String.length "") |> toEqual 0);
    test "length" (fun () -> expect (String.length "123") |> toEqual 3);
    test "reverse empty string" (fun () -> expect (String.reverse "") |> toEqual "");
    test "reverse" (fun () -> expect (String.reverse "stressed") |> toEqual "desserts");
  );

  describe "Tuple2" (fun () ->
    test "create" (fun () -> 
      expect (Tuple2.create 3 4) |> toEqual (3, 4)      
    );

    test "first" (fun () -> 
      expect (Tuple2.first (3, 4)) |> toEqual 3      
    );

    test "second" (fun () -> 
      expect (Tuple2.second (3, 4)) |> toEqual 4      
    );

    test "mapFirst" (fun () ->
      expect (Tuple2.mapFirst ~f:String.reverse ("stressed", 16)) |> toEqual ("desserts", 16)      
    );

    test "mapSecond" (fun () ->
      expect (Tuple2.mapSecond ~f:sqrt ("stressed", 16.)) |> toEqual ("stressed", 4.)      
    );

    test "mapEach" (fun () ->
      expect (Tuple2.mapEach ~f:String.reverse ~g:sqrt ("stressed", 16.)) |> toEqual ("desserts", 4.)      
    );

    test "mapAll" (fun () ->
      expect (Tuple2.mapAll ~f:String.reverse ("was", "stressed")) |> toEqual ("saw", "desserts")      
    );

    test "swap" (fun () ->
      expect (Tuple2.swap (3, 4)) |> toEqual (4, 3)      
    );

    test "curry" (fun () ->
      let tupleAdder (a, b) = a + b in
      expect (Tuple2.curry tupleAdder 3 4) |> toEqual 7
    );

    test "uncurry" (fun () ->
      let curriedAdder a b = a + b in
      expect (Tuple2.uncurry curriedAdder (3, 4)) |> toEqual 7
    );

    test "toList" (fun () ->
      expect (Tuple2.toList (3, 4)) |> toEqual [3; 4]
    );
  );

  describe "Tuple3" (fun () ->
    test "create" (fun () -> 
      expect (Tuple3.create 3 4 5) |> toEqual (3, 4, 5)      
    );

    test "first" (fun () -> 
      expect (Tuple3.first (3, 4, 5)) |> toEqual 3      
    );

    test "second" (fun () -> 
      expect (Tuple3.second (3, 4, 5)) |> toEqual 4      
    );

    test "third" (fun () -> 
      expect (Tuple3.third (3, 4, 5)) |> toEqual 5      
    );

    test "init" (fun () -> 
      expect (Tuple3.init (3, 4, 5)) |> toEqual (3, 4)      
    );

    test "tail" (fun () -> 
      expect (Tuple3.tail (3, 4, 5)) |> toEqual (4, 5)      
    );

    test "mapFirst" (fun () ->
      expect (Tuple3.mapFirst ~f:String.reverse ("stressed", 16, false)) |> toEqual ("desserts", 16, false)
    );

    test "mapSecond" (fun () ->
      expect (Tuple3.mapSecond ~f:sqrt ("stressed", 16., false)) |> toEqual ("stressed", 4., false)      
    );

    test "mapThird" (fun () ->
      expect (Tuple3.mapThird ~f:not ("stressed", 16, false)) |> toEqual ("stressed", 16, true);
    );

    test "mapEach" (fun () ->
      expect (Tuple3.mapEach ~f:String.reverse ~g:sqrt ~h:not ("stressed", 16., false)) |> toEqual ("desserts", 4., true)
    );

    test "mapAll" (fun () ->
      expect (Tuple3.mapAll ~f:String.reverse ("was", "stressed", "now")) |> toEqual ("saw", "desserts", "won")
    );

    test "rotateLeft" (fun () ->
      expect (Tuple3.rotateLeft (3, 4, 5)) |> toEqual (4, 5, 3)
    );

    test "rotateRight" (fun () ->
      expect (Tuple3.rotateRight (3, 4, 5)) |> toEqual (5, 3, 4)
    );

    test "curry" (fun () ->
      let tupleAdder (a, b, c) = a + b + c in
      expect (Tuple3.curry tupleAdder 3 4 5) |> toEqual 12
    );

    test "uncurry" (fun () ->
      let curriedAdder a b c = a + b + c in
      expect (Tuple3.uncurry curriedAdder (3, 4, 5)) |> toEqual 12
    );

    test "toList" (fun () ->
      expect (Tuple3.toList (3, 4, 5)) |> toEqual [3; 4; 5]
    );
  );
