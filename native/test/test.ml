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

let t_Tuple2 () =
  AT.check (AT.pair AT.int AT.int) "create" (Tuple2.create 3 4) (3, 4);

  AT.check AT.int "first" (Tuple2.first (3, 4)) 3;

  AT.check AT.int "second" (Tuple2.second (3, 4)) 4;

  AT.check (AT.pair AT.string AT.int) "mapFirst" (Tuple2.mapFirst ~f:String.reverse ("stressed", 16)) ("desserts", 16);

  AT.check (AT.pair AT.string (AT.float 0.)) "mapSecond" (Tuple2.mapSecond ~f:sqrt ("stressed", 16.)) ("stressed", 4.);

  AT.check (AT.pair AT.string (AT.float 0.)) "mapBoth" (Tuple2.mapBoth ~f:String.reverse ~g:sqrt ("stressed", 16.)) ("desserts", 4.);

  ()

let suite = [
  ("String", `Quick, t_String); 
  ("Tuple2", `Quick, t_Tuple2);
]

let () =
  let suite, exit = Junit_alcotest.run_and_report "suite" [("tests", suite)] in
  let report = Junit.make [suite] in
  Junit.to_file report "test-native.xml"
