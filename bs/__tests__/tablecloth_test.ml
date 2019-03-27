open Tablecloth
open Jest
open Expect

let () =
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
      test "perserves non-ASCII characters" (fun () -> expect (Char.toUppercase '\233') |> toEqual '/233');
    );

    describe "toUppercase" (fun () -> 
      test "converts lowercase ASCII characters to uppercase" (fun () -> expect (Char.toUppercase 'a') |> toEqual 'A');
      test "perserves uppercase characters" (fun () -> expect (Char.toUppercase 'A') |> toEqual 'A');
      test "perserves non-alphabet characters" (fun () -> expect (Char.toUppercase '7') |> toEqual '7');
      test "perserves non-ASCII characters" (fun () -> expect (Char.toUppercase '\233') |> toEqual '/233');
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
      test "partition empty list" (fun () -> expect (List.partition ~f:(fun x -> x mod 2 = 0) []) |> toEqual ([], []));
      test "partition one element" (fun () -> expect (List.partition ~f:(fun x -> x mod 2 = 0) [1]) |> toEqual ([], [1]));
      test "partition four elements" (fun () -> expect (List.partition ~f:(fun x -> x mod 2 = 0) [1;2;3;4]) |> toEqual ([2;4], [1;3]));
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
