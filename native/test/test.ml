open Tablecloth
module AT = Alcotest

let trio a b c = 
  let eq (a1, b1, c1) (a2, b2, c2) = AT.equal a a1 a2 && AT.equal b b1 b2 && AT.equal c c1 c2 in
  let pp ppf (x, y, z) = Fmt.pf ppf "@[<1>(@[%a@],@ @[%a@],@ @[%a@])@]" (AT.pp a) x (AT.pp b) y (AT.pp c) z in
  AT.testable pp eq

let t_Array () =
  AT.check AT.int "empty - has length zero" Array.(empty |> length) 0;
  AT.check (AT.array AT.int) "empty - equals the empty array literal" (Array.empty) [||];

  AT.check (AT.array AT.int) "singleton - equals an array literal of the same value" (Array.singleton 1234) [|1234|];
  AT.check (AT.int) "singleton - has length one" Array.(singleton 1 |> length) 1;

  AT.check (AT.int) "length - equals an array literal of the same value" (Array.length [||]) 0;
  AT.check (AT.int) "length - has length one" (Array.length [|'a'|]) 1;
  AT.check (AT.int) "length - has length two" (Array.length [|"a"; "b"|]) 2;

  AT.check AT.bool "isEmpty - returns true for empty array literals" (Array.isEmpty [||]) true;
  AT.check AT.bool "isEmpty - returns false for literals with a non-zero number of elements" (Array.isEmpty [|1234|]) false;

  AT.check (AT.list AT.int) "map2 empty lists" (List.map2 ~f:(+) [] []) [];
  AT.check (AT.list AT.int) "map2 one element" (List.map2 ~f:(+) [1] [1]) [2];
  AT.check (AT.list AT.int) "map2 two elements" (List.map2 ~f:(+) [1;2] [1;2]) [2;4];
  AT.check (AT.array AT.int) "initialize - create empty array" (Array.initialize ~length:0 ~f:identity) [||];
  AT.check (AT.array AT.int) "initialize - negative length gives an empty array" (Array.initialize ~length:(-1) ~f:identity) [||];
  AT.check (AT.array AT.int) "initialize - create array with initialize" (Array.initialize ~length:3 ~f:identity) [|0;1;2|];

  AT.check (AT.list AT.int) "indexedMap empty list" (List.indexedMap ~f:(fun i _ -> i) []) [];
  AT.check (AT.list AT.int) "indexedMap one element" (List.indexedMap ~f:(fun i _ -> i) ['a']) [0];
  AT.check (AT.list AT.int) "indexedMap two elements" (List.indexedMap ~f:(fun i _ -> i) ['a';'b']) [0;1];
  AT.check (AT.array AT.int) "repeat - length zero creates an empty array" (Array.repeat 0 ~length:0) [||];
  AT.check (AT.array AT.int) "repeat - negative length gives an empty array" (Array.repeat ~length:(-1) 0) [||];
  AT.check (AT.array AT.int) "repeat - create array of ints" (Array.repeat 0 ~length:3) [|0;0;0|];
  AT.check (AT.array AT.string) "repeat - create array strings" (Array.repeat "cat" ~length:3) [|"cat";"cat";"cat"|];

  AT.check (AT.array AT.int) "range - returns an array of the integers from zero and upto but not including [to]" (Array.range 5) [|0; 1; 2; 3; 4|];
  AT.check (AT.array AT.int) "range - returns an empty array when [to] is zero" (Array.range 0) [||];
  AT.check (AT.array AT.int) "range - takes an optional [from] argument to start create empty array" (Array.range ~from:2 5) [|2; 3; 4|];
  AT.check (AT.array AT.int) "range - returns an array of the integers from zero and upto but not including [to_]" (Array.range 5) [|0; 1; 2; 3; 4|];
  AT.check (AT.array AT.int) "range - returns an array of the integers from zero and upto but not including [to_]" (Array.range 0) [||];
  AT.check (AT.array AT.int) "range - takes an optional [from] argument to start create empty array" (Array.range ~from:2 5) [|2; 3; 4|];
  AT.check (AT.array AT.int) "range - can start from negative values" (Array.range ~from:(-2) 3) [|-2; -1; 0; 1; 2|];
  AT.check (AT.array AT.int) "range - returns an empty array when [from] > [to_]" (Array.range ~from:5 0) [||];
  AT.check (AT.array AT.int) "range - can start from negative values" (Array.range ~from:(-2) 3) [|-2; -1; 0; 1; 2|];
  AT.check (AT.array AT.int) "range - returns an empty array when [from] > [to_]" (Array.range ~from:5 0) [||];

  AT.check (AT.list AT.int) "indexedMap empty list" (List.indexedMap ~f:(fun _ n -> n + 1) []) [];
  AT.check (AT.list AT.int) "indexedMap one element" (List.indexedMap ~f:(fun _ n -> n + 1) [-1]) [0];
  AT.check (AT.list AT.int) "indexedMap two elements" (List.indexedMap ~f:(fun _ n -> n + 1) [-1; 0]) [0;1];
  AT.check (AT.array AT.int) "fromList - transforms a list into an array of the same elements" Array.(fromList [1;2;3]) [|1;2;3|];

  AT.check (AT.list AT.int) "toList - transform an array into a list of the same elements" (Array.toList [|1;2;3|]) [1;2;3];

  AT.check (AT.pair (AT.list AT.int) (AT.list AT.int)) "partition empty list" (List.partition ~f:(fun x -> x mod 2 = 0) []) ([], []);
  AT.check (AT.pair (AT.list AT.int) (AT.list AT.int)) "partition one element" (List.partition ~f:(fun x -> x mod 2 = 0) [1]) ([], [1]);
  AT.check (AT.pair (AT.list AT.int) (AT.list AT.int)) "partition four elements" (List.partition ~f:(fun x -> x mod 2 = 0) [1;2;3;4]) ([2;4], [1;3]);
  AT.check (AT.list (AT.pair AT.int AT.string)) "toIndexedList - returns an empty list for an empty array" (Array.toIndexedList [||]) [];
  AT.check (AT.list (AT.pair AT.int AT.string)) "toIndexedList - transforms an array into a list of tuples" (Array.toIndexedList [|"cat"; "dog"|]) [(0, "cat"); (1, "dog")];

  AT.check (AT.option AT.string) "get - returns Some for an in-bounds indexe" (Array.get ~index:2 [|"cat"; "dog"; "eel"|]) (Some "eel");
  AT.check (AT.option AT.int) "get - returns None for an out of bounds index" (Array.get ~index:5 [|0; 1; 2|]) None;
  AT.check (AT.option AT.int) "get - returns None for an empty array" (Array.get ~index:0 [||]) None;

  AT.check 
    (AT.array AT.int) 
    "set - can be partially applied to set an element" 
    (
      let setZero = Array.set ~value:0 in
      let numbers = [|1;2;3|] in
      setZero numbers ~index:2;
      setZero numbers ~index:1;
      numbers 
    )
    [|1;0;0|];

  AT.check 
    (AT.array AT.string) 
    "set - can be partially applied to set an index" 
    (
      let setZerothElement = Array.set ~index:0 in
      let animals = [|"ant"; "bat"; "cat"|] in    
      setZerothElement animals ~value:"antelope";    
      animals
    ) 
    [|"antelope"; "bat"; "cat"|];

  AT.check AT.int "sum - equals zero for an empty array" (Array.sum [||]) 0;
  AT.check (AT.int) "sum - adds up the elements on an integer array" (Array.sum [|1;2;3|]) 6;

  AT.check (AT.float 0.) "floatSum - equals zero for an empty array" (Array.floatSum [||]) 0.0;
  AT.check (AT.float 0.) "floatSum - adds up the elements of a float array" (Array.floatSum [|1.2;2.3;3.4|]) 6.9;

  AT.check (AT.array AT.int) "filter - keep elements that [f] returns [true] for" (Array.filter ~f:Int.isEven [|1; 2; 3; 4; 5; 6|]) [|2; 4; 6|];

  AT.check (AT.array (AT.float 0.)) "map - Apply a function [f] to every element in an array" (Array.map ~f:sqrt [|1.0; 4.0; 9.0|]) [|1.0; 2.0; 3.0|];

  AT.check (AT.array AT.int) "mapWithIndex - equals an array literal of the same value" (Array.mapWithIndex ~f:( * ) [|5; 5; 5|]) [|0; 5; 10|];

  AT.check (AT.array AT.int) "map2 - works when the order of arguments to `f` is not important" (Array.map2 ~f:(+) [|1;2;3|] [|4;5;6|]) [|5;7;9|];

  AT.check 
    (AT.array (AT.pair AT.string AT.int)) 
    "map2 - works when the order of `f` is important" 
    (Array.map2 ~f:Tuple2.create [|"alice"; "bob"; "chuck"|] [|2; 5; 7; 8|]) 
    [|("alice",2);("bob",5);("chuck",7)|];

  AT.check 
    (AT.array (trio AT.string AT.int AT.bool)) 
    "map3" 
    (Array.map3 ~f:Tuple3.create [|"alice"; "bob"; "chuck"|] [|2; 5; 7; 8;|] [|true; false; true; false|]) 
    [|("alice", 2, true); ("bob", 5, false); ("chuck", 7, true)|];

  AT.check (AT.array AT.int) "flatMap" (Array.flatMap ~f:(fun n -> [|n; n|]) [|1; 2; 3|]) [|1; 1; 2; 2; 3; 3|];

  AT.check (AT.option AT.int) "find - returns the first element which `f` returns true for" (Array.find ~f:Int.isEven [|1; 3; 4; 8;|]) (Some 4);
  AT.check (AT.option AT.int) "find - returns `None` if `f` returns false for all elements" (Array.find ~f:Int.isOdd [|0; 2; 4; 8;|]) None;
  AT.check (AT.option AT.int) "find - returns `None` for an empty array" (Array.find ~f:Int.isEven [||]) None;

  AT.check (AT.bool) "any - returns false for empty arrays" (Array.any [||] ~f:Int.isEven) false;
  AT.check (AT.bool) "any - returns true if at least one of the elements of an array return true for [f]" (Array.any [|1;3;4;5;7|] ~f:Int.isEven) true;
  AT.check (AT.bool) "any - returns false if all of the elements of an array return false for [f]" (Array.any [|1;3;5;7|] ~f:Int.isEven) false;

  AT.check (AT.bool) "all - returns true for empty arrays" (Array.all ~f:Int.isEven [||]) true;
  AT.check (AT.bool) "all - returns true if [f] returns true for all elements" (Array.all ~f:Int.isEven [|2;4|]) true;
  AT.check (AT.bool) "all - returns false if a single element fails returns false for [f]" (Array.all ~f:Int.isEven [|2;3|]) false;

  AT.check (AT.array AT.int) "append" (Array.append (Array.repeat ~length:2 42) (Array.repeat ~length:3 81)) [|42; 42; 81; 81; 81|];

  AT.check (AT.array AT.int) "concatenate" (Array.concatenate [|[|1; 2|]; [|3|]; [|4; 5|]|]) [|1; 2; 3; 4; 5|];

  AT.check 
    (AT.array AT.string) 
    "intersperse - equals an array literal of the same value" 
    [|"turtles"; "on"; "turtles"; "on"; "turtles"|]
    (Array.intersperse ~sep:"on" [|"turtles"; "turtles"; "turtles"|]);

  AT.check (AT.array AT.int) "intersperse - equals an array literal of the same value" (Array.intersperse ~sep:0 [||]) [||];

  (
    let array = [|0; 1; 2; 3; 4|] in
    let positiveArrayLengths = [Array.length array; Array.length array + 1; 1000] in
    let negativeArrayLengths = List.map ~f:Int.negate positiveArrayLengths in

    AT.check (AT.array AT.int) "slice - should work with a positive `from`" (Array.slice ~from:1 array) [|1; 2; 3; 4|];

    AT.check (AT.array AT.int) "slice - should work with a negative `from`" (Array.slice ~from:(-1) array) [|4|];

    Base.List.iter positiveArrayLengths ~f:(fun from -> 
      AT.check (AT.array AT.int) "slice - should work when `from` >= `length`" (Array.slice ~from array) [||]
    );

    Base.List.iter negativeArrayLengths ~f:(fun from -> 
      AT.check (AT.array AT.int) "slice - should work when `from` <= negative `length`"  (Array.slice ~from array) array
    );

    AT.check (AT.array AT.int) "slice - should work with a positive `to_`" (Array.slice ~from:0  ~to_:3 array) [|0; 1; 2|];

    AT.check (AT.array AT.int) "slice - should work with a negative `to_`" (Array.slice  ~from:1 ~to_:(-1) array) [|1; 2; 3|];

    Base.List.iter positiveArrayLengths ~f:(fun to_ ->
      AT.check (AT.array AT.int) "slice - should work when `to_` >= length" ( Array.slice ~from:0  ~to_ array) array
    );

    Base.List.iter negativeArrayLengths ~f:(fun to_ ->
      AT.check (AT.array AT.int) "slice - should work when `to_` <= negative `length`"  (Array.slice ~from:0  ~to_ array) [||]
    );
    
    AT.check (AT.array AT.int) "slice - should work when both `from` and `to_` are negative and `from` < `to_`" (Array.slice ~from:(-2)  ~to_:(-1) array) [|3|];

    AT.check (AT.array AT.int) "slice - works when `from` >= `to_`" (Array.slice ~from:(4)  ~to_:(3) array) [||];
  );

  AT.check (AT.string) "foldLeft - works for an empty array" (Array.foldLeft [||] ~f:(^) ~initial:"") "";
  AT.check (AT.int) "foldLeft - works for an ascociative operator" (Array.foldLeft ~f:( * ) ~initial:1 (Array.repeat ~length:4 7)) 2401;
  AT.check (AT.string) "foldLeft - works when the order of arguments to `f` is important" (Array.foldLeft [|"a";"b";"c"|] ~f:(^) ~initial:"") "cba";
  AT.check (AT.list AT.int) "foldLeft - works when the order of arguments to `f` is important" (Array.foldLeft ~f:(fun element list -> element :: list) ~initial:[] [|1; 2; 3|]) [3; 2; 1];

  AT.check (AT.string) "foldRight - works for empty arrays" (Array.foldRight [||] ~f:(^) ~initial:"") "";
  AT.check (AT.int) "foldRight - works for an ascociative operator" (Array.foldRight ~f:(+) ~initial:0 (Array.repeat ~length:3 5)) 15;
  AT.check (AT.string) "foldRight - works when the order of arguments to `f` is important" (Array.foldRight [|"a";"b";"c"|] ~f:(^) ~initial:"") "abc";
  AT.check (AT.list AT.int) "foldRight - works when the order of arguments to `f` is important" (Array.foldRight ~f:(fun element list -> element :: list) ~initial:[] [|1; 2; 3|]) [1; 2; 3];

  AT.check (AT.array AT.int) "reverse - empty array" (Array.reverse [||]) [||];
  AT.check (AT.array AT.int) "reverse - two elements" (Array.reverse [|0;1|]) [|1;0|];
  AT.check 
    (AT.array AT.int) 
    "reverse - leaves the original array untouched" 
    (
      let array = [|0; 1; 2; 3;|] in
      let _reversedArray = Array.reverse array in
      array
    ) 
    [|0; 1; 2; 3;|];

  AT.check 
    (AT.array AT.int) 
    "reverseInPlace - alters an array in-place" 
    (
      let array = [|1;2;3|] in
      Array.reverseInPlace array;
      array
    ) 
    [|3;2;1|];

  AT.check 
    (AT.array AT.int) 
    "forEach" (
      let index = ref 0 in
      let calledValues = [|0;0;0|] in
    
      Array.forEach [|1;2;3|] ~f:(fun value -> 
        Array.set calledValues ~index:!index ~value;
        index := !index + 1;
      );
      
      calledValues
    ) 
    [|1;2;3|];
  
  ()


