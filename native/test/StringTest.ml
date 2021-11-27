open Tablecloth
open AlcoJest

let suite =
  suite "String" (fun () ->
      let open String in
      testAll
        "from_char"
        [ ('a', "a"); ('z', "z"); (' ', " "); ('\n', "\n") ]
        (fun (char, string) ->
          expect (from_char char) |> toEqual Eq.string string ) ;
      describe "from_array" (fun () ->
          test "creates an empty string from an empty array" (fun () ->
              expect (from_array [||]) |> toEqual Eq.string "" ) ;
          test "creates a string of characters" (fun () ->
              expect (from_array [| 'K'; 'u'; 'b'; 'o' |])
              |> toEqual Eq.string "Kubo" ) ;
          test "creates a string of characters" (fun () ->
              expect (from_array [| ' '; '\n'; '\t' |])
              |> toEqual Eq.string " \n\t" ) ) ;
      describe "index_of" (fun () ->
          test "returns some index of the first matching substring" (fun () ->
              expect (index_of "hello" "h")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 0) ) ;
          test "returns the first index even though multiple present" (fun () ->
              expect (index_of "hellh" "h")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 0) ) ;
          test
            "returns first substring that matches with multiple characters"
            (fun () ->
              expect (index_of "hellh" "ell")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 1) ) ;
          test "returns None when no substring matches" (fun () ->
              expect (index_of "hello" "xy")
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;
      describe "index_of_right" (fun () ->
          test "returns some index of the last matching string" (fun () ->
              expect (index_of_right "helloh" "oh")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 4) ) ;
          test "returns the last index even though multiple present" (fun () ->
              expect (index_of_right "ohelloh" "oh")
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 5) ) ;
          test "returns None when no character matches" (fun () ->
              expect (index_of_right "hello" "x")
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;
      describe "from_list" (fun () ->
          test "creates an empty string from an empty array" (fun () ->
              expect (from_list []) |> toEqual Eq.string "" ) ;
          test "creates a string of characters" (fun () ->
              expect (from_list [ 'K'; 'u'; 'b'; 'o' ])
              |> toEqual Eq.string "Kubo" ) ;
          test "creates a string of characters" (fun () ->
              expect (from_list [ ' '; '\n'; '\t' ])
              |> toEqual Eq.string " \n\t" ) ) ;
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
      describe "is_empty" (fun () ->
          test "true for zero length string" (fun () ->
              expect (is_empty "") |> toEqual Eq.bool true ) ;
          testAll
            "false for length > 0 strings"
            [ "abc"; " "; "\n" ]
            (fun string -> expect (is_empty string) |> toEqual Eq.bool false) ) ;
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
      describe "insert_at" (fun () ->
          test "middle" (fun () ->
              expect (String.insert_at "abcde" ~value:"**" ~index:2)
              |> toEqual
                   (let open Eq in
                   string)
                   "ab**cde" ) ;
          test "start" (fun () ->
              expect (String.insert_at "abcde" ~value:"**" ~index:0)
              |> toEqual
                   (let open Eq in
                   string)
                   "**abcde" ) ;
          test "end" (fun () ->
              expect (String.insert_at "abcde" ~value:"**" ~index:5)
              |> toEqual
                   (let open Eq in
                   string)
                   "abcde**" ) ;
          test "negative" (fun () ->
              expect (String.insert_at "abcde" ~value:"**" ~index:(-2))
              |> toEqual
                   (let open Eq in
                   string)
                   "abc**de" ) ;
          test "negative overflow" (fun () ->
              expect (String.insert_at "abcde" ~value:"**" ~index:(-9))
              |> toEqual
                   (let open Eq in
                   string)
                   "**abcde" ) ;
          test "overflow" (fun () ->
              expect (String.insert_at "abcde" ~value:"**" ~index:9)
              |> toEqual
                   (let open Eq in
                   string)
                   "abcde**" ) ) ;
      test "to_array" (fun () ->
          expect (String.to_array "Standard")
          |> toEqual
               (let open Eq in
               array char)
               [| 'S'; 't'; 'a'; 'n'; 'd'; 'a'; 'r'; 'd' |] ) ;
      test "to_list" (fun () ->
          expect (String.to_list "Standard")
          |> toEqual
               (let open Eq in
               list char)
               [ 'S'; 't'; 'a'; 'n'; 'd'; 'a'; 'r'; 'd' ] ) )
