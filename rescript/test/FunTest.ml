open Tablecloth
open AlcoJest

let suite =
  suite ("Fun" [@reason.raw_literal "Fun"]) (fun () ->
      ( (test ("identity" [@reason.raw_literal "identity"]) (fun () ->
             ( expect (Fun.identity 1)
             |> toEqual Eq.int 1 )
             [@reason.preserve_braces] ) ;
         test ("ignore" [@reason.raw_literal "ignore"]) (fun () ->
             ( expect (Fun.ignore 1)
             |> toEqual Eq.unit () )
             [@reason.preserve_braces] ) ;
         test ("constant" [@reason.raw_literal "constant"]) (fun () ->
             ( expect (Fun.constant 1 2)
             |> toEqual Eq.int 1 )
             [@reason.preserve_braces] ) ;
         test ("sequence" [@reason.raw_literal "sequence"]) (fun () ->
             ( expect (Fun.sequence 1 2)
             |> toEqual Eq.int 2 )
             [@reason.preserve_braces] ) ;
         test ("flip" [@reason.raw_literal "flip"]) (fun () ->
             ( expect (Fun.flip Int.( / ) 2 4)
             |> toEqual Eq.int 2 )
             [@reason.preserve_braces] ) ;
         test ("apply" [@reason.raw_literal "apply"]) (fun () ->
             ( expect (Fun.apply (fun a -> a + 1) 1)
             |> toEqual Eq.int 2 )
             [@reason.preserve_braces] ) ;
         let increment x = x + 1 in
         let double x = x * 2 in
         test ("compose" [@reason.raw_literal "compose"]) (fun () ->
             ( expect (Fun.compose increment double 1)
             |> toEqual Eq.int 3 )
             [@reason.preserve_braces] ) ;
         test ("<<" [@reason.raw_literal "<<"]) (fun () ->
             ( expect
                 ((let open Fun in
                  increment << double)
                    1 )
             |> toEqual Eq.int 3 )
             [@reason.preserve_braces] ) ;
         test ("composeRight" [@reason.raw_literal "composeRight"]) (fun () ->
             ( expect (Fun.composeRight increment double 1)
             |> toEqual Eq.int 4 )
             [@reason.preserve_braces] ) ;
         test (">>" [@reason.raw_literal ">>"]) (fun () ->
             ( expect
                 ((let open Fun in
                  increment >> double)
                    1 )
             |> toEqual Eq.int 4 )
             [@reason.preserve_braces] ) ;
         test ("tap" [@reason.raw_literal "tap"]) (fun () ->
             ( expect
                 ( Array.filter [| 1; 3; 2; 5; 4 |] ~f:Int.isEven
                 |> Fun.tap ~f:(fun numbers -> ignore (numbers.(1) <- 0))
                 |> Fun.tap ~f:Array.reverse )
             |> toEqual
                  (let open Eq in
                  array int)
                  [| 0; 2 |] )
             [@reason.preserve_braces] ) ;
         test ("curry" [@reason.raw_literal "curry"]) (fun () ->
             ( expect (Fun.curry (fun (a, b) -> a / b) 8 4)
             |> toEqual
                  (let open Eq in
                  int)
                  2 )
             [@reason.preserve_braces] ) ;
         test ("uncurry" [@reason.raw_literal "uncurry"]) (fun () ->
             ( expect (Fun.uncurry (fun a b -> a / b) (8, 4))
             |> toEqual
                  (let open Eq in
                  int)
                  2 )
             [@reason.preserve_braces] ) ;
         test ("curry3" [@reason.raw_literal "curry3"]) (fun () ->
             (let tupleAdder (a, b, c) = a + b + c in
              expect (Fun.curry3 tupleAdder 3 4 5) |> toEqual Eq.int 12 )
             [@reason.preserve_braces] ) ;
         test ("uncurry3" [@reason.raw_literal "uncurry3"]) (fun () ->
             (let curriedAdder a b c = a + b + c in
              expect (Fun.uncurry3 curriedAdder (3, 4, 5)) |> toEqual Eq.int 12
             )
             [@reason.preserve_braces] ) )
      [@reason.preserve_braces] ) )
