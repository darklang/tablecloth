(** *)

(** Functions for working with functions.

    While the functions in this module can often make code more concise, this
    often imposes a readability burden on future readers.
*)

external identity : 'a -> 'a = "%identity"
(** Given a value, returns exactly the same value. This may seem pointless at first glance but it can often be useful when an api offers you more control than you actually need.

    Perhaps you want to create an array of integers

    {[
      Array.initialize(6, ~f=Fun.identity) == [0, 1, 2, 3, 4, 5]
    ]}

    (In this particular case you probably want to use {!Array.range}.)

    Or maybe you need to register a callback, but dont want to do anything:

    {[
      let httpMiddleware = HttpLibrary.createMiddleWare(
        ~onEventYouDoCareAbout=transformAndReturn,
        ~onEventYouDontCareAbout=Fun.identity,
      )
   ]}
*)

external ignore : _ -> unit = "%ignore"
(** Discards the value it is given and returns [()]

    This is primarily useful when working with imperative side-effecting code
    or to avoid [unused value] compiler warnings when you really meant it,
    and haven't just made a mistake.

    {2 Examples}

    {[
      (* Pretend we have a module with the following signature:
          module type PretendMutableQueue = {
            type t<'a>

            (** Adds an element to the queue, returning the new length of the queue *)
            let pushReturningLength: (t<'a>, 'a) => int
          }
      *)

      let addArrayToQueue = (queue, array) =>
        Array.forEach(array, ~f=element =>
          PretendMutableQueue.pushReturningLength(queue, element)
        )->Fun.ignore
   ]}
*)

val constant : 'a -> 'b -> 'a
(** Create a function that {b always} returns the same value.

    Useful with functions like {!List.map} or {!Array.initialize}.

    {2 Examples}

    {[
      Array.map([1, 2, 3, 4, 5], ~f=Fun.constant(0)) == [0, 0, 0, 0, 0]
      Array.initialize(6, ~f=Fun.constant(0)) == [0, 0, 0, 0, 0, 0]
    ]}
*)

val sequence : 'a -> 'b -> 'b
(** A function which always returns its second argument. *)

val flip : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c
(** Reverses the argument order of a function.

    For any arguments [x] and [y], [flip(f)(x, y)] is the same as [f(y, x)].

    Perhaps you want to [fold] something, but the arguments of a function you
    already have access to are in the wrong order.
*)

val negate : ('a -> bool) -> 'a -> bool
(** Negate a function.

    This can be useful in combination with {!List.filter} / {!Array.filter} or {!List.find} / {!Array.find}.

    {2 Examples}

    {[
      let isLessThanTwelve = Fun.negate(n => n >= 12)
      isLessThanTwelve(12) == false
   ]}
*)

val apply : ('a -> 'b) -> 'a -> 'b
(** Calls function [f] with an argument [x].

    [apply(f, x)] is exactly the same as [f(x)].

    Maybe you want to apply a function to a [switch] expression? That sort of thing.
*)

val compose : 'a -> ('a -> 'b) -> ('b -> 'c) -> 'c
(** Function composition, passing result from left to right.

    This is usefull in cases when you want to make multiple transformations
    during a [map] operation.

    {2 Examples}

    {[
      let numbers = [1, 2, 3, 4, 5, 6, 7]

      let multiplied = Array.map(numbers, ~f=Fun.compose(Int.multiply(5), Int.toString))

      multiplied == ["5", "10", "15", "20", "25", "30", "35"]
   ]}
*)

val composeRight : 'a -> ('b -> 'c) -> ('a -> 'b) -> 'c
(** Function composition, passing result from right to left.

    Same as [!compose], but function application order is reversed.

    This is usefull in cases when you want to make multiple transformations
    during a [map] operation.
    
    {2 Examples}

    {[
      let numbers = [1, 2, 3, 4, 5, 6, 7]

      let a = (b) => b -> Fun.compose(Int.toString, Int.multiply(5))

      multiplied == ["5", "10", "15", "20", "25", "30", "35"]
   ]}
*)

val tap : 'a -> f:('a -> unit) -> 'a
(** Useful for performing some side affect in {!Fun.pipe}-lined code.

    Most commonly used to log a value in the middle of a pipeline of function calls.

    {2 Examples}

    {[
      let sanitize = (input: string): option<int> =>
        input
        ->String.trim
        ->Fun.tap(~f=Js.log)
        ->Int.fromString

      Array.filter([1, 3, 2, 5, 4], ~f=Int.isEven)
      ->Fun.tap(~f=numbers => numbers[0] = 0)
      ->Fun.tap(~f=Array.reverse) == [4, 0]
   ]}
*)

val forever : (unit -> unit) -> exn
(** Runs the provided function, forever.

    If an exception is thrown, returns the exception.
*)

val times : int -> f:(unit -> unit) -> unit
(** Runs a function repeatedly.

    {2 Examples}

    {[
      let count = ref(0)
      Fun.times(10, ~f=() => count.contents = count.contents + 1)
      count.contents == 10
   ]}
*)

val curry : ('a * 'b -> 'c) -> 'a -> 'b -> 'c
(** Takes a function [f] which takes a single argument of a tuple [('a, 'b)] and returns a function which takes two arguments that can be partially applied.

    {2 Examples}

    {[
      let squareArea = ((width, height)) => width * height
      let curriedArea: (int, int) => int = Fun.curry(squareArea)
      let sizes = [3, 4, 5]
      Array.map(sizes, ~f=curriedArea(4)) == [12, 16, 20]
   ]}
*)

val uncurry : ('a -> 'b -> 'c) -> 'a * 'b -> 'c
(** Takes a function which takes two arguments and returns a function which takes a single argument of a tuple.

    {2 Examples}

    {[
      let sum = (a: int, b: int): int => a + b
      let uncurriedSum: ((int, int)) => int = Fun.uncurry(sum)
      uncurriedSum((3, 4)) == 7
   ]}
*)

val curry3 : ('a * 'b * 'c -> 'd) -> 'a -> 'b -> 'c -> 'd
(** Like {!curry} but for a {!Tuple3}. *)

val uncurry3 : ('a -> 'b -> 'c -> 'd) -> 'a * 'b * 'c -> 'd
(** Like {!uncurry} but for a {!Tuple3}. *)
