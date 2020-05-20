open Tablecloth
open AlcoJest
module AT = Alcotest

let t_List () =
  AT.check (AT.list AT.int) "reverse empty list" (List.reverse []) [] ;
  AT.check (AT.list AT.int) "reverse one element" (List.reverse [ 0 ]) [ 0 ] ;
  AT.check
    (AT.list AT.int)
    "reverse two elements"
    (List.reverse [ 0; 1 ])
    [ 1; 0 ] ;

  AT.check
    (AT.list (AT.list AT.int))
    "sliding - step 1"
    (List.sliding [ 1; 2; 3; 4; 5 ] ~size:1)
    [ [ 1 ]; [ 2 ]; [ 3 ]; [ 4 ]; [ 5 ] ] ;

  AT.check
    (AT.list (AT.list AT.int))
    "sliding - step 2"
    [ [ 1; 2 ]; [ 2; 3 ]; [ 3; 4 ]; [ 4; 5 ] ]
    (List.sliding [ 1; 2; 3; 4; 5 ] ~size:2) ;

  AT.check
    (AT.list (AT.list AT.int))
    "sliding - step 3 "
    [ [ 1; 2; 3 ]; [ 2; 3; 4 ]; [ 3; 4; 5 ] ]
    (List.sliding [ 1; 2; 3; 4; 5 ] ~size:3) ;

  AT.check
    (AT.list (AT.list AT.int))
    "sliding - step 2, size 2"
    [ [ 1; 2 ]; [ 3; 4 ] ]
    (List.sliding [ 1; 2; 3; 4; 5 ] ~size:2 ~step:2) ;

  AT.check
    (AT.list (AT.list AT.int))
    "sliding - step 1, size 3"
    [ [ 1 ]; [ 4 ] ]
    (List.sliding [ 1; 2; 3; 4; 5 ] ~size:1 ~step:3) ;

  AT.check
    (AT.list (AT.list AT.int))
    "sliding - step 7"
    [ [ 1; 2 ]; [ 4; 5 ] ]
    (List.sliding [ 1; 2; 3; 4; 5 ] ~size:2 ~step:3) ;

  AT.check
    (AT.list (AT.list AT.int))
    "sliding - size 7"
    []
    (List.sliding [ 1; 2; 3; 4; 5 ] ~size:7) ;

  AT.check (AT.list AT.int) "map2 empty lists" (List.map2 ~f:( + ) [] []) [] ;
  AT.check
    (AT.list AT.int)
    "map2 one element"
    [ 2 ]
    (List.map2 ~f:( + ) [ 1 ] [ 1 ]) ;

  AT.check
    (AT.list AT.int)
    "map2 two elements"
    [ 2; 4 ]
    (List.map2 ~f:( + ) [ 1; 2 ] [ 1; 2 ]) ;

  AT.check
    (AT.list AT.int)
    "indexedMap empty list"
    (List.indexedMap ~f:(fun i _ -> i) [])
    [] ;
  AT.check
    (AT.list AT.int)
    "indexedMap one element"
    (List.indexedMap ~f:(fun i _ -> i) [ 'a' ])
    [ 0 ] ;
  AT.check
    (AT.list AT.int)
    "indexedMap two elements"
    (List.indexedMap ~f:(fun i _ -> i) [ 'a'; 'b' ])
    [ 0; 1 ] ;

  AT.check
    (AT.list AT.int)
    "indexedMap empty list"
    (List.indexedMap ~f:(fun _ n -> n + 1) [])
    [] ;
  AT.check
    (AT.list AT.int)
    "indexedMap one element"
    (List.indexedMap ~f:(fun _ n -> n + 1) [ -1 ])
    [ 0 ] ;
  AT.check
    (AT.list AT.int)
    "indexedMap two elements"
    (List.indexedMap ~f:(fun _ n -> n + 1) [ -1; 0 ])
    [ 0; 1 ] ;

  AT.check
    (AT.option AT.int)
    "minimumBy non-empty list"
    (List.minimumBy ~f:(fun x -> x mod 12) [ 7; 9; 15; 10; 3; 22 ])
    (Some 15) ;
  AT.check
    (AT.option AT.int)
    "minimumBy empty list"
    (List.minimumBy ~f:(fun x -> x mod 12) [])
    None ;

  AT.check
    (AT.option AT.int)
    "maximumBy non-empty list"
    (List.maximumBy ~f:(fun x -> x mod 12) [ 7; 9; 15; 10; 3; 22 ])
    (Some 10) ;
  AT.check
    (AT.option AT.int)
    "maximumBy empty list"
    (List.maximumBy ~f:(fun x -> x mod 12) [])
    None ;

  AT.check
    (AT.option AT.int)
    "minimum non-empty list"
    (List.minimum [ 7; 9; 15; 10; 3 ])
    (Some 3) ;
  AT.check (AT.option AT.int) "minimum empty list" (List.minimum []) None ;

  AT.check
    (AT.option AT.int)
    "maximum non-empty list"
    (List.maximum [ 7; 9; 15; 10; 3 ])
    (Some 15) ;
  AT.check (AT.option AT.int) "maximum empty list" (List.maximum []) None ;

  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "partition empty list"
    (List.partition ~f:(fun x -> x mod 2 = 0) [])
    ([], []) ;
  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "partition one element"
    (List.partition ~f:(fun x -> x mod 2 = 0) [ 1 ])
    ([], [ 1 ]) ;
  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "partition four elements"
    (List.partition ~f:(fun x -> x mod 2 = 0) [ 1; 2; 3; 4 ])
    ([ 2; 4 ], [ 1; 3 ]) ;

  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "split_when four elements"
    (List.split_when ~f:(fun x -> x mod 2 = 0) [ 1; 3; 2; 4 ])
    ([ 1; 3 ], [ 2; 4 ]) ;
  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "split_when at zero"
    (List.split_when ~f:(fun x -> x mod 2 = 0) [ 2; 4; 6 ])
    ([], [ 2; 4; 6 ]) ;
  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "split_when at end"
    (List.split_when ~f:(fun x -> x mod 2 = 0) [ 1; 3; 5 ])
    ([ 1; 3; 5 ], []) ;
  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "split_when empty list"
    (List.split_when ~f:(fun x -> x mod 2 = 0) [])
    ([], []) ;

  AT.check
    (AT.list AT.string)
    "intersperse empty list"
    (List.intersperse "on" [])
    [] ;
  AT.check
    (AT.list AT.string)
    "intersperse one turtle"
    (List.intersperse "on" [ "turtles" ])
    [ "turtles" ] ;
  AT.check
    (AT.list AT.string)
    "intersperse three turtles"
    (List.intersperse "on" [ "turtles"; "turtles"; "turtles" ])
    [ "turtles"; "on"; "turtles"; "on"; "turtles" ] ;

  AT.check (AT.option (AT.list AT.char)) "init empty list" (List.init []) None ;
  AT.check
    (AT.option (AT.list AT.char))
    "init one element"
    (List.init [ 'a' ])
    (Some []) ;
  AT.check
    (AT.option (AT.list AT.char))
    "init two elements"
    (List.init [ 'a'; 'b' ])
    (Some [ 'a' ]) ;

  AT.check (AT.list AT.string) "append empty lists" (List.append [] []) [] ;
  AT.check
    (AT.list AT.string)
    "append empty list"
    (List.append [] [ "turtles" ])
    [ "turtles" ] ;
  AT.check
    (AT.list AT.string)
    "append empty list"
    (List.append [ "turtles" ] [])
    [ "turtles" ] ;
  AT.check
    (AT.list AT.string)
    "append two lists"
    (List.append [ "on" ] [ "turtles" ])
    [ "on"; "turtles" ] ;

  AT.check
    (AT.list AT.int)
    "foldl empty list"
    (List.foldLeft ~f:(fun x acc -> x :: acc) ~initial:[] [])
    [] ;
  AT.check
    (AT.list AT.int)
    "foldl one element"
    (List.foldLeft ~f:(fun x acc -> x :: acc) ~initial:[] [ 1 ])
    [ 1 ] ;
  AT.check
    (AT.list AT.int)
    "foldl three elements"
    (List.foldLeft ~f:(fun x acc -> x :: acc) ~initial:[] [ 1; 2; 3 ])
    [ 3; 2; 1 ] ;
  AT.check
    (AT.list AT.int)
    "foldr empty list"
    (List.foldRight ~f:(fun x acc -> x :: acc) ~initial:[] [])
    [] ;
  AT.check
    (AT.list AT.int)
    "foldr one element"
    (List.foldRight ~f:(fun x acc -> x :: acc) ~initial:[] [ 1 ])
    [ 1 ] ;
  AT.check
    (AT.list AT.int)
    "foldr three elements"
    (List.foldRight ~f:(fun x acc -> x :: acc) ~initial:[] [ 1; 2; 3 ])
    [ 1; 2; 3 ] ;
  AT.check
    AT.int
    "foldl issue #18"
    (List.foldLeft ~f:( - ) ~initial:0 [ 1; 2; 3 ])
    2 ;
  AT.check
    AT.int
    "foldr issue #18"
    (List.foldRight ~f:( - ) ~initial:0 [ 1; 2; 3 ])
    2 ;
  AT.check
    AT.int
    "foldl issue #18"
    (List.foldLeft ~f:( - ) ~initial:0 [ 3; 2; 1 ])
    2 ;
  AT.check
    AT.int
    "foldr issue #18"
    (List.foldRight ~f:( - ) ~initial:0 [ 3; 2; 1 ])
    2 ;

  AT.check
    (AT.list AT.int)
    "insertAt empty list"
    (List.insertAt ~index:0 ~value:1 [])
    [ 1 ] ;
  AT.check
    (AT.list AT.int)
    "insertAt in the middle"
    (List.insertAt ~index:1 ~value:2 [ 1; 3 ])
    [ 1; 2; 3 ] ;
  AT.check
    (AT.list AT.int)
    "insertAt in the front"
    (List.insertAt ~index:0 ~value:2 [ 1; 3 ])
    [ 2; 1; 3 ] ;

  (*      the test below would work on Bucklescript, both should show the same behaviour *)
  (*  AT.check (AT.list AT.int) "insertAt after end of list" (List.insertAt ~index:4 ~value:2 [1;3]) [2];*)
  AT.check
    (AT.list AT.int)
    "updateAt index smaller 0"
    (List.updateAt ~index:(-1) ~f:(fun x -> x + 1) [ 1; 3 ])
    [ 1; 3 ] ;
  AT.check
    (AT.list AT.int)
    "updateAt empty list"
    (List.updateAt ~index:0 ~f:(fun x -> x + 1) [])
    [] ;
  AT.check
    (AT.list AT.int)
    "updateAt empty list"
    (List.updateAt ~index:2 ~f:(fun x -> x + 1) [])
    [] ;
  AT.check
    (AT.list AT.int)
    "updateAt inside the list"
    (List.updateAt ~index:1 ~f:(fun x -> x + 1) [ 1; 3 ])
    [ 1; 4 ] ;
  AT.check
    (AT.list AT.int)
    "updateAt in the front"
    (List.updateAt ~index:0 ~f:(fun x -> x + 1) [ 1; 3 ])
    [ 2; 3 ] ;
  AT.check
    (AT.list AT.int)
    "updateAt after end of list"
    (List.updateAt ~index:4 ~f:(fun x -> x + 1) [ 1; 3 ])
    [ 1; 3 ] ;

  AT.check (AT.list AT.int) "concat two empty lists" (List.concat [ []; [] ]) [] ;
  AT.check
    (AT.list AT.int)
    "concat with one empty list"
    (List.concat [ [ 1 ]; [] ])
    [ 1 ] ;
  AT.check
    (AT.list AT.int)
    "concat with one empty list"
    (List.concat [ []; [ 1 ] ])
    [ 1 ] ;
  AT.check
    (AT.list AT.int)
    "concat with several lists"
    (List.concat [ [ 1 ]; [ 2 ]; [ 3 ] ])
    [ 1; 2; 3 ] ;
  AT.check
    (AT.list AT.int)
    "concat with several lists"
    (List.concat [ [ 1 ]; []; [ 2 ]; []; [ 3 ] ])
    [ 1; 2; 3 ] ;

  AT.check
    (AT.list AT.int)
    "initialize length 0"
    (List.initialize 0 (fun i -> i))
    [] ;
  AT.check
    (AT.list AT.int)
    "initialize length 1"
    (List.initialize 1 (fun i -> i))
    [ 0 ] ;
  AT.check
    (AT.list AT.int)
    "initialize length 2"
    (List.initialize 2 (fun i -> i))
    [ 0; 1 ] ;

  AT.check
    (AT.list AT.int)
    "removeAt index smaller 0"
    (List.removeAt ~index:(-1) [ 1; 3 ])
    [ 1; 3 ] ;
  AT.check (AT.list AT.int) "removeAt empty list" (List.removeAt ~index:0 []) [] ;
  AT.check (AT.list AT.int) "removeAt empty list" (List.removeAt ~index:2 []) [] ;
  AT.check
    (AT.list AT.int)
    "removeAt index 1"
    (List.removeAt ~index:1 [ 1; 3 ])
    [ 1 ] ;
  AT.check
    (AT.list AT.int)
    "removeAt index 0"
    (List.removeAt ~index:0 [ 1; 3 ])
    [ 3 ] ;
  AT.check
    (AT.list AT.int)
    "removeAt after end of list"
    (List.removeAt ~index:4 [ 1; 3 ])
    [ 1; 3 ] ;

  ()


let suite = [ ("List", `Quick, t_List) ]
