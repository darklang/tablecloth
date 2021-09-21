open Tablecloth
open AlcoJest

let suite =
  suite "String" (fun () ->
      let open String in
      testAll
        "fromChar"
        [ ('a', "a"); ('z', "z"); (' ', " "); ('\n', "\n") ]
        (fun (char, string) ->
          expect (fromChar char) |> toEqual Eq.string string ) ;
      describe "fromArray" (fun () ->
          test "creates an empty string from an empty array" (fun () ->
              expect (fromArray [||]) |> toEqual Eq.string "" ) ;
          test "creates a string of characters" (fun () ->
              expect (fromArray [| 'K'; 'u'; 'b'; 'o' |])
              |> toEqual Eq.string "Kubo" ) ;
          test "creates a string of characters" (fun () ->
              expect (fromArray [| ' '; '\n'; '\t' |])
              |> toEqual Eq.string " \n\t" ) ) ;
      describe "indexOf" (fun () ->
          test "returns some index of the first matching substring" (fun () ->
              expect (indexOf "hello" "h")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 0) ) ;
          test "returns the first index even though multiple present" (fun () ->
              expect (indexOf "hellh" "h")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 0) ) ;
          test
            "returns first substring that matches with multiple characters"
            (fun () ->
              expect (indexOf "hellh" "ell")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 1) ) ;
          test "returns None when no substring matches" (fun () ->
              expect (indexOf "hello" "xy")
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;
      describe "indexOfRight" (fun () ->
          test "returns some index of the last matching string" (fun () ->
              expect (indexOfRight "helloh" "oh")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 4) ) ;
          test "returns the last index even though multiple present" (fun () ->
              expect (indexOfRight "ohelloh" "oh")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 5) ) ;
          test "returns None when no character matches" (fun () ->
              expect (indexOfRight "hello" "x")
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;
      describe "fromList" (fun () ->
          test "creates an empty string from an empty array" (fun () ->
              expect (fromList []) |> toEqual Eq.string "" ) ;
          test "creates a string of characters" (fun () ->
              expect (fromList [ 'K'; 'u'; 'b'; 'o' ])
              |> toEqual Eq.string "Kubo" ) ;
          test "creates a string of characters" (fun () ->
              expect (fromList [ ' '; '\n'; '\t' ]) |> toEqual Eq.string " \n\t" ) ) ;
      describe "repeat" (fun () ->
          test "returns an empty string for count zero" (fun () ->
              expect (repeat "bun" ~count:0) |> toEqual Eq.string "" ) ;
          test "raises for negative count" (fun () ->
              expect (fun () -> repeat "bun" ~count:(-1)) |> toThrow ) ;
          test "returns the input string repeated count times" (fun () ->
              expect (repeat "bun" ~count:3) |> toEqual Eq.string "bunbunbun" ) ) ;
      describe "initialize" (fun () ->
          test "returns an empty string for count zero" (fun () ->
              expect (initialize 0 ~f:(Fun.constant 'A'))
              |> toEqual Eq.string "" ) ;
          test "raises for negative count" (fun () ->
              expect (fun () -> initialize (-1) ~f:(Fun.constant 'A'))
              |> toThrow ) ;
          test "returns the input string repeated count times" (fun () ->
              expect (initialize 3 ~f:(Fun.constant 'A'))
              |> toEqual Eq.string "AAA" ) ) ;
      describe "isEmpty" (fun () ->
          test "true for zero length string" (fun () ->
              expect (isEmpty "") |> toEqual Eq.bool true ) ;
          testAll
            "false for length > 0 strings"
            [ "abc"; " "; "\n" ]
            (fun string -> expect (isEmpty string) |> toEqual Eq.bool false) ) ;
      test "length empty string" (fun () ->
          expect (String.length "") |> toEqual Eq.int 0 ) ;
      test "length" (fun () ->
          expect (String.length "123") |> toEqual Eq.int 3 ) ;
      test "reverse empty string" (fun () ->
          expect (String.reverse "") |> toEqual Eq.string "" ) ;
      test "reverse" (fun () ->
          expect (String.reverse "stressed") |> toEqual Eq.string "desserts" ) ;
      describe "split" (fun () ->
          test "middle" (fun () ->
              expect (String.split "abc" ~on:"b")
              |> toEqual
                   (let open Eq in
                   list string)
                   [ "a"; "c" ] ) ;
          test "start" (fun () ->
              expect (String.split "ab" ~on:"a")
              |> toEqual
                   (let open Eq in
                   list string)
                   [ ""; "b" ] ) ;
          test "end" (fun () ->
              expect (String.split "ab" ~on:"b")
              |> toEqual
                   (let open Eq in
                   list string)
                   [ "a"; "" ] ) ) ;
      describe "insertAt" (fun () ->
          test "middle" (fun () ->
              expect (String.insertAt "abcde" ~value:"**" ~index:2)
              |> toEqual
                   (let open Eq in
                   string)
                   "ab**cde" ) ;
          test "start" (fun () ->
              expect (String.insertAt "abcde" ~value:"**" ~index:0)
              |> toEqual
                   (let open Eq in
                   string)
                   "**abcde" ) ;
          test "end" (fun () ->
              expect (String.insertAt "abcde" ~value:"**" ~index:5)
              |> toEqual
                   (let open Eq in
                   string)
                   "abcde**" ) ;
          test "negative" (fun () ->
              expect (String.insertAt "abcde" ~value:"**" ~index:(-2))
              |> toEqual
                   (let open Eq in
                   string)
                   "abc**de" ) ;
          test "negative overflow" (fun () ->
              expect (String.insertAt "abcde" ~value:"**" ~index:(-9))
              |> toEqual
                   (let open Eq in
                   string)
                   "**abcde" ) ;
          test "overflow" (fun () ->
              expect (String.insertAt "abcde" ~value:"**" ~index:9)
              |> toEqual
                   (let open Eq in
                   string)
                   "abcde**" ) ) ;
      test "toArray" (fun () ->
          expect (String.toArray "Standard")
          |> toEqual
               (let open Eq in
               array char)
               [| 'S'; 't'; 'a'; 'n'; 'd'; 'a'; 'r'; 'd' |] ) ;
      test "toList" (fun () ->
          expect (String.toList "Standard")
          |> toEqual
               (let open Eq in
               list char)
               [ 'S'; 't'; 'a'; 'n'; 'd'; 'a'; 'r'; 'd' ] ) )
