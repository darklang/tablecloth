open Tablecloth
open Jest
open Expect

let () =
  describe "List" (fun () ->
      describe "reverse" (fun () ->
          test "reverse empty list" (fun () ->
              expect (List.reverse []) |> toEqual []) ;
          test "reverse one element" (fun () ->
              expect (List.reverse [ 0 ]) |> toEqual [ 0 ]) ;
          test "reverse two elements" (fun () ->
              expect (List.reverse [ 0; 1 ]) |> toEqual [ 1; 0 ])) ;
      describe "map2" (fun () ->
          test "map2 empty lists" (fun () ->
              expect (List.map2 ~f:( + ) [] []) |> toEqual []) ;
          test "map2 one element" (fun () ->
              expect (List.map2 ~f:( + ) [ 1 ] [ 1 ]) |> toEqual [ 2 ]) ;
          test "map2 two elements" (fun () ->
              expect (List.map2 ~f:( + ) [ 1; 2 ] [ 1; 2 ]) |> toEqual [ 2; 4 ])) ;
      describe "indexedMap" (fun () ->
          test "indexedMap empty list" (fun () ->
              expect (List.indexedMap ~f:(fun i _ -> i) []) |> toEqual []) ;
          test "indexedMap one element" (fun () ->
              expect (List.indexedMap ~f:(fun i _ -> i) [ 'a' ])
              |> toEqual [ 0 ]) ;
          test "indexedMap two elements" (fun () ->
              expect (List.indexedMap ~f:(fun i _ -> i) [ 'a'; 'b' ])
              |> toEqual [ 0; 1 ])) ;
      describe "sliding" (fun () ->
          test "size 1" (fun () ->
              expect (List.sliding [ 1; 2; 3; 4; 5 ] ~size:1)
              |> toEqual [ [ 1 ]; [ 2 ]; [ 3 ]; [ 4 ]; [ 5 ] ]) ;
          test "size 2" (fun () ->
              expect (List.sliding [ 1; 2; 3; 4; 5 ] ~size:2)
              |> toEqual [ [ 1; 2 ]; [ 2; 3 ]; [ 3; 4 ]; [ 4; 5 ] ]) ;
          test "step 3 " (fun () ->
              expect (List.sliding [ 1; 2; 3; 4; 5 ] ~size:3)
              |> toEqual [ [ 1; 2; 3 ]; [ 2; 3; 4 ]; [ 3; 4; 5 ] ]) ;
          test "size 2, step 2" (fun () ->
              expect (List.sliding [ 1; 2; 3; 4; 5 ] ~size:2 ~step:2)
              |> toEqual [ [ 1; 2 ]; [ 3; 4 ] ]) ;
          test "size 1, step 3" (fun () ->
              expect (List.sliding [ 1; 2; 3; 4; 5 ] ~size:1 ~step:3)
              |> toEqual [ [ 1 ]; [ 4 ] ]) ;
          test "size 2, step 3" (fun () ->
              expect (List.sliding [ 1; 2; 3; 4; 5 ] ~size:2 ~step:3)
              |> toEqual [ [ 1; 2 ]; [ 4; 5 ] ]) ;
          test "step 7" (fun () ->
              expect (List.sliding [ 1; 2; 3; 4; 5 ] ~size:7) |> toEqual [])) ;
      describe "partition" (fun () ->
          test "empty list" (fun () ->
              expect (List.partition ~f:(fun x -> x mod 2 = 0) [])
              |> toEqual ([], [])) ;
          test "one element" (fun () ->
              expect (List.partition ~f:(fun x -> x mod 2 = 0) [ 1 ])
              |> toEqual ([], [ 1 ])) ;
          test "four elements" (fun () ->
              expect (List.partition ~f:(fun x -> x mod 2 = 0) [ 1; 2; 3; 4 ])
              |> toEqual ([ 2; 4 ], [ 1; 3 ]))) ;
      describe "minimumBy" (fun () ->
          test "minimumBy non-empty list" (fun () ->
              expect
                (List.minimumBy ~f:(fun x -> x mod 12) [ 7; 9; 15; 10; 3; 22 ])
              |> toEqual (Some 15)) ;
          test "minimumBy empty list" (fun () ->
              expect (List.minimumBy ~f:(fun x -> x mod 12) []) |> toEqual None)) ;
      describe "maximumBy" (fun () ->
          test "maximumBy non-empty list" (fun () ->
              expect
                (List.maximumBy ~f:(fun x -> x mod 12) [ 7; 9; 15; 10; 3; 22 ])
              |> toEqual (Some 10)) ;
          test "maximumBy empty list" (fun () ->
              expect (List.maximumBy ~f:(fun x -> x mod 12) []) |> toEqual None)) ;
      describe "minimum" (fun () ->
          test "minimum non-empty list" (fun () ->
              expect (List.minimum [ 7; 9; 15; 10; 3 ]) |> toEqual (Some 3)) ;
          test "minimum empty list" (fun () ->
              expect (List.minimum []) |> toEqual None)) ;
      describe "maximum" (fun () ->
          test "maximum non-empty list" (fun () ->
              expect (List.maximum [ 7; 9; 15; 10; 3 ]) |> toEqual (Some 15)) ;
          test "maximum empty list" (fun () ->
              expect (List.maximum []) |> toEqual None)) ;
      describe "split_when" (fun () ->
          test "empty list" (fun () ->
              expect (List.split_when ~f:(fun x -> x mod 2 = 0) [])
              |> toEqual ([], [])) ;
          test "at zero" (fun () ->
              expect (List.split_when ~f:(fun x -> x mod 2 = 0) [ 2; 4; 6 ])
              |> toEqual ([], [ 2; 4; 6 ])) ;
          test "four elements" (fun () ->
              expect (List.split_when ~f:(fun x -> x mod 2 = 0) [ 1; 3; 2; 4 ])
              |> toEqual ([ 1; 3 ], [ 2; 4 ])) ;
          test "at end" (fun () ->
              expect (List.split_when ~f:(fun x -> x mod 2 = 0) [ 1; 3; 5 ])
              |> toEqual ([ 1; 3; 5 ], []))) ;
      describe "intersperse" (fun () ->
          test "intersperse empty list" (fun () ->
              expect (List.intersperse "on" []) |> toEqual []) ;
          test "intersperse one turtle" (fun () ->
              expect (List.intersperse "on" [ "turtles" ])
              |> toEqual [ "turtles" ]) ;
          test "intersperse three turtles" (fun () ->
              expect (List.intersperse "on" [ "turtles"; "turtles"; "turtles" ])
              |> toEqual [ "turtles"; "on"; "turtles"; "on"; "turtles" ])) ;
      describe "init" (fun () ->
          test "init empty list" (fun () ->
              expect (List.init []) |> toEqual None) ;
          test "init one element" (fun () ->
              expect (List.init [ 'a' ]) |> toEqual (Some [])) ;
          test "init two elements" (fun () ->
              expect (List.init [ 'a'; 'b' ]) |> toEqual (Some [ 'a' ]))) ;
      describe "append" (fun () ->
          test "append empty lists" (fun () ->
              expect (List.append [] []) |> toEqual []) ;
          test "append empty list" (fun () ->
              expect (List.append [] [ "turtles" ]) |> toEqual [ "turtles" ]) ;
          test "append empty list" (fun () ->
              expect (List.append [ "turtles" ] []) |> toEqual [ "turtles" ]) ;
          test "append two lists" (fun () ->
              expect (List.append [ "on" ] [ "turtles" ])
              |> toEqual [ "on"; "turtles" ])) ;
      describe "folds" (fun () ->
          test "foldl empty list" (fun () ->
              expect (List.foldLeft ~f:(fun x acc -> x :: acc) ~initial:[] [])
              |> toEqual []) ;
          test "foldl one element" (fun () ->
              expect
                (List.foldLeft ~f:(fun x acc -> x :: acc) ~initial:[] [ 1 ])
              |> toEqual [ 1 ]) ;
          test "foldl three elements" (fun () ->
              expect
                (List.foldLeft
                   ~f:(fun x acc -> x :: acc)
                   ~initial:[]
                   [ 1; 2; 3 ])
              |> toEqual [ 3; 2; 1 ]) ;
          test "foldr empty list" (fun () ->
              expect (List.foldRight ~f:(fun x acc -> x :: acc) ~initial:[] [])
              |> toEqual []) ;
          test "foldr one element" (fun () ->
              expect
                (List.foldRight ~f:(fun x acc -> x :: acc) ~initial:[] [ 1 ])
              |> toEqual [ 1 ]) ;
          test "foldr three elements" (fun () ->
              expect
                (List.foldRight
                   ~f:(fun x acc -> x :: acc)
                   ~initial:[]
                   [ 1; 2; 3 ])
              |> toEqual [ 1; 2; 3 ]) ;
          test "foldl issue #18" (fun () ->
              expect (List.foldLeft ~f:( - ) ~initial:0 [ 1; 2; 3 ])
              |> toEqual 2) ;
          test "foldr issue #18" (fun () ->
              expect (List.foldRight ~f:( - ) ~initial:0 [ 1; 2; 3 ])
              |> toEqual 2) ;
          test "foldl issue #18" (fun () ->
              expect (List.foldLeft ~f:( - ) ~initial:0 [ 3; 2; 1 ])
              |> toEqual 2) ;
          test "foldl issue #18" (fun () ->
              expect (List.foldRight ~f:( - ) ~initial:0 [ 3; 2; 1 ])
              |> toEqual 2)) ;
      describe "insertAt" (fun () ->
          test "insertAt empty list" (fun () ->
              expect (List.insertAt ~index:0 ~value:1 []) |> toEqual [ 1 ]) ;
          test "insertAt in the middle" (fun () ->
              expect (List.insertAt ~index:1 ~value:2 [ 1; 3 ])
              |> toEqual [ 1; 2; 3 ]) ;
          test "insertAt in the front" (fun () ->
              expect (List.insertAt ~index:0 ~value:2 [ 1; 3 ])
              |> toEqual [ 2; 1; 3 ]) ;
          (*      the test below fails on native, both should show the same behaviour  *)
          test "insertAt after end of list" (fun () ->
              expect (List.insertAt ~index:4 ~value:2 [ 1; 3 ]) |> toEqual [ 2 ])) ;
      describe "updateAt" (fun () ->
          test "updateAt index smaller 0" (fun () ->
              expect (List.updateAt ~index:(-1) ~f:(fun x -> x + 1) [ 1; 3 ])
              |> toEqual [ 1; 3 ]) ;
          test "updateAt empty list" (fun () ->
              expect (List.updateAt ~index:0 ~f:(fun x -> x + 1) [])
              |> toEqual []) ;
          test "updateAt empty list" (fun () ->
              expect (List.updateAt ~index:2 ~f:(fun x -> x + 1) [])
              |> toEqual []) ;
          test "updateAt inside the list" (fun () ->
              expect (List.updateAt ~index:1 ~f:(fun x -> x + 1) [ 1; 3 ])
              |> toEqual [ 1; 4 ]) ;
          test "updateAt in the front" (fun () ->
              expect (List.updateAt ~index:0 ~f:(fun x -> x + 1) [ 1; 3 ])
              |> toEqual [ 2; 3 ]) ;
          test "updateAt after end of list" (fun () ->
              expect (List.updateAt ~index:4 ~f:(fun x -> x + 1) [ 1; 3 ])
              |> toEqual [ 1; 3 ])) ;
      describe "concat" (fun () ->
          test "concat two empty lists" (fun () ->
              expect (List.concat [ []; [] ]) |> toEqual []) ;
          test "concat with one empty list" (fun () ->
              expect (List.concat [ [ 1 ]; [] ]) |> toEqual [ 1 ]) ;
          test "concat with one empty list" (fun () ->
              expect (List.concat [ []; [ 1 ] ]) |> toEqual [ 1 ]) ;
          test "concat with several lists" (fun () ->
              expect (List.concat [ [ 1 ]; [ 2 ]; [ 3 ] ])
              |> toEqual [ 1; 2; 3 ]) ;
          test "concat with several lists" (fun () ->
              expect (List.concat [ [ 1 ]; []; [ 2 ]; []; [ 3 ] ])
              |> toEqual [ 1; 2; 3 ])) ;
      describe "span" (fun () ->
          test "span empty list" (fun () ->
              expect (List.span ~f:(fun x -> x mod 2 = 0) []) |> toEqual ([], [])) ;
          test "span list" (fun () ->
              expect (List.span ~f:(fun x -> x mod 2 = 0) [ 4; 6; 8; 1; 2; 3 ])
              |> toEqual ([ 4; 6; 8 ], [ 1; 2; 3 ])) ;
          test "span list" (fun () ->
              expect (List.span ~f:(fun x -> x mod 2 = 0) [ 1; 2; 3 ])
              |> toEqual ([], [ 1; 2; 3 ])) ;
          test "span list" (fun () ->
              expect (List.span ~f:(fun x -> x mod 2 = 0) [ 20; 40; 60 ])
              |> toEqual ([ 20; 40; 60 ], []))) ;
      describe "initialize" (fun () ->
          test "initialize length 0" (fun () ->
              expect (List.initialize 0 (fun i -> i)) |> toEqual []) ;
          test "initialize length 1" (fun () ->
              expect (List.initialize 1 (fun i -> i)) |> toEqual [ 0 ]) ;
          test "initialize length 2" (fun () ->
              expect (List.initialize 2 (fun i -> i)) |> toEqual [ 0; 1 ])) ;
      describe "removeAt" (fun () ->
          test "removeAt index smaller 0" (fun () ->
              expect (List.removeAt ~index:(-1) [ 1; 3 ]) |> toEqual [ 1; 3 ]) ;
          test "removeAt empty list" (fun () ->
              expect (List.removeAt ~index:0 []) |> toEqual []) ;
          test "removeAt empty list" (fun () ->
              expect (List.removeAt ~index:2 []) |> toEqual []) ;
          test "removeAt index 1" (fun () ->
              expect (List.removeAt ~index:1 [ 1; 3 ]) |> toEqual [ 1 ]) ;
          test "removeAt index 0" (fun () ->
              expect (List.removeAt ~index:0 [ 1; 3 ]) |> toEqual [ 3 ]) ;
          test "removeAt after end of list" (fun () ->
              expect (List.removeAt ~index:4 [ 1; 3 ]) |> toEqual [ 1; 3 ]))) ;
  describe "repeat" (fun () ->
      test "repeat length 0" (fun () ->
          expect (List.repeat ~count:0 5) |> toEqual []) ;
      test "repeat length 1" (fun () ->
          expect (List.repeat ~count:1 5) |> toEqual [ 5 ]) ;
      test "repeat length 3" (fun () ->
          expect (List.repeat ~count:3 5) |> toEqual [ 5; 5; 5 ]))
