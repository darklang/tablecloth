open Tablecloth
open AlcoJest

let suite =
  suite "Array" (fun () ->
      let open Array in
      describe "singleton" (fun () ->
          test "equals an array literal of the same value" (fun () ->
              expect (singleton 1234)
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 1234 |] ) ;
          test "has length one" (fun () ->
              expect (singleton 1 |> length)
              |> toEqual
                   (let open Eq in
                   int)
                   1 ) ) ;
      describe "length" (fun () ->
          test "equals an array literal of the same value" (fun () ->
              expect (length [||]) |> toEqual Eq.int 0 ) ;
          test "has length one" (fun () ->
              expect (length [| 'a' |]) |> toEqual Eq.int 1 ) ;
          test "has length two" (fun () ->
              expect (length [| "a"; "b" |]) |> toEqual Eq.int 2 ) ) ;
      describe "isEmpty" (fun () ->
          test "returns true for empty array literals" (fun () ->
              expect (isEmpty [||]) |> toEqual Eq.bool true ) ;
          test
            "returns false for literals a non-zero number of elements"
            (fun () -> expect (isEmpty [| 1234 |]) |> toEqual Eq.bool false) ) ;
      describe "initialize" (fun () ->
          test "create empty array" (fun () ->
              expect (initialize 0 ~f:Fun.identity)
              |> toEqual
                   (let open Eq in
                   array int)
                   [||] ) ;
          test "negative length gives an empty array" (fun () ->
              expect (initialize (-1) ~f:Fun.identity)
              |> toEqual
                   (let open Eq in
                   array int)
                   [||] ) ;
          test "create array initialize" (fun () ->
              expect (initialize 3 ~f:Fun.identity)
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 0; 1; 2 |] ) ) ;
      describe "repeat" (fun () ->
          test "length zero creates an empty array" (fun () ->
              expect (repeat 0 ~length:0)
              |> toEqual
                   (let open Eq in
                   array int)
                   [||] ) ;
          test "negative length gives an empty array" (fun () ->
              expect (repeat ~length:(-1) 0)
              |> toEqual
                   (let open Eq in
                   array int)
                   [||] ) ;
          test "create array of ints" (fun () ->
              expect (repeat 0 ~length:3)
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 0; 0; 0 |] ) ;
          test "create array strings" (fun () ->
              expect (repeat "cat" ~length:3)
              |> toEqual
                   (let open Eq in
                   array string)
                   [| "cat"; "cat"; "cat" |] ) ) ;
      describe "range" (fun () ->
          test
            "returns an array of the integers from zero and upto but not including [to]"
            (fun () ->
              expect (range 5)
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 0; 1; 2; 3; 4 |] ) ;
          test "returns an empty array [to] is zero" (fun () ->
              expect (range 0)
              |> toEqual
                   (let open Eq in
                   array int)
                   [||] ) ;
          test
            "takes an optional [from] argument to start create empty array"
            (fun () ->
              expect (range ~from:2 5)
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 2; 3; 4 |] ) ;
          test "can start from negative values" (fun () ->
              expect (range ~from:(-2) 3)
              |> toEqual
                   (let open Eq in
                   array int)
                   [| -2; -1; 0; 1; 2 |] ) ;
          test "returns an empty array [from] > [to_]" (fun () ->
              expect (range ~from:5 0)
              |> toEqual
                   (let open Eq in
                   array int)
                   [||] ) ) ;
      describe "fromList" (fun () ->
          test "transforms a list into an array of the same elements" (fun () ->
              expect (fromList [ 1; 2; 3 ])
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 1; 2; 3 |] ) ) ;
      describe "toList" (fun () ->
          test "transform an array into a list of the same elements" (fun () ->
              expect (toList [| 1; 2; 3 |])
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 2; 3 ] ) ) ;
      describe "toIndexedList" (fun () ->
          test "returns an empty list for an empty array" (fun () ->
              expect (toIndexedList [||])
              |> toEqual
                   (let open Eq in
                   list (pair int int))
                   [] ) ;
          test "transforms an array into a list of tuples" (fun () ->
              expect (toIndexedList [| "cat"; "dog" |])
              |> toEqual
                   (let open Eq in
                   list (pair int string))
                   [ (0, "cat"); (1, "dog") ] ) ) ;

      describe "clone" (fun () ->
          test "returns an int array" (fun () ->
              let numbers = [| 1; 2; 3 |] in
              let otherNumbers = clone numbers in
              numbers.(1) <- 9 ;
              expect otherNumbers
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 1; 2; 3 |] ) ;
          test "returns an array of int arrays" (fun () ->
              let numberGrid =
                [| [| 1; 2; 3 |]; [| 4; 5; 6 |]; [| 7; 8; 9 |] |]
              in

              let numberGridCopy = clone numberGrid in

              numberGrid.(1).(1) <- 0 ;

              numberGridCopy.(1).(1) <- 9 ;
              expect numberGridCopy
              |> toEqual
                   (let open Eq in
                   array (array int))
                   [| [| 1; 2; 3 |]; [| 4; 9; 6 |]; [| 7; 8; 9 |] |] ) ) ;

      describe "get" (fun () ->
          test "returns Some for an in-bounds index" (fun () ->
              expect [| "cat"; "dog"; "eel" |].(2) |> toEqual Eq.string "eel" ) ;
          testAll "throws for an out of bounds index" [ -1; 3; 5 ] (fun index ->
              expect (fun () -> [| 0; 1; 2 |].(index)) |> toThrow ) ;
          test "throws for an empty array" (fun () ->
              expect (fun () -> [||].(0)) |> toThrow ) ) ;
      describe "getAt" (fun () ->
          test "returns Some for an in-bounds index" (fun () ->
              expect (getAt ~index:2 [| "cat"; "dog"; "eel" |])
              |> toEqual
                   (let open Eq in
                   option string)
                   (Some "eel") ) ;
          test "returns None for an out of bounds index" (fun () ->
              expect (getAt ~index:5 [| 0; 1; 2 |])
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "returns None for an empty array" (fun () ->
              expect (getAt ~index:0 [||])
              |> toEqual
                   (let open Eq in
                   option string)
                   None ) ) ;
      describe "set" (fun () ->
          test "can set a value at an index" (fun () ->
              let numbers = [| 1; 2; 3 |] in
              numbers.(0) <- 0 ;
              expect numbers
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 0; 2; 3 |] ) ) ;
      describe "setAt" (fun () ->
          test "can be partially applied to set an element" (fun () ->
              let setZero = setAt ~value:0 in
              let numbers = [| 1; 2; 3 |] in
              setZero numbers ~index:2 ;
              setZero numbers ~index:1 ;
              expect numbers
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 1; 0; 0 |] ) ;
          test "can be partially applied to set an index" (fun () ->
              let setZerothElement = setAt ~index:0 in
              let animals = [| "ant"; "bat"; "cat" |] in
              setZerothElement animals ~value:"antelope" ;
              expect animals
              |> toEqual
                   (let open Eq in
                   array string)
                   [| "antelope"; "bat"; "cat" |] ) ) ;

      describe "first" (fun () ->
          test "return first element" (fun () ->
              expect (first [| 1; 2; 3 |])
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 1) ) ;
          test "return none from empty array" (fun () ->
              expect (first [||])
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "last" (fun () ->
          test "return last element" (fun () ->
              expect (last [| 1; 2; 3 |])
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 3) ) ;
          test "return none from empty array" (fun () ->
              expect (last [||])
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "sum" (fun () ->
          test "equals zero for an empty array" (fun () ->
              expect (sum [||] (module Int)) |> toEqual Eq.int 0 ) ;
          test "adds up the elements on an integer array" (fun () ->
              expect (sum [| 1; 2; 3 |] (module Int)) |> toEqual Eq.int 6 ) ) ;
      describe "filter" (fun () ->
          test "keep elements that [f] returns [true] for" (fun () ->
              expect (filter ~f:Int.isEven [| 1; 2; 3; 4; 5; 6 |])
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 2; 4; 6 |] ) ) ;

      describe "filterMap" (fun () ->
          test "keep elements that [f] returns [true] for" (fun () ->
              expect
                (filterMap [| 3; 4; 5; 6 |] ~f:(fun number ->
                     if Int.isEven number then Some (number * number) else None )
                )
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 16; 36 |] ) ) ;

      describe "flatMap" (fun () ->
          test
            "{!map} [f] onto an array and {!flatten} the resulting arrays"
            (fun () ->
              expect (flatMap ~f:(fun n -> [| n; n |]) [| 1; 2; 3 |])
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 1; 1; 2; 2; 3; 3 |] ) ) ;

      describe "swap" (fun () ->
          test "switches values at the given indicies" (fun () ->
              let numbers = [| 1; 2; 3 |] in
              swap numbers 1 2 ;
              expect numbers
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 1; 3; 2 |] ) ) ;
      describe "map" (fun () ->
          test "Apply a function [f] to every element in an array" (fun () ->
              expect (map ~f:Float.squareRoot [| 1.0; 4.0; 9.0 |])
              |> toEqual
                   (let open Eq in
                   array float)
                   [| 1.0; 2.0; 3.0 |] ) ) ;
      describe "mapWithIndex" (fun () ->
          test "equals an array literal of the same value" (fun () ->
              expect (mapWithIndex ~f:( * ) [| 5; 5; 5 |])
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 0; 5; 10 |] ) ) ;
      describe "map2" (fun () ->
          test "works the order of arguments to `f` is not important" (fun () ->
              expect (map2 ~f:( + ) [| 1; 2; 3 |] [| 4; 5; 6 |])
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 5; 7; 9 |] ) ;
          test "works the order of `f` is important" (fun () ->
              expect
                (map2
                   ~f:Tuple2.make
                   [| "alice"; "bob"; "chuck" |]
                   [| 2; 5; 7; 8 |] )
              |> toEqual
                   (let open Eq in
                   array (pair string int))
                   [| ("alice", 2); ("bob", 5); ("chuck", 7) |] ) ) ;

      describe "map3" (fun () ->
          test "maps elements of 3 arrays" (fun () ->
              expect
                (map3
                   ~f:Tuple3.make
                   [| "alice"; "bob"; "chuck" |]
                   [| 2; 5; 7; 8 |]
                   [| true; false; true; false |] )
              |> toEqual
                   (let open Eq in
                   array (trio string int bool))
                   [| ("alice", 2, true)
                    ; ("bob", 5, false)
                    ; ("chuck", 7, true)
                   |] ) ) ;

      describe "partition" (fun () ->
          test "Split an array into a Tuple of arrays" (fun () ->
              expect (partition [| 1; 2; 3; 4; 5; 6 |] ~f:Int.isOdd)
              |> toEqual
                   (let open Eq in
                   pair (array int) (array int))
                   ([| 1; 3; 5 |], [| 2; 4; 6 |]) ) ) ;

      describe "splitAt" (fun () ->
          test "Divides an array into a Tuple of arrays" (fun () ->
              expect (splitAt [| 1; 2; 3; 4; 5 |] ~index:2)
              |> toEqual
                   (let open Eq in
                   pair (array int) (array int))
                   ([| 1; 2 |], [| 3; 4; 5 |]) ) ;
          test "Split array at array[0]" (fun () ->
              expect (splitAt [| 1; 2; 3; 4; 5 |] ~index:0)
              |> toEqual
                   (let open Eq in
                   pair (array int) (array int))
                   ([||], [| 1; 2; 3; 4; 5 |]) ) ) ;

      describe "splitWhen" (fun () ->
          test
            "Divides an array at the first element f returns true for"
            (fun () ->
              expect (splitWhen [| 5; 7; 8; 6; 4 |] ~f:Int.isEven)
              |> toEqual
                   (let open Eq in
                   pair (array int) (array int))
                   ([| 5; 7 |], [| 8; 6; 4 |]) ) ;
          test
            "Divides an array at the first element f returns true for"
            (fun () ->
              expect (splitWhen [| 5; 7; 8; 7; 4 |] ~f:Int.isEven)
              |> toEqual
                   (let open Eq in
                   pair (array int) (array int))
                   ([| 5; 7 |], [| 8; 7; 4 |]) ) ;
          test
            "Divides an array at the first element f returns true for"
            (fun () ->
              expect
                (splitWhen [| "Ant"; "Bat"; "Cat" |] ~f:(fun animal ->
                     String.length animal > 3 ) )
              |> toEqual
                   (let open Eq in
                   pair (array string) (array string))
                   ([| "Ant"; "Bat"; "Cat" |], [||]) ) ;
          test
            "Divides an array at the first element f returns true for"
            (fun () ->
              expect (splitWhen [| 2.; Float.pi; 1.111 |] ~f:Float.isInteger)
              |> toEqual
                   (let open Eq in
                   pair (array float) (array float))
                   ([||], [| 2.; Float.pi; 1.111 |]) ) ) ;
      describe "flatmap" (fun () ->
          test "flatMap" (fun () ->
              let duplicate n = [| n; n |] in
              expect (flatMap ~f:duplicate [| 1; 2; 3 |])
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 1; 1; 2; 2; 3; 3 |] ) ) ;
      describe "sliding" (fun () ->
          test "size 1" (fun () ->
              expect (sliding [| 1; 2; 3; 4; 5 |] ~size:1)
              |> toEqual
                   (let open Eq in
                   array (array int))
                   [| [| 1 |]; [| 2 |]; [| 3 |]; [| 4 |]; [| 5 |] |] ) ;
          test "size 2" (fun () ->
              expect (sliding [| 1; 2; 3; 4; 5 |] ~size:2)
              |> toEqual
                   (let open Eq in
                   array (array int))
                   [| [| 1; 2 |]; [| 2; 3 |]; [| 3; 4 |]; [| 4; 5 |] |] ) ;
          test "step 3 " (fun () ->
              expect (sliding [| 1; 2; 3; 4; 5 |] ~size:3)
              |> toEqual
                   (let open Eq in
                   array (array int))
                   [| [| 1; 2; 3 |]; [| 2; 3; 4 |]; [| 3; 4; 5 |] |] ) ;
          test "size 2, step 2" (fun () ->
              expect (sliding [| 1; 2; 3; 4; 5 |] ~size:2 ~step:2)
              |> toEqual
                   (let open Eq in
                   array (array int))
                   [| [| 1; 2 |]; [| 3; 4 |] |] ) ;
          test "size 1, step 3" (fun () ->
              expect (sliding [| 1; 2; 3; 4; 5 |] ~size:1 ~step:3)
              |> toEqual
                   (let open Eq in
                   array (array int))
                   [| [| 1 |]; [| 4 |] |] ) ;
          test "size 2, step 3" (fun () ->
              expect (sliding [| 1; 2; 3; 4; 5 |] ~size:2 ~step:3)
              |> toEqual
                   (let open Eq in
                   array (array int))
                   [| [| 1; 2 |]; [| 4; 5 |] |] ) ;
          test "step 7" (fun () ->
              expect (sliding [| 1; 2; 3; 4; 5 |] ~size:7)
              |> toEqual
                   (let open Eq in
                   array (array int))
                   [||] ) ) ;

      describe "join" (fun () ->
          test
            "Convert an array of strings into a single String, placing [sep] comma between each string in the result"
            (fun () ->
              expect (join [| "Ant"; "Bat"; "Cat" |] ~sep:", ")
              |> toEqual Eq.string "Ant, Bat, Cat" ) ;
          test
            "Convert an empty array of strings into a String, returns an empty string"
            (fun () -> expect (join [||] ~sep:", ") |> toEqual Eq.string "") ) ;

      describe "count" (fun () ->
          test
            "returns the number of elements in array of odd and even numbers that isEven returns true for, returns int 2"
            (fun () ->
              expect (count ~f:Int.isEven [| 1; 3; 4; 8 |]) |> toEqual Eq.int 2 ) ;
          test
            "returns the number of elements in array of odd numbers that isEven returns true for, returns int 0"
            (fun () ->
              expect (count ~f:Int.isEven [| 1; 3 |]) |> toEqual Eq.int 0 ) ;
          test
            "returns the number of elements in an empty array that isEven returns true for, returns int 0"
            (fun () -> expect (count ~f:Int.isEven [||]) |> toEqual Eq.int 0) ) ;

      describe "find" (fun () ->
          test "returns the first element which `f` returns true for" (fun () ->
              expect (find ~f:Int.isEven [| 1; 3; 4; 8 |])
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 4) ) ;
          test
            "returns `None` if `f` returns false for all elements "
            (fun () ->
              expect (find ~f:Int.isOdd [| 0; 2; 4; 8 |])
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "returns `None` for an empty array" (fun () ->
              expect (find ~f:Int.isEven [||])
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;
      describe "findIndex" (fun () ->
          test
            "returns the first (index,element) tuple which `f` returns true for"
            (fun () ->
              expect
                (findIndex
                   ~f:(fun index number -> index > 2 && Int.isEven number)
                   [| 1; 3; 4; 8 |] )
              |> toEqual
                   (let open Eq in
                   option (pair int int))
                   (Some (3, 8)) ) ;
          test
            "returns `None` if `f` returns false for all elements "
            (fun () ->
              expect (findIndex ~f:(fun _ _ -> false) [| 0; 2; 4; 8 |])
              |> toEqual
                   (let open Eq in
                   option (pair int int))
                   None ) ;
          test "returns `None` for an empty array" (fun () ->
              expect
                (findIndex
                   ~f:(fun index number -> index > 2 && Int.isEven number)
                   [||] )
              |> toEqual
                   (let open Eq in
                   option (pair int int))
                   None ) ) ;

      describe "includes" (fun () ->
          test "returns true if equal" (fun () ->
              expect (includes [| 1; 2; 3 |] 2 ~equal:( = ))
              |> toEqual Eq.bool true ) ;
          test "returns false if not equal" (fun () ->
              expect (includes [| 1; 5; 3 |] 2 ~equal:( = ))
              |> toEqual Eq.bool false ) ;
          test "returns false if empty" (fun () ->
              expect (includes [||] 2 ~equal:( = )) |> toEqual Eq.bool false ) ) ;

      describe "minimum" (fun () ->
          test "returns smallest element" (fun () ->
              expect (minimum [| 1; -2; 3 |] ~compare:Int.compare)
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some (-2)) ) ;
          test "returns none is empty" (fun () ->
              expect (minimum [||] ~compare:Int.compare)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "maximum" (fun () ->
          test "returns largest element" (fun () ->
              expect (maximum [| 1; -2; 3 |] ~compare:Int.compare)
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 3) ) ;
          test "returns none is empty" (fun () ->
              expect (maximum [||] ~compare:Int.compare)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "extent" (fun () ->
          test "returns range" (fun () ->
              expect (extent [| 1; -2; 3 |] ~compare:Int.compare)
              |> toEqual
                   (let open Eq in
                   option (pair int int))
                   (Some (-2, 3)) ) ;
          test "returns range on single" (fun () ->
              expect (extent [| 1 |] ~compare:Int.compare)
              |> toEqual
                   (let open Eq in
                   option (pair int int))
                   (Some (1, 1)) ) ;
          test "returns none is empty" (fun () ->
              expect (extent [||] ~compare:Int.compare)
              |> toEqual
                   (let open Eq in
                   option (pair int int))
                   None ) ) ;

      describe "any" (fun () ->
          test "returns false for empty arrays" (fun () ->
              expect (any [||] ~f:Int.isEven) |> toEqual Eq.bool false ) ;
          test
            "returns true if at least one of the elements of an array return true for [f]"
            (fun () ->
              expect (any [| 1; 3; 4; 5; 7 |] ~f:Int.isEven)
              |> toEqual Eq.bool true ) ;
          test
            "returns false if all of the elements of an array return false for [f]"
            (fun () ->
              expect (any [| 1; 3; 5; 7 |] ~f:Int.isEven)
              |> toEqual Eq.bool false ) ) ;
      describe "all" (fun () ->
          test "returns true for empty arrays" (fun () ->
              expect (all ~f:Int.isEven [||]) |> toEqual Eq.bool true ) ;
          test "returns true if [f] returns true for all elements" (fun () ->
              expect (all ~f:Int.isEven [| 2; 4 |]) |> toEqual Eq.bool true ) ;
          test
            "returns false if a single element fails returns false for [f]"
            (fun () ->
              expect (all ~f:Int.isEven [| 2; 3 |]) |> toEqual Eq.bool false ) ) ;

      describe "append" (fun () ->
          test "append" (fun () ->
              expect (append (repeat ~length:2 42) (repeat ~length:3 81))
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 42; 42; 81; 81; 81 |] ) ) ;
      describe "flatten" (fun () ->
          test "flatten" (fun () ->
              expect (flatten [| [| 1; 2 |]; [| 3 |]; [| 4; 5 |] |])
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 1; 2; 3; 4; 5 |] ) ) ;

      describe "zip" (fun () ->
          test
            "Combine two arrays by merging each pair of elements into a tuple"
            (fun () ->
              expect (zip [| 1; 2; 3; 4; 5 |] [| "Dog"; "Eagle"; "Ferret" |])
              |> toEqual
                   (let open Eq in
                   array (pair int string))
                   [| (1, "Dog"); (2, "Eagle"); (3, "Ferret") |] ) ;
          test "Combine an empty array and another array" (fun () ->
              expect (zip [||] [| "Dog"; "Eagle"; "Ferret" |])
              |> toEqual
                   (let open Eq in
                   array (pair int string))
                   [||] ) ) ;

      describe "unzip" (fun () ->
          test "Decompose an array of tuples into a tuple of arrays" (fun () ->
              expect (unzip [| (0, true); (17, false); (1337, true) |])
              |> toEqual
                   (let open Eq in
                   pair (array int) (array bool))
                   ([| 0; 17; 1337 |], [| true; false; true |]) ) ) ;

      describe "values" (fun () ->
          test
            "Return all of the [Some] values from an array of options"
            (fun () ->
              expect (values [| Some "Ant"; None; Some "Cat" |])
              |> toEqual
                   (let open Eq in
                   array string)
                   [| "Ant"; "Cat" |] ) ;
          test
            "Return all of the [Some] values from an empty array of options"
            (fun () ->
              expect (values [||])
              |> toEqual
                   (let open Eq in
                   array string)
                   [||] ) ) ;

      describe "compare" (fun () ->
          test
            "Compare two arrays of unequal length using provided function Int.compare to compare pairs of elements and returns -1"
            (fun () ->
              expect (compare [| 1; 2; 3 |] [| 1; 2; 3; 4 |] ~f:Int.compare)
              |> toEqual Eq.int (-1) ) ;
          test
            "Compare two identical arrays using provided function Int.compare to compare pairs of elements and returns 0"
            (fun () ->
              expect (compare [| 1; 2; 3 |] [| 1; 2; 3 |] ~f:Int.compare)
              |> toEqual Eq.int 0 ) ;
          test
            "Compare two arrays with of the same length and differing elements using provided function Int.compare to compare pairs of elements and returns 1"
            (fun () ->
              expect (compare [| 1; 2; 5 |] [| 1; 2; 3 |] ~f:Int.compare)
              |> toEqual Eq.int 1 ) ) ;

      describe "intersperse" (fun () ->
          test "equals an array literal of the same value" (fun () ->
              expect
                (intersperse ~sep:"on" [| "turtles"; "turtles"; "turtles" |])
              |> toEqual
                   (let open Eq in
                   array string)
                   [| "turtles"; "on"; "turtles"; "on"; "turtles" |] ) ;
          test "equals an array literal of the same value" (fun () ->
              expect (intersperse ~sep:0 [||])
              |> toEqual
                   (let open Eq in
                   array int)
                   [||] ) ) ;

      describe "chunksOf" (fun () ->
          test "Split an array into equally sized chunks" (fun () ->
              expect
                (chunksOf
                   ~size:2
                   [| "#FFBA49"; "#9984D4"; "#20A39E"; "#EF5B5B" |] )
              |> toEqual
                   (let open Eq in
                   array (array string))
                   [| [| "#FFBA49"; "#9984D4" |]; [| "#20A39E"; "#EF5B5B" |] |] ) ;
          test
            "Split an array into equally sized chunks ignoring partial chunks"
            (fun () ->
              expect
                (chunksOf
                   ~size:2
                   [| "#FFBA49"; "#9984D4"; "#20A39E"; "#EF5B5B"; "#23001E" |] )
              |> toEqual
                   (let open Eq in
                   array (array string))
                   [| [| "#FFBA49"; "#9984D4" |]; [| "#20A39E"; "#EF5B5B" |] |] ) ;
          test "Split an empty array into equally sized chunks" (fun () ->
              expect (chunksOf ~size:2 [||])
              |> toEqual
                   (let open Eq in
                   array (array string))
                   [||] ) ) ;

      describe "slice" (fun () ->
          let numbers = [| 0; 1; 2; 3; 4 |] in
          let positiveArrayLengths =
            [ length numbers; length numbers + 1; 1000 ]
          in
          let negativeArrayLengths =
            List.map ~f:Int.negate positiveArrayLengths
          in
          test "a positive `from`" (fun () ->
              expect (slice ~from:1 numbers)
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 1; 2; 3; 4 |] ) ;
          test "a negative `from`" (fun () ->
              expect (slice ~from:(-1) numbers)
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 4 |] ) ;
          testAll "`from` >= `length`" positiveArrayLengths (fun from ->
              expect (slice ~from numbers)
              |> toEqual
                   (let open Eq in
                   array int)
                   [||] ) ;
          testAll
            "`from` <= negative `length`"
            negativeArrayLengths
            (fun from ->
              expect (slice ~from numbers)
              |> toEqual
                   (let open Eq in
                   array int)
                   numbers ) ;
          test "a positive `to_`" (fun () ->
              expect (slice ~from:0 ~to_:3 numbers)
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 0; 1; 2 |] ) ;
          test "a negative `to_`" (fun () ->
              expect (slice ~from:1 ~to_:(-1) numbers)
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 1; 2; 3 |] ) ;
          testAll "`to_` >= length" positiveArrayLengths (fun to_ ->
              expect (slice ~from:0 ~to_ numbers)
              |> toEqual
                   (let open Eq in
                   array int)
                   numbers ) ;
          testAll "`to_` <= negative `length`" negativeArrayLengths (fun to_ ->
              expect (slice ~from:0 ~to_ numbers)
              |> toEqual
                   (let open Eq in
                   array int)
                   [||] ) ;
          test
            "both `from` and `to_` are negative and `from` < `to_`"
            (fun () ->
              expect (slice ~from:(-2) ~to_:(-1) numbers)
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 3 |] ) ;
          test "works `from` >= `to_`" (fun () ->
              expect (slice ~from:4 ~to_:3 numbers)
              |> toEqual
                   (let open Eq in
                   array int)
                   [||] ) ) ;
      describe "fold" (fun () ->
          test "works for an empty array" (fun () ->
              expect (fold [||] ~f:( ^ ) ~initial:"") |> toEqual Eq.string "" ) ;
          test "works for an ascociative operator" (fun () ->
              expect (fold ~f:( * ) ~initial:1 (repeat ~length:4 7))
              |> toEqual Eq.int 2401 ) ;
          test "works the order of arguments to `f` is important" (fun () ->
              expect (fold [| "a"; "b"; "c" |] ~f:( ^ ) ~initial:"")
              |> toEqual Eq.string "abc" ) ;
          test "works the order of arguments to `f` is important" (fun () ->
              expect
                (fold
                   ~f:(fun list element -> element :: list)
                   ~initial:[]
                   [| 1; 2; 3 |] )
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 3; 2; 1 ] ) ) ;
      describe "foldRight" (fun () ->
          test "works for empty arrays" (fun () ->
              expect (foldRight [||] ~f:( ^ ) ~initial:"")
              |> toEqual Eq.string "" ) ;
          test "foldRight" (fun () ->
              expect (foldRight ~f:( + ) ~initial:0 (repeat ~length:3 5))
              |> toEqual Eq.int 15 ) ;
          test "works the order of arguments to `f` is important" (fun () ->
              expect (foldRight [| "a"; "b"; "c" |] ~f:( ^ ) ~initial:"")
              |> toEqual Eq.string "cba" ) ;
          test "works the order of arguments to `f` is important" (fun () ->
              expect
                (foldRight
                   ~f:(fun list element -> element :: list)
                   ~initial:[]
                   [| 1; 2; 3 |] )
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 1; 2; 3 ] ) ) ;
      describe "reverse" (fun () ->
          test "alters an array in-place" (fun () ->
              let numbers = [| 1; 2; 3 |] in
              reverse numbers ;
              expect numbers
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 3; 2; 1 |] ) ) ;

      describe "sort" (fun () ->
          test "empty list" (fun () ->
              let numbers = [||] in
              sort numbers ~compare:Int.compare ;
              expect numbers
              |> toEqual
                   (let open Eq in
                   array int)
                   [||] ) ;
          test "one element" (fun () ->
              let numbers = [| 5 |] in
              sort numbers ~compare:Int.compare ;
              expect numbers
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 5 |] ) ;
          test "multiple elements" (fun () ->
              let numbers = [| 5; 6; 8; 3; 6 |] in
              sort numbers ~compare:Int.compare ;
              expect numbers
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 3; 5; 6; 6; 8 |] ) ) ;

      describe "groupBy" (fun () ->
          test "returns an empty map for an empty array" (fun () ->
              expect
                (Array.groupBy [||] (module Int) ~f:String.length |> Map.length)
              |> toEqual Eq.int 0 ) ;
          test "example test case" (fun () ->
              let animals = [| "Ant"; "Bear"; "Cat"; "Dewgong" |] in
              expect
                ( Array.groupBy animals (module Int) ~f:String.length
                |> Map.toList )
              |> toEqual
                   (let open Eq in
                   list (pair int (list string)))
                   [ (3, [ "Cat"; "Ant" ])
                   ; (4, [ "Bear" ])
                   ; (7, [ "Dewgong" ])
                   ] ) ) )
