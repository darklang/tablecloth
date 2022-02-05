(** *)

(** Functions for working with ["strings"] *)

type t = string

(** {1 Create}

    Strings literals are created with the ["double quotes"], [`backticks`] syntax.
    {b Warning} If string contains non-ASCII characters, use [`backticks`]

*)

val fromChar : char -> string
(** Converts the given character to an equivalent string of length one. *)

val fromArray : char array -> string
(** Create a string from an {!Array} of characters.

    Note that these must be individual characters in single quotes, not strings of length one.

    {2 Examples}

    {[
      String.fromArray([]) == ""
      String.fromArray(['a', 'b', 'c']) == "abc"
    ]}
*)

val fromList : char list -> string
(** Create a string from a {!List} of characters.

    Note that these must be individual characters in single quotes, not strings of length one.

    {2 Examples}

    {[
      String.fromList(list{}) == ""
      String.fromList(list{'a', 'b', 'c'}) == "abc"
    ]}
*)

val repeat : string -> count:int -> string
(** Create a string by repeating a string [count] time.

    {3 Exceptions}

    If [count] is negative, [String.repeat] throws a [RangeError] exception.

    {2 Examples}

    {[
      String.repeat("ok", ~count=3) == "okokok"
      String.repeat("", ~count=3) == ""
      String.repeat("ok", ~count=0) == ""
    ]}
*)

val initialize : int -> f:(int -> char) -> string
(** Create a string by providing a length and a function to choose characters.

    Returns an empty string if the length is negative.

    {2 Examples}

    {[
      String.initialize(8, ~f=Fun.constant('9')) == "99999999"
    ]}
*)

(** {1 Basic operations} *)

val get : string -> int -> char
(** Get the character at the specified index 

    {3 Exceptions}

    If index out of range, throws a [Invalid_argument] exception.
    Concider using {!getAt}, it returns an [option<char>]

    {2 Examples}

    {[
      String.get("stressed", 1) == 't'
    ]}

*)

val getAt : string -> index:int -> char option
(** Get the character at [~index] *)

val reverse : string -> string
(** Reverse a string

    {2 Examples}

    {[
      String.reverse("stressed") == "desserts"
    ]}
*)

val slice : ?to_:int -> string -> from:int -> string
(** Extract a substring from the specified indicies.

    See {!Array.slice}.
*)

(** {1 Query} *)

val isEmpty : string -> bool
(** Check if a string is empty *)

val length : string -> int
(** Returns the length of the given string.

    {2 Examples}

    {[
      String.length("abc") == 3
    ]}
*)

val startsWith : string -> prefix:string -> bool
(** See if the string starts with [prefix].

    {2 Examples}

    {[
      String.startsWith("theory", ~prefix="the") == true
      String.startsWith("theory", ~prefix="ory") == false
    ]}
*)

val endsWith : string -> suffix:string -> bool
(** See if the string ends with [suffix].

    {2 Examples}

    {[
      String.endsWith("theory", ~suffix="the") == false
      String.endsWith("theory", ~suffix="ory") == true
    ]}
*)

val includes : string -> substring:string -> bool
(** Check if one string appears within another

    {2 Examples}

    {[
      String.includes("team", ~substring="tea") == true
      String.includes("team", ~substring="i") == false
      String.includes("ABC", ~substring="") == true
    ]}
*)

val isCapitalized : string -> bool
(** Test if the first letter of a string is upper case.

    {2 Examples}

    {[
      String.isCapitalized("Anastasia") == true
      String.isCapitalized("") == false
    ]}
*)

val dropLeft : string -> count:int -> string
(** Drop [count] characters from the left side of a string.

    {2 Examples}

    {[
      String.dropLeft("abcdefg", ~count=3) == "defg"
      String.dropLeft("abcdefg", ~count=0) == "abcdefg"
      String.dropLeft("abcdefg", ~count=7) == ""
      String.dropLeft("abcdefg", ~count=-2) == "fg"
      String.dropLeft("abcdefg", ~count=8) == ""
    ]}
*)

val dropRight : string -> count:int -> string
(** Drop [count] characters from the right side of a string.

    {2 Examples}

    {[
      String.dropRight("abcdefg", ~count=3) == "abcd"
      String.dropRight("abcdefg", ~count=0) == "abcdefg"
      String.dropRight("abcdefg", ~count=7) == ""
      String.dropRight("abcdefg", ~count=-2) == "abcdefg"
      String.dropRight("abcdefg", ~count=8) == ""
    ]}
*)

val indexOf : string -> string -> int option
(** Returns the index of the first occurrence of [string] or None if string has no occurences of [string]

    {2 Examples}

    {[
      String.indexOf("Hello World World", "World") == Some(6)
      String.indexOf("Hello World World", "Bye") == None
    ]}
*)

val indexOfRight : string -> string -> int option
(** Returns the index of the last occurrence of [string] or None if string has no occurences of [string]

    {2 Examples}

    {[
      String.indexOfRight("Hello World World", "World") == Some(12)
      String.indexOfRight("Hello World World", "Bye") == None
    ]}
*)

