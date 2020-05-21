(** Functions for working with ["strings"] *)

type t = string

(** {1 Create}

    Strings literals are created with the ["double quotes"] syntax.
*)

val fromChar : char -> string
(** Converts the given character to an equivalent string of length one. *)

val from_char : char -> string

val fromArray : char array -> string
(** Create a string from an {!Array} of characters.

    Note that these must be individual characters in single quotes, not strings of length one.

    {2 Examples}

    {[String.fromArray [||] = ""]}

    {[String.fromArray [|'a'; 'b'; 'c'|] = "abc"]}
*)

val from_array : char array -> string

val fromList : char list -> string
(** Create a string from a {!List} of characters.

    Note that these must be individual characters in single quotes, not strings of length one.

    {2 Examples}

    {[String.fromList [] = ""]}

    {[String.fromList ['a'; 'b'; 'c'] = "abc"]}
*)

val from_list : char list -> string

val repeat : string -> count:int -> string
(** Create a string by repeating a string [count] time.

    {3 Exceptions}

    If [count] is negative, [String.repeat] throws a [RangeError] exception.

    {2 Examples}

    {[String.repeat ~count:3 "ok" = "okokok"]}

    {[String.repeat ~count:3 "" = ""]}

    {[String.repeat ~count:0 "ok" = ""]}
*)

val initialize : int -> f:(int -> char) -> string
(** Create a string by providing a length and a function to choose characters.

    Returns an empty string if the length is negative.

    {2 Examples}

    {[String.initialize 8 ~f:(Fun.constant '9') = "999999999"]}
*)

(** {1 Basic operations} *)

val get : string -> int -> char
(** Get the character at the specified index *)

val getAt : string -> index:int -> char option
(** Get the character at [~index] *)

val get_at : string -> index:int -> char option