let t_Char () =
  AT.check AT.int "toCode" (Char.toCode 'a') 97;

  AT.check (AT.option AT.char) "fromCode - valid ASCII codes return the corresponding character" (Char.fromCode 97) (Some 'a');
  AT.check (AT.option AT.char) "fromCode - negative integers return none" (Char.fromCode (-1)) None;
  AT.check (AT.option AT.char) "fromCode - integers greater than 255 return none" (Char.fromCode 256) None;

  AT.check AT.string "toString" (Char.toString 'a') "a";

  AT.check (AT.option AT.char) "fromString - one-length string return Some" (Char.fromString "a") (Some 'a');
  AT.check (AT.option AT.char) "fromString - multi character strings return none" (Char.fromString "abc") None;
  AT.check (AT.option AT.char) "fromString - zero length strings return none" (Char.fromString "") None;

  AT.check AT.char "toLowercase - converts uppercase ASCII characters to lowercase" (Char.toLowercase 'A') 'a';
  AT.check AT.char "toLowercase - perserves lowercase characters" (Char.toLowercase 'a') 'a';
  AT.check AT.char "toLowercase - perserves non-alphabet characters" (Char.toLowercase '7') '7';
  AT.check AT.char "toUppercase - perserves non-ASCII characters" (Char.toUppercase '\237') '\237';

  AT.check AT.char "toUppercase - converts lowercase ASCII characters to uppercase" (Char.toUppercase 'a') 'A';
  AT.check AT.char "toUppercase - perserves uppercase characters" (Char.toUppercase 'A') 'A';
  AT.check AT.char "toUppercase - perserves non-alphabet characters" (Char.toUppercase '7') '7';
  AT.check AT.char "toUppercase - perserves non-ASCII characters" (Char.toUppercase '\236') '\236';

  AT.check (AT.option AT.int) "toDigit - converts ASCII characters representing digits into integers" (Char.toDigit '0') (Some 0);
  AT.check (AT.option AT.int) "toDigit - converts ASCII characters representing digits into integers" (Char.toDigit '8') (Some 8);
  AT.check (AT.option AT.int) "toDigit - converts ASCII characters representing digits into integers" (Char.toDigit 'a') None;

  AT.check AT.bool "isLowercase - returns true for any lowercase character" (Char.isLowercase 'a') true;
  AT.check AT.bool "isLowercase - returns false for all other characters" (Char.isLowercase '7') false;      
  AT.check AT.bool "isLowercase - returns false for non-ASCII characters" (Char.isLowercase '\236') false;      

  AT.check AT.bool "isUppercase - returns true for any uppercase character" (Char.isUppercase 'A') true;
  AT.check AT.bool "isUppercase - returns false for all other characters" (Char.isUppercase '7') false;      
  AT.check AT.bool "isUppercase - returns false for non-ASCII characters" (Char.isLowercase '\237') false;      

  AT.check AT.bool "isLetter - returns true for any ASCII alphabet character" (Char.isLetter 'A') true;
  AT.check AT.bool "isLetter - returns false for all other characters" (Char.isLetter '\n') false;
  AT.check AT.bool "isLetter - returns false for non-ASCII characters" (Char.isLetter '\236') false;

  AT.check AT.bool "isDigit - returns true for digits 0-9" (Char.isDigit '5') true;
  AT.check AT.bool "isDigit - returns false for all other characters" (Char.isDigit 'a') false;

  AT.check AT.bool "isAlphanumeric - returns true for any alphabet or digit character" (Char.isAlphanumeric 'A') true;
  AT.check AT.bool "isAlphanumeric - returns false for all other characters" (Char.isAlphanumeric '?') false;      

  AT.check AT.bool "isPrintable - returns true for a printable character" (Char.isPrintable '~') true;
  AT.check (AT.option AT.bool) "isPrintable - returns false for non-printable character" (Char.fromCode 31 |> Option.map ~f:Char.isPrintable ) (Some false);      

  AT.check AT.bool "isWhitespace - returns true for any whitespace character" (Char.isWhitespace ' ') true;
  AT.check AT.bool "isWhitespace - returns false for a non-whitespace character" (Char.isWhitespace 'a') false;      
  ()

