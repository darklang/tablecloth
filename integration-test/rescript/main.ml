open Tablecloth

let () =
  assert (
    Array.equal
      (Array.initialize 5 ~f:(fun _ -> 0))
      [| 0; 0; 0; 0; 0 |]
      Int.equal ) ;

  assert (String.equal (Bool.toString true) "true") ;

  assert (Int.equal (Char.toCode 'A') 65) ;

  assert (Float.equal (Float.add 1. 1.) 2.) ;

  assert (Int.equal (Int.add 2 2) 4) ;

  assert (String.equal (String.fromList [ 'A'; 'B'; 'C' ]) "ABC") ;

  assert (
    List.equal (List.initialize 5 ~f:(fun _ -> 0)) [ 0; 0; 0; 0; 0 ] Int.equal ) ;

  assert (Option.isSome (Some 1)) ;

  assert (Result.isOk (Ok 1)) ;

  assert (Tuple2.equal (Tuple2.make 1 1) (1, 1) Int.equal Int.equal) ;

  assert (
    Tuple3.equal (Tuple3.make 1 1 1) (1, 1, 1) Int.equal Int.equal Int.equal ) ;

  assert (Set.length Set.String.empty = 0) ;

  assert (Map.length Map.String.empty = 0) ;

  assert (Fun.constant 1 2 = 1) ;

  print_endline "Success"
