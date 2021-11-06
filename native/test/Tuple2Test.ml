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
      test "map_first" (fun () ->
          expect (Tuple2.map_first ~f:String.reverse ("stressed", 16))
          |> toEqual
               (let open Eq in
               pair string int)
               ("desserts", 16) ) ;
      test "map_second" (fun () ->
          expect (Tuple2.map_second ~f:Float.square_root ("stressed", 16.))
          |> toEqual
               (let open Eq in
               pair string float)
               ("stressed", 4.) ) ;
      test "map_each" (fun () ->
          expect
            (Tuple2.map_each
               ~f:String.reverse
               ~g:Float.square_root
               ("stressed", 16.) )
          |> toEqual
               (let open Eq in
               pair string float)
               ("desserts", 4.) ) ;
      test "map_all" (fun () ->
          expect (Tuple2.map_all ~f:String.reverse ("was", "stressed"))
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
      test "to_array" (fun () ->
          expect (Tuple2.to_array (3, 4))
          |> toEqual
               (let open Eq in
               array int)
               [| 3; 4 |] ) ;
      test "to_list" (fun () ->
          expect (Tuple2.to_list (3, 4))
          |> toEqual
               (let open Eq in
               list int)
               [ 3; 4 ] ) )
