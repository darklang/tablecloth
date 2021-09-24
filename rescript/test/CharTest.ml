open Tablecloth
open AlcoJest

let suite =
  suite "Char" (fun () ->
      let open Char in
      test "toCode" (fun () -> expect (toCode 'a') |> toEqual Eq.int 97) ;
      describe "fromCode" (fun () ->
          test "valid ASCII codes return the corresponding character" (fun () ->
              expect (fromCode 97)
              |> toEqual
                   (let open Eq in
                   option char)
                   (Some 'a') ) ;
          test "negative integers return None" (fun () ->
              expect (fromCode (-1))
              |> toEqual
                   (let open Eq in
                   option char)
                   None ) ;
          test "integers greater than 255 return None" (fun () ->
              expect (fromCode 256)
              |> toEqual
                   (let open Eq in
                   option char)
                   None ) ) ;
      test "toString" (fun () ->
          expect (toString 'a') |> toEqual Eq.string "a" ) ;
      describe "fromString" (fun () ->
          test "one-length string return Some" (fun () ->
              expect (fromString "a")
              |> toEqual
                   (let open Eq in
                   option char)
                   (Some 'a') ) ;
          test "multi character strings return None" (fun () ->
              expect (fromString "abc")
              |> toEqual
                   (let open Eq in
                   option char)
                   None ) ;
          test "zero length strings return None" (fun () ->
              expect (fromString "")
              |> toEqual
                   (let open Eq in
                   option char)
                   None ) ) ;
      describe "toLowercase" (fun () ->
          test "converts uppercase ASCII characters to lowercase" (fun () ->
              expect (toLowercase 'A') |> toEqual Eq.char 'a' ) ;
          test "perserves lowercase characters" (fun () ->
              expect (toLowercase 'a') |> toEqual Eq.char 'a' ) ;
          test "perserves non-alphabet characters" (fun () ->
              expect (toLowercase '7') |> toEqual Eq.char '7' ) ;
          test "perserves non-ASCII characters" (fun () ->
              expect (toLowercase '\233') |> toEqual Eq.char '\233' ) ) ;
      describe "toUppercase" (fun () ->
          test "converts lowercase ASCII characters to uppercase" (fun () ->
              expect (toUppercase 'a') |> toEqual Eq.char 'A' ) ;
          test "perserves uppercase characters" (fun () ->
              expect (toUppercase 'A') |> toEqual Eq.char 'A' ) ;
          test "perserves non-alphabet characters" (fun () ->
              expect (toUppercase '7') |> toEqual Eq.char '7' ) ;
          test "perserves non-ASCII characters" (fun () ->
              expect (toUppercase '\233') |> toEqual Eq.char '\233' ) ) ;
      describe "toDigit" (fun () ->
          test
            "toDigit - converts ASCII characters representing digits into integers"
            (fun () ->
              expect (toDigit '0')
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 0) ) ;
          test
            "toDigit - converts ASCII characters representing digits into integers"
            (fun () ->
              expect (toDigit '8')
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 8) ) ;
          test
            "toDigit - converts ASCII characters representing digits into integers"
            (fun () ->
              expect (toDigit 'a')
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;
      describe "isLowercase" (fun () ->
          test "returns true for any lowercase character" (fun () ->
              expect (isLowercase 'a') |> toEqual Eq.bool true ) ;
          test "returns false for all other characters" (fun () ->
              expect (isLowercase '7') |> toEqual Eq.bool false ) ;
          test "returns false for non-ASCII characters" (fun () ->
              expect (isLowercase '\236') |> toEqual Eq.bool false ) ) ;
      describe "isUppercase" (fun () ->
          test "returns true for any uppercase character" (fun () ->
              expect (isUppercase 'A') |> toEqual Eq.bool true ) ;
          test "returns false for all other characters" (fun () ->
              expect (isUppercase '7') |> toEqual Eq.bool false ) ;
          test "returns false for non-ASCII characters" (fun () ->
              expect (isLowercase '\237') |> toEqual Eq.bool false ) ) ;
      describe "isLetter" (fun () ->
          test "returns true for any ASCII alphabet character" (fun () ->
              expect (isLetter 'A') |> toEqual Eq.bool true ) ;
          testAll
            "returns false for all other characters"
            [ '7'; ' '; '\n'; '\011'; '\236' ]
            (fun char -> expect (isLetter char) |> toEqual Eq.bool false) ) ;
      describe "isDigit" (fun () ->
          testAll
            "returns true for digits 0-9"
            [ '0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9' ]
            (fun digit -> expect (isDigit digit) |> toEqual Eq.bool true) ;
          test "returns false for all other characters" (fun () ->
              expect (isDigit 'a') |> toEqual Eq.bool false ) ) ;
      describe "isAlphanumeric" (fun () ->
          test "returns true for any alphabet or digit character" (fun () ->
              expect (isAlphanumeric 'A') |> toEqual Eq.bool true ) ;
          test "returns false for all other characters" (fun () ->
              expect (isAlphanumeric '?') |> toEqual Eq.bool false ) ) ;
      describe "isPrintable" (fun () ->
          test "returns true for a printable character" (fun () ->
              expect (isPrintable '~') |> toEqual Eq.bool true ) ;
          test "returns false for non-printable character" (fun () ->
              expect (fromCode 31 |> Option.map ~f:isPrintable)
              |> toEqual
                   (let open Eq in
                   option bool)
                   (Some false) ) ) ;
      describe "isWhitespace" (fun () ->
          test "returns true for any whitespace character" (fun () ->
              expect (isWhitespace ' ') |> toEqual Eq.bool true ) ;
          test "returns false for a non-whitespace character" (fun () ->
              expect (isWhitespace 'a') |> toEqual Eq.bool false ) ) )
