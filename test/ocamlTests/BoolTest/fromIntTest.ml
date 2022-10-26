test "fromInt(0)" (fun () -> expect (Bool.fromInt 0) |> toEqual (let open Eq in option bool) Some(false)) ; 
test "fromInt(1)" (fun () -> expect (Bool.fromInt 1) |> toEqual (let open Eq in option bool) Some(true)) ; 
test "fromInt(Int.minimumValue)" (fun () -> expect (Bool.fromInt Int.minimumValue) |> toEqual (let open Eq in option bool) None) ; 
test "fromInt(-2)" (fun () -> expect (Bool.fromInt -2) |> toEqual (let open Eq in option bool) None) ; 
test "fromInt(-1)" (fun () -> expect (Bool.fromInt -1) |> toEqual (let open Eq in option bool) None) ; 
test "fromInt(2)" (fun () -> expect (Bool.fromInt 2) |> toEqual (let open Eq in option bool) None) ; 
test "fromInt(Int.maximumValue)" (fun () -> expect (Bool.fromInt Int.maximumValue) |> toEqual (let open Eq in option bool) None) ; 
