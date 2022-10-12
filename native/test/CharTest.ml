open Tablecloth
open AlcoJest

let suite =
  suite "Char" (fun () ->
      let open Char in
      test "to_code" (fun () -> expect (to_code 'a') |> toEqual Eq.int 97) ;
      describe "from_code" (fun () ->
          test "valid ASCII codes return the corresponding character" (fun () ->
              expect (from_code 97)
              |> toEqual
                   (let open Eq in
                   option char)
                   (Some 'a') ) ;
          test "negative integers return None" (fun () ->
              expect (from_code (-1))
              |> toEqual
                   (let open Eq in
                   option char)
                   None ) ;
          test "integers greater than 255 return None" (fun () ->
              expect (from_code 256)
              |> toEqual
                   (let open Eq in
                   option char)
                   None ) ) ;
      test "to_string" (fun () ->
          expect (to_string 'a') |> toEqual Eq.string "a" ) ;
      describe "from_string" (fun () ->
          test "one-length string return Some" (fun () ->
              expect (from_string "a")
              |> toEqual
                   (let open Eq in
                   option char)
                   (Some 'a') ) ;
          test "multi character strings return None" (fun () ->
              expect (from_string "abc")
              |> toEqual
                   (let open Eq in
                   option char)
                   None ) ;
          test "zero length strings return None" (fun () ->
              expect (from_string "")
              |> toEqual
                   (let open Eq in
                   option char)
                   None ) ) ;
      describe "to_lowercase" (fun () ->
          test "converts uppercase ASCII characters to lowercase" (fun () ->
              expect (to_lowercase 'A') |> toEqual Eq.char 'a' ) ;
          test "perserves lowercase characters" (fun () ->
              expect (to_lowercase 'a') |> toEqual Eq.char 'a' ) ;
          test "perserves non-alphabet characters" (fun () ->
              expect (to_lowercase '7') |> toEqual Eq.char '7' ) ;
          test "perserves non-ASCII characters" (fun () ->
              expect (to_lowercase '\233') |> toEqual Eq.char '\233' ) ) ;
      describe "to_uppercase" (fun () ->
          test "converts lowercase ASCII characters to uppercase" (fun () ->
              expect (to_uppercase 'a') |> toEqual Eq.char 'A' ) ;
          test "perserves uppercase characters" (fun () ->
              expect (to_uppercase 'A') |> toEqual Eq.char 'A' ) ;
          test "perserves non-alphabet characters" (fun () ->
              expect (to_uppercase '7') |> toEqual Eq.char '7' ) ;
          test "perserves non-ASCII characters" (fun () ->
              expect (to_uppercase '\233') |> toEqual Eq.char '\233' ) ) ;
      describe "to_digit" (fun () ->
          test
            "to_digit - converts ASCII characters representing digits into integers"
            (fun () ->
              expect (to_digit '0')
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 0) ) ;
          test
            "to_digit - converts ASCII characters representing digits into integers"
            (fun () ->
              expect (to_digit '8')
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 8) ) ;
          test
            "to_digit - converts ASCII characters representing digits into integers"
            (fun () ->
              expect (to_digit 'a')
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;
      describe "is_lowercase" (fun () ->
          test "returns true for any lowercase character" (fun () ->
              expect (is_lowercase 'a') |> toEqual Eq.bool true ) ;
          test "returns false for all other characters" (fun () ->
              expect (is_lowercase '7') |> toEqual Eq.bool false ) ;
          test "returns false for non-ASCII characters" (fun () ->
              expect (is_lowercase '\236') |> toEqual Eq.bool false ) ) ;
      describe "is_uppercase" (fun () ->
          test "returns true for any uppercase character" (fun () ->
              expect (is_uppercase 'A') |> toEqual Eq.bool true ) ;
          test "returns false for all other characters" (fun () ->
              expect (is_uppercase '7') |> toEqual Eq.bool false ) ;
          test "returns false for non-ASCII characters" (fun () ->
              expect (is_lowercase '\237') |> toEqual Eq.bool false ) ) ;
      describe "is_letter" (fun () ->
          test "returns true for any ASCII alphabet character" (fun () ->
              expect (is_letter 'A') |> toEqual Eq.bool true ) ;
          testAll
            "returns false for all other characters"
            [ '7'; ' '; '\n'; '\011'; '\236' ]
            (fun char -> expect (is_letter char) |> toEqual Eq.bool false) ) ;
      describe "is_digit" (fun () ->
          testAll
            "returns true for digits 0-9"
            [ '0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9' ]
            (fun digit -> expect (is_digit digit) |> toEqual Eq.bool true) ;
          test "returns false for all other characters" (fun () ->
              expect (is_digit 'a') |> toEqual Eq.bool false ) ) ;
      describe "is_alphanumeric" (fun () ->
          test "returns true for any alphabet or digit character" (fun () ->
              expect (is_alphanumeric 'A') |> toEqual Eq.bool true ) ;
          test "returns false for all other characters" (fun () ->
              expect (is_alphanumeric '?') |> toEqual Eq.bool false ) ) ;
      describe "is_printable" (fun () ->
          test "returns true for a printable character" (fun () ->
              expect (is_printable '~') |> toEqual Eq.bool true ) ;
          test "returns false for non-printable character" (fun () ->
              expect (from_code 31 |> Option.map ~f:is_printable)
              |> toEqual
                   (let open Eq in
                   option bool)
                   (Some false) ) ) ;
      describe "is_whitespace" (fun () ->
          test "returns true for any whitespace character" (fun () ->
              expect (is_whitespace ' ') |> toEqual Eq.bool true ) ;
          test "returns false for a non-whitespace character" (fun () ->
              expect (is_whitespace 'a') |> toEqual Eq.bool false ) ) )
