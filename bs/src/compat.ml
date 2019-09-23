(* This file is used to target different OCaml versions using the BuckleScript
   preprocessor. This is a separate file since ocamlformat does not accept
   the BuckleScript preprocessor. *)

module String = struct
#if OCAML_VERSION =~ ">=4.03" then

  let toLower (s : string) : string = String.lowercase_ascii s

  let toUpper (s : string) : string = String.uppercase_ascii s

  let uncapitalize (s : string) : string = String.uncapitalize_ascii s

  let capitalize (s : string) : string = String.capitalize_ascii s

  let isCapitalized (s : string) : bool = s = String.capitalize_ascii s

#else
  let toLower (s : string) : string = String.lowercase s

  let toUpper (s : string) : string = String.uppercase s

  let uncapitalize (s : string) : string = String.uncapitalize s

  let capitalize (s : string) : string = String.capitalize s

  let isCapitalized (s : string) : bool = s = String.capitalize s

#end
end