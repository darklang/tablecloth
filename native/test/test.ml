open Tablecloth
module AT = Alcotest

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


(* TODO
  AT.check (AT.list AT.int * AT.list AT.int) "partition empty list" (List.partition ~f:(fun x -> x mod 2 = 0) []) ([], []);
  AT.check (pair AT.list AT.int AT.list AT.int) "partition one element" (List.partition ~f:(fun x -> x mod 2 = 0) [1]) ([], [1]);
  AT.check (pair AT.list AT.int AT.list AT.int) "partition four elements" (List.partition ~f:(fun x -> x mod 2 = 0) [1;2;3;4]) ([2;4], [1;3]);*)

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
  ("List", `Quick, t_List);
  ("String", `Quick, t_String);
  ("Tuple2", `Quick, t_Tuple2);
  ("Tuple3", `Quick, t_Tuple3);
]

let () =
  let suite, exit = Junit_alcotest.run_and_report "suite" [("tests", suite)] in
  let report = Junit.make [suite] in
  Junit.to_file report "test-native.xml"