let t_List () =
  AT.check (AT.list AT.int) "reverse empty list" (List.reverse []) [];
  AT.check (AT.list AT.int) "reverse one element" (List.reverse [0]) [0];
  AT.check (AT.list AT.int) "reverse two elements" (List.reverse [0;1]) [1;0];

  AT.check (AT.list AT.int) "map2 empty lists" (List.map2 ~f:(+) [] []) [];
  AT.check (AT.list AT.int) "map2 one element" (List.map2 ~f:(+) [1] [1]) [2];
  AT.check (AT.list AT.int) "map2 two elements" (List.map2 ~f:(+) [1;2] [1;2]) [2;4];

  AT.check (AT.list AT.int) "indexedMap empty list" (List.indexedMap ~f:(fun i _ -> i) []) [];
  AT.check (AT.list AT.int) "indexedMap one element" (List.indexedMap ~f:(fun i _ -> i) ['a']) [0];
  AT.check (AT.list AT.int) "indexedMap two elements" (List.indexedMap ~f:(fun i _ -> i) ['a';'b']) [0;1];

  AT.check (AT.list AT.int) "indexedMap empty list" (List.indexedMap ~f:(fun _ n -> n + 1) []) [];
  AT.check (AT.list AT.int) "indexedMap one element" (List.indexedMap ~f:(fun _ n -> n + 1) [-1]) [0];
  AT.check (AT.list AT.int) "indexedMap two elements" (List.indexedMap ~f:(fun _ n -> n + 1) [-1; 0]) [0;1];

  AT.check (AT.option AT.int) "minimumBy non-empty list" (List.minimumBy ~f:(fun x -> x mod 12) [7;9;15;10;3;22]) (Some 15);
  AT.check (AT.option AT.int) "minimumBy empty list" (List.minimumBy ~f:(fun x -> x mod 12) []) None;
  
  AT.check (AT.option AT.int) "maximumBy non-empty list" (List.maximumBy ~f:(fun x -> x mod 12) [7;9;15;10;3;22]) (Some 10);
  AT.check (AT.option AT.int) "maximumBy empty list" (List.maximumBy ~f:(fun x -> x mod 12) []) None;
  
  AT.check (AT.option AT.int) "minimum non-empty list" (List.minimum [7;9;15;10;3]) (Some 3);
  AT.check (AT.option AT.int) "minimum empty list" (List.minimum []) None;
  
  AT.check (AT.option AT.int) "maximum non-empty list" (List.maximum [7;9;15;10;3]) (Some 15);
  AT.check (AT.option AT.int) "maximum empty list" (List.maximum []) None;
  
  AT.check (AT.pair (AT.list AT.int) (AT.list AT.int)) "partition empty list" (List.partition ~f:(fun x -> x mod 2 = 0) []) ([], []);
  AT.check (AT.pair (AT.list AT.int) (AT.list AT.int)) "partition one element" (List.partition ~f:(fun x -> x mod 2 = 0) [1]) ([], [1]);
  AT.check (AT.pair (AT.list AT.int) (AT.list AT.int)) "partition four elements" (List.partition ~f:(fun x -> x mod 2 = 0) [1;2;3;4]) ([2;4], [1;3]);

  AT.check (AT.pair (AT.list AT.int) (AT.list AT.int)) "split_when four elements" (List.split_when ~f:(fun x -> x mod 2 = 0) [1;3;2;4]) ([1;3], [2;4]);
  AT.check (AT.pair (AT.list AT.int) (AT.list AT.int)) "split_when at zero" (List.split_when ~f:(fun x -> x mod 2 = 0) [2;4;6]) ([], [2;4;6]);
  AT.check (AT.pair (AT.list AT.int) (AT.list AT.int)) "split_when at end" (List.split_when ~f:(fun x -> x mod 2 = 0) [1;3;5]) ([1;3;5], []);
  AT.check (AT.pair (AT.list AT.int) (AT.list AT.int)) "split_when empty list" (List.split_when ~f:(fun x -> x mod 2 = 0) []) ([], []);

  ()

