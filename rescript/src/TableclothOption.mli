(** *)

(** {!Option} represents a value which may not be present.

    It is a variant containing the [Some('a)] and [None] constructors

    {[
      type t<'a> =
        | Some('a)
        | None
    ]}

    Many other languages use [null] or [nil] to represent something similar.

    {!Option} values are very common and they are used in a number of ways:
    - Initial values
    - Optional function arguments
    - Optional record fields
    - Return values for functions that are not defined over their entire input range (partial functions).
    - Return value for otherwise reporting simple errors, where [None] is returned on error.

    Lots of functions in [Tablecloth] return options, one you have one you can
    work with the value it might contain by:

    - Pattern matching
    - Using {!map} or {!andThen}
    - Unwrapping it using {!unwrap}
    - Converting a [None] into an exception using{!unwrapUnsafe}

    If the function you are writing can fail in a variety of ways, use a {!Result} instead to
    better communicate with the caller.

    If a function only fails in unexpected, unrecoverable ways, maybe you want raise exception.
*)

type 'a t = 'a option

val some : 'a -> 'a option
(** A function version of the [Some] constructor.

    In most situations you just want to use the [Some] constructor directly.

    Note that when using the Rescript syntax you {b can} use fast pipe ([->]) with variant constructors, so you don't need this function.

    See the {{: https://rescript-lang.org/docs/manual/latest/pipe#pipe-into-variants} Reason docs } for more.

    {2 Examples}

    {[
      String.reverse("desserts")->Option.some == Some("stressed")
      String.reverse("desserts")->Some == Some("stressed")
    ]}
 *)

val and_ : 'a t -> 'a t -> 'a t
(** Returns [None] if the first argument is [None], otherwise return the second argument.

  Unlike the built in [&&] operator, the [and_] function does not short-circuit.

  When you call [and_], both arguments are evaluated before being passed to the function.

  {2 Examples}

  {[
      Option.and_(Some(11), Some(22)) == Some(22)
      Option.and_(None, Some(22)) == None
      Option.and_(Some(11), None) == None
      Option.and_(None, None) == None
    ]}
*)

val or_ : 'a t -> 'a t -> 'a t
(** Return the first argument if it {!isSome}, otherwise return the second.

    Unlike the built in [||] operator, the [or_] function does not short-circuit.
    When you call [or_], both arguments are evaluated before being passed to the function.

    {2 Examples}

    {[
      Option.or_(Some(11), Some(22)) == Some(11)
      Option.or_(None, Some(22)) == Some(22)
      Option.or_(Some(11), None) == Some(11)
      Option.or_(None, None) == None
    ]}
*)

val orElse : 'a t -> 'a t -> 'a t
(** Return the second argument if it {!isSome}, otherwise return the first.

    Like {!or_} but in reverse. Useful when using the [|>] operator

    {2 Examples}

    {[
      Option.orElse(Some(11), Some(22)) == Some(22)
      Option.orElse(None, Some(22)) == Some(22)
      Option.orElse(Some(11), None) == Some(11)
      Option.orElse(None, None) == None
    ]}
*)

val both : 'a t -> 'b t -> ('a * 'b) t
(** Transform two options into an option of a {!Tuple2}.

    Returns None if either of the aguments is None.

    {2 Examples}

    {[
      Option.both(Some(3004), Some("Ant")) == Some(3004, "Ant")
      Option.both(Some(3004), None) == None
      Option.both(None, Some("Ant")) == None
      Option.both(None, None) == None
    ]}
*)

val flatten : 'a t t -> 'a t
(** Flatten two optional layers into a single optional layer.

    {2 Examples}

    {[
      Option.flatten(Some(Some(4))) == Some(4)
      Option.flatten(Some(None)) == None
      Option.flatten(None) == None
    ]}
*)

val map : 'a t -> f:('a -> 'b) -> 'b t
(** Transform the value inside an option.

    Leaves [None] untouched.

    {2 Examples}

    {[
      Option.map(~f=x => x * x, Some(9)) == Some(81)
      Option.map(~f=Int.toString, Some(9)) == Some("9")
      Option.map(~f=x => x * x, None) == None
    ]}
*)

val map2 : 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t
(** Combine two {!Option}s.

    If both options are [Some] returns, as [Some] the result of running [f] on both values.

    If either value is [None], returns [None].

    {2 Examples}

    {[
      Option.map2(Some(3), Some(4), ~f=Int.add) == Some(7)
      Option.map2(Some(3), Some(4), ~f=Tuple.make) == Some(3, 4)
      Option.map2(Some(3), None, ~f=Int.add) == None
      Option.map2(None, Some(4), ~f=Int.add) == None
    ]}
*)

val andThen : 'a t -> f:('a -> 'b t) -> 'b t
(** Chain together many computations that may not return a value.

    It is helpful to see its definition:

    {[
      let andThen = (t, ~f) =>
        switch t {
        | Some(x) => f(x)
        | None => None
        }
    ]}

    This means we only continue with the callback if we have a value.

    For example, say you need to parse some user input as a month:

    {[
      let toValidMonth = (month) =>
        if 1 <= month && month <= 12 {
          Some(month)
        } else {
          None
        }

      let userInput = "5"

      Int.fromString(userInput)->Option.andThen(~f=toValidMonth)
    ]}

    If [Int.fromString] produces [None] (because the [userInput] was not an
    integer) this entire chain of operations will short-circuit and result in
    [None]. If [toValidMonth] results in [None], again the chain of
    computations will result in [None].

    {2 Examples}

    {[
      Option.andThen(Some([1, 2, 3]), ~f=Array.first) == Some(1)
      Option.andThen(Some([]), ~f=Array.first) == None
    ]}
*)

val unwrap : 'a t -> default:'a -> 'a
(** Unwrap an [option<'a>] returning [default] if called with [None].

    This comes in handy when paired with functions like {!Map.get},
    {!Array.first} or {!List.head} which return an {!Option}.

    {b Note:} This can be overused! Many cases are better handled using pattern matching, {!map} or {!andThen}.

    {2 Examples}

    {[
      Option.unwrap(Some(42), ~default=99) == 42
      Option.unwrap(None, ~default=99) == 99
      Option.unwrap(Map.get(Map.String.empty, "Tom"), ~default="unknown") == "unknown"
    ]}
*)

val unwrapUnsafe : 'a t -> 'a
(** Unwrap an [option('a)] returning the enclosed ['a].

    {b Note} in most situations it is better to use pattern matching, {!unwrap}, {!map} or {!andThen}.
    Can you structure your code slightly differently to avoid potentially raising an exception?

    {3 Exceptions}

    Raises an [Invalid_argument] exception if called with [None]

    {2 Examples}

    {[
      Array.first([1, 2, 3])->Option.unwrapUnsafe == 1
      Array.first([])->Option.unwrapUnsafe // will raise Invalid_argument
    ]}
*)

val isSome : 'a t -> bool
(** Check if an {!Option} is a [Some].

    In most situtations you should just use pattern matching instead.

    {2 Examples}

    {[
      Option.isSome(Some(3004)) == true
      Option.isSome(None) == false
    ]}
*)

val isNone : 'a t -> bool
(** Check if an {!Option} is a [None].

    In most situtations you should just use pattern matching instead.

    {2 Examples}

    {[
      Option.isNone(Some(3004)) == false
      Option.isNone(None) == true
    ]}
*)

val tap : 'a t -> f:('a -> unit) -> unit
(** Run a function against an [Some(value)], ignores [None]s.

    {2 Examples}

    {[
      Option.tap(Some("Dog"), ~f=Js.log)
      (* logs "Dog" *)
    ]} 
*)

val toArray : 'a t -> 'a array
(** Convert an option to an {!Array}.

    [None] is represented as an empty array and [Some] is represented as an array of one element.

    {2 Examples}

    {[
      Option.toArray(Some(3004)) == [3004]
      Option.toArray(None) == [
    ]}
*)

val toList : 'a t -> 'a list
(** Convert an option to a {!List}.

    [None] is represented as an empty list and [Some] is represented as a list of one element.

    {2 Examples}

    {[
      Option.toList(Some(3004)) == list{3004}
      Option.toList(None) == list{}
    ]}
*)

(** {1 Compare} *)

val equal : 'a t -> 'a t -> ('a -> 'a -> bool) -> bool
(** Test two optional values for equality using the provided function.

    {2 Examples}

    {[
      Option.equal(Some(1), Some(1), Int.equal) == true
      Option.equal(Some(1), Some(3), Int.equal) == false
      Option.equal(Some(1), None, Int.equal) == false
      Option.equal(None, None, Int.equal) == true
    ]}
*)

val compare : 'a t -> 'a t -> f:('a -> 'a -> int) -> int
(** Compare two optional values using the provided [f] function.

    A [None] is "less" than a [Some].

    {2 Examples}

    {[
      Option.compare(Some(1), Some(3), ~f=Int.compare) == -1
      Option.compare(Some(1), None, ~f=Int.compare) == 1
      Option.compare(None, None, ~f=Int.compare) == 0
    ]}
*)
