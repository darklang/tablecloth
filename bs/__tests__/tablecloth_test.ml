open Tablecloth
open Jest
open Expect

let () =
  describe "Result" (fun () ->
      describe "fromOption" (fun () ->
          test "maps None into Error" (fun () ->
              expect Result.(fromOption ~error:"error message" None)
              |> toEqual (Belt.Result.Error "error message")) ;
          test "maps Some into Ok" (fun () ->
              expect Result.(fromOption ~error:"error message" (Some 10))
              |> toEqual (Belt.Result.Ok 10)))) ;

  describe "Fun" (fun () ->
      test "identity" (fun () -> expect (Fun.identity 1) |> toEqual 1) ;

      test "ignore" (fun () -> expect (Fun.ignore 1) |> toEqual ()) ;

      test "constant" (fun () -> expect (Fun.constant 1 2) |> toEqual 1) ;

      test "sequence" (fun () -> expect (Fun.sequence 1 2) |> toEqual 2) ;

      test "flip" (fun () -> expect (Fun.flip Int.( / ) 2 4) |> toEqual 2) ;

      test "apply" (fun () ->
          expect (Fun.apply (fun a -> a + 1) 1) |> toEqual 2) ;

      test "compose" (fun () ->
          let increment x = x + 1 in
          let double x = x * 2 in
          expect (Fun.compose increment double 1) |> toEqual 3) ;

      test "composeRight" (fun () ->
          let increment x = x + 1 in
          let double x = x * 2 in
          expect (Fun.composeRight increment double 1) |> toEqual 4) ;

      test "tap" (fun () ->
          expect
            ( Array.filter [| 1; 3; 2; 5; 4 |] ~f:Int.isEven
            |> Fun.tap ~f:(fun numbers -> ignore (Belt.Array.set numbers 1 0))
            |> Fun.tap ~f:Belt.Array.reverseInPlace )
          |> toEqual [| 0; 2 |])) ;

  describe "Array" (fun () ->
      describe "empty" (fun () ->
          test "has length zero" (fun () ->
              expect Array.(empty () |> length) |> toEqual 0) ;
          test "equals the empty array literal" (fun () ->
              expect Array.(empty ()) |> toEqual [||])) ;

      describe "singleton" (fun () ->
          test "equals an array literal of the same value" (fun () ->
              expect (Array.singleton 1234) |> toEqual [| 1234 |]) ;
          test "has length one" (fun () ->
              expect Array.(singleton 1 |> length) |> toEqual 1)) ;

      describe "length" (fun () ->
          test "equals an array literal of the same value" (fun () ->
              expect (Array.length [||]) |> toEqual 0) ;
          test "has length one" (fun () ->
              expect (Array.length [| 'a' |]) |> toEqual 1) ;
          test "has length two" (fun () ->
              expect (Array.length [| "a"; "b" |]) |> toEqual 2)) ;

      describe "isEmpty" (fun () ->
          test "returns true for empty array literals" (fun () ->
              expect (Array.isEmpty [||]) |> toEqual true) ;

          test
            "returns false for literals with a non-zero number of elements"
            (fun () -> expect (Array.isEmpty [| 1234 |]) |> toEqual false)) ;

      describe "initialize" (fun () ->
          test "create empty array" (fun () ->
              expect (Array.initialize ~length:0 ~f:Fun.identity)
              |> toEqual [||]) ;

          test "negative length gives an empty array" (fun () ->
              expect (Array.initialize ~length:(-1) ~f:Fun.identity)
              |> toEqual [||]) ;

          test "create array with initialize" (fun () ->
              expect (Array.initialize ~length:3 ~f:Fun.identity)
              |> toEqual [| 0; 1; 2 |])) ;

      describe "repeat" (fun () ->
          test "length zero creates an empty array" (fun () ->
              expect (Array.repeat 0 ~length:0) |> toEqual [||]) ;

          test "negative length gives an empty array" (fun () ->
              expect (Array.repeat ~length:(-1) 0) |> toEqual [||]) ;

          test "create array of ints" (fun () ->
              expect (Array.repeat 0 ~length:3) |> toEqual [| 0; 0; 0 |]) ;

          test "create array strings" (fun () ->
              expect (Array.repeat "cat" ~length:3)
              |> toEqual [| "cat"; "cat"; "cat" |])) ;

      describe "range" (fun () ->
          test
            "returns an array of the integers from zero and upto but not including [to]"
            (fun () -> expect (Array.range 5) |> toEqual [| 0; 1; 2; 3; 4 |]) ;

          test "returns an empty array when [to] is zero" (fun () ->
              expect (Array.range 0) |> toEqual [||]) ;

          test
            "takes an optional [from] argument to start create empty array"
            (fun () -> expect (Array.range ~from:2 5) |> toEqual [| 2; 3; 4 |]) ;

          test "can start from negative values" (fun () ->
              expect (Array.range ~from:(-2) 3)
              |> toEqual [| -2; -1; 0; 1; 2 |]) ;

          test "returns an empty array when [from] > [to_]" (fun () ->
              expect (Array.range ~from:5 0) |> toEqual [||])) ;

      describe "fromList" (fun () ->
          test
            "transforms a list into an array of the same elements"
            (fun () ->
              expect Array.(fromList [ 1; 2; 3 ]) |> toEqual [| 1; 2; 3 |])) ;

      describe "toList" (fun () ->
          test "transform an array into a list of the same elements" (fun () ->
              expect (Array.toList [| 1; 2; 3 |]) |> toEqual [ 1; 2; 3 ])) ;

      describe "toIndexedList" (fun () ->
          test "returns an empty list for an empty array" (fun () ->
              expect (Array.toIndexedList [||]) |> toEqual []) ;

          test "transforms an array into a list of tuples" (fun () ->
              expect (Array.toIndexedList [| "cat"; "dog" |])
              |> toEqual [ (0, "cat"); (1, "dog") ])) ;

      describe "get" (fun () ->
          test "returns Some for an in-bounds index" (fun () ->
              expect [| "cat"; "dog"; "eel" |].(2) |> toEqual (Some "eel")) ;

          test "returns None for an out of bounds index" (fun () ->
              expect [| 0; 1; 2 |].(5) |> toEqual None) ;

          test "returns None for an empty array" (fun () ->
              expect [||].(0) |> toEqual None)) ;

      describe "getAt" (fun () ->
          test "returns Some for an in-bounds index" (fun () ->
              expect (Array.getAt ~index:2 [| "cat"; "dog"; "eel" |])
              |> toEqual (Some "eel")) ;

          test "returns None for an out of bounds index" (fun () ->
              expect (Array.getAt ~index:5 [| 0; 1; 2 |]) |> toEqual None) ;

          test "returns None for an empty array" (fun () ->
              expect (Array.getAt ~index:0 [||]) |> toEqual None)) ;

      describe "set" (fun () ->
          test "can set a value at an index" (fun () ->
              let numbers = [| 1; 2; 3 |] in
              numbers.(0) <- 0 ;
              expect numbers |> toEqual [| 0; 2; 3 |])) ;

      describe "setAt" (fun () ->
          test "can be partially applied to set an element" (fun () ->
              let setZero = Array.setAt ~value:0 in
              let numbers = [| 1; 2; 3 |] in
              setZero numbers ~index:2 ;
              setZero numbers ~index:1 ;
              expect numbers |> toEqual [| 1; 0; 0 |]) ;

          test "can be partially applied to set an index" (fun () ->
              let setZerothElement = Array.setAt ~index:0 in
              let animals = [| "ant"; "bat"; "cat" |] in
              setZerothElement animals ~value:"antelope" ;
              expect animals |> toEqual [| "antelope"; "bat"; "cat" |])) ;

      describe "sum" (fun () ->
          test "equals zero for an empty array" (fun () ->
              expect (Array.sum [||]) |> toEqual 0) ;

          test "adds up the elements on an integer array" (fun () ->
              expect (Array.sum [| 1; 2; 3 |]) |> toEqual 6)) ;

      describe "floatSum" (fun () ->
          test "equals zero for an empty array" (fun () ->
              expect (Array.floatSum [||]) |> toEqual 0.0) ;

          test "adds up the elements of a float array" (fun () ->
              expect (Array.floatSum [| 1.2; 2.3; 3.4 |]) |> toEqual 6.9)) ;

      describe "filter" (fun () ->
          test "keep elements that [f] returns [true] for" (fun () ->
              expect (Array.filter ~f:Int.isEven [| 1; 2; 3; 4; 5; 6 |])
              |> toEqual [| 2; 4; 6 |])) ;

      describe "swap" (fun () ->
          test "switches values at the given indicies" (fun () ->
              let numbers = [| 1; 2; 3 |] in
              Array.swap numbers 1 2 ;
              expect numbers |> toEqual [| 1; 3; 2 |])) ;

      describe "map" (fun () ->
          test "Apply a function [f] to every element in an array" (fun () ->
              expect (Array.map ~f:sqrt [| 1.0; 4.0; 9.0 |])
              |> toEqual [| 1.0; 2.0; 3.0 |])) ;

      describe "mapWithIndex" (fun () ->
          test "equals an array literal of the same value" (fun () ->
              expect (Array.mapWithIndex ~f:( * ) [| 5; 5; 5 |])
              |> toEqual [| 0; 5; 10 |])) ;

      describe "map2" (fun () ->
          test
            "works when the order of arguments to `f` is not important"
            (fun () ->
              expect (Array.map2 ~f:( + ) [| 1; 2; 3 |] [| 4; 5; 6 |])
              |> toEqual [| 5; 7; 9 |]) ;

          test "works when the order of `f` is important" (fun () ->
              expect
                (Array.map2
                   ~f:Tuple2.create
                   [| "alice"; "bob"; "chuck" |]
                   [| 2; 5; 7; 8 |])
              |> toEqual [| ("alice", 2); ("bob", 5); ("chuck", 7) |])) ;

      test "map3" (fun () ->
          expect
            (Array.map3
               ~f:Tuple3.create
               [| "alice"; "bob"; "chuck" |]
               [| 2; 5; 7; 8 |]
               [| true; false; true; false |])
          |> toEqual
               [| ("alice", 2, true); ("bob", 5, false); ("chuck", 7, true) |]) ;

      test "flatMap" (fun () ->
          let duplicate n = [| n; n |] in
          expect (Array.flatMap ~f:duplicate [| 1; 2; 3 |])
          |> toEqual [| 1; 1; 2; 2; 3; 3 |]) ;

      describe "sliding" (fun () ->
          test "size 1" (fun () ->
              expect (Array.sliding [| 1; 2; 3; 4; 5 |] ~size:1)
              |> toEqual [| [| 1 |]; [| 2 |]; [| 3 |]; [| 4 |]; [| 5 |] |]) ;

          test "size 2" (fun () ->
              expect (Array.sliding [| 1; 2; 3; 4; 5 |] ~size:2)
              |> toEqual [| [| 1; 2 |]; [| 2; 3 |]; [| 3; 4 |]; [| 4; 5 |] |]) ;

          test "step 3 " (fun () ->
              expect (Array.sliding [| 1; 2; 3; 4; 5 |] ~size:3)
              |> toEqual [| [| 1; 2; 3 |]; [| 2; 3; 4 |]; [| 3; 4; 5 |] |]) ;

          test "size 2, step 2" (fun () ->
              expect (Array.sliding [| 1; 2; 3; 4; 5 |] ~size:2 ~step:2)
              |> toEqual [| [| 1; 2 |]; [| 3; 4 |] |]) ;

          test "size 1, step 3" (fun () ->
              expect (Array.sliding [| 1; 2; 3; 4; 5 |] ~size:1 ~step:3)
              |> toEqual [| [| 1 |]; [| 4 |] |]) ;

          test "size 2, step 3" (fun () ->
              expect (Array.sliding [| 1; 2; 3; 4; 5 |] ~size:2 ~step:3)
              |> toEqual [| [| 1; 2 |]; [| 4; 5 |] |]) ;

          test "step 7" (fun () ->
              expect (Array.sliding [| 1; 2; 3; 4; 5 |] ~size:7) |> toEqual [||])) ;

      describe "find" (fun () ->
          test
            "returns the first element which `f` returns true for"
            (fun () ->
              expect (Array.find ~f:Int.isEven [| 1; 3; 4; 8 |])
              |> toEqual (Some 4)) ;

          test
            "returns `None` if `f` returns false for all elements "
            (fun () ->
              expect (Array.find ~f:Int.isOdd [| 0; 2; 4; 8 |]) |> toEqual None) ;

          test "returns `None` for an empty array" (fun () ->
              expect (Array.find ~f:Int.isEven [||]) |> toEqual None)) ;

      describe "findIndex" (fun () ->
          test
            "returns the first (index,element) tuple which `f` returns true for"
            (fun () ->
              expect
                (Array.findIndex
                   ~f:(fun index number -> index > 2 && Int.isEven number)
                   [| 1; 3; 4; 8 |])
              |> toEqual (Some (3, 8))) ;

          test
            "returns `None` if `f` returns false for all elements "
            (fun () ->
              expect (Array.findIndex ~f:(fun _ _ -> false) [| 0; 2; 4; 8 |])
              |> toEqual None) ;

          test "returns `None` for an empty array" (fun () ->
              expect
                (Array.findIndex
                   ~f:(fun index number -> index > 2 && Int.isEven number)
                   [||])
              |> toEqual None)) ;

      describe "any" (fun () ->
          test "returns false for empty arrays" (fun () ->
              expect (Array.any [||] ~f:Int.isEven) |> toEqual false) ;

          test
            "returns true if at least one of the elements of an array return true for [f]"
            (fun () ->
              expect (Array.any [| 1; 3; 4; 5; 7 |] ~f:Int.isEven)
              |> toEqual true) ;

          test
            "returns false if all of the elements of an array return false for [f]"
            (fun () ->
              expect (Array.any [| 1; 3; 5; 7 |] ~f:Int.isEven)
              |> toEqual false)) ;

      describe "all" (fun () ->
          test "returns true for empty arrays" (fun () ->
              expect (Array.all ~f:Int.isEven [||]) |> toEqual true) ;

          test "returns true if [f] returns true for all elements" (fun () ->
              expect (Array.all ~f:Int.isEven [| 2; 4 |]) |> toEqual true) ;

          test
            "returns false if a single element fails returns false for [f]"
            (fun () ->
              expect (Array.all ~f:Int.isEven [| 2; 3 |]) |> toEqual false)) ;

      test "append" (fun () ->
          expect
            (Array.append
               (Array.repeat ~length:2 42)
               (Array.repeat ~length:3 81))
          |> toEqual [| 42; 42; 81; 81; 81 |]) ;

      test "concatenate" (fun () ->
          expect (Array.concatenate [| [| 1; 2 |]; [| 3 |]; [| 4; 5 |] |])
          |> toEqual [| 1; 2; 3; 4; 5 |]) ;

      describe "intersperse" (fun () ->
          test "equals an array literal of the same value" (fun () ->
              expect
                (Array.intersperse
                   ~sep:"on"
                   [| "turtles"; "turtles"; "turtles" |])
              |> toEqual [| "turtles"; "on"; "turtles"; "on"; "turtles" |]) ;

          test "equals an array literal of the same value" (fun () ->
              expect (Array.intersperse ~sep:0 [||]) |> toEqual [||])) ;

      describe "slice" (fun () ->
          let array = [| 0; 1; 2; 3; 4 |] in
          let positiveArrayLengths =
            [ Array.length array; Array.length array + 1; 1000 ]
          in
          let negativeArrayLengths =
            List.map ~f:Int.negate positiveArrayLengths
          in
          test "should work with a positive `from`" (fun () ->
              expect (Array.slice ~from:1 array) |> toEqual [| 1; 2; 3; 4 |]) ;

          test "should work with a negative `from`" (fun () ->
              expect (Array.slice ~from:(-1) array) |> toEqual [| 4 |]) ;

          testAll
            "should work when `from` >= `length`"
            positiveArrayLengths
            (fun from -> expect (Array.slice ~from array) |> toEqual [||]) ;

          testAll
            "should work when `from` <= negative `length`"
            negativeArrayLengths
            (fun from -> expect (Array.slice ~from array) |> toEqual array) ;

          test "should work with a positive `to_`" (fun () ->
              expect (Array.slice ~from:0 ~to_:3 array)
              |> toEqual [| 0; 1; 2 |]) ;

          test "should work with a negative `to_`" (fun () ->
              expect (Array.slice ~from:1 ~to_:(-1) array)
              |> toEqual [| 1; 2; 3 |]) ;

          testAll
            "should work when `to_` >= length"
            positiveArrayLengths
            (fun to_ ->
              expect (Array.slice ~from:0 ~to_ array) |> toEqual array) ;

          testAll
            "should work when `to_` <= negative `length`"
            negativeArrayLengths
            (fun to_ ->
              expect (Array.slice ~from:0 ~to_ array) |> toEqual [||]) ;

          test
            "should work when both `from` and `to_` are negative and `from` < `to_`"
            (fun () ->
              expect (Array.slice ~from:(-2) ~to_:(-1) array)
              |> toEqual [| 3 |]) ;

          test "works when `from` >= `to_`" (fun () ->
              expect (Array.slice ~from:4 ~to_:3 array) |> toEqual [||])) ;

      describe "foldLeft" (fun () ->
          test "works for an empty array" (fun () ->
              expect (Array.foldLeft [||] ~f:( ^ ) ~initial:"") |> toEqual "") ;

          test "works for an ascociative operator" (fun () ->
              expect
                (Array.foldLeft ~f:( * ) ~initial:1 (Array.repeat ~length:4 7))
              |> toEqual 2401) ;

          test
            "works when the order of arguments to `f` is important"
            (fun () ->
              expect (Array.foldLeft [| "a"; "b"; "c" |] ~f:( ^ ) ~initial:"")
              |> toEqual "cba") ;

          test
            "works when the order of arguments to `f` is important"
            (fun () ->
              expect
                (Array.foldLeft
                   ~f:(fun element list -> element :: list)
                   ~initial:[]
                   [| 1; 2; 3 |])
              |> toEqual [ 3; 2; 1 ])) ;

      describe "foldRight" (fun () ->
          test "works for empty arrays" (fun () ->
              expect (Array.foldRight [||] ~f:( ^ ) ~initial:"") |> toEqual "") ;

          test "fold right" (fun () ->
              expect
                (Array.foldRight ~f:( + ) ~initial:0 (Array.repeat ~length:3 5))
              |> toEqual 15) ;

          test
            "works when the order of arguments to `f` is important"
            (fun () ->
              expect (Array.foldRight [| "a"; "b"; "c" |] ~f:( ^ ) ~initial:"")
              |> toEqual "abc") ;

          test
            "works when the order of arguments to `f` is important"
            (fun () ->
              expect
                (Array.foldRight
                   ~f:(fun element list -> element :: list)
                   ~initial:[]
                   [| 1; 2; 3 |])
              |> toEqual [ 1; 2; 3 ])) ;

      describe "reverse" (fun () ->
          test "reverse empty array" (fun () ->
              expect (Array.reverse [||]) |> toEqual [||]) ;
          test "reverse two elements" (fun () ->
              expect (Array.reverse [| 0; 1 |]) |> toEqual [| 1; 0 |]) ;
          test "leaves the original array untouched" (fun () ->
              let array = [| 0; 1; 2; 3 |] in
              let _reversedArray = Array.reverse array in
              expect array |> toEqual [| 0; 1; 2; 3 |])) ;

      describe "reverseInPlace" (fun () ->
          test "alters an array in-place" (fun () ->
              let array = [| 1; 2; 3 |] in
              Array.reverseInPlace array ;
              expect array |> toEqual [| 3; 2; 1 |])) ;

      test "forEach" (fun () ->
          let index = ref 0 in
          let calledValues = [| 0; 0; 0 |] in
          Array.forEach [| 1; 2; 3 |] ~f:(fun value ->
              Array.setAt calledValues ~index:!index ~value ;
              index := !index + 1) ;

          expect calledValues |> toEqual [| 1; 2; 3 |])) ;

  describe "Char" (fun () ->
      test "toCode" (fun () -> expect (Char.toCode 'a') |> toEqual 97) ;

      describe "fromCode" (fun () ->
          test
            "valid ASCII codes return the corresponding character"
            (fun () -> expect (Char.fromCode 97) |> toEqual (Some 'a')) ;
          test "negative integers return none" (fun () ->
              expect (Char.fromCode (-1)) |> toEqual None) ;
          test "integers greater than 255 return none" (fun () ->
              expect (Char.fromCode 256) |> toEqual None)) ;

      test "toString" (fun () -> expect (Char.toString 'a') |> toEqual "a") ;

      describe "fromString" (fun () ->
          test "one-length string return Some" (fun () ->
              expect (Char.fromString "a") |> toEqual (Some 'a')) ;
          test "multi character strings return none" (fun () ->
              expect (Char.fromString "abc") |> toEqual None) ;
          test "zero length strings return none" (fun () ->
              expect (Char.fromString "") |> toEqual None)) ;

      describe "toLowercase" (fun () ->
          test "converts uppercase ASCII characters to lowercase" (fun () ->
              expect (Char.toLowercase 'A') |> toEqual 'a') ;
          test "perserves lowercase characters" (fun () ->
              expect (Char.toLowercase 'a') |> toEqual 'a') ;
          test "perserves non-alphabet characters" (fun () ->
              expect (Char.toLowercase '7') |> toEqual '7') ;
          test "perserves non-ASCII characters" (fun () ->
              expect (Char.toUppercase '\233') |> toEqual '\233')) ;

      describe "toUppercase" (fun () ->
          test "converts lowercase ASCII characters to uppercase" (fun () ->
              expect (Char.toUppercase 'a') |> toEqual 'A') ;
          test "perserves uppercase characters" (fun () ->
              expect (Char.toUppercase 'A') |> toEqual 'A') ;
          test "perserves non-alphabet characters" (fun () ->
              expect (Char.toUppercase '7') |> toEqual '7') ;
          test "perserves non-ASCII characters" (fun () ->
              expect (Char.toUppercase '\233') |> toEqual '\233')) ;

      describe "toDigit" (fun () ->
          test
            "toDigit - converts ASCII characters representing digits into integers"
            (fun () -> expect (Char.toDigit '0') |> toEqual (Some 0)) ;
          test
            "toDigit - converts ASCII characters representing digits into integers"
            (fun () -> expect (Char.toDigit '8') |> toEqual (Some 8)) ;
          test
            "toDigit - converts ASCII characters representing digits into integers"
            (fun () -> expect (Char.toDigit 'a') |> toEqual None)) ;

      describe "isLowercase" (fun () ->
          test "returns true for any lowercase character" (fun () ->
              expect (Char.isLowercase 'a') |> toEqual true) ;
          test "returns false for all other characters" (fun () ->
              expect (Char.isLowercase '7') |> toEqual false) ;
          test "returns false for non-ASCII characters" (fun () ->
              expect (Char.isLowercase '\236') |> toEqual false)) ;

      describe "isUppercase" (fun () ->
          test "returns true for any uppercase character" (fun () ->
              expect (Char.isUppercase 'A') |> toEqual true) ;
          test "returns false for all other characters" (fun () ->
              expect (Char.isUppercase '7') |> toEqual false) ;
          test "returns false for non-ASCII characters" (fun () ->
              expect (Char.isLowercase '\237') |> toEqual false)) ;

      describe "isLetter" (fun () ->
          test "returns true for any ASCII alphabet character" (fun () ->
              expect (Char.isLetter 'A') |> toEqual true) ;
          testAll
            "returns false for all other characters"
            [ '7'; ' '; '\n'; '\011'; '\236' ]
            (fun char -> expect (Char.isLetter char) |> toEqual false)) ;

      describe "isDigit" (fun () ->
          testAll
            "returns true for digits 0-9"
            [ '0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9' ]
            (fun digit -> expect (Char.isDigit digit) |> toEqual true) ;
          test "returns false for all other characters" (fun () ->
              expect (Char.isDigit 'a') |> toEqual false)) ;

      describe "isAlphanumeric" (fun () ->
          test "returns true for any alphabet or digit character" (fun () ->
              expect (Char.isAlphanumeric 'A') |> toEqual true) ;
          test "returns false for all other characters" (fun () ->
              expect (Char.isAlphanumeric '?') |> toEqual false)) ;

      describe "isPrintable" (fun () ->
          test "returns true for a printable character" (fun () ->
              expect (Char.isPrintable '~') |> toEqual true) ;

          test "returns false for non-printable character" (fun () ->
              expect (Char.fromCode 31 |> Option.map ~f:Char.isPrintable)
              |> toEqual (Some false))) ;

      describe "isWhitespace" (fun () ->
          test "returns true for any whitespace character" (fun () ->
              expect (Char.isWhitespace ' ') |> toEqual true) ;
          test "returns false for a non-whitespace character" (fun () ->
              expect (Char.isWhitespace 'a') |> toEqual false))) ;

  describe "Float" (fun () ->
      Float.(
        test "zero" (fun () -> expect zero |> toEqual 0.) ;

        test "one" (fun () -> expect one |> toEqual 1.) ;

        test "nan" (fun () -> expect (nan = nan) |> toEqual false) ;

        test "infinity" (fun () -> expect (infinity > 0.) |> toEqual true) ;

        test "negativeInfinity" (fun () ->
            expect (negativeInfinity < 0.) |> toEqual true) ;

        describe "equals" (fun () ->
            test "zero" (fun () -> expect (0. = -0.) |> toBe true)) ;

        describe "add" (fun () ->
            test "add" (fun () -> expect (add 3.14 3.14) |> toEqual 6.28) ;
            test "+" (fun () -> expect (3.14 + 3.14) |> toEqual 6.28)) ;

        describe "subtract" (fun () ->
            test "subtract" (fun () -> expect (subtract 4. 3.) |> toEqual 1.) ;
            test "-" (fun () -> expect (4. - 3.) |> toEqual 1.)) ;

        describe "multiply" (fun () ->
            test "multiply" (fun () -> expect (multiply 2. 7.) |> toEqual 14.) ;
            test "*" (fun () -> expect (2. * 7.) |> toEqual 14.)) ;

        describe "divide" (fun () ->
            test "divide" (fun () ->
                expect (divide 3.14 ~by:2.) |> toEqual 1.57) ;
            test "divide by zero" (fun () ->
                expect (divide 3.14 ~by:0.) |> toEqual infinity) ;
            test "divide by negative zero" (fun () ->
                expect (divide 3.14 ~by:(-0.)) |> toEqual negativeInfinity) ;

            test "/" (fun () -> expect (3.14 / 2.) |> toEqual 1.57)) ;

        describe "power" (fun () ->
            test "power" (fun () ->
                expect (power ~base:7. ~exponent:3.) |> toEqual 343.) ;
            test "0 base" (fun () ->
                expect (power ~base:0. ~exponent:3.) |> toEqual 0.) ;
            test "0 exponent" (fun () ->
                expect (power ~base:7. ~exponent:0.) |> toEqual 1.) ;
            test "**" (fun () -> expect (7. ** 3.) |> toEqual 343.)) ;

        describe "negate" (fun () ->
            test "positive number" (fun () ->
                expect (negate 8.) |> toEqual (-8.)) ;
            test "negative number" (fun () ->
                expect (negate (-7.)) |> toEqual 7.) ;
            test "zero" (fun () -> expect (negate 0.) |> toEqual (-0.)) ;
            test "~-" (fun () -> expect ~-7. |> toEqual (-7.))) ;

        describe "absolute" (fun () ->
            test "positive number" (fun () ->
                expect (absolute 8.) |> toEqual 8.) ;
            test "negative number" (fun () ->
                expect (absolute (-7.)) |> toEqual 7.) ;
            test "zero" (fun () -> expect (absolute 0.) |> toEqual 0.)) ;

        describe "maximum" (fun () ->
            test "positive numbers" (fun () ->
                expect (maximum 7. 9.) |> toEqual 9.) ;
            test "negative numbers" (fun () ->
                expect (maximum (-4.) (-1.)) |> toEqual (-1.)) ;
            test "nan" (fun () -> expect (maximum 7. nan) |> toEqual nan) ;
            test "infinity" (fun () ->
                expect (maximum 7. infinity) |> toEqual infinity) ;
            test "negativeInfinity" (fun () ->
                expect (maximum 7. negativeInfinity) |> toEqual 7.)) ;

        describe "minimum" (fun () ->
            test "positive numbers" (fun () ->
                expect (minimum 7. 9.) |> toEqual 7.) ;
            test "negative numbers" (fun () ->
                expect (minimum (-4.) (-1.)) |> toEqual (-4.)) ;
            test "nan" (fun () -> expect (minimum 7. nan) |> toEqual nan) ;
            test "infinity" (fun () ->
                expect (minimum 7. infinity) |> toEqual 7.) ;
            test "negativeInfinity" (fun () ->
                expect (minimum 7. negativeInfinity)
                |> toEqual negativeInfinity)) ;

        describe "clamp" (fun () ->
            test "in range" (fun () ->
                expect (clamp ~lower:0. ~upper:8. 5.) |> toEqual 5.) ;
            test "above range" (fun () ->
                expect (clamp ~lower:0. ~upper:8. 9.) |> toEqual 8.) ;
            test "below range" (fun () ->
                expect (clamp ~lower:2. ~upper:8. 1.) |> toEqual 2.) ;
            test "above negative range" (fun () ->
                expect (clamp ~lower:(-10.) ~upper:(-5.) 5.) |> toEqual (-5.)) ;
            test "below negative range" (fun () ->
                expect (clamp ~lower:(-10.) ~upper:(-5.) (-15.))
                |> toEqual (-10.)) ;
            test "nan upper bound" (fun () ->
                expect (clamp ~lower:(-7.9) ~upper:nan (-6.6)) |> toEqual nan) ;
            test "nan lower bound" (fun () ->
                expect (clamp ~lower:nan ~upper:0. (-6.6)) |> toEqual nan) ;
            test "nan value" (fun () ->
                expect (clamp ~lower:2. ~upper:8. nan) |> toEqual nan) ;
            test "invalid arguments" (fun () ->
                expect (fun () -> clamp ~lower:7. ~upper:1. 3.) |> toThrow)) ;

        describe "squareRoot" (fun () ->
            test "whole numbers" (fun () ->
                expect (squareRoot 4.) |> toEqual 2.) ;
            test "decimal numbers" (fun () ->
                expect (squareRoot 20.25) |> toEqual 4.5) ;
            test "negative number" (fun () ->
                expect (squareRoot (-1.)) |> toEqual nan)) ;

        describe "log" (fun () ->
            test "base 10" (fun () ->
                expect (log ~base:10. 100.) |> toEqual 2.) ;
            test "base 2" (fun () -> expect (log ~base:2. 256.) |> toEqual 8.) ;
            test "of zero" (fun () ->
                expect (log ~base:10. 0.) |> toEqual negativeInfinity)) ;

        describe "isNaN" (fun () ->
            test "nan" (fun () -> expect (isNaN nan) |> toEqual true) ;
            test "non-nan" (fun () -> expect (isNaN 91.4) |> toEqual false)) ;

        describe "isFinite" (fun () ->
            test "infinity" (fun () ->
                expect (isFinite infinity) |> toEqual false) ;
            test "negative infinity" (fun () ->
                expect (isFinite negativeInfinity) |> toEqual false) ;
            test "NaN" (fun () -> expect (isFinite nan) |> toEqual false) ;
            testAll "regular numbers" [ -5.; -0.314; 0.; 3.14 ] (fun n ->
                expect (isFinite n) |> toEqual true)) ;

        describe "isInfinite" (fun () ->
            test "infinity" (fun () ->
                expect (isInfinite infinity) |> toEqual true) ;
            test "negative infinity" (fun () ->
                expect (isInfinite negativeInfinity) |> toEqual true) ;
            test "NaN" (fun () -> expect (isInfinite nan) |> toEqual false) ;
            testAll "regular numbers" [ -5.; -0.314; 0.; 3.14 ] (fun n ->
                expect (isInfinite n) |> toEqual false)) ;

        describe "inRange" (fun () ->
            test "in range" (fun () ->
                expect (inRange ~lower:2. ~upper:4. 3.) |> toEqual true) ;
            test "above range" (fun () ->
                expect (inRange ~lower:2. ~upper:4. 8.) |> toEqual false) ;
            test "below range" (fun () ->
                expect (inRange ~lower:2. ~upper:4. 1.) |> toEqual false) ;
            test "equal to ~upper" (fun () ->
                expect (inRange ~lower:1. ~upper:2. 2.) |> toEqual false) ;
            test "negative range" (fun () ->
                expect (inRange ~lower:(-7.9) ~upper:(-5.2) (-6.6))
                |> toEqual true) ;
            test "nan upper bound" (fun () ->
                expect (inRange ~lower:(-7.9) ~upper:nan (-6.6))
                |> toEqual false) ;
            test "nan lower bound" (fun () ->
                expect (inRange ~lower:nan ~upper:0. (-6.6)) |> toEqual false) ;
            test "nan value" (fun () ->
                expect (inRange ~lower:2. ~upper:8. nan) |> toEqual false) ;
            test "invalid arguments" (fun () ->
                expect (fun () -> inRange ~lower:7. ~upper:1. 3.) |> toThrow)) ;

        test "hypotenuse" (fun () -> expect (hypotenuse 3. 4.) |> toEqual 5.) ;

        test "degrees" (fun () -> expect (degrees 180.) |> toEqual pi) ;

        test "radians" (fun () -> expect (radians pi) |> toEqual pi) ;

        test "turns" (fun () -> expect (turns 1.) |> toEqual (2. * pi)) ;

        describe "fromPolar" (fun () ->
            let x, y = fromPolar (squareRoot 2., degrees 45.) in
            test "x" (fun () -> expect x |> toBeCloseTo 1.) ;
            test "y" (fun () -> expect y |> toBeCloseTo 1.)) ;

        describe "toPolar" (fun () ->
            test "toPolar" (fun () ->
                expect (toPolar (3.0, 4.0)) |> toEqual (5.0, 0.9272952180016122)) ;

            test "toPolar" (fun () ->
                expect (toPolar (5.0, 12.0))
                |> toEqual (13.0, 1.1760052070951352))) ;

        describe "cos" (fun () ->
            test "cos" (fun () ->
                expect (cos (degrees 60.)) |> toEqual 0.5000000000000001) ;

            test "cos" (fun () ->
                expect (cos (radians (pi / 3.))) |> toEqual 0.5000000000000001)) ;

        describe "acos" (fun () ->
            test "1 / 2" (fun () ->
                (* pi / 3. *)
                expect (acos (1. / 2.)) |> toEqual 1.0471975511965979)) ;

        describe "sin" (fun () ->
            test "30 degrees" (fun () ->
                expect (sin (degrees 30.)) |> toEqual 0.49999999999999994) ;
            test "pi / 6" (fun () ->
                expect (sin (radians (pi / 6.))) |> toEqual 0.49999999999999994)) ;

        describe "asin" (fun () ->
            test "asin" (fun () ->
                (* ~ pi / 6. *)
                expect (asin (1. / 2.)) |> toEqual 0.5235987755982989)) ;

        describe "tan" (fun () ->
            test "45 degrees" (fun () ->
                expect (tan (degrees 45.)) |> toEqual 0.9999999999999999) ;
            test "pi / 4" (fun () ->
                expect (tan (radians (pi / 4.))) |> toEqual 0.9999999999999999) ;
            test "0" (fun () -> expect (tan 0.) |> toEqual 0.)) ;

        describe "atan" (fun () ->
            test "0" (fun () -> expect (atan 0.) |> toEqual 0.) ;
            test "1 / 1" (fun () ->
                expect (atan (1. / 1.)) |> toEqual 0.7853981633974483) ;
            test "1 / -1" (fun () ->
                expect (atan (1. / -1.)) |> toEqual (-0.7853981633974483)) ;
            test "-1 / -1" (fun () ->
                expect (atan (-1. / -1.)) |> toEqual 0.7853981633974483) ;
            test "-1 / -1" (fun () ->
                expect (atan (-1. / 1.)) |> toEqual (-0.7853981633974483))) ;

        describe "atan2" (fun () ->
            test "0" (fun () -> expect (atan2 ~y:0. ~x:0.) |> toEqual 0.) ;
            test "(1, 1)" (fun () ->
                expect (atan2 ~y:1. ~x:1.) |> toEqual 0.7853981633974483) ;
            test "(-1, 1)" (fun () ->
                expect (atan2 ~y:1. ~x:(-1.)) |> toEqual 2.3561944901923449) ;
            test "(-1 -1)" (fun () ->
                expect (atan2 ~y:(-1.) ~x:(-1.))
                |> toEqual (-2.3561944901923449)) ;
            test "(1, -1)" (fun () ->
                expect (atan2 ~y:(-1.) ~x:1.) |> toEqual (-0.7853981633974483))) ;

        describe "round" (fun () ->
            test "`Zero" (fun () ->
                expect (round ~direction:`Zero 1.2) |> toEqual 1.) ;
            test "`Zero" (fun () ->
                expect (round ~direction:`Zero 1.5) |> toEqual 1.) ;
            test "`Zero" (fun () ->
                expect (round ~direction:`Zero 1.8) |> toEqual 1.) ;
            test "`Zero" (fun () ->
                expect (round ~direction:`Zero (-1.2)) |> toEqual (-1.)) ;
            test "`Zero" (fun () ->
                expect (round ~direction:`Zero (-1.5)) |> toEqual (-1.)) ;
            test "`Zero" (fun () ->
                expect (round ~direction:`Zero (-1.8)) |> toEqual (-1.)) ;

            test "`AwayFromZero" (fun () ->
                expect (round ~direction:`AwayFromZero 1.2) |> toEqual 2.) ;
            test "`AwayFromZero" (fun () ->
                expect (round ~direction:`AwayFromZero 1.5) |> toEqual 2.) ;
            test "`AwayFromZero" (fun () ->
                expect (round ~direction:`AwayFromZero 1.8) |> toEqual 2.) ;
            test "`AwayFromZero" (fun () ->
                expect (round ~direction:`AwayFromZero (-1.2)) |> toEqual (-2.)) ;
            test "`AwayFromZero" (fun () ->
                expect (round ~direction:`AwayFromZero (-1.5)) |> toEqual (-2.)) ;
            test "`AwayFromZero" (fun () ->
                expect (round ~direction:`AwayFromZero (-1.8)) |> toEqual (-2.)) ;

            test "`Up" (fun () ->
                expect (round ~direction:`Up 1.2) |> toEqual 2.) ;
            test "`Up" (fun () ->
                expect (round ~direction:`Up 1.5) |> toEqual 2.) ;
            test "`Up" (fun () ->
                expect (round ~direction:`Up 1.8) |> toEqual 2.) ;
            test "`Up" (fun () ->
                expect (round ~direction:`Up (-1.2)) |> toEqual (-1.)) ;
            test "`Up" (fun () ->
                expect (round ~direction:`Up (-1.5)) |> toEqual (-1.)) ;
            test "`Up" (fun () ->
                expect (round ~direction:`Up (-1.8)) |> toEqual (-1.)) ;

            test "`Down" (fun () ->
                expect (round ~direction:`Down 1.2) |> toEqual 1.) ;
            test "`Down" (fun () ->
                expect (round ~direction:`Down 1.5) |> toEqual 1.) ;
            test "`Down" (fun () ->
                expect (round ~direction:`Down 1.8) |> toEqual 1.) ;
            test "`Down" (fun () ->
                expect (round ~direction:`Down (-1.2)) |> toEqual (-2.)) ;
            test "`Down" (fun () ->
                expect (round ~direction:`Down (-1.5)) |> toEqual (-2.)) ;
            test "`Down" (fun () ->
                expect (round ~direction:`Down (-1.8)) |> toEqual (-2.)) ;

            test "`Closest `Zero" (fun () ->
                expect (round ~direction:(`Closest `Zero) 1.2) |> toEqual 1.) ;
            test "`Closest `Zero" (fun () ->
                expect (round ~direction:(`Closest `Zero) 1.5) |> toEqual 1.) ;
            test "`Closest `Zero" (fun () ->
                expect (round ~direction:(`Closest `Zero) 1.8) |> toEqual 2.) ;
            test "`Closest `Zero" (fun () ->
                expect (round ~direction:(`Closest `Zero) (-1.2))
                |> toEqual (-1.)) ;
            test "`Closest `Zero" (fun () ->
                expect (round ~direction:(`Closest `Zero) (-1.5))
                |> toEqual (-1.)) ;
            test "`Closest `Zero" (fun () ->
                expect (round ~direction:(`Closest `Zero) (-1.8))
                |> toEqual (-2.)) ;

            test "`Closest `AwayFromZero" (fun () ->
                expect (round ~direction:(`Closest `AwayFromZero) 1.2)
                |> toEqual 1.) ;
            test "`Closest `AwayFromZero" (fun () ->
                expect (round ~direction:(`Closest `AwayFromZero) 1.5)
                |> toEqual 2.) ;
            test "`Closest `AwayFromZero" (fun () ->
                expect (round ~direction:(`Closest `AwayFromZero) 1.8)
                |> toEqual 2.) ;
            test "`Closest `AwayFromZero" (fun () ->
                expect (round ~direction:(`Closest `AwayFromZero) (-1.2))
                |> toEqual (-1.)) ;
            test "`Closest `AwayFromZero" (fun () ->
                expect (round ~direction:(`Closest `AwayFromZero) (-1.5))
                |> toEqual (-2.)) ;
            test "`Closest `AwayFromZero" (fun () ->
                expect (round ~direction:(`Closest `AwayFromZero) (-1.8))
                |> toEqual (-2.)) ;

            test "`Closest `Up" (fun () ->
                expect (round ~direction:(`Closest `Up) 1.2) |> toEqual 1.) ;
            test "`Closest `Up" (fun () ->
                expect (round ~direction:(`Closest `Up) 1.5) |> toEqual 2.) ;
            test "`Closest `Up" (fun () ->
                expect (round ~direction:(`Closest `Up) 1.8) |> toEqual 2.) ;
            test "`Closest `Up" (fun () ->
                expect (round ~direction:(`Closest `Up) (-1.2))
                |> toEqual (-1.)) ;
            test "`Closest `Up" (fun () ->
                expect (round ~direction:(`Closest `Up) (-1.5))
                |> toEqual (-1.)) ;
            test "`Closest `Up" (fun () ->
                expect (round ~direction:(`Closest `Up) (-1.8))
                |> toEqual (-2.)) ;

            test "`Closest `Down" (fun () ->
                expect (round ~direction:(`Closest `Down) 1.2) |> toEqual 1.) ;
            test "`Closest `Down" (fun () ->
                expect (round ~direction:(`Closest `Down) 1.5) |> toEqual 1.) ;
            test "`Closest `Down" (fun () ->
                expect (round ~direction:(`Closest `Down) 1.8) |> toEqual 2.) ;
            test "`Closest `Down" (fun () ->
                expect (round ~direction:(`Closest `Down) (-1.2))
                |> toEqual (-1.)) ;
            test "`Closest `Down" (fun () ->
                expect (round ~direction:(`Closest `Down) (-1.5))
                |> toEqual (-2.)) ;
            test "`Closest `Down" (fun () ->
                expect (round ~direction:(`Closest `Down) (-1.8))
                |> toEqual (-2.)) ;

            test "`Closest `ToEven" (fun () ->
                expect (round ~direction:(`Closest `ToEven) 1.2) |> toEqual 1.) ;
            test "`Closest `ToEven" (fun () ->
                expect (round ~direction:(`Closest `ToEven) 1.5) |> toEqual 2.) ;
            test "`Closest `ToEven" (fun () ->
                expect (round ~direction:(`Closest `ToEven) 1.8) |> toEqual 2.) ;
            test "`Closest `ToEven" (fun () ->
                expect (round ~direction:(`Closest `ToEven) 2.2) |> toEqual 2.) ;
            test "`Closest `ToEven" (fun () ->
                expect (round ~direction:(`Closest `ToEven) 2.5) |> toEqual 2.) ;
            test "`Closest `ToEven" (fun () ->
                expect (round ~direction:(`Closest `ToEven) 2.8) |> toEqual 3.) ;
            test "`Closest `ToEven" (fun () ->
                expect (round ~direction:(`Closest `ToEven) (-1.2))
                |> toEqual (-1.)) ;
            test "`Closest `ToEven" (fun () ->
                expect (round ~direction:(`Closest `ToEven) (-1.5))
                |> toEqual (-2.)) ;
            test "`Closest `ToEven" (fun () ->
                expect (round ~direction:(`Closest `ToEven) (-1.8))
                |> toEqual (-2.)) ;
            test "`Closest `ToEven" (fun () ->
                expect (round ~direction:(`Closest `ToEven) (-2.2))
                |> toEqual (-2.)) ;
            test "`Closest `ToEven" (fun () ->
                expect (round ~direction:(`Closest `ToEven) (-2.5))
                |> toEqual (-2.)) ;
            test "`Closest `ToEven" (fun () ->
                expect (round ~direction:(`Closest `ToEven) (-2.8))
                |> toEqual (-3.))) ;

        describe "floor" (fun () ->
            test "floor" (fun () -> expect (floor 1.2) |> toEqual 1.) ;
            test "floor" (fun () -> expect (floor 1.5) |> toEqual 1.) ;
            test "floor" (fun () -> expect (floor 1.8) |> toEqual 1.) ;
            test "floor" (fun () -> expect (floor (-1.2)) |> toEqual (-2.)) ;
            test "floor" (fun () -> expect (floor (-1.5)) |> toEqual (-2.)) ;
            test "floor" (fun () -> expect (floor (-1.8)) |> toEqual (-2.))) ;

        describe "ceiling" (fun () ->
            test "ceiling" (fun () -> expect (ceiling 1.2) |> toEqual 2.) ;
            test "ceiling" (fun () -> expect (ceiling 1.5) |> toEqual 2.) ;
            test "ceiling" (fun () -> expect (ceiling 1.8) |> toEqual 2.) ;
            test "ceiling" (fun () -> expect (ceiling (-1.2)) |> toEqual (-1.)) ;
            test "ceiling" (fun () -> expect (ceiling (-1.5)) |> toEqual (-1.)) ;
            test "ceiling" (fun () -> expect (ceiling (-1.8)) |> toEqual (-1.))) ;

        describe "truncate" (fun () ->
            test "truncate" (fun () -> expect (truncate 1.2) |> toEqual 1.) ;
            test "truncate" (fun () -> expect (truncate 1.5) |> toEqual 1.) ;
            test "truncate" (fun () -> expect (truncate 1.8) |> toEqual 1.) ;
            test "truncate" (fun () ->
                expect (truncate (-1.2)) |> toEqual (-1.)) ;
            test "truncate" (fun () ->
                expect (truncate (-1.5)) |> toEqual (-1.)) ;
            test "truncate" (fun () ->
                expect (truncate (-1.8)) |> toEqual (-1.))) ;

        describe "fromInt" (fun () ->
            test "5" (fun () -> expect (fromInt 5) |> toEqual 5.0) ;
            test "0" (fun () -> expect (fromInt 0) |> toEqual 0.0) ;
            test "-7" (fun () -> expect (fromInt (-7)) |> toEqual (-7.0))) ;

        describe "toInt" (fun () ->
            test "5." (fun () -> expect (toInt 5.) |> toEqual (Some 5)) ;
            test "5.3" (fun () -> expect (toInt 5.3) |> toEqual (Some 5)) ;
            test "0." (fun () -> expect (toInt 0.) |> toEqual (Some 0)) ;
            test "-7." (fun () -> expect (toInt (-7.)) |> toEqual (Some (-7))) ;
            test "nan" (fun () -> expect (toInt nan) |> toEqual None) ;
            test "infinity" (fun () -> expect (toInt infinity) |> toEqual None) ;
            test "negativeInfinity" (fun () ->
                expect (toInt negativeInfinity) |> toEqual None)))) ;

  describe "Int" (fun () ->
      Int.(
        test "zero" (fun () -> expect zero |> toEqual 0) ;

        test "one" (fun () -> expect one |> toEqual 1) ;

        test "minimumValue" (fun () ->
            expect (minimumValue - 1) |> toEqual maximumValue) ;

        test "maximumValue" (fun () ->
            expect (maximumValue + 1) |> toEqual minimumValue) ;

        describe "add" (fun () ->
            test "add" (fun () -> expect (add 3002 4004) |> toEqual 7006) ;
            test "+" (fun () -> expect (3002 + 4004) |> toEqual 7006)) ;

        describe "subtract" (fun () ->
            test "subtract" (fun () -> expect (subtract 4 3) |> toEqual 1) ;
            test "-" (fun () -> expect (4 - 3) |> toEqual 1)) ;

        describe "multiply" (fun () ->
            test "multiply" (fun () -> expect (multiply 2 7) |> toEqual 14) ;
            test "*" (fun () -> expect (2 * 7) |> toEqual 14)) ;

        describe "divide" (fun () ->
            test "divide" (fun () -> expect (divide 3 ~by:2) |> toEqual 1) ;
            test "division by zero" (fun () ->
                expect (fun () -> divide 3 ~by:0) |> toThrow) ;

            test "/" (fun () -> expect (27 / 5) |> toEqual 5) ;

            test "//" (fun () -> expect (3 // 2) |> toEqual 1.5) ;
            test "//" (fun () -> expect (27 // 5) |> toEqual 5.4) ;
            test "//" (fun () -> expect (8 // 4) |> toEqual 2.0) ;

            test "x // 0" (fun () -> expect (8 // 0) |> toEqual Float.infinity) ;
            test "-x // 0" (fun () ->
                expect (-8 // 0) |> toEqual Float.negativeInfinity)) ;

        describe "power" (fun () ->
            test "power" (fun () ->
                expect (power ~base:7 ~exponent:3) |> toEqual 343) ;
            test "0 base" (fun () ->
                expect (power ~base:0 ~exponent:3) |> toEqual 0) ;
            test "0 exponent" (fun () ->
                expect (power ~base:7 ~exponent:0) |> toEqual 1) ;
            test "**" (fun () -> expect (7 ** 3) |> toEqual 343)) ;

        describe "negate" (fun () ->
            test "positive number" (fun () ->
                expect (negate 8) |> toEqual (-8)) ;
            test "negative number" (fun () ->
                expect (negate (-7)) |> toEqual 7) ;
            test "zero" (fun () -> expect (negate 0) |> toEqual (-0)) ;
            test "~-" (fun () -> expect ~-7 |> toEqual (-7))) ;

        describe "absolute" (fun () ->
            test "positive number" (fun () -> expect (absolute 8) |> toEqual 8) ;
            test "negative number" (fun () ->
                expect (absolute (-7)) |> toEqual 7) ;
            test "zero" (fun () -> expect (absolute 0) |> toEqual 0)) ;

        describe "clamp" (fun () ->
            test "in range" (fun () ->
                expect (clamp ~lower:0 ~upper:8 5) |> toEqual 5) ;
            test "above range" (fun () ->
                expect (clamp ~lower:0 ~upper:8 9) |> toEqual 8) ;
            test "below range" (fun () ->
                expect (clamp ~lower:2 ~upper:8 1) |> toEqual 2) ;
            test "above negative range" (fun () ->
                expect (clamp ~lower:(-10) ~upper:(-5) 5) |> toEqual (-5)) ;
            test "below negative range" (fun () ->
                expect (clamp ~lower:(-10) ~upper:(-5) (-15)) |> toEqual (-10)) ;
            test "invalid arguments" (fun () ->
                expect (fun () -> clamp ~lower:7 ~upper:1 3) |> toThrow)) ;

        describe "inRange" (fun () ->
            test "in range" (fun () ->
                expect (inRange ~lower:2 ~upper:4 3) |> toEqual true) ;
            test "above range" (fun () ->
                expect (inRange ~lower:2 ~upper:4 8) |> toEqual false) ;
            test "below range" (fun () ->
                expect (inRange ~lower:2 ~upper:4 1) |> toEqual false) ;
            test "equal to ~upper" (fun () ->
                expect (inRange ~lower:1 ~upper:2 2) |> toEqual false) ;
            test "negative range" (fun () ->
                expect (inRange ~lower:(-7) ~upper:(-5) (-6)) |> toEqual true) ;
            test "invalid arguments" (fun () ->
                expect (fun () -> inRange ~lower:7 ~upper:1 3) |> toThrow)) ;

        describe "toFloat" (fun () ->
            test "5" (fun () -> expect (toFloat 5) |> toEqual 5.) ;
            test "0" (fun () -> expect (toFloat 0) |> toEqual 0.) ;
            test "-7" (fun () -> expect (toFloat (-7)) |> toEqual (-7.))) ;

        describe "fromString" (fun () ->
            test "0" (fun () -> expect (fromString "0") |> toEqual (Some 0)) ;
            test "-0" (fun () ->
                expect (fromString "-0") |> toEqual (Some (-0))) ;
            test "42" (fun () -> expect (fromString "42") |> toEqual (Some 42)) ;
            test "123_456" (fun () ->
                expect (fromString "123_456") |> toEqual (Some 123_456)) ;
            test "-42" (fun () ->
                expect (fromString "-42") |> toEqual (Some (-42))) ;
            test "0XFF" (fun () ->
                expect (fromString "0XFF") |> toEqual (Some 255)) ;
            test "0X000A" (fun () ->
                expect (fromString "0X000A") |> toEqual (Some 10)) ;
            test "Infinity" (fun () ->
                expect (fromString "Infinity") |> toEqual None) ;
            test "-Infinity" (fun () ->
                expect (fromString "-Infinity") |> toEqual None) ;
            test "NaN" (fun () -> expect (fromString "NaN") |> toEqual None) ;
            test "abc" (fun () -> expect (fromString "abc") |> toEqual None) ;
            test "--4" (fun () -> expect (fromString "--4") |> toEqual None) ;
            test "empty string" (fun () ->
                expect (fromString " ") |> toEqual None)) ;

        describe "toString" (fun () ->
            test "positive number" (fun () ->
                expect (toString 1) |> toEqual "1") ;
            test "negative number" (fun () ->
                expect (toString (-1)) |> toEqual "-1")))) ;

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
              expect
                (List.intersperse "on" [ "turtles"; "turtles"; "turtles" ])
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
              expect (List.span ~f:(fun x -> x mod 2 = 0) [])
              |> toEqual ([], [])) ;
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
          expect (List.repeat ~count:3 5) |> toEqual [ 5; 5; 5 ])) ;

  describe "String" (fun () ->
      test "length empty string" (fun () ->
          expect (String.length "") |> toEqual 0) ;
      test "length" (fun () -> expect (String.length "123") |> toEqual 3) ;
      test "reverse empty string" (fun () ->
          expect (String.reverse "") |> toEqual "") ;
      test "reverse" (fun () ->
          expect (String.reverse "stressed") |> toEqual "desserts")) ;

  describe "Tuple2" (fun () ->
      test "create" (fun () -> expect (Tuple2.create 3 4) |> toEqual (3, 4)) ;

      test "first" (fun () -> expect (Tuple2.first (3, 4)) |> toEqual 3) ;

      test "second" (fun () -> expect (Tuple2.second (3, 4)) |> toEqual 4) ;

      test "mapFirst" (fun () ->
          expect (Tuple2.mapFirst ~f:String.reverse ("stressed", 16))
          |> toEqual ("desserts", 16)) ;

      test "mapSecond" (fun () ->
          expect (Tuple2.mapSecond ~f:sqrt ("stressed", 16.))
          |> toEqual ("stressed", 4.)) ;

      test "mapEach" (fun () ->
          expect (Tuple2.mapEach ~f:String.reverse ~g:sqrt ("stressed", 16.))
          |> toEqual ("desserts", 4.)) ;

      test "mapAll" (fun () ->
          expect (Tuple2.mapAll ~f:String.reverse ("was", "stressed"))
          |> toEqual ("saw", "desserts")) ;

      test "swap" (fun () -> expect (Tuple2.swap (3, 4)) |> toEqual (4, 3)) ;

      test "curry" (fun () ->
          let tupleAdder (a, b) = a + b in
          expect (Tuple2.curry tupleAdder 3 4) |> toEqual 7) ;

      test "uncurry" (fun () ->
          let curriedAdder a b = a + b in
          expect (Tuple2.uncurry curriedAdder (3, 4)) |> toEqual 7) ;

      test "toList" (fun () ->
          expect (Tuple2.toList (3, 4)) |> toEqual [ 3; 4 ])) ;

  describe "Tuple3" (fun () ->
      test "create" (fun () ->
          expect (Tuple3.create 3 4 5) |> toEqual (3, 4, 5)) ;

      test "first" (fun () -> expect (Tuple3.first (3, 4, 5)) |> toEqual 3) ;

      test "second" (fun () -> expect (Tuple3.second (3, 4, 5)) |> toEqual 4) ;

      test "third" (fun () -> expect (Tuple3.third (3, 4, 5)) |> toEqual 5) ;

      test "init" (fun () -> expect (Tuple3.init (3, 4, 5)) |> toEqual (3, 4)) ;

      test "tail" (fun () -> expect (Tuple3.tail (3, 4, 5)) |> toEqual (4, 5)) ;

      test "mapFirst" (fun () ->
          expect (Tuple3.mapFirst ~f:String.reverse ("stressed", 16, false))
          |> toEqual ("desserts", 16, false)) ;

      test "mapSecond" (fun () ->
          expect (Tuple3.mapSecond ~f:sqrt ("stressed", 16., false))
          |> toEqual ("stressed", 4., false)) ;

      test "mapThird" (fun () ->
          expect (Tuple3.mapThird ~f:not ("stressed", 16, false))
          |> toEqual ("stressed", 16, true)) ;

      test "mapEach" (fun () ->
          expect
            (Tuple3.mapEach
               ~f:String.reverse
               ~g:sqrt
               ~h:not
               ("stressed", 16., false))
          |> toEqual ("desserts", 4., true)) ;

      test "mapAll" (fun () ->
          expect (Tuple3.mapAll ~f:String.reverse ("was", "stressed", "now"))
          |> toEqual ("saw", "desserts", "won")) ;

      test "rotateLeft" (fun () ->
          expect (Tuple3.rotateLeft (3, 4, 5)) |> toEqual (4, 5, 3)) ;

      test "rotateRight" (fun () ->
          expect (Tuple3.rotateRight (3, 4, 5)) |> toEqual (5, 3, 4)) ;

      test "curry" (fun () ->
          let tupleAdder (a, b, c) = a + b + c in
          expect (Tuple3.curry tupleAdder 3 4 5) |> toEqual 12) ;

      test "uncurry" (fun () ->
          let curriedAdder a b c = a + b + c in
          expect (Tuple3.uncurry curriedAdder (3, 4, 5)) |> toEqual 12) ;

      test "toList" (fun () ->
          expect (Tuple3.toList (3, 4, 5)) |> toEqual [ 3; 4; 5 ])) ;

  describe "Option" (fun () ->
      test "getExn Some(1)" (fun () ->
          expect (Option.getExn (Some 1)) |> toEqual 1) ;

      test "getExn None" (fun () ->
          expect (fun () -> Option.getExn None)
          |> toThrowException (Invalid_argument "option is None")))
