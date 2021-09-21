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
      test "mapFirst" (fun () ->
          expect (mapFirst ~f:String.reverse ("stressed", 16, false))
          |> toEqual
               (let open Eq in
               trio string int bool)
               ("desserts", 16, false) ) ;
      test "mapSecond" (fun () ->
          expect (mapSecond ~f:Float.squareRoot ("stressed", 16., false))
          |> toEqual
               (let open Eq in
               trio string float bool)
               ("stressed", 4., false) ) ;
      test "mapThird" (fun () ->
          expect (mapThird ~f:not ("stressed", 16, false))
          |> toEqual
               (let open Eq in
               trio string int bool)
               ("stressed", 16, true) ) ;
      test "mapEach" (fun () ->
          expect
            (mapEach
               ~f:String.reverse
               ~g:Float.squareRoot
               ~h:not
               ("stressed", 16., false) )
          |> toEqual
               (let open Eq in
               trio string float bool)
               ("desserts", 4., true) ) ;
      test "mapAll" (fun () ->
          expect (mapAll ~f:String.reverse ("was", "stressed", "now"))
          |> toEqual
               (let open Eq in
               trio string string string)
               ("saw", "desserts", "won") ) ;
      test "rotateLeft" (fun () ->
          expect (rotateLeft (3, 4, 5))
          |> toEqual
               (let open Eq in
               trio int int int)
               (4, 5, 3) ) ;
      test "rotateRight" (fun () ->
          expect (rotateRight (3, 4, 5))
          |> toEqual
               (let open Eq in
               trio int int int)
               (5, 3, 4) ) ;
      test "toArray" (fun () ->
          expect (toArray (3, 4, 5))
          |> toEqual
               (let open Eq in
               array int)
               [| 3; 4; 5 |] ) ;
      test "toList" (fun () ->
          expect (toList (3, 4, 5))
          |> toEqual
               (let open Eq in
               list int)
               [ 3; 4; 5 ] ) )
