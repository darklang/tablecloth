open Tablecloth
module AT = Alcotest

let t_strings () =
  AT.check
    AT.bool
    "imported correctly"
    true
    (Tablecloth.String.length == String.length) ;
  AT.check AT.int "length works" (String.length "123") 3


let suite = [("strings", `Quick, t_strings)]

let () =
  let suite, exit = Junit_alcotest.run_and_report "suite" [("tests", suite)] in
  let report = Junit.make [suite] in
  Junit.to_file report "test-native.xml"
