open Tablecloth
open AlcoJest

let suite =
  suite "pp" (fun () ->
      test "pp formats result" (fun () ->
          let result = Ok 5 in
          let buffer = Buffer.create 100 in
          let formatter = Format.formatter_of_buffer buffer in
          Result.pp Format.pp_print_int Format.pp_print_string formatter result ;
          Format.pp_print_flush formatter () ;
          expect (Buffer.contents buffer) |> toEqual Eq.string "<ok: 5>" ) )
