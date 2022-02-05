(** *)

(** A {!Result} is used to represent a computation which may fail.

    A [Result] is a variant, which has a constructor for successful results
    [Ok('ok)], and one for unsuccessful results ([Error('error)]).

    {[
      type t<'ok, 'error> =
        | Ok('ok)
        | Error('error)
    ]}

    Here is how you would annotate a [Result] variable whose [Ok]
    variant is an integer and whose [Error] variant is a string:

    {[
      let ok: Result.t<int, string> = Ok(3)
      let error: Result.t<int, string> = Error("This computation failed!")
    ]}

    {b Note} The ['error] case can be of {b any} type and while [string] is very common you could also use:
    - [Array.t(string)] to allow errors to be accumulated
    - [exn], in which case the result type just makes exceptions explicit in the return type
    - A variant or polymorphic variant, with one case per possible error. This is means each error can be dealt with explicitly. See {{: https://dev.to/kevanstannard/exploring-rescript-exception-handling-57o3 } this excellent article} for more information on this approach.

    If the function you are writing can only fail in a single obvious way, maybe you want an {!Option} instead.
*)

type ('ok, 'error) t = ('ok, 'error) result

(** {1 Create} *)

val ok : 'ok -> ('ok, 'error) t
(** A function alternative to the [Ok] constructor which can be used in places where
    the constructor isn't permitted or functions like {!List.map}.

    {2 Examples}

    {[
      String.reverse("desserts") ->Result.ok == Ok("stressed")
      Array.map([1, 2, 3], ~f=Result.ok) == [Ok(1), Ok(2), Ok(3)]
    ]}
*)

val error : 'error -> ('ok, 'error) t
(** A function alternative to the [Error] constructor which can be used in places where
    the constructor isn't permitted such as at the of a {!Fun.pipe} or functions like {!List.map}.

    {b Note}

    In Rescript you {b can} use constructors with the fast pipe ([->]).

    {[
      5->Ok == Ok(5)
    ]}

    See the {{: https://reasonml.github.io/docs/en/pipe-first#pipe-into-variants} Rescript docs } for more.

    {2 Examples}

    {[
      Int.negate(3)->Result.error == Error(-3)
      Array.map([1, 2, 3], ~f=Result.error) == [Error(1), Error(2), Error(3)]
    ]}
*)

val attempt : (unit -> 'ok) -> ('ok, exn) t
(** Run the provided function and wrap the returned value in a {!Result}, catching any exceptions raised.

    {2 Examples}

    {[
      Result.attempt(() => 5 / 0) // returns Error(Division_by_zero)
      
      Array.map([1, 2, 3], ~f=Result.ok) == [Ok(1), Ok(2), Ok(3)]

      let numbers = [1, 2, 3]
      Result.attempt(() => numbers[3]) // returns Error(Assert_failure)
    ]}
*)

val fromOption : 'ok option -> error:'error -> ('ok, 'error) t
(** Convert an {!Option} to a {!Result} where a [Some(value)] becomes [Ok(value)] and a [None] becomes [Error(error)].

    {2 Examples}

    {[
      Result.fromOption(Some(84), ~error="Greater than 100") == Ok(84)
      
      Result.fromOption(None, ~error="Greater than 100") == Error("Greater than 100")
    ]}
*)

val isOk : (_, _) t -> bool
(** Check if a {!Result} is an [Ok].

    Useful when you want to perform some side effect based on the presence of
    an [Ok] like logging.

    {b Note} if you need access to the contained value rather than doing
    [Result.isOk] followed by {!Result.unwrapUnsafe} its safer and just as
    convenient to use pattern matching directly or use one of {!Result.andThen}
    or {!Result.map}

    {2 Examples}

    {[
      Result.isOk(Ok(3)) == true
      Result.isOk(Error(3)) == false
    ]}
*)

val isError : (_, _) t -> bool
(** Check if a {!Result} is an [Error].

    Useful when you want to perform some side effect based on the presence of
    an [Error] like logging.

    {b Note} if you need access to the contained value rather than doing
    {!Result.isOk} followed by {!Result.unwrapUnsafe} its safer and just as
    convenient to use pattern matching directly or use one of {!Result.andThen}
    or {!Result.map}

    {2 Examples}

    {[
      Result.isError(Ok(3)) == false
      Result.isError(Error(3)) == true
    ]}
*)

val and_ : ('ok, 'error) t -> ('ok, 'error) t -> ('ok, 'error) t
(** Returns the first argument if it {!isError}, otherwise return the second argument.

    Unlike the {!Bool.and_} operator, the [and_] function does not short-circuit.
    When you call [and_], both arguments are evaluated before being passed to the function.

    {2 Examples}

    {[
      Result.and_(Ok("Antelope"), Ok("Salmon")) == Ok("Salmon")
      
     Result.and_(Error(#UnexpectedBird("Finch")), Ok("Salmon"))
     == Error(#UnexpectedBird("Finch"))

      Result.and_(Ok("Antelope"), Error(#UnexpectedBird("Finch")))
      == Error(#UnexpectedBird("Finch"))

      Result.and_(Error(#UnexpectedInvertebrate("Honey Bee")), Error(#UnexpectedBird("Finch")))
      == Error(#UnexpectedInvertebrate("Honey Bee"))
    ]}
*)

val or_ : ('ok, 'error) t -> ('ok, 'error) t -> ('ok, 'error) t
(** Return the first argument if it {!isOk}, otherwise return the second.

  Unlike the built in [||] operator, the [or_] function does not short-circuit.
  When you call [or_], both arguments are evaluated before being passed to the function.

  {2 Examples}

  {[
      Result.or_(Ok("Boar"), Ok("Gecko")) == Ok("Boar")
      Result.or_(Error(#UnexpectedInvertebrate("Periwinkle")), Ok("Gecko")) == Ok("Gecko")
      Result.or_(Ok("Boar"), Error(#UnexpectedInvertebrate("Periwinkle"))) == Ok("Boar") 
      
    Result.or_(Error(#UnexpectedInvertebrate("Periwinkle")), Error(#UnexpectedBird("Robin")))
    == Error(#UnexpectedBird("Robin"))
   ]}
*)

val both : ('a, 'error) t -> ('b, 'error) t -> ('a * 'b, 'error) t
(** Combine two results, if both are [Ok] returns an [Ok] containing a {!Tuple2} of the values.

    If either is an [Error], returns the first [Error].

    The same as writing [Result.map2(~f=Tuple2.make)].

    {2 Examples}

    {[
      Result.both(Ok("Badger"), Ok("Rhino")) == Ok("Dog", "Rhino")
      
      Result.both(Error(#UnexpectedBird("Flamingo")), Ok("Rhino"))
      == Error(#UnexpectedBird("Flamingo"))

      Result.both(Ok("Badger"), Error(#UnexpectedInvertebrate("Blue ringed octopus")))
      == Error(#UnexpectedInvertebrate("Blue ringed octopus"))

      Result.both(
        Error(#UnexpectedBird("Flamingo")),
        Error(#UnexpectedInvertebrate("Blue ringed octopus")),
      ) == Error(#UnexpectedBird("Flamingo"))
    ]}
*)

val flatten : (('ok, 'error) t, 'error) t -> ('ok, 'error) t
(** Collapse a nested result, removing one layer of nesting.

    {2 Examples}

    {[
      Result.flatten(Ok(Ok(2))) == Ok(2)
      
      Result.flatten(Ok(Error(#UnexpectedBird("Peregrin falcon"))))
      == Error(#UnexpectedBird("Peregrin falcon"))

      Result.flatten(Error(#UnexpectedInvertebrate("Woodlouse")))
      == Error(#UnexpectedInvertebrate("Woodlouse"))
    ]}
*)

val unwrap : ('ok, 'error) t -> default:'ok -> 'ok
(** Unwrap a Result using the [~default] value in case of an [Error].

    {2 Examples}

    {[
      Result.unwrap(Ok(12), ~default=0) == 12
      Result.unwrap(Error(#UnexpectedBird("Ostrich")), ~default=0) == 0
    ]}
*)

val unwrapUnsafe : ('ok, _) t -> 'ok
(** Unwrap a Result, raising an exception in case of an [Error].

    {3 Exceptions}

    Raises an [Not_found] exception.

    {2 Examples}

    {[
      Result.unwrapUnsafe(Ok(12)) == 12
      Result.unwrapUnsafe(Error("bad")) // raises Not_found
    ]}
*)

val unwrapError : ('ok, 'error) t -> default:'error -> 'error
(** Like {!Result.unwrap} but unwraps an [Error] value instead.

    {2 Examples}

    {[
      Result.unwrapError(
        Error(#UnexpectedBird("Swallow")),
        ~default=#UnexpectedInvertebrate("Ladybird"),
      ) == #UnexpectedBird("Swallow")

      Result.unwrapError(Ok(5), ~default=#UnexpectedInvertebrate("Ladybird"))
      == #UnexpectedInvertebrate("Ladybird")
    ]}
*)

val map2 :
  ('a, 'error) t -> ('b, 'error) t -> f:('a -> 'b -> 'c) -> ('c, 'error) t
(** Combine two Results.

    If one of the results is an [Error], that becomes the return result.

    If both are [Error] values, returns its first.

    {2 Examples}

    {[
      Result.map2(Ok(7), Ok(3), ~f=Int.add) == Ok(10)
      Result.map2(Error("A"), Ok(3), ~f=Int.add) == Error("A")
      Result.map2(Ok(7), Error("B"), ~f=Int.add) == Error("B")
      Result.map2(Error("A"), Error("B"), ~f=Int.add) == Error("A")
    ]}
*)

val values : ('ok, 'error) t list -> ('ok list, 'error) t
(** If all of the elements of a list are [Ok], returns an [Ok] of the the list of unwrapped values.

    If {b any} of the elements are an [Error], the first one encountered is returned.

    {2 Examples}

    {[
      Result.values(list{Ok(1), Ok(2), Ok(3), Ok(4)}) == Ok(list{1, 2, 3, 4})
      Result.values(list{Ok(1), Error("two"), Ok(3), Error("four")}) == Error("two")
    ]}
*)

val combine : ('ok, 'error) result list -> ('ok list, 'error) result
(**
    [Result.combine(results)] takes a list of [Result] values. If all
    the elements in [results] are of the form [Ok x], then [Result.combine]
    creates a list [xs] of all the values extracted from their [Ok]s, and returns
    [Ok xs]

    If any of the elements in [results] are of the form [Error err],
    the first of them is returned as the result of [Result.combine].

    {2 Examples}

    {[
      Result.combine(list{Ok(1), Ok(2), Ok(3), Ok(4)}) == Ok(list{1, 2, 3, 4})
      Result.combine(list{Ok(1), Error("two"), Ok(3), Error("four")}) == Error("two")
    ]}
  *)

val map : ('a, 'error) t -> f:('a -> 'b) -> ('b, 'error) t
(** Transforms the ['ok] in a result using [f]. Leaves the ['error] untouched.

    {2 Examples}

    {[
      Result.map(Ok(3), ~f=Int.add(1)) == Ok(9)
      Result.map(Error("three"), ~f=Int.add(1)) == Error("three")
    ]}
*)

val mapError : ('ok, 'a) t -> f:('a -> 'b) -> ('ok, 'b) t
(** Transforms the value in an [Error] using [f]. Leaves an [Ok] untouched.

    {2 Examples}

    {[
      Result.mapError(Ok(3), ~f=String.reverse) == Ok(3)
      Result.mapError(Error("bad"), ~f=String.reverse) == Error("dab")
    ]}
*)

val andThen : ('a, 'error) t -> f:('a -> ('b, 'error) t) -> ('b, 'error) t
(** Run a function which may fail on a result.

    Short-circuits of called with an [Error].

    {2 Examples}

    {[
      let reciprical = (x: float): Result.t<float, string> =>
        if x == 0.0 {
          Error("Divide by zero")
        } else {
          Ok(1.0 /. x)
        }

      let root = (x: float): Result.t<float, string> =>
        if x < 0.0 {
          Error("Cannot be negative")
        } else {
          Ok(Float.squareRoot(x))
        }
    
      Result.andThen(Ok(4.0), ~f=reciprical) == Ok(0.25)
      Result.andThen(Error("Missing number!"), ~f=reciprical) == Error("Missing number!")
      Result.andThen(Ok(0.0), ~f=reciprical) == Error("Divide by zero")
      Result.andThen(Ok(4.0), ~f=root)->Result.andThen(~f=reciprical) == Ok(0.5)
      Result.andThen(Ok(-2.0), ~f=root)->Result.andThen(~f=reciprical) == Error("Cannot be negative")
      Result.andThen(Ok(0.0), ~f=root)->Result.andThen(~f=reciprical) == Error("Divide by zero")
    ]}
*)

val tap : ('ok, _) t -> f:('ok -> unit) -> unit
(** Run a function against an [Ok(value)], ignores [Error]s.

    {2 Examples}

    {[
      Result.tap(Ok("Dog"), ~f=Js.log)
      (* logs "Dog" *)
    ]}
 *)

(** {1 Convert} *)

val toOption : ('ok, _) t -> 'ok option
(** Convert a {!Result} to an {!Option}.

    An [Ok x] becomes [Some x]

    An [Error _] becomes [None]

    {2 Examples}

    {[
      Result.toOption(Ok(42)) == Some(42)
      Result.toOption(Error("Missing number!")) == None
    ]}
*)

(** {1 Compare} *)

val equal :
     ('ok, 'error) t
  -> ('ok, 'error) t
  -> ('ok -> 'ok -> bool)
  -> ('error -> 'error -> bool)
  -> bool
(** Test two results for equality using the provided functions.

    {2 Examples}

    {[
      Result.equal(Ok(3), Ok(3), Int.equal, String.equal) == true
      Result.equal(Ok(3), Ok(4), Int.equal, String.equal) == false
      Result.equal(Error("Fail"), Error("Fail"), Int.equal, String.equal) == true
      Result.equal(Error("Expected error"), Error("Unexpected error"), Int.equal, String.equal) == false
      Result.equal(Error("Fail"), Ok(4), Int.equal, String.equal) == false
    ]}
*)

val compare :
     ('ok, 'error) t
  -> ('ok, 'error) t
  -> f:('ok -> 'ok -> int)
  -> g:('error -> 'error -> int)
  -> int
(** Compare results for using the provided functions.
    [f] will be used to compare [Ok]'s and [g] will be used on [Error]s. 

    In the case when one of the results is an [Error] and one is [Ok], [Error]s  are considered 'less' then [Ok]s.

    {2 Examples}

    {[
      Result.compare(Ok(3), Ok(3), ~f=Int.compare, ~g=String.compare) == 0
      Result.compare(Ok(3), Ok(4), ~f=Int.compare, ~g=String.compare) == -1
      Result.compare(Error("Fail"), Error("Fail"), ~f=Int.compare, ~g=String.compare) == 0
      Result.compare(Error("Fail"), Ok(4), ~f=Int.compare, ~g=String.compare) == -1
      Result.compare(Ok(4), Error("Fail"), ~f=Int.compare, ~g=String.compare) == 1
      
      Result.compare(
        Error("Expected error"),
        Error("Unexpected error"),
        ~f=Int.compare,
        ~g=String.compare
      ) == -1
    ]}
*)
