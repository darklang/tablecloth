open Tablecloth
open AlcoJest

let suite =
 suite "Bool" (fun () ->
   let open Bool in
test "compare(true,true)" (fun () -> expect (Bool.compare true true) |> toEqual Eq.int 0) ; 
test "compare(true,false)" (fun () -> expect (Bool.compare true false) |> toEqual Eq.int 1) ; 
test "compare(false,true)" (fun () -> expect (Bool.compare false true) |> toEqual Eq.int -1) ; 
test "compare(false,false)" (fun () -> expect (Bool.compare false false) |> toEqual Eq.int 0) ; 
test "equal(true,true)" (fun () -> expect (Bool.equal true true) |> toEqual Eq.bool true) ; 
test "equal(false,false)" (fun () -> expect (Bool.equal false false) |> toEqual Eq.bool true) ; 
test "equal(true,false)" (fun () -> expect (Bool.equal true false) |> toEqual Eq.bool false) ; 
test "fromInt(0)" (fun () -> expect (Bool.fromInt 0) |> toEqual (let open Eq in option bool) Some(false)) ; 
test "fromInt(1)" (fun () -> expect (Bool.fromInt 1) |> toEqual (let open Eq in option bool) Some(true)) ; 
test "fromInt(Int.minimumValue)" (fun () -> expect (Bool.fromInt Int.minimumValue) |> toEqual (let open Eq in option bool) None) ; 
test "fromInt(-2)" (fun () -> expect (Bool.fromInt -2) |> toEqual (let open Eq in option bool) None) ; 
test "fromInt(-1)" (fun () -> expect (Bool.fromInt -1) |> toEqual (let open Eq in option bool) None) ; 
test "fromInt(2)" (fun () -> expect (Bool.fromInt 2) |> toEqual (let open Eq in option bool) None) ; 
test "fromInt(Int.maximumValue)" (fun () -> expect (Bool.fromInt Int.maximumValue) |> toEqual (let open Eq in option bool) None) ; 
test "fromString("true")" (fun () -> expect (Bool.fromString "true") |> toEqual (let open Eq in option bool) Some(true)) ; 
test "fromString("false")" (fun () -> expect (Bool.fromString "false") |> toEqual (let open Eq in option bool) Some(false)) ; 
test "fromString("True")" (fun () -> expect (Bool.fromString "True") |> toEqual (let open Eq in option bool) None) ; 
test "fromString("1")" (fun () -> expect (Bool.fromString "1") |> toEqual (let open Eq in option bool) None) ; 
test "toInt(true)" (fun () -> expect (Bool.toInt true) |> toEqual Eq.int 1) ; 
test "toInt(false)" (fun () -> expect (Bool.toInt false) |> toEqual Eq.int 0) ; 
test "toString(true)" (fun () -> expect (Bool.toString true) |> toEqual Eq.string "true") ; 
test "toString(false)" (fun () -> expect (Bool.toString false) |> toEqual Eq.string "false") ; 
test "xor(true,true)" (fun () -> expect (Bool.xor true true) |> toEqual Eq.bool false) ; 
test "xor(true,false)" (fun () -> expect (Bool.xor true false) |> toEqual Eq.bool true) ; 
test "xor(false,true)" (fun () -> expect (Bool.xor false true) |> toEqual Eq.bool true) ; 
test "xor(false,false)" (fun () -> expect (Bool.xor false false) |> toEqual Eq.bool false) ; 
)