let t_String () =
  AT.check
    AT.bool
    "imported correctly"
    true
    (Tablecloth.String.length == String.length) ;

  AT.check AT.int "length" (String.length "") 0;
  AT.check AT.int "length" (String.length "123") 3;

  AT.check AT.string "reverse" (String.reverse "") "";
  AT.check AT.string "reverse" (String.reverse "stressed") "desserts";

  ()

let t_Tuple2 () =
  AT.check (AT.pair AT.int AT.int) "create" (Tuple2.create 3 4) (3, 4);

  AT.check AT.int "first" (Tuple2.first (3, 4)) 3;

  AT.check AT.int "second" (Tuple2.second (3, 4)) 4;

  AT.check (AT.pair AT.string AT.int) "mapFirst" (Tuple2.mapFirst ~f:String.reverse ("stressed", 16)) ("desserts", 16);

  AT.check (AT.pair AT.string (AT.float 0.)) "mapSecond" (Tuple2.mapSecond ~f:sqrt ("stressed", 16.)) ("stressed", 4.);

  AT.check (AT.pair AT.string (AT.float 0.)) "mapEach" (Tuple2.mapEach ~f:String.reverse ~g:sqrt ("stressed", 16.)) ("desserts", 4.);

  AT.check (AT.pair AT.string AT.string) "mapAll" (Tuple2.mapAll ~f:String.reverse ("was", "stressed")) ("saw", "desserts");

  AT.check (AT.pair AT.int AT.int) "swap" (Tuple2.swap (3, 4)) (4, 3);

  AT.check AT.int "curry" (Tuple2.curry (fun (a, b) -> a + b) 3 4) 7;

  AT.check AT.int "uncurry" (Tuple2.uncurry (fun a b -> a + b) (3, 4)) 7;

  AT.check (AT.list AT.int) "toList" (Tuple2.toList (3, 4)) [3; 4;];

  ()



