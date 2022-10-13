open Tablecloth

let () =
  assert (
    Array.equal
      Int.equal
      (Array.initialize 5 ~f:(fun _ -> 0))
      [| 0; 0; 0; 0; 0 |] ) ;

  assert (String.equal (Bool.to_string true) "true") ;

  assert (Int.equal (Char.to_code 'A') 65) ;

  assert (Float.equal (Float.add 1. 1.) 2.) ;

  assert (Int.equal (Int.add 2 2) 4) ;

  assert (String.equal (String.from_list [ 'A'; 'B'; 'C' ]) "ABC") ;

  assert (
    List.equal Int.equal (List.initialize 5 ~f:(fun _ -> 0)) [ 0; 0; 0; 0; 0 ] ) ;

  assert (Option.is_some (Some 1)) ;

  assert (Result.is_ok (Ok 1)) ;

  assert (Tuple2.equal Int.equal Int.equal (Tuple2.make 1 1) (1, 1)) ;

  assert (
    Tuple3.equal Int.equal Int.equal Int.equal (Tuple3.make 1 1 1) (1, 1, 1) ) ;

  assert (Set.length Set.String.empty = 0) ;

  assert (Map.length Map.String.empty = 0) ;

  assert (Fun.constant 1 2 = 1) ;

  print_endline "Success"
