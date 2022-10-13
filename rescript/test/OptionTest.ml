open Tablecloth
open AlcoJest

let suite =
  suite "Option" (fun () ->
      describe "unwrapUnsafe" (fun () ->
          test "returns the wrapped value for a Some" (fun () ->
              expect (Option.unwrapUnsafe (Some 1)) |> toEqual Eq.int 1 ) ;
          test "raises for a None" (fun () ->
              expect (fun () -> ignore (Option.unwrapUnsafe None))
              |> toRaise
                   (Invalid_argument "Option.unwrapUnsafe called with None") ) ) ;
      describe "and_" (fun () ->
          test "returns second argument" (fun () ->
              expect (Option.and_ (Some 1) (Some 15))
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 15) ) ;

          test "returns none" (fun () ->
              expect (Option.and_ None (Some 15))
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;

          test "returns none" (fun () ->
              expect (Option.and_ (Some 1) None)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;

          test "returns none" (fun () ->
              expect (Option.and_ None None)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "or_" (fun () ->
          test "returns first argument" (fun () ->
              expect (Option.or_ (Some 1) (Some 15))
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 1) ) ;

          test "returns second argument some" (fun () ->
              expect (Option.or_ None (Some 15))
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 15) ) ;

          test "returns first argument some" (fun () ->
              expect (Option.or_ (Some 1) None)
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 1) ) ;

          test "returns none" (fun () ->
              expect (Option.or_ None None)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "orElse" (fun () ->
          test "returns second argument" (fun () ->
              expect (Option.orElse (Some 1) (Some 15))
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 15) ) ;

          test "returns second argument" (fun () ->
              expect (Option.orElse None (Some 15))
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 15) ) ;

          test "returns first argument some" (fun () ->
              expect (Option.orElse (Some 1) None)
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 1) ) ;

          test "returns none" (fun () ->
              expect (Option.orElse None None)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "both" (fun () ->
          test "returns both as pair" (fun () ->
              expect (Option.both (Some 3004) (Some "Ant"))
              |> toEqual
                   (let open Eq in
                   option (pair int string))
                   (Some (3004, "Ant")) ) ;

          test "returns none" (fun () ->
              expect (Option.both None (Some "Ant"))
              |> toEqual
                   (let open Eq in
                   option (pair int string))
                   None ) ;

          test "returns none" (fun () ->
              expect (Option.both (Some 3004) None)
              |> toEqual
                   (let open Eq in
                   option (pair int string))
                   None ) ;

          test "returns none" (fun () ->
              expect (Option.both None None)
              |> toEqual
                   (let open Eq in
                   option (pair int string))
                   None ) ) ;

      describe "flatten" (fun () ->
          test "returns option layers as single option layer" (fun () ->
              expect (Option.flatten (Some (Some 4)))
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 4) ) ;

          test "returns none" (fun () ->
              expect (Option.flatten (Some None))
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;

          test "returns none" (fun () ->
              expect (Option.flatten None)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "map" (fun () ->
          test "returns transformed value from inside option arg" (fun () ->
              expect (Option.map ~f:(fun x -> x * x) (Some 9))
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 81) ) ;

          test "returns transformed value from inside option arg" (fun () ->
              expect (Option.map ~f:Int.toString (Some 9))
              |> toEqual
                   (let open Eq in
                   option string)
                   (Some "9") ) ;

          test "returns none" (fun () ->
              expect (Option.map ~f:(fun x -> x * x) None)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "map2" (fun () ->
          test "returns transformed value from two option arg" (fun () ->
              expect (Option.map2 (Some 3) (Some 4) ~f:Int.add)
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 7) ) ;

          test "returns none" (fun () ->
              expect (Option.map2 (Some 3) None ~f:Int.add)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ;
          test "returns none" (fun () ->
              expect (Option.map2 None (Some 4) ~f:Int.add)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "andThen" (fun () ->
          test "returns result of callback" (fun () ->
              expect (Option.andThen (Some [ 1; 2; 3 ]) ~f:List.head)
              |> toEqual
                   (let open Eq in
                   option int)
                   (Some 1) ) ;

          test "returns none" (fun () ->
              expect (Option.andThen (Some []) ~f:List.head)
              |> toEqual
                   (let open Eq in
                   option int)
                   None ) ) ;

      describe "unwrap" (fun () ->
          test "returns unwrapped [option('a)]" (fun () ->
              expect (Option.unwrap ~default:99 (Some 42)) |> toEqual Eq.int 42 ) ;

          test "returns default" (fun () ->
              expect (Option.unwrap ~default:99 None) |> toEqual Eq.int 99 ) ) ;

      describe "isSome" (fun () ->
          test "returns true if is a Some" (fun () ->
              expect (Option.isSome (Some 3004)) |> toEqual Eq.bool true ) ;

          test "returns false if is a None" (fun () ->
              expect (Option.isSome None) |> toEqual Eq.bool false ) ) ;

      describe "isNone" (fun () ->
          test "returns false if is a Some" (fun () ->
              expect (Option.isNone (Some 3004)) |> toEqual Eq.bool false ) ;

          test "returns true if is a None" (fun () ->
              expect (Option.isNone None) |> toEqual Eq.bool true ) ) ;

      describe "toArray" (fun () ->
          test "returns option as array" (fun () ->
              expect (Option.toArray (Some 3004))
              |> toEqual
                   (let open Eq in
                   array int)
                   [| 3004 |] ) ;

          test "returns empty array if None" (fun () ->
              expect (Option.toArray None)
              |> toEqual
                   (let open Eq in
                   array int)
                   [||] ) ) ;

      describe "toList" (fun () ->
          test "returns option as list" (fun () ->
              expect (Option.toList (Some 3004))
              |> toEqual
                   (let open Eq in
                   list int)
                   [ 3004 ] ) ;

          test "returns empty list if None" (fun () ->
              expect (Option.toList None)
              |> toEqual
                   (let open Eq in
                   list int)
                   [] ) ) ;

      describe "equal" (fun () ->
          test "returns bool true if options are equal" (fun () ->
              expect (Option.equal (Some 1) (Some 1) Int.equal)
              |> toEqual Eq.bool true ) ;

          test "returns bool true if options are equal" (fun () ->
              expect (Option.equal (Some 1) (Some 3) Int.equal)
              |> toEqual Eq.bool false ) ;

          test "returns bool true if options are equal" (fun () ->
              expect (Option.equal (Some 1) None Int.equal)
              |> toEqual Eq.bool false ) ;
          test "returns bool true if options are equal" (fun () ->
              expect (Option.equal None None Int.equal) |> toEqual Eq.bool true ) ) ;

      describe "compare" (fun () ->
          test "returns comparative value -1, 0, or 1" (fun () ->
              expect (Option.compare (Some 1) (Some 3) ~f:Int.compare)
              |> toEqual Eq.int (-1) ) ;

          test "returns comparative value -1, 0, or 1" (fun () ->
              expect (Option.compare (Some 1) None ~f:Int.compare)
              |> toEqual Eq.int 1 ) ;

          test "returns comparative value -1, 0, or 1" (fun () ->
              expect (Option.compare None None ~f:Int.compare)
              |> toEqual Eq.int 0 ) ) )