let t_Tuple3 () =
  AT.check (trio AT.int AT.int AT.int) "create" (Tuple3.create 3 4 5) (3, 4, 5);

  AT.check AT.int "first" (Tuple3.first (3, 4, 5)) 3;

  AT.check AT.int "second" (Tuple3.second (3, 4, 5)) 4;      

  AT.check AT.int "third" (Tuple3.third (3, 4, 5)) 5;      

  AT.check (AT.pair AT.int AT.int) "init" (Tuple3.init (3, 4, 5)) (3, 4);      

  AT.check (AT.pair AT.int AT.int) "tail" (Tuple3.tail (3, 4, 5)) (4, 5);      

  AT.check (trio AT.string AT.int AT.bool) "mapFirst" (Tuple3.mapFirst ~f:String.reverse ("stressed", 16, false)) ("desserts", 16, false);

  AT.check (trio AT.string (AT.float 0.) AT.bool) "mapSecond" (Tuple3.mapSecond ~f:sqrt ("stressed", 16., false)) ("stressed", 4., false);

  AT.check (trio AT.string AT.int AT.bool) "mapThird" (Tuple3.mapThird ~f:not ("stressed", 16, false)) ("stressed", 16, true);

  AT.check (trio AT.string (AT.float 0.) AT.bool) "mapEach" (Tuple3.mapEach ~f:String.reverse ~g:sqrt ~h:not ("stressed", 16., false)) ("desserts", 4., true);

  AT.check (trio AT.string AT.string AT.string) "mapAll" (Tuple3.mapAll ~f:String.reverse ("was", "stressed", "now")) ("saw", "desserts", "won");
  
  AT.check (trio AT.int AT.int AT.int) "rotateLeft" (Tuple3.rotateLeft (3, 4, 5)) (4, 5, 3);
  
  AT.check (trio AT.int AT.int AT.int) "rotateRight" (Tuple3.rotateRight (3, 4, 5)) (5, 3, 4);

  AT.check AT.int "curry" (Tuple3.curry (fun (a, b, c) -> a + b + c) 3 4 5) 12;

  AT.check AT.int "uncurry" (Tuple3.uncurry (fun a b c -> a + b + c) (3, 4, 5)) 12;

  AT.check (AT.list AT.int) "toList" (Tuple3.toList (3, 4, 5)) [3; 4; 5;];

  ()

let suite = [
  ("Array", `Quick, t_Array); 
  ("Char", `Quick, t_Char); 
  ("String", `Quick, t_String); 
  ("Tuple2", `Quick, t_Tuple2);
  ("Tuple3", `Quick, t_Tuple3);
]

let () =
  let suite, exit = Junit_alcotest.run_and_report "suite" [("tests", suite)] in
  let report = Junit.make [suite] in
  Junit.to_file report "test-native.xml"