val insertAt : string -> index:int -> value:t -> string
(** Insert a string at [index].

    The character previously at index will now follow the inserted string.

    {2 Examples}

    {[
      String.insertAt("abcde", ~value="**", ~index=2) == "ab**cde"
      String.insertAt("abcde", ~value="**", ~index=0) == "**abcde"
      String.insertAt("abcde", ~value="**", ~index=5) == "abcde**"
      String.insertAt("abcde", ~value="**", ~index=-2) == "abc**de"
      String.insertAt("abcde", ~value="**", ~index=-9) == "**abcde"
      String.insertAt("abcde", ~value="**", ~index=9) == "abcde**"
    ]}
*)

val toLowercase : string -> string
(** Converts all upper case letters to lower case.

    {2 Examples}

    {[
      String.toLowercase("AaBbCc123") == "aabbcc123"
    ]}
*)

val toUppercase : string -> string
(** Converts all lower case letters to upper case.

    {2 Examples}

    {[
      String.toUppercase("AaBbCc123") == "AABBCC123"
    ]}
*)

val uncapitalize : string -> string
(** Converts the first letter to lower case if it is upper case.

    {2 Examples}

    {[
      String.uncapitalize("Anastasia") == "anastasia"
    ]}
*)

val capitalize : string -> string
(** Converts the first letter of [s] to lowercase if it is upper case.

    {2 Examples}

    {[
      String.capitalize("den") == "Den"
    ]}
*)

val trim : string -> string
(** Removes leading and trailing {{!Char.isWhitespace} whitespace} from a string

    {2 Examples}

    {[
      String.trim("  abc  ") == "abc"
      String.trim("  abc def  ") == "abc def"
      String.trim("\r\n\t abc \n\n") == "abc"
    ]}
*)

val trimLeft : string -> string
(** Like {!trim} but only drops characters from the beginning of the string. *)

val trimRight : string -> string
(** Like {!trim} but only drops characters from the end of the string. *)

val padLeft : string -> int -> with_:string -> string
(** Pad a string up to a minimum length.

    If the string is shorted than the proivded length, adds [with_]
    to the left of the string until the minimum length is met.

    {2 Examples}

    {[
      String.padLeft("5", 3, ~with_="0") == "005"
    ]}
*)

val padRight : string -> int -> with_:string -> string
(** Pad a string up to a minimum length.

    If the string is shorted than the proivded length, adds [with_]
    to the left of the string until the minimum length is met.

    {2 Examples}

    {[
      String.padRight("Ahh", 7, ~with_="h") == "Ahhhhhh"
    ]}
*)

val uncons : string -> (char * string) option
(** Returns, as an {!Option}, a tuple containing the first {!Char} and the remaining String.

    If given an empty string, returns [None].

    {2 Examples}

    {[
      String.uncons("abcde") == Some('a', "bcde")
      String.uncons("a") == Some('a', "")
      String.uncons("") == None
    ]}
*)

val split : string -> on:string -> string list
(** Divide a string into a list of strings, splitting whenever [on] is encountered.

    {2 Examples}

    {[
      String.split("a/b/c", ~on="/") == list{"a", "b", "c"}
      String.split("a--b--c", ~on="--") == list{"a", "b", "c"}
      String.split("abc", ~on="/") == list{"abc"}
      String.split("", ~on="/") == list{""}
      String.split("abc", ~on="") == list{"a", "b", "c"}
    ]}
*)

(** {1 Iterate} *)

val forEach : string -> f:(char -> unit) -> unit
(** Run [f] on each character in a string. *)

val fold : string -> initial:'a -> f:('a -> char -> 'a) -> 'a
(** Like {!Array.fold} but the elements are {!Char}s  *)

(** {1 Convert} *)

val toArray : string -> char array
(** Returns an {!Array} of the individual characters in the given string.

    {2 Examples}

    {[
      String.toArray("") == []
      String.toArray("abc") == ['a', 'b', 'c']
    ]}
*)

val toList : string -> char list
(** Returns a {!List} of the individual characters in the given string.

    {2 Examples}

    {[
      String.toList("") == list{}
      String.toList("abc") == list{'a', 'b', 'c'}
    ]}
*)

(** {1 Compare} *)

val equal : string -> string -> bool
(** Test two string for equality. *)

val compare : string -> string -> int
(** Compare two strings. Strings use 'dictionary' ordering.
1
    Also known as {{: https://en.wikipedia.org/wiki/Lexicographical_order } lexicographical ordering }.

    {2 Examples}

    {[
      String.compare("Z", "A") == 1
      String.compare("Be", "Bee") == -1
      String.compare("Pear", "pear") == 1
      String.compare("Peach", "Peach") == 0
    ]}
*)

(** The unique identity for {!Comparator} *)
type identity

val comparator : (t, identity) TableclothComparator.t
