(* Export standard libraries that we override so they can be used if needs be. *)
module Caml = struct
  module String = String
  module List = String
end

include (
  Tablecloth :
    module type of Tablecloth
    (* with module StrSet := Tablecloth.StrSet *)
    (*  and module IntSet := Tablecloth.IntSet *)
    (*  and module StrDict := Tablecloth.StrDict *)
    with module Option := Tablecloth.Option
    (*  and module Result := Tablecloth.Result *)
    (*  and module List := Tablecloth.List *) )

module Option = struct
  include Tablecloth.Option

  let exec ~(f : 'a -> unit) (v : 'a option) : unit =
    match v with Some v -> f v | None -> ()


  let valueExn (value : 'a option) : 'a =
    match value with Some v -> v | None -> raise Not_found
end

module Tuple3 = struct
  let first (x, _, _) = x

  let second (_, x, _) = x

  let third (_, _, x) = x
end
