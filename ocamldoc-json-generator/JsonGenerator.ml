open Odoc_info
open Value
open Type
open Extension
open Exception
open Class
open Module

module Json = struct
  type t =
    [ `Null
    | `Bool of bool
    | `Int of int
    | `Float of float
    | `String of string
    | `Array of t list
    | `Object of (string * t) list
    ]

  let null = `Null

  let nullable f value : t = match value with None -> null | Some v -> f v

  let bool value : t = `Bool value

  let int value : t = `Int value

  let float value : t = `Float value

  let string (value : string) : t = `String value

  let array (f : 'a -> t) (a : 'a list) : t = `Array (List.map f a)

  let obj values : t = `Object values

  let tagged tag json = `Object [ ("tag", `String tag); ("value", json) ]

  let rec toBuffer ?(depth = 0) buffer (t : t) : unit =
    let writeIndent depth =
      for _ = 0 to depth do
        Buffer.add_string buffer "  "
      done
    in
    let write string = Buffer.add_string buffer string in
    let writeUnescapedString string =
      write {|"|} ;
      write (String.escaped string) ;
      write {|"|}
    in
    let keyValueToBuffer (key, value) =
      writeIndent (depth + 1) ;
      writeUnescapedString key ;
      write ": " ;
      toBuffer ~depth:(depth + 1) buffer value
    in
    match t with
    | `Null ->
        write "null"
    | `Bool bool ->
        write (string_of_bool bool)
    | `Int int ->
        write (string_of_int int)
    | `Float float ->
        write (string_of_float float)
    | `String string ->
        writeUnescapedString string
    | `Array elements ->
        write "[\n" ;
        let rec loop = function
          | [] ->
              ()
          | [ element ] ->
              writeIndent (depth + 1) ;
              toBuffer ~depth:(depth + 1) buffer element ;
              write "\n"
          | element :: next :: rest ->
              writeIndent (depth + 1) ;
              toBuffer ~depth:(depth + 1) buffer element ;
              write ",\n" ;
              loop (next :: rest)
        in
        loop elements ;
        writeIndent depth ;
        write "]"
    | `Object elements ->
        write "{\n" ;
        (let rec loop = function
           | [] ->
               ()
           | [ element ] ->
               keyValueToBuffer element ;
               write "\n"
           | element :: next :: rest ->
               keyValueToBuffer element ;
               write ",\n" ;
               loop (next :: rest)
         in
         loop elements ;
         writeIndent depth ;
         write "}" ) ;
        ()


  let toString (t : t) : string =
    let buffer = Buffer.create 1024 in
    toBuffer buffer t ;
    Buffer.contents buffer
end

module StringSet = Set.Make (struct
  type t = string

  let compare = compare
end)

(* module String = Misc.Stdlib.String *)

module Naming = struct
  (** The prefix for modules marks. *)
  let mark_module = "MODULE"

  (** The prefix for module type marks. *)
  let mark_module_type = "MODULETYPE"

  (** The prefix for types marks. *)
  let mark_type = "TYPE"

  (** The prefix for types elements (record fields or constructors). *)
  let mark_type_elt = "TYPEELT"

  (** The prefix for functions marks. *)
  let mark_function = "FUN"

  (** The prefix for extensions marks. *)
  let mark_extension = "EXTENSION"

  (** The prefix for exceptions marks. *)
  let mark_exception = "EXCEPTION"

  (** The prefix for values marks. *)
  let mark_value = "VAL"

  (** The prefix for attributes marks. *)
  let mark_attribute = "ATT"

  (** The prefix for methods marks. *)
  let mark_method = "METHOD"

  (** The prefix for code files. *)
  let code_prefix = "code_"

  (** The prefix for type files. *)
  let type_prefix = "type_"

  (** Return the two html files names for the given module or class name.*)
  let html_files name =
    let qual =
      try
        let i = String.rindex name '.' in
        match name.[i + 1] with 'A' .. 'Z' -> "" | _ -> "-c"
      with
      | Not_found ->
          ""
    in
    let prefix = name ^ qual in
    let html_file = prefix ^ ".html" in
    let html_frame_file = prefix ^ "-frame.html" in
    (html_file, html_frame_file)


  (** Return the target for the given prefix and simple name. *)
  let target pref simple_name = pref ^ simple_name

  (** Return the complete link target (file#target) for the given prefix string and complete name.*)
  let complete_target pref complete_name =
    let simple_name = Name.simple complete_name in
    let module_name =
      let s = Name.father complete_name in
      if s = "" then simple_name else s
    in
    let html_file, _ = html_files module_name in
    html_file ^ "#" ^ target pref simple_name


  (**return the link target for the given module. *)
  let module_target m = target mark_module (Name.simple m.m_name)

  (**return the link target for the given module type. *)
  let module_type_target mt = target mark_module_type (Name.simple mt.mt_name)

  (** Return the link target for the given type. *)
  let type_target t = target mark_type (Name.simple t.ty_name)

  (** Return the link target for the given variant constructor. *)
  let const_target t f =
    let name = Printf.sprintf "%s.%s" (Name.simple t.ty_name) f.vc_name in
    target mark_type_elt name


  (** Return the link target for the given record field. *)
  let recfield_target t f =
    target
      mark_type_elt
      (Printf.sprintf "%s.%s" (Name.simple t.ty_name) f.rf_name)


  (** Return the link target for the given inline record field. *)
  let inline_recfield_target t c f =
    target mark_type_elt (Printf.sprintf "%s.%s.%s" t c f.rf_name)


  (** Return the link target for the given object field. *)
  let objfield_target t f =
    target
      mark_type_elt
      (Printf.sprintf "%s.%s" (Name.simple t.ty_name) f.of_name)


  (** Return the complete link target for the given type. *)
  let complete_type_target t = complete_target mark_type t.ty_name

  let complete_recfield_target name =
    let typ = Name.father name in
    let field = Name.simple name in
    Printf.sprintf "%s.%s" (complete_target mark_type_elt typ) field


  let complete_const_target = complete_recfield_target

  (** Return the link target for the given extension. *)
  let extension_target x = target mark_extension (Name.simple x.xt_name)

  (** Return the complete link target for the given extension. *)
  let complete_extension_target x = complete_target mark_extension x.xt_name

  (** Return the link target for the given exception. *)
  let exception_target e = target mark_exception (Name.simple e.ex_name)

  (** Return the complete link target for the given exception. *)
  let complete_exception_target e = complete_target mark_exception e.ex_name

  (** Return the link target for the given value. *)
  let value_target v = target mark_value (Name.simple v.val_name)

  (** Return the given value name where symbols accepted in infix values
      are replaced by strings, to avoid clashes with the filesystem.*)
  let subst_infix_symbols name =
    let len = String.length name in
    let buf = Buffer.create len in
    let ch c = Buffer.add_char buf c in
    let st s = Buffer.add_string buf s in
    for i = 0 to len - 1 do
      match name.[i] with
      | '|' ->
          st "_pipe_"
      | '<' ->
          st "_lt_"
      | '>' ->
          st "_gt_"
      | '@' ->
          st "_at_"
      | '^' ->
          st "_exp_"
      | '&' ->
          st "_amp_"
      | '+' ->
          st "_plus_"
      | '-' ->
          st "_minus_"
      | '*' ->
          st "_star_"
      | '/' ->
          st "_slash_"
      | '$' ->
          st "_dollar_"
      | '%' ->
          st "_percent_"
      | '=' ->
          st "_equal_"
      | ':' ->
          st "_column_"
      | '~' ->
          st "_tilde_"
      | '!' ->
          st "_bang_"
      | '?' ->
          st "_questionmark_"
      | c ->
          ch c
    done ;
    Buffer.contents buf


  (** Return the complete link target for the given value. *)
  let complete_value_target v = complete_target mark_value v.val_name

  (** Return the complete filename for the code of the given value. *)
  let file_code_value_complete_target v =
    code_prefix ^ mark_value ^ subst_infix_symbols v.val_name ^ ".html"


  (** Return the link target for the given attribute. *)
  let attribute_target a =
    target mark_attribute (Name.simple a.att_value.val_name)


  (** Return the complete link target for the given attribute. *)
  let complete_attribute_target a =
    complete_target mark_attribute a.att_value.val_name


  (** Return the complete filename for the code of the given attribute. *)
  let file_code_attribute_complete_target a =
    code_prefix ^ mark_attribute ^ a.att_value.val_name ^ ".html"


  (** Return the link target for the given method. *)
  let method_target m = target mark_method (Name.simple m.met_value.val_name)

  (** Return the complete link target for the given method. *)
  let complete_method_target m =
    complete_target mark_method m.met_value.val_name


  (** Return the complete filename for the code of the given method. *)
  let file_code_method_complete_target m =
    code_prefix ^ mark_method ^ m.met_value.val_name ^ ".html"


  (** Return the link target for the given label section. *)
  let label_target l = target "" l

  (** Return the complete link target for the given section label. *)
  let complete_label_target l = complete_target "" l

  (** Return the complete filename for the code of the type of the
      given module or module type name. *)
  let file_type_module_complete_target name = type_prefix ^ name ^ ".html"

  (** Return the complete filename for the code of the
      given module name. *)
  let file_code_module_complete_target name = code_prefix ^ name ^ ".html"

  (** Return the complete filename for the code of the type of the
      given class or class type name. *)
  let file_type_class_complete_target name = type_prefix ^ name ^ ".html"
end

let print_DEBUG s =
  print_string s ;
  print_newline ()


let bp = Printf.printf

let bs s =
  print_string "bs encounterd: " ;
  print_endline s


type extractionKind =
  | ExtractRegular
  | ExtractManifest

let destination_json = Sys.getenv "DESTINATION_JSON"

(* TODO surely everything in this class is going to be deleted soon *)
class virtual text =
  object (self)
    (** Escape the strings which would clash with html syntax, and make some replacements (double newlines replaced by <br>). *)
    method escape s = Odoc_ocamlhtml.escape_base s

    method keep_alpha_num s =
      let len = String.length s in
      let buf = Buffer.create len in
      for i = 0 to len - 1 do
        match s.[i] with
        | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' ->
            Buffer.add_char buf s.[i]
        | _ ->
            ()
      done ;
      Buffer.contents buf

    (** Create a label for the associated title.
       Return the label specified by the user or a label created
       from the title level and the first sentence of the title. *)
    method create_title_label
        ((n : int), (label_opt : string option), (t : text_element list)) =
      match label_opt with
      | Some s ->
          s
      | None ->
          (* Return a label created from the first sentence of a text. *)
          let t2 = Odoc_info.first_sentence_of_text t in
          let s = Odoc_info.string_of_text t2 in
          let label = self#keep_alpha_num s in
          Printf.sprintf "%d_%s" n label

    (** Print the html code corresponding to the [text] parameter. *)
    method json_of_text (t : text_element list) : Json.t =
      let open Json in
      tagged "Text" (Json.array self#json_of_text_element t)

    method json_of_text_element =
      Json.(
        function
        | Odoc_info.Raw s ->
            tagged "Raw" (string s)
        | Odoc_info.Code s ->
            tagged "Code" (string s)
        | Odoc_info.CodePre code ->
          ( match destination_json with
          | "model-rescript.json" ->
              tagged "CodePre" (obj [ ("rescript", string code) ])
          | _ ->
              let reasonSyntax : string =
                try
                  Lexing.from_string code
                  |> Reason_toolchain.ML.implementation_with_comments
                  |> Reason_toolchain.RE.print_implementation_with_comments
                       Format.str_formatter
                  |> Format.flush_str_formatter
                with
                | _ ->
                    print_DEBUG "Unable to convert code snippet" ;
                    print_DEBUG code ;
                    code
              in

              tagged
                "CodePre"
                (obj
                   [ ("ocaml", string code); ("reason", string reasonSyntax) ] )
          )
        | Odoc_info.Verbatim s ->
            tagged "Verbatim" (string s)
        | Odoc_info.Bold t ->
            tagged "Bold" (array self#json_of_text_element t)
        | Odoc_info.Italic t ->
            tagged "Italic" (array self#json_of_text_element t)
        | Odoc_info.Emphasize t ->
            tagged "Emphasize" (array self#json_of_text_element t)
        | Odoc_info.Center t ->
            tagged "Center" (array self#json_of_text_element t)
        | Odoc_info.Left t ->
            tagged "Left" (array self#json_of_text_element t)
        | Odoc_info.Right t ->
            tagged "Right" (array self#json_of_text_element t)
        | Odoc_info.List (tl : text_element list list) ->
            tagged "List" (array (array self#json_of_text_element) tl)
        | Odoc_info.Enum tl ->
            tagged "Enum" (array (array self#json_of_text_element) tl)
        | Odoc_info.Newline ->
            tagged "Newline" (string "\n")
        | Odoc_info.Block t ->
            tagged "Block" (array self#json_of_text_element t)
        | Odoc_info.Superscript t ->
            tagged "Superscript" (array self#json_of_text_element t)
        | Odoc_info.Subscript t ->
            tagged "Subscript" (array self#json_of_text_element t)
        | Odoc_info.Title
            ((n : int), (label : string option), (t : text_element list)) ->
            tagged
              "Title"
              (obj
                 [ ("size", int n)
                 ; ("label", nullable string label)
                 ; ("content", array self#json_of_text_element t)
                 ] )
        | Odoc_info.Link (target, content) ->
            tagged
              "Link"
              (obj
                 [ ("target", string target)
                 ; ("content", array self#json_of_text_element content)
                 ] )
        | Odoc_info.Target ((target : string), (code : string)) ->
            tagged
              "Custom"
              (obj [ ("target", string target); ("code", string code) ])
        | Odoc_info.Custom (tag, content) ->
            tagged
              "Custom"
              (obj
                 [ ("tag", string tag)
                 ; ("content", array self#json_of_text_element content)
                 ] )
        | Odoc_info.Latex text ->
            tagged "Latex" (string text)
        | Odoc_info.Index_list ->
            tagged "Index_list" null
        | Odoc_info.Module_list (moduleNames : string list) ->
            tagged "Module_list" (array string moduleNames)
        | Odoc_info.Ref
            ( (name : string)
            , (ref_opt : ref_kind option)
            , (text_opt : Odoc_info.text option) ) ->
            tagged
              "Ref"
              (obj
                 [ ("name", string name)
                 ; ( "reference"
                   , match ref_opt with
                     | None ->
                         obj
                           [ ("kind", string "Unknown")
                           ; ("target", string name)
                           ; ( "content"
                             , match text_opt with
                               | None ->
                                   (array self#json_of_text_element)
                                     [ Odoc_info.Code name ]
                               | Some t ->
                                   (array self#json_of_text_element) t )
                           ]
                     | Some kind ->
                         let hidden name =
                           Odoc_info.Code (Odoc_info.use_hidden_modules name)
                         in
                         let mark_value, target, text =
                           match kind with
                           | Odoc_info.RK_module ->
                               (Naming.mark_module, name, hidden name)
                           | Odoc_info.RK_module_type ->
                               (Naming.mark_module_type, name, hidden name)
                           | Odoc_info.RK_class | Odoc_info.RK_class_type ->
                               ("", name, hidden name)
                           | Odoc_info.RK_value ->
                               (Naming.mark_value, name, hidden name)
                           | Odoc_info.RK_type ->
                               (Naming.mark_type, name, hidden name)
                           | Odoc_info.RK_extension ->
                               (Naming.mark_extension, name, hidden name)
                           | Odoc_info.RK_exception ->
                               (Naming.mark_exception, name, hidden name)
                           | Odoc_info.RK_attribute ->
                               (Naming.mark_attribute, name, hidden name)
                           | Odoc_info.RK_method ->
                               (Naming.mark_method, name, hidden name)
                           | Odoc_info.RK_section t ->
                               ( "Section"
                               , name
                               , Odoc_info.Italic
                                   [ Raw (Odoc_info.string_of_text t) ] )
                           | Odoc_info.RK_recfield ->
                               ("Reffield", name, hidden name)
                           | Odoc_info.RK_const ->
                               ("Const", name, hidden name)
                         in
                         let text =
                           match text_opt with
                           | None ->
                               [ text ]
                           | Some text ->
                               text
                         in
                         obj
                           [ ("kind", string mark_value)
                           ; ("target", string target)
                           ; ("content", array self#json_of_text_element text)
                           ] )
                 ] ))
    (* method json_of_Module_list (moduleNames: string list) =
       List.iter
         (fun name ->
           (
            try
              let m =
                List.find (fun m -> m.m_name = name) self#list_modules
              in
              let (html, _) = Naming.html_files m.m_name in
              bp "<a href=\"%s\">%s</a></td>" html m.m_name;
              bs "<td>";
              (* self#json_of_info_first_sentence m.m_info; *)
            with
              Not_found ->
                Odoc_global.pwarning (Odoc_messages.cross_module_not_found name);
           );
         )
         moduleNames; *)

    (* method json_of_Index_list () =
       let index_if_not_empty l url m =
         match l with
           [] -> ()
         | _ -> bp "<li><a href=\"%s\">%s</a></li>\n" url m
       in
       index_if_not_empty self#list_types self#index_types Odoc_messages.index_of_types;
       index_if_not_empty self#list_extensions self#index_extensions Odoc_messages.index_of_extensions;
       index_if_not_empty self#list_exceptions self#index_exceptions Odoc_messages.index_of_exceptions;
       index_if_not_empty self#list_values self#index_values Odoc_messages.index_of_values;
       index_if_not_empty self#list_attributes self#index_attributes Odoc_messages.index_of_attributes;
       index_if_not_empty self#list_methods self#index_methods Odoc_messages.index_of_methods;
       index_if_not_empty self#list_classes self#index_classes Odoc_messages.index_of_classes;
       index_if_not_empty self#list_class_types self#index_class_types Odoc_messages.index_of_class_types;
       index_if_not_empty self#list_modules self#index_modules Odoc_messages.index_of_modules;
       index_if_not_empty self#list_module_types self#index_module_types Odoc_messages.index_of_module_types; *)
  end

let newline_to_indented_br s =
  let len = String.length s in
  let b = Buffer.create len in
  for i = 0 to len - 1 do
    match s.[i] with
    | '\n' ->
        Buffer.add_string b "<br>     "
    | c ->
        Buffer.add_char b c
  done ;
  Buffer.contents b


class json =
  object (self)
    inherit text

    method json_of_version_opt v_opt = Json.(nullable string v_opt)

    method json_of_since_opt s_opt = Json.(nullable string s_opt)

    method json_of_before l =
      let open Json in
      let f (v, text) =
        obj [ ("version", string v); ("text", self#json_of_text text) ]
      in
      array f l

    (** TODO Json for "see also" reference. *)
    method json_of_see ((see_ref : see_ref), (t : text_element list)) =
      let t_ref =
        match see_ref with
        | Odoc_info.See_url s ->
            [ Odoc_info.Link (s, t) ]
        | Odoc_info.See_file s ->
            Odoc_info.Code s :: Odoc_info.Raw " " :: t
        | Odoc_info.See_doc s ->
            Odoc_info.Italic [ Odoc_info.Raw s ] :: Odoc_info.Raw " " :: t
      in
      self#json_of_text t_ref

    method json_of_sees (l : (see_ref * text_element list) list) =
      Json.array self#json_of_see l

    method json_of_return_opt return_opt =
      let open Json in
      nullable self#json_of_text return_opt

    method json_of_custom (custom_tags : (string * text_element list) list) =
      let open Json in
      let json_of_custom_tag (tag, text) =
        tagged tag (self#json_of_text text)
      in
      array json_of_custom_tag custom_tags

    method json_of_info (info_opt : Odoc_info.info option) : Json.t =
      let open Json in
      let module M = Odoc_info in
      match info_opt with
      | None ->
          null
      | Some info ->
          obj
            [ ("deprecated", (nullable self#json_of_text) info.i_deprecated)
            ; ("description", (nullable self#json_of_text) info.M.i_desc)
            ; (* TODO *)
              (* ("authors", self#json_of_author_list info.M.i_authors); *)
              ("version", self#json_of_version_opt info.M.i_version)
            ; ("before", self#json_of_before info.M.i_before)
            ; ("since", self#json_of_since_opt info.M.i_since)
            ; ( "exceptions"
              , let json_of_exception ((name, description) : raised_exception) =
                  obj
                    [ ("name", string name)
                    ; ("description", self#json_of_text description)
                    ]
                in
                array json_of_exception info.M.i_raised_exceptions )
            ; ("return", self#json_of_return_opt info.M.i_return_value)
            ; ("see", self#json_of_sees info.M.i_sees)
            ; ("custom", self#json_of_custom info.M.i_custom)
            ]

    (** The known types names.
      Used to know if we must create a link to a type
      when printing a type. *)
    val mutable known_types_names = StringSet.empty

    (** The known class and class type names.
      Used to know if we must create a link to a class
      or class type or not when printing a type. *)
    val mutable known_classes_names = StringSet.empty

    (** The known modules and module types names.
      Used to know if we must create a link to a type or not
      when printing a module type. *)
    val mutable known_modules_names = StringSet.empty

    method index_prefix =
      if !Odoc_global.out_file = Odoc_messages.default_out_file
      then "index"
      else Filename.basename !Odoc_global.out_file

    (** The main file. *)
    method index =
      let p = self#index_prefix in
      Printf.sprintf "%s.html" p

    (** The file for the index of values. *)
    method index_values = Printf.sprintf "%s_values.html" self#index_prefix

    (** The file for the index of types. *)
    method index_types = Printf.sprintf "%s_types.html" self#index_prefix

    (** The file for the index of extensions. *)
    method index_extensions =
      Printf.sprintf "%s_extensions.html" self#index_prefix

    (** The file for the index of exceptions. *)
    method index_exceptions =
      Printf.sprintf "%s_exceptions.html" self#index_prefix

    (** The file for the index of attributes. *)
    method index_attributes =
      Printf.sprintf "%s_attributes.html" self#index_prefix

    (** The file for the index of methods. *)
    method index_methods = Printf.sprintf "%s_methods.html" self#index_prefix

    (** The file for the index of classes. *)
    method index_classes = Printf.sprintf "%s_classes.html" self#index_prefix

    (** The file for the index of class types. *)
    method index_class_types =
      Printf.sprintf "%s_class_types.html" self#index_prefix

    (** The file for the index of modules. *)
    method index_modules = Printf.sprintf "%s_modules.html" self#index_prefix

    (** The file for the index of module types. *)
    method index_module_types =
      Printf.sprintf "%s_module_types.html" self#index_prefix

    (** The list of attributes. Filled in the [generate] method. *)
    val mutable list_attributes = []

    method list_attributes = list_attributes

    (** The list of methods. Filled in the [generate] method. *)
    val mutable list_methods = []

    method list_methods = list_methods

    (** The list of values. Filled in the [generate] method. *)
    val mutable list_values = []

    method list_values = list_values

    (** The list of extensions. Filled in the [generate] method. *)
    val mutable list_extensions = []

    method list_extensions = list_extensions

    (** The list of exceptions. Filled in the [generate] method. *)
    val mutable list_exceptions = []

    method list_exceptions = list_exceptions

    (** The list of types. Filled in the [generate] method. *)
    val mutable list_types = []

    method list_types = list_types

    (** The list of modules. Filled in the [generate] method. *)
    val mutable list_modules = []

    method list_modules = list_modules

    (** The list of module types. Filled in the [generate] method. *)
    val mutable list_module_types = []

    method list_module_types = list_module_types

    (** The list of classes. Filled in the [generate] method. *)
    val mutable list_classes = []

    method list_classes = list_classes

    (** The list of class types. Filled in the [generate] method. *)
    val mutable list_class_types = []

    method list_class_types = list_class_types

    method init_style = ()

    (** Get the title given by the user *)
    method title = ""

    (** Build the html code for the link tags in the header, defining section and
       subsections for the titles found in the given comments.*)
    method html_sections_links comments =
      let titles =
        List.flatten (List.map Odoc_info.get_titles_in_text comments)
      in
      let levels =
        let rec iter acc l =
          match l with
          | [] ->
              acc
          | (n, _, _) :: q ->
              if List.mem n acc then iter acc q else iter (n :: acc) q
        in
        iter [] titles
      in
      let sorted_levels = List.sort compare levels in
      let section_level, subsection_level =
        match sorted_levels with
        | [] ->
            (None, None)
        | [ n ] ->
            (Some n, None)
        | n :: m :: _ ->
            (Some n, Some m)
      in
      let titles_per_level level_opt =
        match level_opt with
        | None ->
            []
        | Some n ->
            List.filter (fun (m, _, _) -> m = n) titles
      in
      let section_titles = titles_per_level section_level in
      let subsection_titles = titles_per_level subsection_level in
      let print_lines s_rel titles =
        List.iter
          (fun (n, lopt, t) ->
            let s = Odoc_info.string_of_text t in
            let label = self#create_title_label (n, lopt, t) in
            bp "<link title=\"%s\" rel=\"%s\" href=\"#%s\">\n" s s_rel label )
          titles
      in
      print_lines "Section" section_titles ;
      print_lines "Subsection" subsection_titles

    (** Take a string and return the string where fully qualified
       type (or class or class type) idents
       have been replaced by links to the type referenced by the ident.*)
    method create_fully_qualified_idents_links m_name s : string =
      let ln = !Odoc_global.library_namespace in
      let f (str_t : string) =
        let match_s = Str.matched_string str_t in
        let known_type = StringSet.mem match_s known_types_names in
        let known_class = StringSet.mem match_s known_classes_names in
        let retry, match_s =
          if (not (known_type || known_class)) && ln <> ""
          then (true, Name.get_relative_opt ln match_s)
          else (false, match_s)
        in
        let rel = Name.get_relative m_name match_s in
        let s_final =
          Odoc_info.apply_if_equal Odoc_info.use_hidden_modules match_s rel
        in
        if known_type || (retry && StringSet.mem match_s known_types_names)
        then
          "<a href=\""
          ^ Naming.complete_target Naming.mark_type match_s
          ^ "\">"
          ^ s_final
          ^ "</a>"
        else if known_class
                || (retry && StringSet.mem match_s known_classes_names)
        then
          let html_file, _ = Naming.html_files match_s in
          "<a href=\"" ^ html_file ^ "\">" ^ s_final ^ "</a>"
        else s_final
      in
      Str.global_substitute
        (Str.regexp
           "\\([A-Z]\\([a-zA-Z_'0-9]\\)*\\.\\)+\\([a-z][a-zA-Z_'0-9]*\\)" )
        f
        s

    (** Take a string and return the string where fully qualified module idents
       have been replaced by links to the module referenced by the ident.*)
    method create_fully_qualified_module_idents_links m_name s : string =
      let f str_t =
        let match_s = Str.matched_string str_t in
        let known_module = StringSet.mem match_s known_modules_names in
        let ln = !Odoc_global.library_namespace in
        let retry, match_s =
          if (not known_module) && ln <> ""
          then (true, Name.get_relative_opt ln match_s)
          else (false, match_s)
        in
        let rel = Name.get_relative m_name match_s in
        let s_final =
          Odoc_info.apply_if_equal Odoc_info.use_hidden_modules match_s rel
        in
        if known_module || (retry && StringSet.mem match_s known_modules_names)
        then
          let html_file, _ = Naming.html_files match_s in
          "<a href=\"" ^ html_file ^ "\">" ^ s_final ^ "</a>"
        else s_final
      in
      Str.global_substitute
        (Str.regexp
           "\\([A-Z]\\([a-zA-Z_'0-9]\\)*\\)\\(\\.[A-Z][a-zA-Z_'0-9]*\\)*" )
        f
        s

    method json_of_ident (ident : Ident.t) : Json.t =
      Json.string (Ident.name ident)

    method json_of_path (path : Path.t) : Json.t =
      let open Json in
      match path with
      | Pident (ident : Ident.t) ->
          tagged "Ident" (self#json_of_ident ident)
      | Pdot (t, s) ->
          tagged "Dot" (obj [ ("t", self#json_of_path t); ("s", string s) ])
      | Papply (left, right) ->
          tagged
            "Apply"
            (obj
               [ ("left", self#json_of_path left)
               ; ("right", self#json_of_path right)
               ] )

    method json_of_type_expr (t : Types.type_expr) : Json.t =
      let open Json in
      (* let desc = t.desc in *)
      let rendered =
        Odoc_info.string_of_type_expr t |> Odoc_info.remove_ending_newline
      in
      (*
      let raw =
        match desc with
        | Tvar tvar ->
            tagged "Var" (nullable string tvar)
        | Tnil ->
            tagged "Nil" null
        | Ttuple components ->
            tagged "Tuple" (array self#json_of_type_expr components)
        | Tarrow (label, from, to_, _commutable) ->
            tagged
              "Arrow"
              (obj
                 [ ( "label"
                   , match label with
                     | Nolabel ->
                         tagged "Nolabel" null
                     | Labelled label ->
                         tagged "Labelled" (string label)
                     | Optional label ->
                         tagged "Optional" (string label) )
                 ; ("from", self#json_of_type_expr from)
                 ; ("to", self#json_of_type_expr to_)
                   (* ("commutable",
                        match commutable with
                        | Cok -> tagged "Ok" null
                        | Cunknown -> tagged "Unknown" null
                        | Clink (link : Types.commutable ref) -> tagged "Link" null
                      ) *)
                 ])
        | Tconstr
            ( (path : Path.t)
            , (ts : Types.type_expr list)
            , (_am : Types.abbrev_memo ref) ) ->
            tagged
              "Constr"
              (obj
                 [ ("path", self#json_of_path path)
                 ; ("expressions", array self#json_of_type_expr ts)
                 ])
        | Tobject
            ( (_expression : Types.type_expr)
            , (_b : (Path.t * Types.type_expr list) option ref) ) ->
            tagged "Object" (obj [])
        | Tfield
            ( _string
            , _field_kind
            , (_a : Types.type_expr)
            , (_b : Types.type_expr) ) ->
            tagged "Field" null
        | Tlink type_expr ->
            tagged "Link" (self#json_of_type_expr type_expr)
        | Tsubst type_expr ->
            tagged "Subst" (self#json_of_type_expr type_expr)
        | Tvariant row_desc ->
            tagged
              "Variant"
              (obj
                 [ ("fields", null)
                 ; ("more", self#json_of_type_expr row_desc.row_more)
                 ; ("bound", null)
                 ; ("closed", bool row_desc.row_closed)
                 ; ("fixed", bool row_desc.row_fixed)
                 ; ( "name"
                   , nullable
                       (fun ((_path : Path.t), expressions) ->
                         obj
                           [ ( "expressions"
                             , array self#json_of_type_expr expressions )
                           ])
                       row_desc.row_name )
                 ])
        | Tunivar (univar : string option) ->
            tagged "Univar" (nullable string univar)
        | Tpoly ((_ex : Types.type_expr), (_expressions : Types.type_expr list))
          ->
            tagged "Poly" null
        | Tpackage
            ( (_path : Path.t)
            , (_idents : Longident.t list)
            , (_expressions : Types.type_expr list) ) ->
            tagged "Package" null
      in
      *)
      obj [ ("rendered", string rendered) (*      ("raw", raw) *) ]

    method json_of_rescript_type_expr
        (moduleName : string)
        (funcName : string)
        (extractionKind : extractionKind) : Json.t =
      let open Json in
      let read_file filename =
        let lines = ref [] in
        let chan = open_in filename in
        try
          while true do
            lines := input_line chan :: !lines
          done ;
          !lines
        with
        | End_of_file ->
            close_in chan ;
            List.rev !lines
      in

      let has_type_definition line funcName extractionKind =
        let contains_pars x = String.contains x '(' in
        if contains_pars funcName
        then
          (* detect let/external (~-) (.?[]) (mod) (|>) *)
          let start_i = 1 in
          let close_i = String.index funcName ')' in
          let extracted_val =
            String.sub funcName start_i (close_i - start_i) |> String.trim
          in
          let r_ignore = Str.regexp "[\"ltextrna]" in
          let cleaned_line =
            Str.global_replace r_ignore "" line |> String.trim
          in
          let q_external = Str.quote ("\\" ^ extracted_val) in
          let q_let = Str.quote ("let " ^ extracted_val) in

          let r_external = Str.regexp q_external in
          let r_let = Str.regexp q_let in

          let is_external = Str.string_match r_external cleaned_line 0 in
          let is_let = Str.string_match r_let line 0 in

          is_external || is_let
        else
          (* detect let/external/module/module type function_name *)
          match extractionKind with
          | ExtractManifest ->
              let q_type = Str.quote ("type " ^ funcName) in
              let q_type_rec = Str.quote ("type rec " ^ funcName) in

              let r_type = Str.regexp q_type in
              let r_type_rec = Str.regexp q_type_rec in

              let is_type = Str.string_match r_type line 0 in
              let is_type_rec = Str.string_match r_type_rec line 0 in

              is_type || is_type_rec
          | ExtractRegular ->
              let q_let = Str.quote ("let " ^ funcName ^ ":") in
              let q_external = Str.quote ("external " ^ funcName ^ ":") in
              let q_module = Str.quote ("module " ^ funcName) in
              let q_module_type = Str.quote ("module type " ^ funcName) in

              let r_let = Str.regexp q_let in
              let r_external = Str.regexp q_external in
              let r_module = Str.regexp q_module in
              let r_module_type = Str.regexp q_module_type in

              let is_let = Str.string_match r_let line 0 in
              let is_external = Str.string_match r_external line 0 in
              let is_module = Str.string_match r_module line 0 in
              let is_module_type = Str.string_match r_module_type line 0 in

              is_let || is_external || is_module || is_module_type
      in
      let trim_name line =
        (*let (||): (bool, bool) => bool = "%seqor" => (bool, bool) => bool = "%seqor" *)
        let extract_after_char char =
          match String.split_on_char char line with
          | _ :: result ->
              result |> String.concat (String.make 1 char) |> String.trim
          | _ ->
              line |> String.trim
        in
        match String.index_from_opt line 0 ':' with
        | Some _ ->
            extract_after_char ':'
        | None ->
            extract_after_char '='
      in
      let remove_external line =
        (* (bool, bool) => bool = "%seqor" => (bool, bool) => bool *)
        let q_has_external = Str.quote " = \"" in
        let r_let = Str.regexp q_has_external in
        let result = Str.split r_let line in
        match result with [ result; _ ] -> result | _ -> line
      in
      let is_submodule moduleName =
        match moduleName |> String.split_on_char '.' with
        | [ _ ] ->
            None
        | [ glob; block ] ->
            Some (glob, block)
        | _ ->
            None
      in
      let fetch_rescript_submodule ~file ~block =
        let filename = "./_rescript/" ^ file ^ ".resi" in
        let result = ref [ "" ] in
        let subName = block in
        let handle_line line =
          match has_type_definition line subName ExtractRegular with
          | true ->
              result := List.append [ line ] !result
          | _ ->
            ( match !result with
            | [ "" ] | "}" :: _ ->
                ()
            | _ ->
                result := List.append [ line |> String.trim ] !result )
        in
        let () =
          let lines = read_file filename in
          List.iter handle_line lines
        in
        !result |> List.tl |> List.rev
      in
      let fetch_rescript_type ~moduleName ~funcName =
        let filename = "./_rescript/" ^ moduleName ^ ".resi" in
        let result = ref [ "" ] in
        let handle_line line =
          match (has_type_definition line funcName extractionKind, !result) with
          | true, [ "" ] ->
              result := List.append [ line ] !result
          | _, "" :: rest ->
              ()
          | _ ->
              result := List.append [ line; "\n" ] !result
        in

        let () =
          let lines =
            match moduleName |> is_submodule with
            | Some (file, block) ->
                fetch_rescript_submodule ~file ~block
            | None ->
                read_file filename
          in

          List.iter handle_line lines
        in
        !result |> List.rev |> String.concat "" |> trim_name |> remove_external
      in
      let rendered =
        fetch_rescript_type ~moduleName ~funcName
        |> Odoc_info.remove_ending_newline
      in
      obj [ ("rendered", string rendered) ]

    (** Json to display a [Types.type_expr list]. *)
    method json_of_cstr_args
        ?(par : bool option)
        (m_name : string)
        (constructor_name : string)
        sep
        (l : constructor_args) : Json.t =
      print_DEBUG "json_of_cstr_args" ;

      match l with
      | Cstr_tuple l ->
          print_DEBUG "json_of_cstr_args: 1" ;
          let s = Odoc_info.string_of_type_list ?par sep l in
          let s2 = newline_to_indented_br s in
          print_DEBUG "json_of_cstr_args: 2" ;
          Json.string (self#create_fully_qualified_idents_links m_name s2)
      | Cstr_record l ->
          print_DEBUG "json_of_cstr_args: 1 bis" ;
          bs "<code>" ;
          self#json_of_record
            ~father:m_name
            (Naming.inline_recfield_target m_name constructor_name)
            l

    (** Json to display a [Types.type_expr list] as type parameters
       of a class of class type. *)
    method json_of_class_type_param_expr_list m_name l : Json.t =
      let s = Odoc_info.string_of_class_type_param_list l in
      let s2 = newline_to_indented_br s in
      Json.string (self#create_fully_qualified_idents_links m_name s2)

    method json_of_class_parameter_list father c : Json.t =
      let s = Odoc_info.string_of_class_params c in
      let s = Odoc_info.remove_ending_newline s in
      let s2 = newline_to_indented_br s in
      Json.string (self#create_fully_qualified_idents_links father s2)

    (** Json to display a list of type parameters for the given type.*)
    method json_of_type_expr_param_list m_name t : Json.t =
      let s = Odoc_info.string_of_type_param_list t in
      let s2 = newline_to_indented_br s in
      Json.string (self#create_fully_qualified_idents_links m_name s2)

    method json_of_module_type ?code m_name t : Json.t =
      let s =
        Odoc_info.remove_ending_newline
          (Odoc_info.string_of_module_type ?code t)
      in
      Json.string (self#create_fully_qualified_module_idents_links m_name s)

    (** Json to display the given module kind. *)
    method json_of_module_kind (father : string) ?(modu : t_module option) kind
        : Json.t =
      let open Json in
      match kind with
      | Module_struct (eles : module_element list) ->
          tagged
            "ModuleStruct"
            (array (self#json_of_module_element father) eles)
      | Module_alias (a : module_alias) ->
          tagged
            "ModuleAlias"
            (obj [ ("father", string father); ("name", string a.ma_name) ])
      | Module_functor ((p : module_parameter), (k : module_kind)) ->
          tagged
            "ModuleFunctor"
            (obj
               [ ("parameter", self#json_of_module_parameter father p)
               ; ("result", self#json_of_module_kind father ?modu k)
               ] )
      | Module_apply ((k1 : module_kind), (k2 : module_kind)) ->
          tagged
            "ModuleApply"
            (obj
               [ ("from", self#json_of_module_kind father k1)
               ; ("to", self#json_of_module_kind father k2)
               ] )
      | Module_with ((k : module_type_kind), (s : string)) ->
          tagged
            "ModuleWith"
            (obj
               [ ("kind", self#json_of_module_type_kind father k)
               ; ("s", string s)
               ] )
      | Module_constraint (_k, _tk) ->
          print_endline "Encountered Module_constraint" ;
          null
      | Module_typeof _s ->
          print_endline "Encountered Module_typeof" ;
          null
      | Module_unpack (_code, _mta) ->
          print_endline "Encountered Module_unpack" ;
          null

    method json_of_module_parameter father p : Json.t =
      let open Json in
      tagged
        "ModuleParameter"
        (obj
           [ ("name", string p.mp_name)
           ; ("kind", self#json_of_module_type_kind father p.mp_kind)
           ] )

    method json_of_module_element (m_name : string) (ele : module_element)
        : Json.t =
      match ele with
      | Element_module m ->
          self#json_of_module m
      | Element_module_type mt ->
          self#json_of_modtype mt
      | Element_included_module im ->
          self#json_of_included_module im
      | Element_class c ->
          self#json_of_class ~complete:false c
      | Element_class_type ct ->
          self#json_of_class_type ~complete:false ct
      | Element_value v ->
          self#json_of_value v
      | Element_type_extension te ->
          self#json_of_type_extension m_name te
      | Element_exception e ->
          self#json_of_exception e
      | Element_type t ->
          self#json_of_type t
      | Element_module_comment text ->
          self#json_of_module_comment text

    method json_of_module_type_kind
        father ?modu ?(mt : t_module_type option) (kind : module_type_kind)
        : Json.t =
      let open Json in
      match kind with
      | Module_type_struct eles ->
          tagged
            "ModuleTypeStruct"
            ( match mt with
            | Some mt ->
                string mt.mt_name
            | None ->
              ( match modu with
              | Some m ->
                  string m.m_name
              | None ->
                  array (self#json_of_module_element father) eles ) )
      | Module_type_functor ((p : module_parameter), (k : module_type_kind)) ->
          tagged
            "ModuleTypeFunctor"
            (obj
               [ ("parameter", self#json_of_module_parameter father p)
               ; ("type_kind", self#json_of_module_type_kind father ?modu ?mt k)
               ] )
      | Module_type_alias (a : module_type_alias) ->
          tagged "ModuleTypeAlias" (string a.mta_name)
      | Module_type_with ((k : module_type_kind), (s : string)) ->
          tagged
            "ModuleTypeWith"
            (obj
               [ ("kind", self#json_of_module_type_kind father k)
               ; ("s", string s)
               ] )
      | Module_type_typeof (s : string) ->
          tagged "ModuleTypeTypeof" (string s)

    (** Json to display the type of a module parameter.. *)
    method json_of_module_parameter_type m_name p : Json.t =
      Json.nullable
        (self#json_of_module_type m_name ~code:p.mp_type_code)
        p.mp_type

    method json_of_value v : Json.t =
      let open Json in
      Odoc_info.reset_type_names () ;
      let value_content =
        match destination_json with
        | "model-rescript.json" ->
            self#json_of_rescript_type_expr
              (Name.father v.val_name)
              (Name.simple v.val_name)
              ExtractRegular
        | _ ->
            self#json_of_type_expr v.val_type
      in
      tagged
        "Value"
        (obj
           [ ("name", string (Name.simple v.val_name))
           ; ("qualified_name", string v.val_name)
           ; ("type", value_content)
           ; ("info", self#json_of_info v.val_info)
           ; ( "parameters"
             , self#json_of_described_parameter_list
                 (Name.father v.val_name)
                 v.val_parameters )
           ] )

    method json_of_type_extension (m_name : string) (te : t_type_extension)
        : Json.t =
      let open Json in
      Odoc_info.reset_type_names () ;
      let s2 =
        Odoc_info.string_of_type_extension_param_list te
        |> newline_to_indented_br
      in
      let print_one x : Json.t =
        let father = Name.father x.xt_name in
        ignore father ;
        let constructor_name = Name.simple x.xt_name in
        obj
          [ ("name", string constructor_name)
          ; ("target", string (Naming.extension_target x))
          ; (* ("arguments", )
                 (
                 match x.xt_args, x.xt_ret with
                   | Cstr_tuple [], None -> Json.null
                   | (l, None) ->
                       self#json_of_cstr_args ~par:false father constructor_name " * " l
                   | (Cstr_tuple [], Some r) ->
                       self#json_of_type_expr father r
                   | (l,Some r) -> obj [
                     ("constructor_arguments", self#json_of_cstr_args ~par: falsefather constructor_name " * " l);
                     ("father", self#json_of_type_exprfather r);
                   ]
               ); *)
            ( "alias"
            , match x.xt_alias with
              | None ->
                  null
              | Some xa ->
                ( match xa.xa_xt with
                | None ->
                    string xa.xa_name
                | Some x ->
                    obj
                      [ ("name", string x.xt_name)
                      ; ("target", string (Naming.complete_extension_target x))
                      ] ) )
          ]
      in
      obj
        [ ("name", string (self#create_fully_qualified_idents_links m_name s2))
        ; ( "type_name"
          , string
              (self#create_fully_qualified_idents_links m_name te.te_type_name)
          )
        ; ("private", bool (te.te_private = Asttypes.Private))
        ; ("info", self#json_of_info te.te_info)
        ; ("constructors", array print_one te.te_constructors)
          (* (
               match x.xt_text with
                 | None -> ()
                 | Some t ->
                     bs "<td class=\"typefieldcomment\" align=\"left\" valign=\"top\" >";
                     bs "<code>";
                     bs "(*";
                     bs "</code></td>";
                     bs "<td class=\"typefieldcomment\" align=\"left\" valign=\"top\" >";
                     self#json_of_info(Some t);
                     bs "</td>";
                     bs "<td class=\"typefieldcomment\" align=\"left\" valign=\"bottom\" >";
                     bs "<code>";
                     bs "*)";
                     bs "</code></td>";
             ); *)
        ]

    method json_of_exception e : Json.t =
      let open Json in
      let constructor_name = Name.simple e.ex_name in
      Odoc_info.reset_type_names () ;
      obj
        [ ("name", string constructor_name)
        ; ("target", string (Naming.exception_target e))
        ; ( "alias"
          , nullable
              (fun ea ->
                match ea.ea_ex with
                | None ->
                    string ea.ea_name
                | Some e ->
                    obj
                      [ ("target", string (Naming.complete_exception_target e))
                      ; ("name", string e.ex_name)
                      ] )
              e.ex_alias )
        ; ("info", self#json_of_info e.ex_info)
        ]

    (* (
         let father = Name.father e.ex_name in
         match e.ex_args, e.ex_ret with
         | (Cstr_tuple [], None) -> null
         | (_, None) ->
             self#json_of_cstr_args
                    ~par:false father constructor_name " * " e.ex_args
         | (Cstr_tuple [], Some r) ->
             self#json_of_type_expr father r;
         | (l, Some r) -> obj [
           ("constructor_name",
             self#json_of_cstr_args
                    ~par:false father constructor_name " * " l);
           ("father",
             self#json_of_type_expr father r);
         ]
       ); *)
    method json_of_record ~father _gen_name _l : Json.t =
      ignore father ;
      print_DEBUG "json_of_record" ;
      Json.null

    (* bs "{";
       let print_one r =
         if r.rf_mutable then bs ( "mutable&nbsp;") ;
         self#json_of_type_expr father r.rf_type;
         (
           match r.rf_text with
           | None -> ()
           | Some t ->
               self#json_of_info (Some t);
         );
       in
       Json.array print_one l; *)
    method json_of_type (t : t_type) : Json.t =
      let open Json in
      Odoc_info.reset_type_names () ;
      let father = Name.father t.ty_name in
      tagged
        "Type"
        (obj
           [ ("name", string (Name.simple t.ty_name))
           ; ("parameters", self#json_of_type_expr_param_list father t)
           ; ("is_private", bool (t.ty_private = Asttypes.Private))
           ; ("father", string (Name.father t.ty_name))
           ; ("field_comment", self#json_of_info t.ty_info)
           ; ( "kind"
             , match t.ty_kind with
               | Type_abstract ->
                   tagged "TypeAbstract" null
               | Type_open ->
                   tagged "TypeOpen" null
               | Type_record l ->
                   tagged
                     "TypeRecord"
                     (self#json_of_record ~father (Naming.recfield_target t) l)
               | Type_variant constructors ->
                   let constructor_to_json constr =
                     obj
                       [ ("name", string constr.vc_name)
                       ; ( "arguments"
                         , (self#json_of_cstr_args
                              ~par:false
                              father
                              constr.vc_name
                              " * " )
                             constr.vc_args )
                       ; ( "return"
                         , nullable self#json_of_type_expr constr.vc_ret )
                       ; ( "info"
                         , nullable
                             (fun t -> self#json_of_info (Some t))
                             constr.vc_text )
                       ]
                   in
                   tagged "TypeVariant" (array constructor_to_json constructors)
             )
           ; ( "manifest"
             , match t.ty_manifest with
               | None ->
                   null
               | Some (Object_type fields) ->
                   let json_of_field f =
                     obj
                       [ ("name", string f.of_name)
                       ; ("type", self#json_of_type_expr f.of_type)
                       ; ("comment", self#json_of_info f.of_text)
                       ]
                   in
                   tagged "ObjectType" (array json_of_field fields)
               | Some (Other typ) ->
                   let value_content =
                     match destination_json with
                     | "model-rescript.json" ->
                         self#json_of_rescript_type_expr
                           (Name.father t.ty_name)
                           (Name.simple t.ty_name)
                           ExtractManifest
                     | _ ->
                         self#json_of_type_expr typ
                   in
                   tagged "Other" value_content )
           ; ("info", self#json_of_info t.ty_info)
           ] )

    method json_of_class_attribute (_a : t_attribute) : Json.t =
      print_DEBUG "json_of_class_attribute" ;
      Json.null

    (* let module_name = Name.father (Name.father a.att_value.val_name) in
       bp "<span id=\"%s\">" (Naming.attribute_target a);
       bs ( "val");
       (
        if a.att_virtual then
          bs (( "virtual")^ " ")
        else
          ()
       );
       (
        if a.att_mutable then
          bs (( Odoc_messages.mutab)^ " ")
        else
          ()
       );(
        match a.att_value.val_code with
        | None -> bs (Name.simple a.att_value.val_name)
        | Some c ->
            let file = Naming.file_code_attribute_complete_target a in
            self#output_code a.att_value.val_name (Filename.concat !Global.target_dir file) c;
            bp "<a href=\"%s\">%s</a>" file (Name.simple a.att_value.val_name);
       );

       bs " : ";
       self#json_of_type_expr module_name a.att_value.val_type;
       bs "</pre>";
       self#json_of_info a.att_value.val_info *)

    (** Json for a class method. *)
    method json_of_method _m =
      print_DEBUG "json_of_method" ;
      Json.null

    (* let module_name = Name.father (Name.father m.met_value.val_name) in
       bs "\n<pre>";
       (* html mark *)
       bp "<span id=\"%s\">" (Naming.method_target m);
       bs (( "method")^" ");
        if m.met_private then bs (( "private")^" ");
       if m.met_virtual then bs (( "virtual")^" ");
       (
        match m.met_value.val_code with
        | None -> bs  (Name.simple m.met_value.val_name)
        | Some c ->
            let file = Naming.file_code_method_complete_target m in
            self#output_code m.met_value.val_name (Filename.concat !Global.target_dir file) c;
            bp "<a href=\"%s\">%s</a>" file (Name.simple m.met_value.val_name);
       );

       bs " : ";
       self#json_of_type_expr module_name m.met_value.val_type;
       bs "</pre>";
       self#json_of_info m.met_value.val_info;
       (
          self#json_of_parameter_list b
            module_name m.met_value.val_parameters
       ) *)
    method json_of_parameter_description (p : Parameter.parameter) : Json.t =
      let open Json in
      let json_of_parameter_name name =
        match Parameter.desc_by_name p name with
        | None ->
            Json.null
        | Some t ->
            obj [ ("name", string name); ("description", self#json_of_text t) ]
      in
      Json.array json_of_parameter_name (Parameter.names p)

    (** Json for a list of parameters. *)
    method json_of_parameter_list
        (_m_name : string) (l : Parameter.parameter list) =
      let json_of_parameter p =
        Json.(
          obj
            [ ( "name"
              , string
                  (match Parameter.complete_name p with "" -> "?" | s -> s) )
            ; ("type", self#json_of_type_expr (Parameter.typ p))
            ; ("description", self#json_of_parameter_description p)
            ])
      in
      Json.array json_of_parameter l

    (** Json for the parameters which have a name and description. *)
    method json_of_described_parameter_list (_m_name : string) l =
      let open Json in
      (* get the parameters which have a name, and at least one name described. *)
      let l2 =
        List.filter
          (fun p ->
            List.exists
              (fun n -> Parameter.desc_by_name p n <> None)
              (Parameter.names p) )
          l
      in
      tagged
        "DescribedParameterList"
        (array self#json_of_parameter_description l2)

    (** Json for a list of module parameters. *)
    method json_of_module_parameter_list
        (_m_name : string) (_l : module_parameter list) : Json.t =
      print_DEBUG "json_of_module_parameter_list" ;
      Json.null

    (* match l with
         [] ->
           ()
       | _ ->
           bs "<table border=\"0\" cellpadding=\"3\" width=\"100%\">\n";
           bs "<tr>\n";
           bs "<td align=\"left\" valign=\"top\" width=\"1%%\"><b>";
           bs Odoc_messages.parameters ;
           bs ": </b></td>\n<td>\n";
           bs "<table class=\"paramstable\">\n";
           List.iter
             (fun (p, desc_opt) ->
               bs "<tr>\n";
               bs "<td align=\"center\" valign=\"top\" width=\"15%\">\n<code>" ;
               bs p.mp_name;
               bs "</code></td>\n" ;
               bs "<td align=\"center\" valign=\"top\">:</td>\n";
               bs "<td>" ;
               self#json_of_module_parameter_type m_name p;
               bs "\n";
               (
                match desc_opt with
                | None -> ()
                | Some t ->
                    bs "<div class=\"parameter-desc\" >";
                    self#json_of_text t;
                    bs "\n</div>\n";
                    bs "\n</tr>\n" ;
               )
             )
             l; *)
    method json_of_module (m : t_module) : Json.t =
      let open Json in
      let father = Name.father m.m_name in
      tagged
        "Module"
        (obj
           [ ("name", string (Name.simple m.m_name))
           ; ("kind", self#json_of_module_kind father ~modu:m m.m_kind)
           ; ("info", self#json_of_info m.m_info)
           ] )

    method json_of_modtype (mt : t_module_type) =
      let father = Name.father mt.mt_name in
      let open Json in
      tagged
        "ModuleType"
        (obj
           [ ("name", string (Name.simple mt.mt_name))
           ; ("target", string (Naming.module_type_target mt))
           ; ( "kind"
             , nullable (self#json_of_module_type_kind father ~mt) mt.mt_kind )
           ; ("info", self#json_of_info mt.mt_info)
           ; ( "signature"
             , nullable
                 (fun (m_type : Types.module_type) : Json.t ->
                   string
                     (Odoc_info.string_of_module_type ~complete:true m_type) )
                 mt.mt_type )
           ; ( "elements"
             , array
                 (self#json_of_module_element mt.mt_name)
                 (Module.module_type_elements mt) )
           ] )

    method json_of_included_module (im : included_module) : Json.t =
      let open Json in
      tagged
        "IncludedModule"
        (obj
           [ ("name", string im.im_name)
           ; ("info", self#json_of_info im.im_info)
           ; ( "module"
             , match im.im_module with
               | None ->
                   string im.im_name
               | Some (Mod m) ->
                   tagged "Module" (string m.m_name)
               | Some (Modtype mt) ->
                   tagged "ModuleType" (string mt.mt_name) )
           ] )

    method json_of_class_element element =
      match element with
      | Class_attribute a ->
          self#json_of_class_attribute a
      | Class_method m ->
          self#json_of_method m
      | Class_comment t ->
          self#json_of_class_comment t

    method json_of_class_kind
        (father : string) ?(cl : t_class option) (kind : class_kind) : Json.t =
      print_DEBUG "json_of_class_kind" ;
      ( match kind with
      | Class_structure (inh, eles) ->
        ( match cl with
        | None ->
            (match inh with [] -> () | _ -> self#generate_inheritance_info inh) ;
            Json.array self#json_of_class_element eles |> ignore
        | Some cl ->
            let html_file, _ = Naming.html_files cl.cl_name in
            bp " <a href=\"%s\">..</a> " html_file )
      | Class_apply _ ->
          (* TODO: display final type from typedtree *)
          bs "class application not handled yet"
      | Class_constr cco ->
        ( match cco.cco_type_parameters with
        | [] ->
            ()
        | l ->
            self#json_of_class_type_param_expr_list father l |> ignore )
      (* bs (self#create_fully_qualified_idents_links father cco.cco_name); *)
      (* self#json_of_text [Code "( "] ; *)
      (* self#json_of_class_kind father ck; *)
      (* self#json_of_text [Code " : "] ; *)
      (* self#json_of_class_type_kind father ctk; *)
      (* self#json_of_text [Code " )"] *)
      | Class_constraint (_ck, _ctk) ->
          () ) ;

      Json.null

    method json_of_class_type_kind
        (father : string) ?(ct : t_class option) (kind : class_kind) : Json.t =
      ignore father ;
      ignore ct ;
      ignore kind ;
      failwith "json_of_class_type_kind"

    (* match kind with
         Class_type cta ->
           (
            match cta.cta_type_parameters with
              [] -> ()
            | l ->
                self#json_of_class_type_param_expr_list father l;
                bs " "
           );
           bs "<code class=\"type\">";
           bs (self#create_fully_qualified_idents_links father cta.cta_name);
           bs "</code>"

       | Class_signature (inh, eles) ->
           self#json_of_text [Code "object"];
           (
            match ct with
            | None ->
                bs "\n";
                (
                 match inh with
                   [] -> ()
                 | _ -> self#generate_inheritance_info inh
                );
                List.iter (self#json_of_class_element b) eles
            | Some ct ->
                let (html_file, _) = Naming.html_files ct.clt_name in
                bp " <a href=\"%s\">..</a> " html_file
           );
           self#json_of_text [Code "end"] *)

    (** Json for a class. *)
    method json_of_class ?(complete = true) ?(with_link = true) _c =
      print_DEBUG "json_of_class" ;
      ignore complete ;
      ignore with_link ;
      Json.null

    (* let father = Name.father c.cl_name in
       Odoc_info.reset_type_names ();
       let (html_file, _) = Naming.html_files c.cl_name in
       bs "\n<pre>";
       (* we add a html id, the same as for a type so we can
          go directly here when the class name is used as a type name *)
       bp "<span id=\"%s\">"
         (Naming.type_target
            { ty_name = c.cl_name ;
              ty_info = None ; ty_parameters = [] ;
              ty_kind = Type_abstract ; ty_private = Asttypes.Public;
              ty_manifest = None ;
              ty_loc = Odoc_info.dummy_loc ;
              ty_code = None ;
            }
         );
       bs (( "class")^" ");
       if c.cl_virtual then bs (( "virtual")^" ");
       (
        match c.cl_type_parameters with
          [] -> ()
        | l ->
            self#json_of_class_type_param_expr_list father l;
            bs " "
       );
       print_DEBUG "json_of_class : with link or not" ;
       (
        if with_link then
          bp "<a href=\"%s\">%s</a>" html_file (Name.simple c.cl_name)
        else
          bs (Name.simple c.cl_name)
       );

       bs " : " ;
       self#json_of_class_parameter_list father c ;
       self#json_of_class_kind father ~cl: c c.cl_kind;
       bs "</pre>" ;
       print_DEBUG "json_of_class : info" ;
       (
        if complete then
          self#json_of_info ~indent: true
        else
          self#json_of_info_first_sentence
       ) c.cl_info *)

    (** Json for a class type. *)
    method json_of_class_type ?(complete = true) ?(with_link = true) _ct =
      print_DEBUG "json_of_class_type" ;
      ignore complete ;
      ignore with_link ;
      Json.null

    (* Odoc_info.reset_type_names ();
       let father = Name.father ct.clt_name in
       let (html_file, _) = Naming.html_files ct.clt_name in
       bs "\n<pre>";
       (* we add a html id, the same as for a type so we can
          go directly here when the class type name is used as a type name *)
       bp "<span id=\"%s\">"
         (Naming.type_target
            { ty_name = ct.clt_name ;
              ty_info = None ; ty_parameters = [] ;
              ty_kind = Type_abstract ; ty_private = Asttypes.Public; ty_manifest = None ;
              ty_loc = Odoc_info.dummy_loc ;
              ty_code = None ;
            }
         );
       bs (( "class type")^" ");
       if ct.clt_virtual then bs (( "virtual")^" ");
       (
        match ct.clt_type_parameters with
         [] -> ()
       | l ->
           self#json_of_class_type_param_expr_list father l;
           bs " "
       );

       if with_link then
         bp "<a href=\"%s\">%s</a>" html_file (Name.simple ct.clt_name)
       else
         bs (Name.simple ct.clt_name);

       self#json_of_class_type_kind father ~ct ct.clt_kind;
       (
        if complete then
          self#json_of_info
        else
          self#json_of_info_first_sentence
       ) ct.clt_info *)

    (** represent a dag, represented as in Odoc_dag2html. *)
    method json_of_dag dag : Json.t =
      print_DEBUG "json_of_dag" ;

      (* Json.null *)
      let f n =
        let name, cct_opt = n.Odoc_dag2html.valu in
        (* if we have a c_opt = Some class then we take its information
           because we are sure the name is complete. *)
        let name2, html_file =
          match cct_opt with
          | None ->
              (name, fst (Naming.html_files name))
          | Some (Cl c) ->
              (c.cl_name, fst (Naming.html_files c.cl_name))
          | Some (Cltype (ct, _)) ->
              (ct.clt_name, fst (Naming.html_files ct.clt_name))
        in
        let new_v =
          "<table border=1>\n<tr><td>"
          ^ "<a href=\""
          ^ html_file
          ^ "\">"
          ^ name2
          ^ "</a>"
          ^ "</td></tr>\n</table>\n"
        in
        { n with Odoc_dag2html.valu = new_v }
      in
      let a = Array.map f dag.Odoc_dag2html.dag in
      Json.string (Odoc_dag2html.html_of_dag { Odoc_dag2html.dag = a })

    method json_of_module_comment text = self#json_of_text text

    method json_of_class_comment (text : text_element list) : Json.t =
      self#json_of_text text

    (** Generate html code for the given list of inherited classes.*)
    method generate_inheritance_info (_inher_l : inherited_class list) : unit =
      print_DEBUG "generate_inheritance_info" ;
      ()

    (* let f inh =
         match inh.ic_class with
         | None -> (* we can't make the link. *)
             (Odoc_info.Code inh.ic_name) ::
             (match inh.ic_text with
             | None -> []
             | Some t -> (Odoc_info.Raw "    ") :: t)
         | Some cct ->
             (* we can create the link. *)
             let real_name = (* even if it should be the same *)
               match cct with
                 Cl c -> c.cl_name
               | Cltype (ct, _) -> ct.clt_name
             in
             let (class_file, _) = Naming.html_files real_name in
             (Odoc_info.Link (class_file, [Odoc_info.Code real_name])) ::
             (match inh.ic_text with
             | None -> []
             | Some t -> (Odoc_info.Raw "    ") :: t)
       in
       let text = [
         Odoc_info.Bold [Odoc_info.Raw Odoc_messages.inherits] ;
         Odoc_info.List (List.map f inher_l)
       ]
       in
       self#json_of_text text *)
    method generate_class_inheritance_info (cl : t_class) : Json.t =
      print_DEBUG "generate_class_inheritance_info" ;
      let rec iter_kind k =
        match k with
        | Class_structure ([], _) ->
            ()
        | Class_structure (l, _) ->
            self#generate_inheritance_info l |> ignore ;
            ()
        | Class_constraint (k, _) ->
            iter_kind k
        | Class_apply _ | Class_constr _ ->
            ()
      in
      iter_kind cl.cl_kind ;
      Json.null

    method generate_class_type_inheritance_info (clt : t_class_type) : Json.t =
      ( match clt.clt_kind with
      | Class_signature ([], _) ->
          ()
      | Class_signature (l, _) ->
          self#generate_inheritance_info l |> ignore
      | Class_type _ ->
          () ) ;
      failwith "generate_class_inheritance_info"

    (** A method to create index files. *)
    method generate_elements_index
        : 'a.
             'a list
          -> ('a -> Odoc_info.Name.t)
          -> ('a -> Odoc_info.info option)
          -> ('a -> string)
          -> string
          -> unit =
      fun elements name _info target simple_file ->
        try
          let chanout =
            open_out (Filename.concat !Global.target_dir simple_file)
          in
          let b = Buffer.create 1024 in
          bs "<html>\n" ;
          bs "<body>\n" ;

          let sorted_elements =
            List.sort
              (fun e1 e2 ->
                compare (Name.simple (name e1)) (Name.simple (name e2)) )
              elements
          in
          let groups =
            Odoc_info.create_index_lists sorted_elements (fun e ->
                Name.simple (name e) )
          in
          let f_ele e =
            let simple_name = Name.simple (name e) in
            let father_name = Name.father (name e) in
            if father_name = "Stdlib" && father_name <> simple_name
            then (* avoid duplicata *) ()
            else (
              bp
                "<tr><td><a href=\"%s\">%s</a> "
                (target e)
                (self#escape simple_name) ;
              if simple_name <> father_name && father_name <> ""
              then
                bp
                  "[<a href=\"%s\">%s</a>]"
                  (fst (Naming.html_files father_name))
                  father_name ;
              bs "</td></tr>\n" )
          in
          let f_group l =
            match l with
            | [] ->
                ()
            | e :: _ ->
                let s =
                  match Char.uppercase_ascii (Name.simple (name e)).[0] with
                  | 'A' .. 'Z' as c ->
                      String.make 1 c
                  | _ ->
                      ""
                in
                bs "<tr><td align=\"left\"><div>" ;
                bs s ;
                bs "</div></td></tr>\n" ;
                List.iter f_ele l
          in
          bs "<table>\n" ;
          List.iter f_group groups ;
          bs "</table>\n" ;
          bs "</body>\n</html>\n" ;
          Buffer.output_buffer chanout b ;
          close_out chanout
        with
        | Sys_error s ->
            raise (Failure s)

    (** A method to generate a list of module/class files. *)
    method generate_elements
        : 'a. ('a option -> 'a option -> 'a -> unit) -> 'a list -> unit =
      fun f_generate l ->
        let rec iter pre_opt = function
          | [] ->
              ()
          | [ ele ] ->
              f_generate pre_opt None ele
          | ele1 :: ele2 :: q ->
              f_generate pre_opt (Some ele2) ele1 ;
              iter (Some ele1) (ele2 :: q)
        in
        iter None l

    (** Generate the code of the html page for the given class.*)
    method generate_for_class
        (_pre : t_class option) (_post : t_class option) (_cl : t_class) : unit
        =
      failwith "generate_for_class"

    (* Odoc_info.reset_type_names ();
       let (html_file, _) = Naming.html_files cl.cl_name in
       let type_file = Naming.file_type_class_complete_target cl.cl_name in
       try
         let chanout = open_out (Filename.concat !Global.target_dir html_file) in
         let b = Buffer.create 1024 in
         bs doctype ;
         bs "<html>\n";
         bs "<body>\n";
         bs "<h1>";
         bs (Odoc_messages.clas^" ");
         if cl.cl_virtual then bs "virtual " ;
         bp "<a href=\"%s\">%s</a>" type_file cl.cl_name;
         bs "</h1>\n";
         self#json_of_class ~with_link: false cl;
         (* parameters *)
         self#json_of_described_parameter_list b
           (Name.father cl.cl_name) cl.cl_parameters;
         (* class inheritance *)
         self#generate_class_inheritance_info cl;

         (* the various elements *)
         List.iter (self#json_of_class_element b)
           (Class.class_elements ~trans:false cl);
         bs "</body></html>\n";
         Buffer.output_buffer chanout b;
         close_out chanout;

         (* generate the file with the complete class type *)
         self#output_class_type
           cl.cl_name
           (Filename.concat !Global.target_dir type_file)
           cl.cl_type
       with
         Sys_error s ->
           raise (Failure s) *)

    (** Generate the code of the html page for the given class type.*)
    method generate_for_class_type (_clt : t_class_type) : unit =
      Odoc_info.reset_type_names () ;
      failwith "generate_for_class_type"

    (* let (html_file, _) = Naming.html_files clt.clt_name in
       let type_file = Naming.file_type_class_complete_target clt.clt_name in
       try
         let chanout = open_out (Filename.concat !Global.target_dir html_file) in
         let b = Buffer.create 1024 in
         bs doctype ;
         bs "<html>\n";
         bs "<body>\n";
         bs "<h1>";
         bs (Odoc_messages.class_type^" ");
         if clt.clt_virtual then bs "virtual ";
         bp "<a href=\"%s\">%s</a>" type_file clt.clt_name;
         bs "</h1>\n";
         self#json_of_class_type ~with_link: false clt;

         (* class inheritance *)
         self#generate_class_type_inheritance_info clt;

         (* the various elements *)
         List.iter (self#json_of_class_element b)
           (Class.class_type_elements ~trans: false clt);
         bs "</body></html>\n";
         Buffer.output_buffer chanout b;
         close_out chanout;

         (* generate the file with the complete class type *)
         self#output_class_type
           clt.clt_name
           (Filename.concat !Global.target_dir type_file)
           clt.clt_type
       with
         Sys_error s ->
           raise (Failure s) *)

    (** Generate the html file for the given module type.
       @raise Failure if an error occurs.*)
    method json_for_module_type (mt : t_module_type) : Json.t =
      let open Json in
      obj
        [ ("name", string mt.mt_name)
        ; (* ("paramenter_list", self#json_of_module_parameter_list
             (Name.father mt.mt_name)
             (Module.module_type_parameters mt)); *)
          ( "signature"
          , nullable
              (fun (m_type : Types.module_type) : Json.t ->
                string (Odoc_info.string_of_module_type ~complete:true m_type)
                )
              mt.mt_type )
        ; ( "elements"
          , array
              (self#json_of_module_element mt.mt_name)
              (Module.module_type_elements mt) )
        ]

    (* generate html files for submodules
       self#generate_elements
         self#generate_for_module
         (Module.module_type_modules mt);

       (* generate html files for module types *)
       self#generate_elements
         self#generate_for_module_type
         (Module.module_type_module_types mt);

       (* generate html files for classes *)
       self#generate_elements self#generate_for_class (Module.module_type_classes mt);

       (* generate html files for class types *)
       self#generate_elements self#generate_for_class_type (Module.module_type_class_types mt); *)

    (* generate the file with the complete module type *)
    (* (
        match mt.mt_type with
        | None -> ()
        | Some mty ->
            string (Odoc_info.remove_ending_newline (Odoc_info.string_of_module_type ~complete: true mty))
       ) *)
    (** Generate the html file for the given module.
       @raise Failure if an error occurs.*)

    (* method generate_for_module (modu: t_module) =
       try *)
    (* parameters for functors *)
    (* self#json_of_module_parameter_list
       (Name.father modu.m_name)
       (Module.module_parameters modu); *)

    (* module elements *)
    (* List.iter
       (self#json_of_module_element modu.m_name)
       (Module.module_elements modu); *)

    (* generate html files for submodules *)
    (* self#generate_elements  self#generate_for_module (Module.module_modules modu); *)

    (* generate html files for module types *)
    (* self#generate_elements  self#generate_for_module_type (Module.module_module_types modu); *)

    (* generate html files for classes *)
    (* self#generate_elements  self#generate_for_class (Module.module_classes modu); *)

    (* generate html files for class types *)
    (* self#generate_elements  self#generate_for_class_type (Module.module_class_types modu); *)

    (* generate the file with the complete module type *)
    (* self#output_module_type *)
    (* modu.m_name *)
    (* (Filename.concat !Global.target_dir type_file) *)
    (* modu.m_type; *)

    (* match modu.m_code with
       | None -> ()
       | Some code ->
           self#output_code ~with_pre:false
             modu.m_name
             (Filename.concat !Global.target_dir code_file)
             code *)
    (* with
       Sys_error s -> raise (Failure s) *)

    (** Generate the [<index_prefix>.html] file corresponding to the given module list.

       @raise Failure if an error occurs.*)
    method generate_index module_list =
      try
        let chanout =
          open_out (Filename.concat !Global.target_dir self#index)
        in
        let b = Buffer.create 1024 in
        (match !Global.title with None -> () | Some t -> bs (self#escape t)) ;

        let info =
          Odoc_info.apply_opt
            (Odoc_info.info_of_comment_file module_list)
            !Odoc_info.Global.intro_file
        in
        ( match info with
        | None ->
            (* self#json_of_Index_list (); *)
            (* self#json_of_Module_list (List.map (fun m -> m.m_name) module_list) *)
            Json.null
        | Some _ ->
            self#json_of_info info )
        |> Json.toBuffer b ;

        Buffer.output_buffer chanout b ;
        close_out chanout
      with
      | Sys_error s ->
          raise (Failure s)

    (** Generate the values index in the file [index_values.html]. *)
    method generate_values_index (_module_list : t_module list) =
      self#generate_elements_index
        self#list_values
        (fun v -> v.val_name)
        (fun v -> v.val_info)
        Naming.complete_value_target
        self#index_values

    (** Generate the extensions index in the file [index_extensions.html]. *)
    method generate_extensions_index (_module_list : t_module list) =
      self#generate_elements_index
        self#list_extensions
        (fun x -> x.xt_name)
        (fun x -> x.xt_type_extension.te_info)
        (fun x -> Naming.complete_extension_target x)
        self#index_extensions

    (** Generate the exceptions index in the file [index_exceptions.html]. *)
    method generate_exceptions_index (_module_list : t_module list) =
      self#generate_elements_index
        self#list_exceptions
        (fun e -> e.ex_name)
        (fun e -> e.ex_info)
        Naming.complete_exception_target
        self#index_exceptions

    (** Generate the types index in the file [index_types.html]. *)
    method generate_types_index (_module_list : t_module list) =
      self#generate_elements_index
        self#list_types
        (fun t -> t.ty_name)
        (fun t -> t.ty_info)
        Naming.complete_type_target
        self#index_types

    (** Generate the attributes index in the file [index_attributes.html]. *)
    method generate_attributes_index (_module_list : t_module list) =
      self#generate_elements_index
        self#list_attributes
        (fun a -> a.att_value.val_name)
        (fun a -> a.att_value.val_info)
        Naming.complete_attribute_target
        self#index_attributes

    (** Generate the methods index in the file [index_methods.html]. *)
    method generate_methods_index (_module_list : t_module list) =
      self#generate_elements_index
        self#list_methods
        (fun m -> m.met_value.val_name)
        (fun m -> m.met_value.val_info)
        Naming.complete_method_target
        self#index_methods

    (** Generate the classes index in the file [index_classes.html]. *)
    method generate_classes_index (_module_list : t_module list) =
      self#generate_elements_index
        self#list_classes
        (fun c -> c.cl_name)
        (fun c -> c.cl_info)
        (fun c -> fst (Naming.html_files c.cl_name))
        self#index_classes

    (** Generate the class types index in the file [index_class_types.html]. *)
    method generate_class_types_index (_module_list : t_module list) =
      self#generate_elements_index
        self#list_class_types
        (fun ct -> ct.clt_name)
        (fun ct -> ct.clt_info)
        (fun ct -> fst (Naming.html_files ct.clt_name))
        self#index_class_types

    (** Generate the modules index in the file [index_modules.html]. *)
    method generate_modules_index (_module_list : t_module list) =
      self#generate_elements_index
        self#list_modules
        (fun m -> m.m_name)
        (fun m -> m.m_info)
        (fun m -> fst (Naming.html_files m.m_name))
        self#index_modules

    (** Generate the module types index in the file [index_module_types.html]. *)
    method generate_module_types_index (_module_list : t_module list) =
      self#generate_elements_index
        self#list_module_types
        (fun mt -> mt.mt_name)
        (fun mt -> mt.mt_info)
        (fun mt -> fst (Naming.html_files mt.mt_name))
        self#index_module_types

    (** Generate all the html files from a module list. The main
       file is [<index_prefix>.html]. *)
    method generate (module_list : t_module list) =
      (* init the lists of elements *)
      list_values <- Odoc_info.Search.values module_list ;
      list_extensions <- Odoc_info.Search.extensions module_list ;
      list_exceptions <- Odoc_info.Search.exceptions module_list ;
      list_types <- Odoc_info.Search.types module_list ;
      list_attributes <- Odoc_info.Search.attributes module_list ;
      list_methods <- Odoc_info.Search.methods module_list ;
      list_classes <- Odoc_info.Search.classes module_list ;
      list_class_types <- Odoc_info.Search.class_types module_list ;
      list_modules <- Odoc_info.Search.modules module_list ;
      list_module_types <- Odoc_info.Search.module_types module_list ;

      (* Get the names of all known types. *)
      let types = Odoc_info.Search.types module_list in
      known_types_names <-
        List.fold_left
          (fun acc t -> StringSet.add t.ty_name acc)
          known_types_names
          types ;

      (* Get the names of all class and class types. *)
      let classes = Odoc_info.Search.classes module_list in
      known_classes_names <-
        List.fold_left
          (fun acc c -> StringSet.add c.cl_name acc)
          known_classes_names
          classes ;

      let class_types = Odoc_info.Search.class_types module_list in
      known_classes_names <-
        List.fold_left
          (fun acc ct -> StringSet.add ct.clt_name acc)
          known_classes_names
          class_types ;

      (* Get the names of all known modules and module types. *)
      let modules = Odoc_info.Search.modules module_list in
      known_modules_names <-
        List.fold_left
          (fun acc m -> StringSet.add m.m_name acc)
          known_modules_names
          modules ;

      let module_types : t_module_type list =
        Odoc_info.Search.module_types module_list
      in
      known_modules_names <-
        List.fold_left
          (fun acc mt -> StringSet.add mt.mt_name acc)
          known_modules_names
          module_types ;

      let chanout =
        open_out (Filename.concat !Global.target_dir destination_json)
      in
      let buffer = Buffer.create 1024 in
      module_list
      |> List.rev
      |> function
      | [] ->
          raise (Failure "No modules to generate from")
      | entrypoint :: linkedModules ->
          print_string "Entry point: " ;
          print_endline entrypoint.m_name ;
          print_DEBUG "Linked modules:" ;
          List.iter (fun modu -> print_endline modu.m_name) linkedModules ;
          let open Json in
          toBuffer
            buffer
            (obj
               [ ("entry_point", self#json_of_module entrypoint)
               ; ( "modules"
                 , obj
                     (List.map
                        (fun modu -> (modu.m_name, self#json_of_module modu))
                        linkedModules ) )
                 (* ("module_types", obj (List.map (fun module_type ->  *)
                 (* (module_type.mt_name, self#json_of_modtype module_type)) module_types)); *)
               ] ) ;

          Buffer.output_buffer chanout buffer ;
          close_out chanout
    (* try *)
    (* self#generate_index module_list; *)
    (* self#generate_values_index module_list ; *)
    (* self#generate_extensions_index module_list ; *)
    (* self#generate_exceptions_index module_list ; *)
    (* self#generate_types_index module_list ; *)
    (* self#generate_attributes_index module_list ; *)
    (* self#generate_methods_index module_list ; *)
    (* self#generate_classes_index module_list ; *)
    (* self#generate_class_types_index module_list ; *)
    (* self#generate_modules_index module_list ; *)
    (* self#generate_module_types_index module_list ; *)
    (* with *)
    (* Failure s -> *)
    (* prerr_endline s ; *)
    (* incr Odoc_info.errors *)
  end

module JsonGenerator = struct
  class generator =
    object
      method generate =
        print_endline "Generating" ;

        let jsonGenerator = new json in
        jsonGenerator#generate
    end
end

let _ = Odoc_args.set_generator (Base (module JsonGenerator))
