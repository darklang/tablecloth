open Tablecloth
module AT = Alcotest

let t_Char () =
  AT.check AT.int "toCode" (Char.toCode 'a') 97;

  AT.check (AT.option AT.char) "fromCode - valid ASCII codes return the corresponding character" (Char.fromCode 97) (Some 'a');
  AT.check (AT.option AT.char) "fromCode - negative integers return none" (Char.fromCode (-1)) None;
  AT.check (AT.option AT.char) "fromCode - integers greater than 255 return none" (Char.fromCode 256) None;

  AT.check AT.string "toString" (Char.toString 'a') "a";

  AT.check (AT.option AT.char) "fromString - one-length string return Some" (Char.fromString "a") (Some 'a');
  AT.check (AT.option AT.char) "fromString - multi character strings return none" (Char.fromString "abc") None;
  AT.check (AT.option AT.char) "fromString - zero length strings return none" (Char.fromString "") None;

  AT.check AT.char "lowercase - converts uppercase ASCII characters to lowercase" (Char.lowercase 'A') 'a';
  AT.check AT.char "lowercase - perserves lowercase characters" (Char.lowercase 'a') 'a';
  AT.check AT.char "lowercase - perserves non-alphabet characters" (Char.lowercase '7') '7';

  AT.check AT.char "uppercase - converts lowercase ASCII characters to uppercase" (Char.uppercase 'a') 'A';
  AT.check AT.char "uppercase - perserves uppercase characters" (Char.uppercase 'A') 'A';
  AT.check AT.char "uppercase - perserves non-alphabet characters" (Char.uppercase '7') '7';

  AT.check AT.bool "isLowercase - returns true for any lowercase character" (Char.isLowercase 'a') true;
  AT.check AT.bool "isLowercase - returns false for all other characters" (Char.isLowercase '7') false;      

  AT.check AT.bool "isUppercase - returns true for any uppercase character" (Char.isUppercase 'A') true;
  AT.check AT.bool "isUppercase - returns false for all other characters" (Char.isUppercase '7') false;      

  AT.check AT.bool "isAlphabetic - returns true for any ASCII alphabet character" (Char.isAlphabetic 'A') true;
  AT.check AT.bool "isAlphabetic - returns false for all other characters" (Char.isAlphabetic '\n') false;

  AT.check AT.bool "isNumeric - returns true for digits 0-9" (Char.isNumeric '5') true;
  AT.check AT.bool "isNumeric - returns false for all other characters" (Char.isNumeric 'a') false;

  AT.check AT.bool "isAlphanumeric - returns true for any alphabet or digit character" (Char.isAlphanumeric 'A') true;
  AT.check AT.bool "isAlphanumeric - returns false for all other characters" (Char.isAlphanumeric '?') false;      

  AT.check AT.bool "isPrintable - returns true for a printable character" (Char.isPrintable '~') true;
  AT.check (AT.option AT.bool) "isPrintable - returns false for non-printable character" (Char.fromCode 31 |> Option.map ~f:Char.isPrintable ) (Some false);      

  AT.check AT.bool "isWhitespace - returns true for any whitespace character" (Char.isWhitespace ' ') true;
  AT.check AT.bool "isWhitespace - returns false for a non-whitespace character" (Char.isWhitespace 'a') false;      
  ()

let t_String () =
  AT.check
    AT.bool
    "imported correctly"
    true
    (Tablecloth.String.length == String.length) ;

  AT.check AT.int "length" (String.length "123") 3;

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

  AT.check (AT.list AT.int) "toList" (Tuple2.toList (3, 4)) [3; 4;];

  ()

let trio a b c = 
  let eq (a1, b1, c1) (a2, b2, c2) = AT.equal a a1 a2 && AT.equal b b1 b2 && AT.equal c c1 c2 in
  let pp ppf (x, y, z) = Fmt.pf ppf "@[<1>(@[%a@],@ @[%a@],@ @[%a@])@]" (AT.pp a) x (AT.pp b) y (AT.pp c) z in
  AT.testable pp eq

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

  AT.check (AT.list AT.int) "toList" (Tuple3.toList (3, 4, 5)) [3; 4; 5;];

  ()

let suite = [
  ("Char", `Quick, t_Char); 
  ("String", `Quick, t_String); 
  ("Tuple2", `Quick, t_Tuple2);
  ("Tuple3", `Quick, t_Tuple3);
]

let () =
  let suite, exit = Junit_alcotest.run_and_report "suite" [("tests", suite)] in
  let report = Junit.make [suite] in
  Junit.to_file report "test-native.xml"
