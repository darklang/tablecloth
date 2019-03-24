open Tablecloth
open Jest
open Expect
module Array = TC_Array

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

    test "toList" (fun () ->
      expect (Tuple3.toList (3, 4, 5)) |> toEqual [3; 4; 5]
    );
  );

  describe "Array" (fun () ->
    test "create empty array" (fun () -> expect (Array.empty) |> toEqual [||]);
    test "length of empty array" (fun () -> expect Array.(empty |> length) |> toEqual 0);
    test "create empty array with initialize" (fun () -> expect (Array.initialize ~n:0 ~f:identity) |> toEqual [||]);
    test "check if negative length gives an empty array" (fun () -> expect (Array.initialize ~n:(-1) ~f:identity) |> toEqual [||]);
    test "create array with initialize" (fun () -> expect (Array.initialize ~n:3 ~f:identity) |> toEqual [|0;1;2|]);
    test "create empty array with repeat" (fun () -> expect (0 |. Array.repeat ~n:0) |> toEqual [||]);
    test "check if negative length gives an empty array" (fun () -> expect (Array.repeat ~n:(-1) 0) |> toEqual [||]);
    test "create array of ints with repeat & fastpipe" (fun () -> expect (0 |. Array.repeat ~n:3) |> toEqual [|0;0;0|]);
    test "create array of ints with repeat & apply" (fun () -> expect (0 |> Array.repeat ~n:3) |> toEqual [|0;0;0|]);
    test "create array strings with repeat" (fun () -> expect ("cat" |> Array.repeat ~n:3) |> toEqual [|"cat";"cat";"cat"|]);

    test "last element of empty array" (fun () -> expect (Array.last [||]) |> toEqual None);
    test "last element of array" (fun () -> expect (Array.last [|0;1|]) |> toEqual (Some 1));
    test "element index" (fun () -> expect (Array.elem_index ~value:1 [|0;1|]) |> toEqual (Some 1));
    test "element index of value not inside array" (fun () -> expect (Array.elem_index ~value:2 [|0;1|]) |> toEqual None);
    test "element index empty array" (fun () -> expect (Array.elem_index ~value:2 [||]) |> toEqual None);
    test "member there" (fun () -> expect (Array.member ~value:1 [|0;1|]) |> toEqual true);
    test "member missing" (fun () -> expect (Array.member ~value:2 [|0;1|]) |> toEqual false);
    test "head of array" (fun () -> expect (Array.head [|0;1|]) |> toEqual (Some 0));
    test "head of empty array" (fun () -> expect (Array.head [||]) |> toEqual None);

    test "flatten empty arrays" (fun () -> expect (Array.flatten [| [||]; [||]; [||] |]) |> toEqual [||]);
    test "flatten arrays one empty" (fun () -> expect (Array.flatten [|[|1;2;3|]; [||]|]) |> toEqual [|1;2;3|]);
    test "flatten arrays" (fun () -> expect (Array.flatten [| [|1;2;3|]; [|4;5;6|]; [|7;8|] |]) |> toEqual [|1;2;3;4;5;6;7;8|]);
    test "concat arrays" (fun () -> expect (Array.concat [| [|1;2;3|]; [|4;5|] |]) |> toEqual [|1;2;3;4;5|]);
    test "concat arrays one empty" (fun () -> expect (Array.concat [|[|1;2;3|]; [||]|]) |> toEqual [|1;2;3|]);
    test "concat empty arrays" (fun () -> expect (Array.concat [|[||];[||]|]) |> toEqual [||]);

    test "reverse empty array" (fun () -> expect (Array.reverse [||]) |> toEqual [||]);
    test "reverse one element" (fun () -> expect (Array.reverse [|0|]) |> toEqual [|0|]);
    test "reverse two elements" (fun () -> expect (Array.reverse [|0;1|]) |> toEqual [|1;0|]);

    test "init empty array" (fun () -> expect (Array.init [||]) |> toEqual None);
    test "init one element" (fun () -> expect (Array.init [|'a'|]) |> toEqual (Some [||]));
    test "init two elements" (fun () -> expect (Array.init [|'a';'b'|]) |> toEqual (Some [|'a'|]));

    test "member not in array" (fun () -> expect (Array.member [||] ~value:0) |> toEqual false);
    test "member in array" (fun () -> expect (Array.member [|'a'|] ~value:'a') |> toEqual true);

    test "any false" (fun () -> expect (Array.any [||] ~f:(fun e -> e = 0)) |> toEqual false);
    test "any true" (fun () -> expect (Array.any [|0|] ~f:(fun e -> e = 0)) |> toEqual true);

    test "fold left empty array" (fun () -> expect (Array.foldl [||] ~f:(^) ~init:"") |> toEqual "");
    test "fold left" (fun () -> expect (Array.foldl [|"a";"b";"c";"d"|] ~f:(^) ~init:"") |> toEqual "abcd");
    test "fold right" (fun () -> expect (Array.foldr [|"a";"b";"c";"d"|] ~f:(^) ~init:"") |> toEqual "dcba");
  );

(*    test "map2 empty lists" (fun () -> expect (List.map2 ~f:(+) [] []) |> toEqual []);
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
    test "partition four elements" (fun () -> expect (List.partition ~f:(fun x -> x mod 2 = 0) [1;2;3;4]) |> toEqual ([2;4], [1;3]));*)
