test "isPrintable('~')" (fun () -> expect (Char.isPrintable '~') |> toEqual Eq.bool true) ; 
test "isPrintable(fromCode(31) |> Option.map(~f=isPrintable))" (fun () -> expect (Char.isPrintable fromCode(31) |> Option.map(~f=isPrintable)) |> toEqual (let open Eq in bool ) Some(false)) ; 
