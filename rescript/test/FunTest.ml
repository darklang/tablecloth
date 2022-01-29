open Tablecloth
open AlcoJest

let suite =
  suite "Fun" (fun () ->
      test "identity" (fun () -> expect (Fun.identity 1) |> toEqual Eq.int 1) ;
      test "ignore" (fun () -> expect (Fun.ignore 1) |> toEqual Eq.unit ()) ;
      test "constant" (fun () -> expect (Fun.constant 1 2) |> toEqual Eq.int 1) ;
      test "sequence" (fun () -> expect (Fun.sequence 1 2) |> toEqual Eq.int 2) ;
      test "flip" (fun () ->
          expect (Fun.flip Int.subtract 2 4) |> toEqual Eq.int 2 ) ;
      test "negate" (fun () ->
          let num = 5 in
          let greaterThanFour n = n > 4 in
          expect (Fun.negate greaterThanFour num) |> toEqual Eq.bool false ) ;
      test "apply" (fun () ->
          expect (Fun.apply (fun a -> a + 1) 1) |> toEqual Eq.int 2 ) ;
      let increment x = x + 1 in
      let double x = x * 2 in
      test "compose" (fun () ->
          expect (Fun.compose 1 increment double) |> toEqual Eq.int 4 ) ;
      test "composeRight" (fun () ->
          expect (Fun.composeRight 1 increment double) |> toEqual Eq.int 3 ) ;
      test "tap" (fun () ->
          expect
            ( Array.filter [| 1; 3; 2; 5; 4 |] ~f:Int.isEven
            |> Fun.tap ~f:(fun numbers -> ignore (numbers.(1) <- 0))
            |> Fun.tap ~f:Array.reverse )
          |> toEqual
               (let open Eq in
               array int)
               [| 0; 2 |] ) ;

      test "curry" (fun () ->
          expect (Fun.curry (fun (a, b) -> a / b) 8 4)
          |> toEqual
               (let open Eq in
               int)
               2 ) ;
      test "uncurry" (fun () ->
          expect (Fun.uncurry (fun a b -> a / b) (8, 4))
          |> toEqual
               (let open Eq in
               int)
               2 ) ;
      test "curry3" (fun () ->
          let tupleAdder (a, b, c) = a + b + c in
          expect (Fun.curry3 tupleAdder 3 4 5) |> toEqual Eq.int 12 ) ;
      test "uncurry3" (fun () ->
          let curriedAdder a b c = a + b + c in
          expect (Fun.uncurry3 curriedAdder (3, 4, 5)) |> toEqual Eq.int 12 ) )
