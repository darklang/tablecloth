open Tablecloth
open AlcoJest

let suite =
  suite "Tuple3" (fun () ->
      let open Tuple3 in
      test "make" (fun () ->
          expect (make 3 4 5)
          |> toEqual
               (let open Eq in
               trio int int int)
               (3, 4, 5) ) ;
      test "first" (fun () -> expect (first (3, 4, 5)) |> toEqual Eq.int 3) ;
      test "second" (fun () -> expect (second (3, 4, 5)) |> toEqual Eq.int 4) ;
      test "third" (fun () -> expect (third (3, 4, 5)) |> toEqual Eq.int 5) ;
      test "initial" (fun () ->
          expect (initial (3, 4, 5))
          |> toEqual
               (let open Eq in
               pair int int)
               (3, 4) ) ;
      test "tail" (fun () ->
          expect (tail (3, 4, 5))
          |> toEqual
               (let open Eq in
               pair int int)
               (4, 5) ) ;
      test "map_first" (fun () ->
          expect (map_first ~f:String.reverse ("stressed", 16, false))
          |> toEqual
               (let open Eq in
               trio string int bool)
               ("desserts", 16, false) ) ;
      test "map_second" (fun () ->
          expect (map_second ~f:Float.square_root ("stressed", 16., false))
          |> toEqual
               (let open Eq in
               trio string float bool)
               ("stressed", 4., false) ) ;
      test "map_third" (fun () ->
          expect (map_third ~f:not ("stressed", 16, false))
          |> toEqual
               (let open Eq in
               trio string int bool)
               ("stressed", 16, true) ) ;
      test "map_each" (fun () ->
          expect
            (map_each
               ~f:String.reverse
               ~g:Float.square_root
               ~h:not
               ("stressed", 16., false) )
          |> toEqual
               (let open Eq in
               trio string float bool)
               ("desserts", 4., true) ) ;
      test "map_all" (fun () ->
          expect (map_all ~f:String.reverse ("was", "stressed", "now"))
          |> toEqual
               (let open Eq in
               trio string string string)
               ("saw", "desserts", "won") ) ;
      test "rotate_left" (fun () ->
          expect (rotate_left (3, 4, 5))
          |> toEqual
               (let open Eq in
               trio int int int)
               (4, 5, 3) ) ;
      test "rotate_right" (fun () ->
          expect (rotate_right (3, 4, 5))
          |> toEqual
               (let open Eq in
               trio int int int)
               (5, 3, 4) ) ;
      test "to_array" (fun () ->
          expect (to_array (3, 4, 5))
          |> toEqual
               (let open Eq in
               array int)
               [| 3; 4; 5 |] ) ;
      test "to_list" (fun () ->
          expect (to_list (3, 4, 5))
          |> toEqual
               (let open Eq in
               list int)
               [ 3; 4; 5 ] ) )
