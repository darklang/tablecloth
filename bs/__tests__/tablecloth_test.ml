open Tablecloth
open Jest
open Expect

let () =
  describe "Array" (fun () ->
    describe "empty" (fun () -> 
      test "has length zero" (fun () -> expect Array.(empty |> length) |> toEqual 0);
      test "equals the empty array literal" (fun () -> expect (Array.empty) |> toEqual [||]);
    );

    describe "singleton" (fun () -> 
      test "equals an array literal of the same value" (fun () -> expect (Array.singleton 1234) |> toEqual [|1234|]);
      test "has length one" (fun () -> expect Array.(singleton 1 |> length) |> toEqual 1);
    );

    describe "length" (fun () -> 
      test "equals an array literal of the same value" (fun () -> expect (Array.length [||]) |> toEqual 0);
      test "has length one" (fun () -> expect (Array.length [|'a'|]) |> toEqual 1);
      test "has length two" (fun () -> expect (Array.length [|"a"; "b"|]) |> toEqual 2);
    );

    describe "isEmpty" (fun () -> 
      test "returns true for empty array literals" (fun () -> 
        expect (Array.isEmpty [||]) |> toEqual true);

      test "returns false for literals with a non-zero number of elements" (fun () -> 
        expect (Array.isEmpty [|1234|]) |> toEqual false);
    );

    describe "initialize" (fun () -> 
      test "create empty array" (fun () -> 
        expect (Array.initialize ~length:0 ~f:identity) |> toEqual [||]);

      test "negative length gives an empty array" (fun () -> 
        expect (Array.initialize ~length:(-1) ~f:identity) |> toEqual [||]);

      test "create array with initialize" (fun () -> 
        expect (Array.initialize ~length:3 ~f:identity) |> toEqual [|0;1;2|]);
    );

    describe "repeat" (fun () -> 
      test "length zero creates an empty array" (fun () -> 
        expect (Array.repeat 0 ~length:0) |> toEqual [||]);

      test "negative length gives an empty array" (fun () -> 
        expect (Array.repeat ~length:(-1) 0) |> toEqual [||]);

      test "create array of ints" (fun () -> 
        expect (Array.repeat 0 ~length:3) |> toEqual [|0;0;0|]);

      test "create array strings" (fun () -> 
        expect (Array.repeat "cat" ~length:3) |> toEqual [|"cat";"cat";"cat"|]);
    );

    describe "range" (fun () -> 
      test "returns an array of the integers from zero and upto but not including [to]" (fun () -> 
        expect (Array.range 5) |> toEqual [|0; 1; 2; 3; 4|]);

      test "returns an empty array when [to] is zero" (fun () -> 
        expect (Array.range 0) |> toEqual [||]);

      test "takes an optional [from] argument to start create empty array" (fun () -> 
        expect (Array.range ~from:2 5) |> toEqual [|2; 3; 4|]);

      test "can start from negative values" (fun () -> 
        expect (Array.range ~from:(-2) 3) |> toEqual [|-2; -1; 0; 1; 2|]);

      test "returns an empty array when [from] > [to_]" (fun () -> 
        expect (Array.range ~from:5 0) |> toEqual [||]);
    );

    describe "fromList" (fun () -> 
      test "transforms a list into an array of the same elements" (fun () -> 
        expect Array.(fromList [1;2;3]) |> toEqual [|1;2;3|]);
    );

    describe "toList" (fun () -> 
      test "transform an array into a list of the same elements" (fun () -> 
        expect (Array.toList [|1;2;3|]) |> toEqual [1;2;3]);
    );

    describe "toIndexedList" (fun () -> 
      test "returns an empty list for an empty array" (fun () -> 
        expect (Array.toIndexedList [||]) |> toEqual []);

      test "transforms an array into a list of tuples" (fun () -> 
        expect (Array.toIndexedList [|"cat"; "dog"|]) |> toEqual [(0, "cat"); (1, "dog")]);
    );

    describe "get" (fun () -> 
      test "returns Some for an in-bounds indexe" (fun () -> 
        expect (Array.get ~index:2 [|"cat"; "dog"; "eel"|]) |> toEqual (Some "eel"));

      test "returns None for an out of bounds index" (fun () -> 
        expect (Array.get ~index:5 [|0; 1; 2|]) |> toEqual None);

      test "returns None for an empty array" (fun () -> 
        expect (Array.get ~index:0 [||]) |> toEqual None);
    );

    describe "set" (fun () -> 
      test "can be partially applied to set an element" (fun () -> 
        let setZero = Array.set ~value:0 in
        let numbers = [|1;2;3|] in
        setZero numbers ~index:2;
        setZero numbers ~index:1;
        expect numbers |> toEqual [|1;0;0|]
      );

      test "can be partially applied to set an index" (fun () -> 
        let setZerothElement = Array.set ~index:0 in
        let animals = [|"ant"; "bat"; "cat"|] in    
        setZerothElement animals ~value:"antelope";    
        expect animals |> toEqual [|"antelope"; "bat"; "cat"|]);
    );

    describe "sum" (fun () -> 
      test "equals zero for an empty array" (fun () -> 
        expect (Array.sum [||]) |> toEqual 0);

      test "adds up the elements on an integer array" (fun () -> 
        expect (Array.sum [|1;2;3|]) |> toEqual 6);
    );

    describe "floatSum" (fun () -> 
      test "equals zero for an empty array" (fun () -> 
        expect (Array.floatSum [||]) |> toEqual 0.0);

      test "adds up the elements of a float array" (fun () -> 
        expect (Array.floatSum [|1.2;2.3;3.4|]) |> toEqual 6.9);
    );

    describe "filter" (fun () -> 
      test "keep elements that [f] returns [true] for" (fun () -> 
        expect (Array.filter ~f:Int.isEven [|1; 2; 3; 4; 5; 6|]) |> toEqual [|2; 4; 6|]);
    );

    describe "map" (fun () -> 
      test "Apply a function [f] to every element in an array" (fun () -> 
        expect (Array.map ~f:sqrt [|1.0; 4.0; 9.0|]) |> toEqual [|1.0; 2.0; 3.0|]);
    );

    describe "mapWithIndex" (fun () -> 
      test "equals an array literal of the same value" (fun () -> 
        expect (Array.mapWithIndex ~f:( * ) [|5; 5; 5|]) |> toEqual [|0; 5; 10|]);
    );

    describe "map2" (fun () -> 
      test "works when the order of arguments to `f` is not important" (fun () -> 
        expect (Array.map2 ~f:(+) [|1;2;3|] [|4;5;6|]) |> toEqual [|5;7;9|]);

      test "works when the order of `f` is important" (fun () -> 
        expect (Array.map2 ~f:Tuple2.create [|"alice"; "bob"; "chuck"|] [|2; 5; 7; 8|]) 
        |> toEqual [|("alice",2);("bob",5);("chuck",7)|]);
    );

    test "map3" (fun () -> 
      expect (
        Array.map3 
          ~f:Tuple3.create 
          [|"alice"; "bob"; "chuck"|] 
          [|2; 5; 7; 8;|] 
          [|true; false; true; false|] 
        ) 
      |> toEqual [|("alice", 2, true); ("bob", 5, false); ("chuck", 7, true)|]);

    test "flatMap" (fun () -> 
      let duplicate n = [|n; n|] in
      expect (Array.flatMap ~f:duplicate [|1; 2; 3|]) |> toEqual [|1; 1; 2; 2; 3; 3|]
    );

    describe "find" (fun () -> 
      test "returns the first element which `f` returns true for" (fun () -> 
        expect (Array.find ~f:Int.isEven [|1; 3; 4; 8;|]) |> toEqual (Some 4));

      test "returns `None` if `f` returns false for all elements " (fun () -> 
        expect (Array.find ~f:Int.isOdd [|0; 2; 4; 8;|]) |> toEqual None);

      test "returns `None` for an empty array" (fun () -> 
        expect (Array.find ~f:Int.isEven [||]) |> toEqual None);
    );

    describe "any" (fun () -> 
      test "returns false for empty arrays" (fun () -> 
        expect (Array.any [||] ~f:Int.isEven) |> toEqual false
      );

      test "returns true if at least one of the elements of an array return true for [f]" (fun () -> 
        expect (Array.any [|1;3;4;5;7|] ~f:Int.isEven) |> toEqual true
      );

      test "returns false if all of the elements of an array return false for [f]" (fun () -> 
        expect (Array.any [|1;3;5;7|] ~f:Int.isEven) |> toEqual false
      );
    );

    describe "all" (fun () -> 
      test "returns true for empty arrays" (fun () -> 
        expect (Array.all ~f:Int.isEven [||]) |> toEqual true);

      test "returns true if [f] returns true for all elements" (fun () -> 
        expect (Array.all ~f:Int.isEven [|2;4|]) |> toEqual true);

      test "returns false if a single element fails returns false for [f]" (fun () ->
        expect (Array.all ~f:Int.isEven [|2;3|]) |> toEqual false);
    );

    test "append" (fun () -> 
      expect (Array.append (Array.repeat ~length:2 42) (Array.repeat ~length:3 81)) |> toEqual  [|42; 42; 81; 81; 81|]
    );

    test "concatenate" (fun () -> 
      expect (Array.concatenate [|[|1; 2|]; [|3|]; [|4; 5|]|]) |> toEqual [|1; 2; 3; 4; 5|]);

    describe "intersperse" (fun () -> 
      test "equals an array literal of the same value" (fun () -> 
        expect (Array.intersperse ~sep:"on" [|"turtles"; "turtles"; "turtles"|]) 
        |> toEqual [|"turtles"; "on"; "turtles"; "on"; "turtles"|]
      );

      test "equals an array literal of the same value" (fun () -> 
        expect (Array.intersperse ~sep:0 [||]) |> toEqual [||]);
    );

    describe "slice" (fun () -> 
      let array = [|0; 1; 2; 3; 4|] in
      let positiveArrayLengths = [Array.length array; Array.length array + 1; 1000] in
      let negativeArrayLengths = List.map ~f:Int.negate positiveArrayLengths in

      test "should work with a positive `from`" (fun () -> 
        expect (Array.slice ~from:1 array) |> toEqual [|1; 2; 3; 4|]);

      test "should work with a negative `from`" (fun () -> 
        expect (Array.slice ~from:(-1) array) |> toEqual [|4|]);

      testAll "should work when `from` >= `length`" positiveArrayLengths (fun from -> 
        expect (Array.slice ~from array) |> toEqual [||]);

      testAll "should work when `from` <= negative `length`" negativeArrayLengths (fun from -> 
        expect (Array.slice ~from array) |> toEqual array);

      test "should work with a positive `to_`" (fun () -> 
        expect (Array.slice ~from:0  ~to_:3 array) |> toEqual [|0; 1; 2|]);

      test "should work with a negative `to_`" (fun () -> 
        expect (Array.slice  ~from:1 ~to_:(-1) array) |> toEqual [|1; 2; 3|]);

      testAll "should work when `to_` >= length" positiveArrayLengths (fun to_ -> 
        expect (Array.slice ~from:0  ~to_ array) |> toEqual array);

      testAll "should work when `to_` <= negative `length`" negativeArrayLengths (fun to_ -> 
        expect (Array.slice ~from:0  ~to_ array) |> toEqual [||]);
      
      test "should work when both `from` and `to_` are negative and `from` < `to_`" (fun () -> 
        expect (Array.slice ~from:(-2)  ~to_:(-1) array) |> toEqual [|3|]);

      test "works when `from` >= `to_`" (fun () -> 
        expect (Array.slice ~from:(4)  ~to_:(3) array) |> toEqual [||]);
    );
     
    describe "foldLeft" (fun () -> 
      test "works for an empty array" (fun () -> 
        expect (Array.foldLeft [||] ~f:(^) ~initial:"") |> toEqual "");

      test "works for an ascociative operator" (fun () -> 
        expect (Array.foldLeft ~f:( * ) ~initial:1 (Array.repeat ~length:4 7)) |> toEqual 2401);

      test "works when the order of arguments to `f` is important" (fun () -> 
        expect (Array.foldLeft [|"a";"b";"c"|] ~f:(^) ~initial:"") |> toEqual "cba");

      test "works when the order of arguments to `f` is important" (fun () -> 
        expect (Array.foldLeft ~f:(fun element list -> element :: list) ~initial:[] [|1; 2; 3|]) |> toEqual [3; 2; 1]);
    );

    describe "foldRight" (fun () -> 
      test "works for empty arrays" (fun () -> 
        expect (Array.foldRight [||] ~f:(^) ~initial:"") |> toEqual "");

      test "fold right" (fun () -> 
        expect (Array.foldRight ~f:(+) ~initial:0 (Array.repeat ~length:3 5)) |> toEqual 15);

      test "works when the order of arguments to `f` is important" (fun () -> 
        expect (Array.foldRight [|"a";"b";"c"|] ~f:(^) ~initial:"") |> toEqual "abc");
        
      test "works when the order of arguments to `f` is important" (fun () -> 
        expect (Array.foldRight ~f:(fun element list -> element :: list) ~initial:[] [|1; 2; 3|]) |> toEqual [1; 2; 3]);
    );

    describe "reverse" (fun () -> 
      test "reverse empty array" (fun () -> expect (Array.reverse [||]) |> toEqual [||]);
      test "reverse two elements" (fun () -> expect (Array.reverse [|0;1|]) |> toEqual [|1;0|]);
      test "leaves the original array untouched" (fun () -> 
        let array = [|0; 1; 2; 3;|] in
        let _reversedArray = Array.reverse array in
        expect array |> toEqual [|0; 1; 2; 3;|]
      );
    );

    describe "reverseInPlace" (fun () -> 
      test "alters an array in-place" (fun () -> 
        let array = [|1;2;3|] in
        Array.reverseInPlace array;
        expect array |> toEqual [|3;2;1|]
      );
    );

    test "forEach" (fun () -> 
      let index = ref 0 in
      let calledValues = [|0;0;0|] in
      
      Array.forEach [|1;2;3|] ~f:(fun value -> 
        Array.set calledValues ~index:!index ~value;
        index := !index + 1;
      );
      
      expect calledValues |> toEqual [|1;2;3|]
    );
  );

  describe "Char" (fun () -> 
    test "toCode" (fun () -> expect (Char.toCode 'a') |> toEqual 97);

    describe "fromCode" (fun () -> 
      test "valid ASCII codes return the corresponding character" (fun () -> expect (Char.fromCode 97) |> toEqual (Some 'a'));
      test "negative integers return none" (fun () -> expect (Char.fromCode (-1)) |> toEqual None);
      test "integers greater than 255 return none" (fun () -> expect (Char.fromCode 256) |> toEqual None);
    );

    test "toString" (fun () -> expect (Char.toString 'a') |> toEqual "a");

    describe "fromString" (fun () -> 
      test "one-length string return Some" (fun () -> expect (Char.fromString "a") |> toEqual (Some 'a'));
      test "multi character strings return none" (fun () -> expect (Char.fromString "abc") |> toEqual None);
      test "zero length strings return none" (fun () -> expect (Char.fromString "") |> toEqual None);
    );

    describe "toLowercase" (fun () -> 
      test "converts uppercase ASCII characters to lowercase" (fun () -> expect (Char.toLowercase 'A') |> toEqual 'a');
      test "perserves lowercase characters" (fun () -> expect (Char.toLowercase 'a') |> toEqual 'a');
      test "perserves non-alphabet characters" (fun () -> expect (Char.toLowercase '7') |> toEqual '7');
      test "perserves non-ASCII characters" (fun () -> expect (Char.toUppercase '\233') |> toEqual '\233');
    );

    describe "toUppercase" (fun () -> 
      test "converts lowercase ASCII characters to uppercase" (fun () -> expect (Char.toUppercase 'a') |> toEqual 'A');
      test "perserves uppercase characters" (fun () -> expect (Char.toUppercase 'A') |> toEqual 'A');
      test "perserves non-alphabet characters" (fun () -> expect (Char.toUppercase '7') |> toEqual '7');
      test "perserves non-ASCII characters" (fun () -> expect (Char.toUppercase '\233') |> toEqual '\233');
    );

    describe "toDigit" (fun () -> 
      test "toDigit - converts ASCII characters representing digits into integers" (fun () -> expect (Char.toDigit '0') |> toEqual (Some 0));
      test "toDigit - converts ASCII characters representing digits into integers" (fun () -> expect (Char.toDigit '8') |> toEqual (Some 8));
      test "toDigit - converts ASCII characters representing digits into integers" (fun () -> expect (Char.toDigit 'a') |> toEqual None);
    );


    describe "isLowercase" (fun () -> 
      test "returns true for any lowercase character" (fun () -> expect (Char.isLowercase 'a') |> toEqual true);
      test "returns false for all other characters" (fun () -> expect (Char.isLowercase '7') |> toEqual false);      
      test "returns false for non-ASCII characters" (fun () -> expect (Char.isLowercase '\236') |> toEqual false);      
    );

    describe "isUppercase" (fun () -> 
      test "returns true for any uppercase character" (fun () -> expect (Char.isUppercase 'A') |> toEqual true);
      test "returns false for all other characters" (fun () -> expect (Char.isUppercase '7') |> toEqual false);      
      test "returns false for non-ASCII characters" (fun () -> expect (Char.isLowercase '\237') |> toEqual false);      
    );

    describe "isLetter" (fun () -> 
      test "returns true for any ASCII alphabet character" (fun () -> expect (Char.isLetter 'A') |> toEqual true);
      testAll "returns false for all other characters" ['7'; ' '; '\n'; '\011'; '\236'] (fun char -> expect (Char.isLetter char) |> toEqual false);      
    );

    describe "isDigit" (fun () -> 
      testAll "returns true for digits 0-9" ['0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9';] (fun digit -> expect (Char.isDigit digit) |> toEqual true);
      test "returns false for all other characters" (fun () -> expect (Char.isDigit 'a') |> toEqual false);
    );

    describe "isAlphanumeric" (fun () -> 
      test "returns true for any alphabet or digit character" (fun () -> expect (Char.isAlphanumeric 'A') |> toEqual true);
      test "returns false for all other characters" (fun () -> expect (Char.isAlphanumeric '?') |> toEqual false);      
    );
 
    describe "isPrintable" (fun () -> 
      test "returns true for a printable character" (fun () -> expect (Char.isPrintable '~') |> toEqual true);

      test "returns false for non-printable character" (fun () -> expect (Char.fromCode 31 |> Option.map ~f:Char.isPrintable ) |> toEqual (Some false));      
    );   

    describe "isWhitespace" (fun () -> 
      test "returns true for any whitespace character" (fun () -> expect (Char.isWhitespace ' ') |> toEqual true);
      test "returns false for a non-whitespace character" (fun () -> expect (Char.isWhitespace 'a') |> toEqual false);      
    );
  );

  describe "List" (fun () ->
    describe "reverse" (fun () ->
      test "reverse empty list" (fun () -> expect (List.reverse []) |> toEqual []);
      test "reverse one element" (fun () -> expect (List.reverse [0]) |> toEqual [0]);
      test "reverse two elements" (fun () -> expect (List.reverse [0;1]) |> toEqual [1;0]);
    );

    describe "map2" (fun () ->
      test "map2 empty lists" (fun () -> expect (List.map2 ~f:(+) [] []) |> toEqual []);
      test "map2 one element" (fun () -> expect (List.map2 ~f:(+) [1] [1]) |> toEqual [2]);
      test "map2 two elements" (fun () -> expect (List.map2 ~f:(+) [1;2] [1;2]) |> toEqual [2;4]);
    );

    describe "indexedMap" (fun () ->
      test "indexedMap empty list" (fun () -> expect (List.indexedMap ~f:(fun i _ -> i) []) |> toEqual []);
      test "indexedMap one element" (fun () -> expect (List.indexedMap ~f:(fun i _ -> i) ['a']) |> toEqual [0]);
      test "indexedMap two elements" (fun () -> expect (List.indexedMap ~f:(fun i _ -> i) ['a';'b']) |> toEqual [0;1]);
    );

    describe "partition" (fun () ->
      test "empty list" (fun () -> expect (List.partition ~f:(fun x -> x mod 2 = 0) []) |> toEqual ([], []));
      test "one element" (fun () -> expect (List.partition ~f:(fun x -> x mod 2 = 0) [1]) |> toEqual ([], [1]));
      test "four elements" (fun () -> expect (List.partition ~f:(fun x -> x mod 2 = 0) [1;2;3;4]) |> toEqual ([2;4], [1;3]));
    );
 
    describe "minimumBy" (fun () ->
      test "minimumBy non-empty list" (fun () -> expect (List.minimumBy ~f:(fun x -> x mod 12) [7;9;15;10;3;22]) |> toEqual (Some 15));
      test "minimumBy empty list" (fun () -> expect (List.minimumBy ~f:(fun x -> x mod 12) []) |> toEqual None);
    );
    
    describe "maximumBy" (fun () ->
      test "maximumBy non-empty list" (fun () -> expect (List.maximumBy ~f:(fun x -> x mod 12) [7;9;15;10;3;22]) |> toEqual (Some 10));
      test "maximumBy empty list" (fun () -> expect (List.maximumBy ~f:(fun x -> x mod 12) []) |> toEqual None);
    );
    
    describe "minimum" (fun () ->
      test "minimum non-empty list" (fun () -> expect (List.minimum [7; 9; 15; 10; 3]) |> toEqual (Some 3));
      test "minimum empty list" (fun () -> expect (List.minimum []) |> toEqual None);
    );
    
    describe "maximum" (fun () ->
      test "maximum non-empty list" (fun () -> expect (List.maximum [7; 9; 15; 10; 3]) |> toEqual (Some 15));
      test "maximum empty list" (fun () -> expect (List.maximum []) |> toEqual None);
    );
   
    describe "split_when" (fun () ->
      test "empty list" (fun () -> expect (List.split_when ~f:(fun x -> x mod 2 = 0) []) |> toEqual ([], []));
      test "at zero" (fun () -> expect (List.split_when ~f:(fun x -> x mod 2 = 0) [2;4;6]) |> toEqual ([], [2;4;6]));
      test "four elements" (fun () -> expect (List.split_when ~f:(fun x -> x mod 2 = 0) [1;3;2;4]) |> toEqual ([1;3], [2;4]));
      test "at end" (fun () -> expect (List.split_when ~f:(fun x -> x mod 2 = 0) [1;3;5]) |> toEqual ([1;3;5], []));
    );
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
