(** *)

(** Functions for working with single characters.

    Character literals are enclosed in ['a'] pair of single quotes.

    {[let digit = '7']}

    The functions in this module work on ASCII characters (range 0-255) only,
    {b not Unicode}.

    Since character 128 through 255 have varying values depending on what
    standard you are using (ISO 8859-1 or Windows 1252), you are advised to
    stick to the 0-127 range.
*)

type t = char

(** {1 Create}

    You can also create a {!Char} using single quotes:

    {[let char = 'c']}
*)

val from_code : int -> char option
(** Convert an ASCII {{: https://en.wikipedia.org/wiki/Code_point } code point } to a character.

    The full range of extended ASCII is from [0] to [255].
    For numbers outside that range, you get [None].

    {2 Examples}

    {[Char.from_code 65 = Some 'A']}
    {[Char.from_code 66 = Some 'B']}
    {[Char.from_code 3000 = None]}
    {[Char.from_code (-1) = None]}
*)

val from_string : string -> char option
(** Converts a string to character. 

    Returns [None] when the [string] isn't of length one.

    {2 Examples}

    {[Char.from_string "A" = Some 'A']}
    {[Char.from_string " " = Some ' ']}
    {[Char.from_string "" = None]}
    {[Char.from_string "abc" = None]}
    {[Char.from_string " a" = None]}
*)

val is_lowercase : char -> bool
(** Detect lower case ASCII characters.

    {2 Examples}

    {[Char.is_lowercase 'a' = true]}
    {[Char.is_lowercase 'b' = true]}
    {[Char.is_lowercase 'z' = true]}
    {[Char.is_lowercase '0' = false]}
    {[Char.is_lowercase 'A' = false]}
    {[Char.is_lowercase '-' = false]}
*)

val is_uppercase : char -> bool
(** Detect upper case ASCII characters.

    {2 Examples}

    {[Char.is_uppercase 'A' = true]}
    {[Char.is_uppercase 'B' = true]}
    {[Char.is_uppercase 'Z' = true]}
    {[Char.is_uppercase 'h' = false]}
    {[Char.is_uppercase '0' = false]}
    {[Char.is_uppercase '-' = false]}
*)

val is_letter : char -> bool
(** Detect upper and lower case ASCII alphabetic characters.

    {2 Examples}

    {[Char.is_letter 'a' = true]}
    {[Char.is_letter 'b' = true]}
    {[Char.is_letter 'E' = true]}
    {[Char.is_letter 'Y' = true]}
    {[Char.is_letter '0' = false]}
    {[Char.is_letter '-' = false]}
*)

val is_digit : char -> bool
(** Detect when a character is a number.

    {2 Examples}

    {[Char.is_digit '0' = true]}
    {[Char.is_digit '1' = true]}
    {[Char.is_digit '9' = true]}
    {[Char.is_digit 'a' = false]}
    {[Char.is_digit 'b' = false]}
*)

val is_alphanumeric : char -> bool
(** Detect upper case, lower case and digit ASCII characters.

    {2 Examples}

    {[Char.is_alphanumeric 'a' = true]}
    {[Char.is_alphanumeric 'b' = true]}
    {[Char.is_alphanumeric 'E' = true]}
    {[Char.is_alphanumeric 'Y' = true]}
    {[Char.is_alphanumeric '0' = true]}
    {[Char.is_alphanumeric '7' = true]}
    {[Char.is_alphanumeric '-' = false]}
*)

val is_printable : char -> bool
(** Detect if a character is a {{: https://en.wikipedia.org/wiki/ASCII#Printable_characters } printable } character

    A Printable character has a {!Char.to_code} in the range 32 to 127, inclusive ([' '] to ['~']).

    {2 Examples}

    {[Char.is_printable 'G' = true]}
    {[Char.is_printable '%' = true]}
    {[Char.is_printable ' ' = true]}
    {[Char.is_printable '\t' = false]}
    {[Char.is_printable '\007' = false]}
*)

val is_whitespace : char -> bool
(** Detect one of the following characters:
    - ['\t'] (tab)
    - ['\n'] (newline)
    - ['\011'] (vertical tab)
    - ['\012'] (form feed)
    - ['\r'] (carriage return)
    - [' '] (space)

    {2 Examples}

    {[Char.is_whitespace '\t' = true]}
    {[Char.is_whitespace ' ' = true]}
    {[Char.is_whitespace '?' = false]}
    {[Char.is_whitespace 'G' = false]}
*)

val to_lowercase : char -> char
(** Converts an ASCII character to lower case, preserving non alphabetic ASCII characters.

    {2 Examples}

    {[Char.to_lowercase 'A' = 'a']}
    {[Char.to_lowercase 'B' = 'b']}
    {[Char.to_lowercase '7' = '7']} *)

val to_uppercase : char -> char
(** Convert an ASCII character to upper case, preserving non alphabetic ASCII characters.

    {2 Examples}

    {[Char.to_uppercase 'a' = 'A']}
    {[Char.to_uppercase 'b' = 'B']}
    {[Char.to_uppercase '7' = '7']}
*)

val to_code : char -> int
(** Convert [char] to the corresponding ASCII {{: https://en.wikipedia.org/wiki/Code_point } code point}.

    {2 Examples}

    {[Char.to_code 'A' = 65]}
    {[Char.to_code 'B' = 66]}
*)

val to_string : char -> string
(** Convert a character into a [string].

    {2 Examples}

    {[Char.to_string 'A' = "A"]}
    {[Char.to_string '{' = "{"]}
    {[Char.to_string '7' = "7"]}
*)

val to_digit : char -> int option
(** Converts a digit character to its corresponding {!Int}.

    Returns [None] when the character isn't a digit.

    {2 Examples}

    {[Char.to_digit "7" = Some 7]}
    {[Char.to_digit "0" = Some 0]}
    {[Char.to_digit "A" = None]}
    {[Char.to_digit "" = None]}
*)

val equal : t -> t -> bool
(** Test two {!Char}s for equality *)

val compare : t -> t -> int
(** Compare two {!Char}s *)

(** The unique identity for {!Comparator} *)
type identity

val comparator : (t, identity) TableclothComparator.t
