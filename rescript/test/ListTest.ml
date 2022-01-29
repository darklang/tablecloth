open Tablecloth
open AlcoJest

let suite =
  suite "List" (fun () ->
      let open List in
      describe "empty" (fun () ->
          test "returns int 0 for empty list arg" (fun () ->
              expect (List.length List.empty) |> toEqual Eq.int 0 ) ) ;
      describe "singleton" (fun () ->
          test
            "returns array singleton of empty string from arg empty string"
            (fun () ->
              expect (List.singleton "")
              |> toEqual
                   (let open Eq in
                   list string)
                   [ "" ] ) ;
          test "returns array singleton of int arg" (fun () ->
              expect (List.singleton 1234)
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1234 ] ) ;
          test "returns array singleton of string arg" (fun () ->
              expect (List.singleton "hello")
              |> toEqual
                   (let open Eq in
                   list string)
                   [ "hello" ] ) ) ;
      describe "repeat" (fun () ->
          test "returns empty list from repeat arg 0" (fun () ->
              expect (List.repeat ~times:0 7)
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "returns empty list from negative repeat arg -10" (fun () ->
              expect (List.repeat ~times:(-10) 7)
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "returns list of char 'a' repeated 5 times" (fun () ->
              expect (List.repeat ~times:5 'a')
              |> toEqual
                   (let open Eq in
                   list char)
                   [ 'a'; 'a'; 'a'; 'a'; 'a' ] ) ) ;
      describe "range" (fun () ->
          test "returns empty when is zero" (fun () ->
              expect (List.range 0)
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "with single" (fun () ->
              expect (List.range 5)
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 0; 1; 2; 3; 4 ] ) ;
          test "with to and from" (fun () ->
              expect (List.range ~from:2 5)
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 2; 3; 4 ] ) ;
          test "with negative" (fun () ->
              expect (List.range ~from:(-2) 2)
              |> toEqual
                   (let open Eq in
                   list int)
                   [ -2; -1; 0; 1 ] ) ;

          test "returns empty with count down" (fun () ->
              expect (List.range ~from:5 2)
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ) ;

      describe "initalize" (fun () ->
          test "with identity" (fun () ->
              expect (List.initialize 4 ~f:(fun index -> index))
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 0; 1; 2; 3 ] ) ;
          test "with math" (fun () ->
              expect (List.initialize 4 ~f:(fun index -> index * index))
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 0; 1; 4; 9 ] ) ) ;

      describe "fromArray" (fun () ->
          test "from empty" (fun () ->
              expect (List.fromArray [||])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "from string" (fun () ->
              expect (List.fromArray [| 'h'; 'e'; 'l'; 'l'; 'o' |])
              |> toEqual
                   (let open Eq in
                   list char)
                   [ 'h'; 'e'; 'l'; 'l'; 'o' ] ) ;
          test "with int" (fun () ->
              expect (List.fromArray [| -1; 3; 2; 7 |])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ -1; 3; 2; 7 ] ) ) ;
      describe "head" (fun () ->
          test "from empty" (fun () ->
              expect (List.head [])
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "with int" (fun () ->
              expect (List.head [ -3; 2; 3; 4; 6 ])
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some (-3)) ) ) ;
      describe "cons" (fun () ->
          test "from empty" (fun () ->
              expect (List.cons [] 1)
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1 ] ) ;
          test "with int" (fun () ->
              expect (List.cons [ 2; 3; 4 ] 1)
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 2; 3; 4 ] ) ) ;

      describe "filterMap" (fun () ->
          test "keeps elements which return Some" (fun () ->
              expect (List.filterMap [ -1; 80; 99 ] ~f:Char.fromCode)
              |> toEqual
                   (let open Eq in
                   list char)
                   [ 'P'; 'c' ] ) ) ;

      describe "filterWithIndex" (fun () ->
          test "returns elements if index is greater than 1" (fun () ->
              expect (filterWithIndex [ 2; 99; 0; 3 ] ~f:(fun i _ -> i > 1))
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 0; 3 ] ) ;
          test "empty list" (fun () ->
              expect (filterWithIndex [] ~f:(fun i _ -> i > 1))
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ) ;

      describe "drop" (fun () ->
          test "from an empty list" (fun () ->
              expect (drop [] ~count:1)
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "zero elements" (fun () ->
              expect (drop [ 1; 2; 3 ] ~count:0)
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 2; 3 ] ) ;
          test "the first element" (fun () ->
              expect (drop [ 1; 2; 3 ] ~count:1)
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 2; 3 ] ) ;
          test "all elements" (fun () ->
              expect (drop [ 1; 2; 3 ] ~count:3)
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "greater than the number of elements" (fun () ->
              expect (drop [ 1; 2; 3 ] ~count:4)
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "negative count" (fun () ->
              expect (drop [ 1; 2; 3 ] ~count:(-1))
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 2; 3 ] ) ;
          test "zero count" (fun () ->
              expect (drop [ 1; 2; 3 ] ~count:(-1))
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 2; 3 ] ) ) ;

      describe "filter" (fun () ->
          test "normal" (fun () ->
              expect (filter ~f:Int.isEven [ 2; 4; 6; 7; 8; 9 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 2; 4; 6; 8 ] ) ;
          test "filter none" (fun () ->
              expect (filter ~f:Int.isEven [ 5; 7; 9 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "filter all" (fun () ->
              expect (filter ~f:Int.isEven [ 2; 4; 6 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 2; 4; 6 ] ) ) ;

      describe "dropWhile" (fun () ->
          test
            "drops item from list if isEven, returns list of only odd items"
            (fun () ->
              expect (dropWhile ~f:Int.isEven [ 2; 4; 6; 7; 8; 9 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 7; 8; 9 ] ) ;
          test
            "drops none despite items dispersed throughout list because first item returns false for isEven, returns list without changes"
            (fun () ->
              expect (dropWhile ~f:Int.isEven [ 3; 4; 7; 8; 9 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 3; 4; 7; 8; 9 ] ) ;
          test
            "drops all because all items are even, returns empty list"
            (fun () ->
              expect (dropWhile ~f:Int.isEven [ 2; 4; 6; 8 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test
            "drops none because all items are odd, returns list without changes"
            (fun () ->
              expect (dropWhile ~f:Int.isEven [ 1; 3; 5; 7 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 3; 5; 7 ] ) ) ;

      describe "take" (fun () ->
          test "normal" (fun () ->
              expect (take [ 1; 2; 3 ] ~count:2)
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 2 ] ) ;
          test "from an empty list" (fun () ->
              expect (take [] ~count:2)
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "overflow" (fun () ->
              expect (take [ 1; 2; 3; 4 ] ~count:8)
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 2; 3; 4 ] ) ;
          test "overflow" (fun () ->
              expect (take [ 1; 2; 3; 4 ] ~count:(-1))
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ) ;

      describe "takeWhile" (fun () ->
          test
            "takes items until isEven returns false, returns list of items until first odd item"
            (fun () ->
              expect (takeWhile ~f:Int.isEven [ 2; 4; 6; 7; 8; 9 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 2; 4; 6 ] ) ;
          test
            "takes items in list of dispersed items until isEven returns false, returns list of items until first odd item"
            (fun () ->
              expect (takeWhile ~f:Int.isEven [ 2; 6; 7; 15; 10; 9; 8 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 2; 6 ] ) ;
          test
            "takes no items as first item returns false to isEven, returns empty list"
            (fun () ->
              expect (takeWhile ~f:Int.isEven [ 1; 6; 7; 15; 10; 9; 8 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test
            "takes all items as all items return true to isEven, returns list without changes"
            (fun () ->
              expect (takeWhile ~f:Int.isEven [ 2; 4; 6 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 2; 4; 6 ] ) ;
          test "returns empty list from arg empty list" (fun () ->
              expect (takeWhile ~f:Int.isEven [])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test
            "takes no items as all items return false to isEven, returns empty list"
            (fun () ->
              expect (takeWhile ~f:Int.isEven [ 1; 3; 5 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ) ;

      describe "findIndex" (fun () ->
          test
            "returns the first (index, element) tuple which f returns true for"
            (fun () ->
              expect
                (findIndex
                   ~f:(fun index number -> index > 2 && Int.isEven number)
                   [ 1; 3; 4; 8 ] )
              |> toEqual
                   (let open Eq in
                   option (pair int int))
                   (Some (3, 8)) ) ;
          test
            "returns `None` if `f` returns false for all elements "
            (fun () ->
              expect (findIndex ~f:(fun _ _ -> false) [ 0; 2; 4; 8 ])
              |> toEqual
                   (let open Eq in
                   option (pair int int))
                   None ) ;
          test "returns `None` for an empty array" (fun () ->
              expect
                (findIndex
                   ~f:(fun index number -> index > 2 && Int.isEven number)
                   [] )
              |> toEqual
                   (let open Eq in
                   option (pair int int))
                   None ) ) ;

      describe "includes" (fun () ->
          test "includes int" (fun () ->
              expect (includes [ 1; 3; 5; 7 ] 3 ~equal:Int.equal)
              |> toEqual Eq.bool true ) ;
          test "does not includes int" (fun () ->
              expect (includes [ 1; 3; 5; 7 ] 4 ~equal:Int.equal)
              |> toEqual Eq.bool false ) ;
          test "empty list" (fun () ->
              expect (includes [] 5 ~equal:Int.equal) |> toEqual Eq.bool false ) ) ;

      describe "reverse" (fun () ->
          test "empty list" (fun () ->
              expect (reverse [])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "one element" (fun () ->
              expect (reverse [ 0 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 0 ] ) ;
          test "two elements" (fun () ->
              expect (reverse [ 0; 1 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 0 ] ) ) ;
      describe "map2" (fun () ->
          test "map2 empty lists" (fun () ->
              expect (map2 ~f:( + ) [] [])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "map2 one element" (fun () ->
              expect (map2 ~f:( + ) [ 1 ] [ 1 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 2 ] ) ;
          test "map2 two elements" (fun () ->
              expect (map2 ~f:( + ) [ 1; 2 ] [ 1; 2 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 2; 4 ] ) ;
          test "map2 with lists of different lengths" (fun () ->
              expect (map2 ~f:( + ) [ 1; 2; 3 ] [ 1; 2 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 2; 4 ] ) ) ;

      describe "map3" (fun () ->
          test "map3 empty lists" (fun () ->
              expect (map3 ~f:(fun x y z -> x + y + z) [] [] [])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "map3 one element" (fun () ->
              expect (map3 ~f:(fun x y z -> x + y + z) [ 1 ] [ 1 ] [ 1 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 3 ] ) ;
          test "map3 two elements" (fun () ->
              expect
                (map3 ~f:(fun x y z -> x + y + z) [ 1; 2 ] [ 1; 2 ] [ 1; 2 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 3; 6 ] ) ;

          test "map3 elements on lists of different lengths" (fun () ->
              expect
                (map3
                   ~f:(fun x y z -> x + y + z)
                   [ 1; 2; 3 ]
                   [ 1; 2; 3 ]
                   [ 1; 2 ] )
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 3; 6 ] ) ) ;

      describe "mapWithIndex" (fun () ->
          test "on an empty list" (fun () ->
              expect (mapWithIndex ~f:(fun i _ -> i) [])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "with a single element" (fun () ->
              expect (mapWithIndex ~f:(fun i _ -> i) [ 'a' ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 0 ] ) ;
          test "with two elements" (fun () ->
              expect (mapWithIndex ~f:(fun i _ -> i) [ 'a'; 'b' ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 0; 1 ] ) ) ;

      describe "flatMap" (fun () ->
          test "normal" (fun () ->
              expect (flatMap ~f:(fun x -> [ x; x ]) [ 1; 2; 3 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 1; 2; 2; 3; 3 ] ) ;
          test "on an empty list" (fun () ->
              expect (flatMap ~f:(fun x -> [ x; x ]) [])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "deeper list" (fun () ->
              expect
                (flatMap
                   ~f:(fun x -> append x [ 1 ])
                   [ [ 1; 1 ]; [ 2 ]; [ 3 ] ] )
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 1; 1; 2; 1; 3; 1 ] ) ) ;

      describe "sliding" (fun () ->
          test "size 1" (fun () ->
              expect (sliding [ 1; 2; 3; 4; 5 ] ~size:1)
              |> toEqual
                   (let open Eq in
                   list (list int))
                   [ [ 1 ]; [ 2 ]; [ 3 ]; [ 4 ]; [ 5 ] ] ) ;
          test "size 2" (fun () ->
              expect (sliding [ 1; 2; 3; 4; 5 ] ~size:2)
              |> toEqual
                   (let open Eq in
                   list (list int))
                   [ [ 1; 2 ]; [ 2; 3 ]; [ 3; 4 ]; [ 4; 5 ] ] ) ;
          test "step 3 " (fun () ->
              expect (sliding [ 1; 2; 3; 4; 5 ] ~size:3)
              |> toEqual
                   (let open Eq in
                   list (list int))
                   [ [ 1; 2; 3 ]; [ 2; 3; 4 ]; [ 3; 4; 5 ] ] ) ;
          test "size 2, step 2" (fun () ->
              expect (sliding [ 1; 2; 3; 4; 5 ] ~size:2 ~step:2)
              |> toEqual
                   (let open Eq in
                   list (list int))
                   [ [ 1; 2 ]; [ 3; 4 ] ] ) ;
          test "size 1, step 3" (fun () ->
              expect (sliding [ 1; 2; 3; 4; 5 ] ~size:1 ~step:3)
              |> toEqual
                   (let open Eq in
                   list (list int))
                   [ [ 1 ]; [ 4 ] ] ) ;
          test "size 2, step 3" (fun () ->
              expect (sliding [ 1; 2; 3; 4; 5 ] ~size:2 ~step:3)
              |> toEqual
                   (let open Eq in
                   list (list int))
                   [ [ 1; 2 ]; [ 4; 5 ] ] ) ;
          test "step 7" (fun () ->
              expect (sliding [ 1; 2; 3; 4; 5 ] ~size:7)
              |> toEqual
                   (let open Eq in
                   list (list int))
                   [] ) ) ;

      describe "groupWhile" (fun () ->
          test "empty list" (fun () ->
              expect (groupWhile ~f:String.equal [])
              |> toEqual
                   (let open Eq in
                   list (list string))
                   [] ) ;

          test "normal char" (fun () ->
              expect
                (groupWhile
                   ~f:( <> )
                   [ "a"; "b"; "b"; "a"; "a"; "a"; "b"; "a" ] )
              |> toEqual
                   (let open Eq in
                   list (list string))
                   [ [ "a" ]
                   ; [ "b"; "b" ]
                   ; [ "a"; "a"; "a" ]
                   ; [ "b" ]
                   ; [ "a" ]
                   ] ) ;

          test "normal int" (fun () ->
              expect
                (groupWhile
                   ~f:(fun x y -> x mod 2 != y mod 2)
                   [ 2; 4; 6; 5; 3; 1; 8; 7; 9 ] )
              |> toEqual
                   (let open Eq in
                   list (list int))
                   [ [ 2; 4; 6 ]; [ 5; 3; 1 ]; [ 8 ]; [ 7; 9 ] ] ) ) ;

      describe "join" (fun () ->
          test "normal" (fun () ->
              expect (join [ "Ant"; "Bat"; "Cat" ] ~sep:", ")
              |> toEqual Eq.string "Ant, Bat, Cat" ) ;
          test "empty list" (fun () ->
              expect (join [] ~sep:", ") |> toEqual Eq.string "" ) ) ;

      describe "partition" (fun () ->
          test "empty list" (fun () ->
              expect (partition ~f:Int.isEven [])
              |> toEqual
                   (let open Eq in
                   pair (list int) (list int))
                   ([], []) ) ;
          test "one element" (fun () ->
              expect (partition ~f:Int.isEven [ 1 ])
              |> toEqual
                   (let open Eq in
                   pair (list int) (list int))
                   ([], [ 1 ]) ) ;
          test "four elements" (fun () ->
              expect (partition ~f:Int.isEven [ 1; 2; 3; 4 ])
              |> toEqual
                   (let open Eq in
                   pair (list int) (list int))
                   ([ 2; 4 ], [ 1; 3 ]) ) ) ;

      describe "sort" (fun () ->
          test "empty list" (fun () ->
              expect (sort ~compare:Int.compare [])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "one element" (fun () ->
              expect (sort ~compare:Int.compare [ 5 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 5 ] ) ;
          test "multiple elements" (fun () ->
              expect (sort ~compare:Int.compare [ 5; 6; 8; 3; 6 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 3; 5; 6; 6; 8 ] ) ;

          test "with negative" (fun () ->
              expect (sort ~compare:Int.compare [ 5; 6; -8; 3; 6 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ -8; 3; 5; 6; 6 ] ) ) ;

      describe "sortBy" (fun () ->
          test "empty list" (fun () ->
              expect (sortBy ~f:(fun x -> x) [])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "one element" (fun () ->
              expect (sortBy ~f:(fun x -> x) [ 5 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 5 ] ) ;
          test "sort records" (fun () ->
              let s1 =
                { AlcoJest.Student.id = 200; AlcoJest.Student.name = "Syd" }
              in
              let s2 =
                { AlcoJest.Student.id = 53; AlcoJest.Student.name = "Bill" }
              in
              let s3 =
                { AlcoJest.Student.id = 30; AlcoJest.Student.name = "Carmen" }
              in
              let studentList = [ s1; s2; s3 ] in
              let sortedRecs =
                sortBy ~f:(fun x -> x.AlcoJest.Student.id) studentList
              in
              expect sortedRecs
              |> toEqual
                   (let open Eq in
                   list student)
                   [ s3; s2; s1 ] ) ;
          test "empty list" (fun () ->
              expect (sortBy ~f:(fun x -> x * x) [ 3; 2; 5; -2; 4 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 2; -2; 3; 4; 5 ] ) ) ;
      describe "uniqueBy" (fun () ->
          test "int self" (fun () ->
              expect
                (uniqueBy
                   ~f:(fun element -> string_of_int element)
                   [ 1; 3; 4; 3; 7; 7; 6 ] )
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 3; 4; 7; 6 ] ) ;
          test "math" (fun () ->
              expect
                (uniqueBy
                   ~f:(fun element -> string_of_int (5 mod element))
                   [ 1; 3; 4; 3; 7; 7; 6 ] )
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 3; 4; 7 ] ) ;
          test "string self" (fun () ->
              expect
                (uniqueBy
                   ~f:(fun element -> element)
                   [ "hello"; "h"; "e"; "hello"; "l"; "l"; "o" ] )
              |> toEqual
                   (let open Eq in
                   list string)
                   [ "hello"; "h"; "e"; "l"; "o" ] ) ) ;
      describe "minimumBy" (fun () ->
          test "minimumBy non-empty list" (fun () ->
              expect
                (List.minimumBy ~f:(fun x -> x mod 12) [ 7; 9; 15; 10; 3; 22 ])
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 15) ) ;
          test "minimumBy empty list" (fun () ->
              expect (List.minimumBy ~f:(fun x -> x mod 12) [])
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "maximumBy" (fun () ->
          test "maximumBy non-empty list" (fun () ->
              expect
                (List.maximumBy ~f:(fun x -> x mod 12) [ 7; 9; 15; 10; 3; 22 ])
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 10) ) ;
          test "maximumBy empty list" (fun () ->
              expect (List.maximumBy ~f:(fun x -> x mod 12) [])
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "minimum" (fun () ->
          test "minimum non-empty list" (fun () ->
              expect (minimum [ 7; 9; 15; 10; 3 ] ~compare:Int.compare)
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 3) ) ;
          test "minimum empty list" (fun () ->
              expect (minimum [] ~compare:Int.compare)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;
      describe "maximum" (fun () ->
          test "maximum non-empty list" (fun () ->
              expect (maximum [ 7; 9; 15; 10; 3 ] ~compare:Int.compare)
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 15) ) ;
          test "maximum empty list" (fun () ->
              expect (maximum [] ~compare:Int.compare)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "extent" (fun () ->
          test "return tuple of min and max" (fun () ->
              expect (extent [ 7; 5; 8; 6 ] ~compare:Int.compare)
              |> toEqual
                   (let open Eq in
                   option (pair int int))
                   (Some (5, 8)) ) ;
          test "return tuple of min and max from single element list" (fun () ->
              expect (extent [ 5 ] ~compare:Int.compare)
              |> toEqual
                   (let open Eq in
                   option (pair int int))
                   (Some (5, 5)) ) ;
          test "return tuple of min and max from empty list" (fun () ->
              expect (extent [] ~compare:Int.compare)
              |> toEqual
                   (let open Eq in
                   option (pair int int))
                   None ) ) ;

      describe "sum" (fun () ->
          test "sum of empty" (fun () ->
              expect (sum [] (module Int)) |> toEqual Eq.int 0 ) ;
          test "sum of ints" (fun () ->
              expect (sum [ 1; 1; 2; 3 ] (module Int)) |> toEqual Eq.int 7 ) ;
          test "sum with module struct" (fun () ->
              expect
                (sum
                   [ "a"; "b"; "c" ]
                   ( module struct
                     type t = string

                     let zero = ""

                     let add = ( ^ )
                   end ) )
              |> toEqual Eq.string "abc" ) ) ;

      describe "map" (fun () ->
          test "map sqrt" (fun () ->
              expect (map ~f:Float.squareRoot [ 1.0; 4.0; 9.0 ])
              |> toEqual
                   (let open Eq in
                   list float)
                   [ 1.0; 2.0; 3.0 ] ) ;
          test "list char" (fun () ->
              expect
                (map
                   ~f:(fun element -> cons element 'h')
                   [ [ 'i' ]; [ 'a' ]; [ 'o'; 'p' ] ] )
              |> toEqual
                   (let open Eq in
                   list (list char))
                   [ [ 'h'; 'i' ]; [ 'h'; 'a' ]; [ 'h'; 'o'; 'p' ] ] ) ;
          test "empty list" (fun () ->
              expect (map ~f:Float.squareRoot [])
              |> toEqual
                   (let open Eq in
                   list float)
                   [] ) ) ;

      describe "find" (fun () ->
          test "find first of 2 matches" (fun () ->
              expect (List.find ~f:Int.isEven [ 1; 3; 4; 8 ])
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 4) ) ;
          test "find 0 of 0 matches" (fun () ->
              expect (List.find ~f:Int.isOdd [ 0; 2; 4; 8 ])
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "empty list" (fun () ->
              expect (List.find ~f:Int.isEven [])
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "isEmpty" (fun () ->
          test "from empty list" (fun () ->
              expect (isEmpty List.empty) |> toEqual Eq.bool true ) ;
          test "from empty list" (fun () ->
              expect (isEmpty []) |> toEqual Eq.bool true ) ;
          test "from list with elements" (fun () ->
              expect (isEmpty [ 1; -4; 5; 6 ]) |> toEqual Eq.bool false ) ) ;

      describe "length" (fun () ->
          test "from empty list" (fun () ->
              expect (length []) |> toEqual Eq.int 0 ) ;
          test "from list with elements" (fun () ->
              expect (length [ 1; -4; 5; 6 ]) |> toEqual Eq.int 4 ) ) ;

      describe "any" (fun () ->
          test "from empty list" (fun () ->
              expect (any [] ~f:Int.isEven) |> toEqual Eq.bool false ) ;
          test "from even list" (fun () ->
              expect (any [ 2; 3 ] ~f:Int.isEven) |> toEqual Eq.bool true ) ;
          test "from odd list" (fun () ->
              expect (any [ 1; 3 ] ~f:Int.isEven) |> toEqual Eq.bool false ) ) ;
      describe "all" (fun () ->
          test "from empty list" (fun () ->
              expect (all [] ~f:Int.isEven) |> toEqual Eq.bool true ) ;
          test "from even list" (fun () ->
              expect (all [ 2; 3 ] ~f:Int.isEven) |> toEqual Eq.bool false ) ;
          test "from all even list" (fun () ->
              expect (all [ 2; 4 ] ~f:Int.isEven) |> toEqual Eq.bool true ) ;
          test "from odd list" (fun () ->
              expect (any [ 1; 3 ] ~f:Int.isEven) |> toEqual Eq.bool false ) ) ;

      describe "count" (fun () ->
          test "empty list" (fun () ->
              expect (count [] ~f:Int.isEven) |> toEqual Eq.int 0 ) ;

          test "one even element" (fun () ->
              expect (count [ 2; 3 ] ~f:Int.isEven) |> toEqual Eq.int 1 ) ;
          test "all even elements" (fun () ->
              expect (count [ 2; 4 ] ~f:Int.isEven) |> toEqual Eq.int 2 ) ) ;

      describe "splitAt" (fun () ->
          test "empty list" (fun () ->
              expect (splitAt [] ~index:1)
              |> toEqual
                   (let open Eq in
                   pair (list int) (list int))
                   ([], []) ) ;
          test "at evens" (fun () ->
              expect (splitAt ~index:0 [ 2; 4; 6 ])
              |> toEqual
                   (let open Eq in
                   pair (list int) (list int))
                   ([], [ 2; 4; 6 ]) ) ;
          test "four elements" (fun () ->
              expect (splitAt ~index:2 [ 1; 3; 2; 4 ])
              |> toEqual
                   (let open Eq in
                   pair (list int) (list int))
                   ([ 1; 3 ], [ 2; 4 ]) ) ;
          test "at end" (fun () ->
              expect (splitAt ~index:3 [ 1; 3; 5 ])
              |> toEqual
                   (let open Eq in
                   pair (list int) (list int))
                   ([ 1; 3; 5 ], []) ) ;
          test "past end" (fun () ->
              expect (splitAt ~index:6 [ 1; 3; 5 ])
              |> toEqual
                   (let open Eq in
                   pair (list int) (list int))
                   ([ 1; 3; 5 ], []) ) ;
          test "negative" (fun () ->
              expect (splitAt ~index:(-1) [ 1; 3; 5 ])
              |> toEqual
                   (let open Eq in
                   pair (list int) (list int))
                   ([], [ 1; 3; 5 ]) ) ) ;
      describe "splitWhen" (fun () ->
          test "empty list" (fun () ->
              expect (splitWhen ~f:Int.isEven [])
              |> toEqual
                   (let open Eq in
                   pair (list int) (list int))
                   ([], []) ) ;
          test "the first element satisfies f" (fun () ->
              expect (splitWhen ~f:Int.isEven [ 2; 4; 6 ])
              |> toEqual
                   (let open Eq in
                   pair (list int) (list int))
                   ([], [ 2; 4; 6 ]) ) ;
          test "the last element satisfies f" (fun () ->
              expect (splitWhen ~f:Int.isEven [ 1; 3; 2; 4 ])
              |> toEqual
                   (let open Eq in
                   pair (list int) (list int))
                   ([ 1; 3 ], [ 2; 4 ]) ) ;
          test "no element satisfies f" (fun () ->
              expect (splitWhen ~f:Int.isEven [ 1; 3; 5 ])
              |> toEqual
                   (let open Eq in
                   pair (list int) (list int))
                   ([ 1; 3; 5 ], []) ) ) ;
      describe "intersperse" (fun () ->
          test "intersperse empty list" (fun () ->
              expect (intersperse [] ~sep:"on")
              |> toEqual
                   (let open Eq in
                   list string)
                   [] ) ;
          test "intersperse one turtle" (fun () ->
              expect (intersperse ~sep:"on" [ "turtles" ])
              |> toEqual
                   (let open Eq in
                   list string)
                   [ "turtles" ] ) ;
          test "intersperse three turtles" (fun () ->
              expect (intersperse ~sep:"on" [ "turtles"; "turtles"; "turtles" ])
              |> toEqual
                   (let open Eq in
                   list string)
                   [ "turtles"; "on"; "turtles"; "on"; "turtles" ] ) ) ;
      describe "initial" (fun () ->
          test "empty list" (fun () ->
              expect (initial [])
              |> toEqual
                   (let open Eq in
                   option (list int))
                   None ) ;
          test "one element" (fun () ->
              expect (initial [ 'a' ])
              |> toEqual
                   (let open Eq in
                   option (list char))
                   (Some []) ) ;
          test "two elements" (fun () ->
              expect (initial [ 'a'; 'b' ])
              |> toEqual
                   (let open Eq in
                   option (list char))
                   (Some [ 'a' ]) ) ) ;

      describe "last" (fun () ->
          test "empty list" (fun () ->
              expect (last [])
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "one element" (fun () ->
              expect (last [ 'a' ])
              |> toEqual
                   (let open Eq in
                   option char)
                   (Some 'a') ) ;
          test "two elements" (fun () ->
              expect (last [ 'a'; 'b' ])
              |> toEqual
                   (let open Eq in
                   option char)
                   (Some 'b') ) ) ;

      describe "getAt" (fun () ->
          test "empty list" (fun () ->
              expect (List.getAt [] ~index:2)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "normal" (fun () ->
              expect (List.getAt [ 1; 2; 3 ] ~index:1)
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 2) ) ;
          test "overflow" (fun () ->
              expect (List.getAt [ 1; 2; 3 ] ~index:100)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "negative index" (fun () ->
              expect (List.getAt [ 1; 2; 3 ] ~index:(-2))
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "append" (fun () ->
          test "append empty lists" (fun () ->
              expect (append [] [])
              |> toEqual
                   (let open Eq in
                   list string)
                   [] ) ;
          test "append empty list" (fun () ->
              expect (append [] [ "turtles" ])
              |> toEqual
                   (let open Eq in
                   list string)
                   [ "turtles" ] ) ;
          test "append empty list" (fun () ->
              expect (append [ "turtles" ] [])
              |> toEqual
                   (let open Eq in
                   list string)
                   [ "turtles" ] ) ;
          test "append two lists" (fun () ->
              expect (append [ "on" ] [ "turtles" ])
              |> toEqual
                   (let open Eq in
                   list string)
                   [ "on"; "turtles" ] ) ) ;
      describe "fold" (fun () ->
          test "empty list" (fun () ->
              expect (fold ~f:cons ~initial:[] [])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "one element" (fun () ->
              expect (fold ~f:cons ~initial:[] [ 1 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1 ] ) ;
          test "three elements" (fun () ->
              expect (fold ~f:cons ~initial:[] [ 1; 2; 3 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 3; 2; 1 ] ) ;
          test "foldr empty list" (fun () ->
              expect (foldRight ~f:cons ~initial:[] [])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "foldr one element" (fun () ->
              expect (foldRight ~f:cons ~initial:[] [ 1 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1 ] ) ;
          test "foldr three elements" (fun () ->
              expect (foldRight ~f:cons ~initial:[] [ 1; 2; 3 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 2; 3 ] ) ;
          test "-" (fun () ->
              expect (fold ~f:( - ) ~initial:0 [ 1; 2; 3 ])
              |> toEqual Eq.int (-6) ) ;
          test "- foldRight" (fun () ->
              expect (foldRight ~f:( - ) ~initial:0 [ 1; 2; 3 ])
              |> toEqual Eq.int (-6) ) ) ;
      describe "insertAt" (fun () ->
          test "empty list" (fun () ->
              expect (insertAt ~index:0 ~value:1 [])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1 ] ) ;
          test "in the middle" (fun () ->
              expect (insertAt ~index:1 ~value:2 [ 1; 3 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 2; 3 ] ) ;
          test "in the front" (fun () ->
              expect (insertAt ~index:0 ~value:2 [ 1; 3 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 2; 1; 3 ] ) ;
          test "after end of list" (fun () ->
              expect (insertAt ~index:4 ~value:2 [ 1; 3 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 3; 2 ] ) ;
          test "#216" (fun () ->
              expect (insertAt ~index:5 ~value:1 [ 0; 2; 3; 4; 5; 6; 7; 8; 9 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 0; 2; 3; 4; 5; 1; 6; 7; 8; 9 ] ) ;
          test "doc 1" (fun () ->
              expect (insertAt ~index:2 ~value:999 [ 100; 101; 102; 103 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 100; 101; 999; 102; 103 ] ) ;
          test "doc 2" (fun () ->
              expect (insertAt ~index:0 ~value:999 [ 100; 101; 102; 103 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 999; 100; 101; 102; 103 ] ) ;
          test "doc 3" (fun () ->
              expect (insertAt ~index:4 ~value:999 [ 100; 101; 102; 103 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 100; 101; 102; 103; 999 ] ) ;
          test "doc 4" (fun () ->
              expect (insertAt ~index:(-1) ~value:999 [ 100; 101; 102; 103 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 999; 100; 101; 102; 103 ] ) ;
          test "doc 5" (fun () ->
              expect (insertAt ~index:5 ~value:999 [ 100; 101; 102; 103 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 100; 101; 102; 103; 999 ] ) ) ;
      describe "updateAt" (fun () ->
          test "updateAt index smaller 0" (fun () ->
              expect (updateAt ~index:(-1) ~f:(fun x -> x + 1) [ 1; 3 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 3 ] ) ;
          test "updateAt empty list" (fun () ->
              expect (updateAt ~index:0 ~f:(fun x -> x + 1) [])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "updateAt empty list" (fun () ->
              expect (updateAt ~index:2 ~f:(fun x -> x + 1) [])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "updateAt inside the list" (fun () ->
              expect (updateAt ~index:1 ~f:(fun x -> x + 1) [ 1; 3 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 4 ] ) ;
          test "updateAt in the front" (fun () ->
              expect (updateAt ~index:0 ~f:(fun x -> x + 1) [ 1; 3 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 2; 3 ] ) ;
          test "updateAt after end of list" (fun () ->
              expect (updateAt ~index:4 ~f:(fun x -> x + 1) [ 1; 3 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 3 ] ) ) ;
      describe "flatten" (fun () ->
          test "two empty lists" (fun () ->
              expect (flatten [ []; [] ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "one empty list" (fun () ->
              expect (flatten [ [ 1 ]; [] ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1 ] ) ;
          test "one empty list" (fun () ->
              expect (flatten [ []; [ 1 ] ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1 ] ) ;
          test "several lists" (fun () ->
              expect (flatten [ [ 1 ]; [ 2 ]; [ 3 ] ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 2; 3 ] ) ;
          test "several lists" (fun () ->
              expect (flatten [ [ 1 ]; []; [ 2 ]; []; [ 3 ] ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 2; 3 ] ) ) ;

      describe "zip" (fun () ->
          test "zip num and string" (fun () ->
              expect (zip [ 1; 2; 3; 4; 5 ] [ "Dog"; "Eagle"; "Ferret" ])
              |> toEqual
                   (let open Eq in
                   list (pair int string))
                   [ (1, "Dog"); (2, "Eagle"); (3, "Ferret") ] ) ;
          test "zip num and empty" (fun () ->
              expect (zip [ 1; 2; 3; 4; 5 ] [])
              |> toEqual
                   (let open Eq in
                   list (pair int int))
                   [] ) ) ;

      describe "unzip" (fun () ->
          test "unzip num and bool" (fun () ->
              expect (unzip [ (0, true); (17, false); (1337, true) ])
              |> toEqual
                   (let open Eq in
                   pair (list int) (list bool))
                   ([ 0; 17; 1337 ], [ true; false; true ]) ) ) ;

      describe "chunksOf" (fun () ->
          test "empty list" (fun () ->
              expect (chunksOf ~size:2 [])
              |> toEqual
                   (let open Eq in
                   list (list int))
                   [] ) ;
          test "normal" (fun () ->
              expect
                (chunksOf
                   ~size:2
                   [ "#FFBA49"; "#9984D4"; "#20A39E"; "#EF5B5B"; "#23001E" ] )
              |> toEqual
                   (let open Eq in
                   list (list string))
                   [ [ "#FFBA49"; "#9984D4" ]; [ "#20A39E"; "#EF5B5B" ] ] ) ) ;

      describe "initialize" (fun () ->
          test "initialize length 0" (fun () ->
              expect (initialize 0 ~f:(fun i -> i))
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "initialize length 1" (fun () ->
              expect (initialize 1 ~f:(fun i -> i))
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 0 ] ) ;
          test "initialize length 2" (fun () ->
              expect (initialize 2 ~f:(fun i -> i))
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 0; 1 ] ) ) ;
      describe "removeAt" (fun () ->
          test "removeAt index smaller 0" (fun () ->
              expect (removeAt ~index:(-1) [ 1; 3 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 3 ] ) ;
          test "removeAt empty list" (fun () ->
              expect (removeAt ~index:0 [])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "removeAt empty list" (fun () ->
              expect (removeAt ~index:2 [])
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ;
          test "removeAt index 1" (fun () ->
              expect (removeAt ~index:1 [ 1; 3 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1 ] ) ;
          test "removeAt index 0" (fun () ->
              expect (removeAt ~index:0 [ 1; 3 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 3 ] ) ;
          test "removeAt after end of list" (fun () ->
              expect (removeAt ~index:4 [ 1; 3 ])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 3 ] ) ) ;
      describe "groupBy" (fun () ->
          test "returns an empty map for an empty array" (fun () ->
              expect
                (List.groupBy [] (module Int) ~f:String.length |> Map.length)
              |> toEqual Eq.int 0 ) ;
          test "example test case" (fun () ->
              let animals = [ "Ant"; "Bear"; "Cat"; "Dewgong" ] in
              expect
                ( List.groupBy animals (module Int) ~f:String.length
                |> Map.toList )
              |> toEqual
                   (let open Eq in
                   list (pair int (list string)))
                   [ (3, [ "Cat"; "Ant" ])
                   ; (4, [ "Bear" ])
                   ; (7, [ "Dewgong" ])
                   ] ) ) ;

      describe "toArray" (fun () ->
          test "returns an array of int" (fun () ->
              expect (toArray [ 2; 4; 6; 8 ])
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 2; 4; 6; 8 |] ) ;
          test "empty" (fun () ->
              expect (toArray [])
              |> toEqual
                   (let open Eq in
                   array int)
                   [||] ) ;
          test "returns an array of char" (fun () ->
              expect (toArray [ 'h'; 'i' ])
              |> toEqual
                   (let open Eq in
                   array char)
                   [| 'h'; 'i' |] ) ) ;

      describe "equal" (fun () ->
          test "normal int" (fun () ->
              expect (equal [ 2; 5; 6; 11 ] [ 2; 5; 6; 11 ] Int.equal)
              |> toEqual Eq.bool true ) ;
          test "normal int" (fun () ->
              expect (equal [ 2; 5; -6; 11 ] [ 2; 5; 6; 11 ] Int.equal)
              |> toEqual Eq.bool false ) ;
          test "normal string" (fun () ->
              expect
                (equal
                   [ "hi"; "hello"; "hey" ]
                   [ "hi"; "hello"; "hey" ]
                   String.equal )
              |> toEqual Eq.bool true ) ) ;

      describe "compare" (fun () ->
          test "normal int" (fun () ->
              expect (compare [ 2; 5; 6; 11 ] [ 2; 5; 6; 11 ] ~f:Int.compare)
              |> toEqual Eq.int 0 ) ;
          test "normal int with different element" (fun () ->
              expect (compare [ 2; 5; -6; 11 ] [ 2; 5; 6; 11 ] ~f:Int.compare)
              |> toEqual Eq.int (-1) ) ;
          test "normal int with shorter and longer array" (fun () ->
              expect (compare [ 2; 5; 6; 11 ] [ 2; 5; 6 ] ~f:Int.compare)
              |> toEqual Eq.int 1 ) ;
          test "normal string" (fun () ->
              expect
                (compare
                   [ "hi"; "hello"; "hey" ]
                   [ "hi"; "hello"; "hey" ]
                   ~f:String.compare )
              |> toEqual Eq.int 0 ) ) )