val ( .?[] ) : string -> int -> char option
(** The {{: https://caml.inria.fr/pub/docs/manual-ocaml/indexops.html } index operator} version of {!getAt}

    {b Note} Currently this is only supported by the OCaml syntax.

    {2 Examples}

    {[("Doggie".String.?[3]) = Some 'g']}

    {[String.("Doggie".?[9]) = None]}
 *)

val reverse : string -> string
(** Reverse a string

    {b Note} This function does not work with Unicode characters.

    {2 Examples}

    {[String.reverse "stressed" = "desserts"]}
*)

val slice : ?to_:int -> string -> from:int -> string
(** Extract a substring from the specified indicies.

    See {!Array.slice}.
*)

(** {1 Query} *)

val isEmpty : string -> bool
(** Check if a string is empty *)

val is_empty : string -> bool

val length : string -> int
(** Returns the length of the given string.

    {b Warning} if the string contains non-ASCII characters then [length] will
    not equal the number of characters

    {2 Examples}

    {[String.length "abc" = 3]}
*)

val startsWith : string -> prefix:string -> bool
(** See if the second string starts with [prefix]

    {2 Examples}

    {[String.startsWith ~prefix:"the" "theory" = true]}

    {[String.startsWith ~prefix:"ory" "theory" = false]}
*)

val starts_with : string -> prefix:string -> bool

val endsWith : string -> suffix:string -> bool
(** See if the second string ends with [suffix].

    {2 Examples}

    {[String.endsWith ~suffix:"the" "theory" = false]}

    {[String.endsWith ~suffix:"ory" "theory" = true]}
*)

val ends_with : string -> suffix:string -> bool

val includes : string -> substring:string -> bool
(** Check if one string appears within another

    {2 Examples}

    {[String.includes "team" ~substring:"tea" = true]}

    {[String.includes "team" ~substring:"i" = false]}

    {[String.includes "ABC" ~substring:"" = true]}
*)

val isCapitalized : string -> bool
(** Test if the first letter of a string is upper case.

    {b Note} This function works only with ASCII characters, not Unicode.

    {2 Examples}

    {[String.isCapitalized "Anastasia" = true]}

    {[String.isCapitalized "" = false]}
*)

val is_capitalized : string -> bool

(** {1 Modify} *)

val dropLeft : string -> count:int -> string
(** Drop [count] characters from the left side of a string.

    {2 Examples}

    {[
      String.dropLeft ~count:3 "abcdefg" = "defg"
      String.dropLeft ~count:0 "abcdefg" = "abcdefg"
      String.dropLeft ~count:7 "abcdefg" = ""
      String.dropLeft ~count:(-2) "abcdefg" = "fg"
      String.dropLeft ~count:8 "abcdefg" = ""
    ]}
*)

val drop_left : string -> count:int -> string

val dropRight : string -> count:int -> string
(** Drop [count] characters from the right side of a string.

    {2 Examples}

    {[
      String.dropRight ~count:3 "abcdefg" = "abcd"
      String.dropRight ~count:0 "abcdefg" = "abcdefg"
      String.dropRight ~count:7 "abcdefg" = ""
      String.dropRight ~count:(-2) "abcdefg" = "abcdefg"
      String.dropRight ~count:8 "abcdefg" = ""
    ]}
*)

val drop_right : string -> count:int -> string

val insertAt : string -> index:int -> value:t -> string
(** Insert a string at [index].

    The character previously at index will now follow the inserted string.

    {2 Examples}

    {[String.insertAt ~insert:"**" ~index:2 "abcde" = "ab**cde"]}

    {[String.insertAt ~insert:"**" ~index:0 "abcde" = "**abcde"]}

    {[String.insertAt ~insert:"**" ~index:5 "abcde" = "abcde**"]}

    {[String.insertAt ~insert:"**" ~index:(-2) "abcde" = "abc**de"]}

    {[String.insertAt ~insert:"**" ~index:(-9) "abcde" = "**abcde"]}

    {[String.insertAt ~insert:"**" ~index:9 "abcde" = "abcde**"]}
*)

val insert_at : string -> index:int -> value:t -> string

val toLowercase : string -> string
(** Converts all upper case letters to lower case.

    {b Note} This function works only with ASCII characters, not Unicode.

    {2 Examples}

    {[String.toLowercase "AaBbCc123" = "aabbcc123"]}
*)

val to_lowercase : string -> string

val toUppercase : string -> string
(** Converts all lower case letters to upper case.

    {b Note} This function works only with ASCII characters, not Unicode.

    {2 Examples}

    {[String.toUppercase "AaBbCc123" = "AABBCC123"]}
*)

val to_uppercase : string -> string

val uncapitalize : string -> string
(** Converts the first letter to lower case if it is upper case.

    {b Note} This function works only with ASCII characters, not Unicode.

    {2 Examples}

    {[String.uncapitalize "Anastasia" = "anastasia"]}
*)

val capitalize : string -> string
(** Converts the first letter of [s] to lowercase if it is upper case.

    {b Note} This function works only with ASCII characters, not Unicode.

    {2 Examples}

    {[String.uncapitalize "den" = "Den"]}
*)

val trim : string -> string
(** Removes leading and trailing {{!Char.isWhitespace} whitespace} from a string

    {2 Examples}

    {[String.trim "  abc  " = "abc"]}

    {[String.trim "  abc def  " = "abc def"]}

    {[String.trim "\r\n\t abc \n\n" = "abc"]}
*)

val trimLeft : string -> string
(** Like {!trim} but only drops characters from the beginning of the string. *)

val trim_left : string -> string

val trim_right : string -> string
(** Like {!trim} but only drops characters from the end of the string. *)

val padLeft : string -> int -> with_:string -> string
(** Pad a string up to a minimum length

    If the string is shorted than the proivded length, adds [with] to the left of the string until the minimum length is met

    {2 Examples}

    {[String.padLeft "5" 3 ~with_:"0" = "005"]}
*)

val pad_left : string -> int -> with_:string -> string

val padRight : string -> int -> with_:string -> string
(** Pad a string up to a minimum length

    If the string is shorted than the proivded length, adds [with] to the left of the string until the minimum length is met

    {2 Examples}

    {[String.padRight "Ahh" 7 ~with_:"h" = "Ahhhhhh"]}
*)

val pad_right : string -> int -> with_:string -> string

(** {1 Deconstruct} *)

val uncons : string -> (char * string) option
(** Returns, as an {!Option}, a tuple containing the first {!Char} and the remaining String.

    If given an empty string, returns [None].

    {2 Examples}

    {[String.uncons "abcde" = Some ('a', "bcde")]}

    {[String.uncons "a" = Some ('a', "")]}

    {[String.uncons "" = None]}
*)

val split : string -> on:string -> string list
(** Divide a string into a list of strings, splitting whenever [on] is encountered.

    {2 Examples}

    {[
      String.split ~on:"/" "a/b/c" = ["a"; "b"; "c"]
      String.split ~on:"--" "a--b--c" = ["a"; "b"; "c"]
      String.split ~on:"/" "abc" = ["abc"]
      String.split ~on:"/" "" = [""]
      String.split ~on:"" "abc" = ["a"; "b"; "c"]
    ]}
*)

(** {1 Iterate} *)

val forEach : string -> f:(char -> unit) -> unit
(** Run [f] on each character in a string. *)

val for_each : string -> f:(char -> unit) -> unit

val fold : string -> initial:'a -> f:('a -> char -> 'a) -> 'a
(** Like {!Array.fold} but the elements are {!Char}s  *)

(** {1 Convert} *)

val toArray : string -> char array
(** Returns an {!Array} of the individual characters in the given string.

    {2 Examples}

    {[String.toArray "" = [||]]}

    {[String.toArray "abc" = [|'a'; 'b'; 'c'|]]}
*)

val to_array : string -> char array

val toList : string -> char list
(** Returns a {!List} of the individual characters in the given string.

    {2 Examples}

    {[String.toList "" = []]}

    {[String.toList "abc" = ['a'; 'b'; 'c']]}
*)

val to_list : string -> char list

(** {1 Compare} *)

val equal : string -> string -> bool
(** Test two string for equality *)

val compare : string -> string -> int
(** Compare two strings. Strings use 'dictionary' ordering.
1
    Also known as {{: https://en.wikipedia.org/wiki/Lexicographical_order } lexicographical ordering }.

    {2 Examples}

    {[String.compare "Z" "A" = 1]}

    {[String.compare "Be" "Bee" = -1]}

    {[String.compare "Pear" "pear" = 1]}

    {[String.compare "Peach" "Peach" = 0]}
*)
