open Tablecloth
module AT = Alcotest

let t_String () =
  AT.check
    AT.bool
    "imported correctly"
    true
    (Tablecloth.String.length == String.length) ;

  AT.check AT.int "length" (String.length "123") 3;

  AT.check AT.string "reverse" (String.reverse "stressed") "desserts";

  ()

let suite = [
  ("String", `Quick, t_String); 
]

let () =
  let suite, exit = Junit_alcotest.run_and_report "suite" [("tests", suite)] in
  let report = Junit.make [suite] in
  Junit.to_file report "test-native.xml"
