open Tablecloth
open AlcoJest

let suite =
  suite "Tuple2" (fun () ->
      test "make" (fun () ->
          expect (Tuple2.make 3 4)
          |> toEqual
               (let open Eq in
               pair int int)
               (3, 4) ) ;
      test "first" (fun () ->
          expect (Tuple2.first (3, 4))
          |> toEqual
               (let open Eq in
               int)
               3 ) ;
      test "second" (fun () ->
          expect (Tuple2.second (3, 4))
          |> toEqual
               (let open Eq in
               int)
               4 ) ;
      test "mapFirst" (fun () ->
          expect (Tuple2.mapFirst ~f:String.reverse ("stressed", 16))
          |> toEqual
               (let open Eq in
               pair string int)
               ("desserts", 16) ) ;
      test "mapSecond" (fun () ->
          expect (Tuple2.mapSecond ~f:Float.squareRoot ("stressed", 16.))
          |> toEqual
               (let open Eq in
               pair string float)
               ("stressed", 4.) ) ;
      test "mapEach" (fun () ->
          expect
            (Tuple2.mapEach
               ~f:String.reverse
               ~g:Float.squareRoot
               ("stressed", 16.) )
          |> toEqual
               (let open Eq in
               pair string float)
               ("desserts", 4.) ) ;
      test "mapAll" (fun () ->
          expect (Tuple2.mapAll ~f:String.reverse ("was", "stressed"))
          |> toEqual
               (let open Eq in
               pair string string)
               ("saw", "desserts") ) ;
      test "swap" (fun () ->
          expect (Tuple2.swap (3, 4))
          |> toEqual
               (let open Eq in
               pair int int)
               (4, 3) ) ;
      test "toArray" (fun () ->
          expect (Tuple2.toArray (3, 4))
          |> toEqual
               (let open Eq in
               array int)
               [| 3; 4 |] ) ;
      test "toList" (fun () ->
          expect (Tuple2.toList (3, 4))
          |> toEqual
               (let open Eq in
               list int)
               [ 3; 4 ] ) )
