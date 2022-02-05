(** *)

(** A mutable vector of elements which must have the same type.

    Has constant time (O(1)) {!get}, {!set} and {!length} operations.

    Arrays have a fixed length, if you want to be able to add an arbitrary number of elements maybe you want a {!List}.
*)

type 'a t = 'a array

(** {1 Create}

    You can create an [array] in Rescript with the [[1, 2, 3]] syntax.
*)

val singleton : 'a -> 'a t
(** Create an array with only one element.

    {2 Examples}

    {[
      Array.singleton(1234) == [1234]
      Array.singleton("hi") == ["hi"]
    ]}
*)

val repeat : 'a -> length:int -> 'a t
(** Creates an array of length [length] with the value [x] populated at each index.

    {2 Examples}

    {[
      Array.repeat('a', ~length=5) == ['a', 'a', 'a', 'a', 'a']
      Array.repeat(7, ~length=0) == []
      Array.repeat("Why?", ~length=-1) == []
    ]}
*)

val range : ?from:int -> int -> int t
(** Creates an array containing all of the integers from [from] if it is provided or [0] if not, up to but not including [to].

    {2 Examples}

    {[
      Array.range(5) == [0, 1, 2, 3, 4]
      Array.range(5, ~from=2) == [2, 3, 4]
      Array.range(3, ~from=-2) == [-2, -1, 0, 1, 2]
    ]}
*)

val initialize : int -> f:(int -> 'a) -> 'a t
(** Initialize an array. [Array.initialize n ~f] creates an array of length [n] with
    the element at index [i] initialized to the result of [(f i)].

    {2 Examples}

    {[
      Array.initialize(4, ~f=identity) == [0, 1, 2, 3]
      Array.initialize(4, ~f=n => n * n) == [0, 1, 4, 9]
    ]}
*)

val fromList : 'a list -> 'a t
(** Create an array from a {!List}.

    {2 Examples}

    {[
      Array.fromList(list{1, 2, 3}) == [1, 2, 3]
    ]}
*)

val clone : 'a t -> 'a t
(** Create a shallow copy of an array.

    {2 Examples}

    {[
      let numbers = [1, 2, 3]
      let otherNumbers = Array.copy(numbers)
      numbers[1] == 9
      numbers == [1, 9, 3]
      otherNumbers == [1, 2, 3]
      
      let numberGrid = [
        [1, 2, 3], 
        [4, 5, 6], 
        [7, 8, 9]
        ]

      let numberGridCopy = Array.copy(numberGrid)

      numberGrid[1][1] == 0
      numberGridCopy[1][1] == 9
    ]}
*)

(** {1 Basic operations} *)

val get : 'a t -> int -> 'a
(** Get the element at the specified index.

    The first element has index number 0.

    The last element has index number [Array.length(a) - 1].

    You should prefer using the dedicated literal syntax:

    {[
      array[n]
    ]}

    Or using the safer {!Array.getAt} function.

    {3 Exceptions}

    Raises [Invalid_argument("index out of bounds")] for indexes outside of the range [0] to [(Array.length a - 1)].

    {2 Examples}

    {[
      [1, 2, 3, 2, 1][3] == 2
      
      let animals = ["cat", "dog", "eel"]
      animals[2] == "eel"
    ]}
*)

val getAt : 'a t -> index:int -> 'a option
(** Returns, as an {!Option}, the element at index number [n] of array [a].

    Returns [None] if [n] is outside the range [0] to [(Array.length(a) - 1)].

    {2 Examples}

    {[
      Array.getAt([0, 1, 2], ~index=5) == None
      Array.getAt([], ~index=0) == None
    ]}
*)

val set : 'a t -> int -> 'a -> unit
(** Modifies an array in place, replacing the element at [index] with [value].

    You should prefer either to write

    {[
      array[index] = value
    ]}

    Or use the {!setAt} function instead.

    {3 Exceptions}

    Raises [Invalid_argument("index out of bounds")] if [n] is outside the range [0] to [Array.length(a) - 1].

    {2 Examples}

    {[
      let numbers = [1, 2, 3]
      Array.set(numbers, 1, 1)
      numbers[2] = 0

      numbers  == [1, 1, 0]
    ]}
*)

val setAt : 'a t -> index:int -> value:'a -> unit
(** Like {!set} but with labelled arguments. *)

val first : 'a t -> 'a option
(** Get the first element of an array.

    Returns [None] if the array is empty.

    {2 Examples}

    {[
      Array.first([1, 2, 3]) == Some(1)
      Array.first([1]) == Some(1)
      Array.first([]) == None
    ]}
*)

val last : 'a t -> 'a option
(** Get the last element of an array.

    Returns [None] if the array is empty.

    {2 Examples}

    {[
      Array.last([1, 2, 3]) == Some(3)
      Array.last([1]) == Some(1)
      Array.last([]) == None
    ]}
*)

val slice : ?to_:int -> 'a t -> from:int -> 'a t
(** Get a sub-section of an array. [from] is a zero-based index where we will start our slice.

    The [to_] is a zero-based index that indicates the end of the slice.

    The slice extracts up to but not including [to_].

    Both the [from] and [to_] indexes can be negative, indicating an offset from the end of the array.

    {2 Examples}

    {[
      Array.slice([0, 1, 2, 3, 4], ~from=0, ~to_=3) == [0, 1, 2]
      Array.slice([0, 1, 2, 3, 4], ~from=1, ~to_=4) == [1, 2, 3]
      Array.slice([0, 1, 2, 3, 4], ~from=5, ~to_=3) == []
      Array.slice([0, 1, 2, 3, 4], ~from=1, ~to_=-1) == [1, 2, 3]
      Array.slice([0, 1, 2, 3, 4], ~from=-2, ~to_=5) == [3, 4]
      Array.slice([0, 1, 2, 3, 4], ~from=-2, ~to_=-1) == [3]
    ]}
*)

val swap : 'a t -> int -> int -> unit
(** Swaps the values at the provided indicies.

    {3 Exceptions}

    Raises an [Invalid_argument] exception of either index is out of bounds for the array.

    {2 Examples}

    {[
      Array.swap([1, 2, 3], 1, 2) == [1, 3, 2]
    ]}
*)

val reverse : 'a t -> unit
(** Reverses an array {b in place}, mutating the existing array.

    {2 Examples}

    {[
      let numbers = [1, 2, 3]
      Array.reverse(numbers)
      numbers == [3, 2, 1]
    ]}
*)

val sort : 'a t -> compare:('a -> 'a -> int) -> unit
(** Sort in place, modifying the existing array, using the provided [compare] function to determine order.

    The time and space complexity of the sort cannot be guaranteed as it depends on the implementation.

    {2 Examples}

    {[
      Array.sort([5, 6, 8, 3, 6], ~compare) == [3, 5, 6, 6, 8]
    ]}
*)

(** {1 Query} *)

val isEmpty : 'a t -> bool
(** Check if an array is empty.

    {2 Examples}

    {[
      Array.isEmpty([1, 2, 3]) == false
      Array.isEmpty([]) == true
    ]}
*)

val length : 'a t -> int
(** Return the length of an array.

    {2 Examples}

    {[
      Array.length([1, 2, 3]) == 3
      Array.length([]) == 0
    ]}
*)

val any : 'a t -> f:('a -> bool) -> bool
(** Determine if [f] returns true for [any] values in an array.

    Iteration is stopped as soon as [f] returns [true].

    {2 Examples}

    {[
      Array.any([1, 2, 3, 5], ~f=Int.isEven) == true
      Array.any([1, 3, 5, 7], ~f=Int.isEven) == false
      Array.any([], ~f=Int.isEven) == false
    ]}
*)

val all : 'a t -> f:('a -> bool) -> bool
(** Determine if [f] returns true for [all] values in an array.

    Iteration is stopped as soon as [f] returns [false].

    {2 Examples}

    {[
      Array.all([2, 4], ~f=Int.isEven) == true
      Array.all([2, 3], ~f=Int.isEven) == false
      Array.all([], ~f=Int.isEven) == true
    ]}
*)

val count : 'a t -> f:('a -> bool) -> int
(** Count the number of elements which function [f] will return [true].

    {2 Examples}

    {[
      Array.count([7, 5, 8, 6], ~f=Int.isEven) == 2
    ]}
*)

val find : 'a t -> f:('a -> bool) -> 'a option
(** Returns, as an {!Option}, the first element for which [f] evaluates to [true].

    If [f] doesn't return [true] for any of the elements [find] will return [None]

    {2 Examples}

    {[
      Array.find([1, 3, 4, 8], ~f=Int.isEven) == Some(4)
      Array.find([0, 2, 4, 8], ~f=Int.isOdd) == None
      Array.find([], ~f=Int.isEven) == None
    ]}
*)

val findIndex : 'a t -> f:(int -> 'a -> bool) -> (int * 'a) option
(** Similar to {!Array.find} but [f] is also called with the current index, and the return value will be a tuple of the index the passing value was found at and the passing value.

    {2 Examples}

    {[
      Array.findIndex([1, 3, 4, 8], ~f=(index, number) => index > 2 && Int.isEven(number)) == Some(3, 8)
    ]}
*)

val includes : 'a t -> 'a -> equal:('a -> 'a -> bool) -> bool
(** Test if an array contains the specified element using the provided [equal] to test for equality.

    {2 Examples}

    {[
      Array.includes([1, 2, 3], 2, ~equal=Int.equal) == true
    ]}
*)

val minimum : 'a t -> compare:('a -> 'a -> int) -> 'a option
(** Find the smallest element using the provided [compare] function.

    Returns [None] if called on an empty array.

    {2 Examples}

    {[
      Array.minimum([7, 5, 8, 6], ~compare=Int.compare) == Some(5)
      Array.minimum([], ~compare=Int.compare) == None
    ]}
*)

val maximum : 'a t -> compare:('a -> 'a -> int) -> 'a option
(** Find the largest element using the provided [compare] function.

    Returns [None] if called on an empty array.

    {2 Examples}

    {[
      Array.maximum([7, 5, 8, 6], ~compare=Int.compare) == Some(8)
      Array.maximum([], ~compare=Int.compare) == None
    ]}
*)

val extent : 'a t -> compare:('a -> 'a -> int) -> ('a * 'a) option
(** Find a {!Tuple2} of the {!minimum} and {!maximum} in a single pass.

    Returns [None] if called on an empty array.

    {2 Examples}

    {[
      Array.extent([7, 5, 8, 6], ~compare=Int.compare) == Some(5, 8)
      Array.extent([7], ~compare=Int.compare) == Some(7, 7)
      Array.extent([], ~compare=Int.compare) == None
    ]}
*)

val sum : 'a t -> (module TableclothContainer.Sum with type t = 'a) -> 'a
(** Calculate the sum of an array using the provided modules [zero] value and [add] function.

    {2 Examples}

    {[
      Array.sum([1, 2, 3], module(Int)) == 6
      Array.sum([4.0, 4.5, 5.0], module(Float)) == 13.5
      
      Array.sum(
      ["a", "b", "c"],
      module(
        {
          type rec t = string
          let zero = ""
          let add = (x, y) => x ++ y
        }
      ),
    ) == "abc"
    ]}
*)

(** {1 Transform} *)

val map : 'a t -> f:('a -> 'b) -> 'b t
(** Create a new array which is the result of applying a function [f] to every element.

    {2 Examples}

    {[
      Array.map([1.0, 4.0, 9.0], ~f=Float.squareRoot) == [1.0, 2.0, 3.0]
    ]}
*)

val mapWithIndex : 'a t -> f:(int -> 'a -> 'b) -> 'b t
(** Apply a function [f] to every element with its index as the first argument.

    {2 Examples}

    {[
      Array.mapWithIndex([5, 5, 5], ~f=Int.multiply) == [0, 5, 10]
    ]}
*)

val filter : 'a t -> f:('a -> bool) -> 'a t
(** Keep elements where function [f] will return [true].

    {2 Examples}

    {[
      Array.filter([1, 2, 3, 4, 5, 6], ~f=Int.isEven) == [2, 4, 6]
    ]}
*)

val filterMap : 'a t -> f:('a -> 'b option) -> 'b t
(** Allows you to combine {!map} and {!filter} into a single pass.

    The output array only contains elements for which [f] returns [Some].

    Why [filterMap] and not just {!filter} then {!map}?

    {!filterMap} removes the {!Option} layer automatically.

    If your mapping is already returning an {!Option} and you want to skip over [None]s, then [filterMap] is much nicer to use.

    {2 Examples}

    {[
      let characters = ['a', '9', '6', ' ', '2', 'z']
      Array.filterMap(characters, ~f=Char.toDigit) == [9, 6, 2]

      Array.filterMap([3, 4, 5, 6], ~f=number =>
        Int.isEven(number) ? Some(number * number) : None
      ) == [16, 36]
    ]}
*)

val flatMap : 'a t -> f:('a -> 'b t) -> 'b t
(** {!map} [f] onto an array and {!flatten} the resulting arrays.

    {2 Examples}

    {[
      Array.flatMap([1, 2, 3], ~f=n => [n, n]) == [1, 1, 2, 2, 3, 3]
    ]}
*)

val fold : 'a t -> initial:'b -> f:('b -> 'a -> 'b) -> 'b
(** Just as {{: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/Reduce } Array.prototype.reduce() } from the JS,
    [fold] will produce a new value from an array.

    [fold] takes two arguments, an [initial] 'accumulator' value and a function [f].

    For each element of the array [f] will be called with two arguments: the current accumulator and an element.

    [f] returns the value that the accumulator should have for the next iteration.

    The [initial] value is the value the accumulator will have on the first call to [f].

    After applying [f] to every element of the array, [fold] returns the accumulator.

    [fold] iterates over the elements of the array from first to last.

    Folding is useful whenever you have a collection of something, and want to produce a single value from it.

    For example, if we have:

    {[
      let numbers = [(1, 2, 3)]
      let sum = Array.fold(numbers, ~initial=0, ~f=(accumulator, element) => accumulator + element)

      sum == 6
    ]}

    Walking though each iteration step by step:

    + [accumulator: 0, element: 1, result: 1]
    + [accumulator: 1, element: 2, result: 3]
    + [accumulator: 3, element: 3, result: 6]

    And so the final result is [6]. (Note that in reality you probably want to use {!Array.sum})

    {2 Examples}

    {[
      Array.fold([3, 4, 5], ~f=Int.multiply, ~initial=2) == 120
      
      Array.fold([1, 1, 2, 2, 3], ~initial=Set.Int.empty, ~f=Set.add) -> Set.toArray == [1, 2, 3]

      let lastEven = integers =>
        Array.fold(integers, ~initial=None, ~f=(last, int) =>
          int->Int.isEven ? Some(int) : last
        )

      lastEven([1, 2, 3, 4, 5]) == Some(4)
    ]}
*)

val foldRight : 'a t -> initial:'b -> f:('b -> 'a -> 'b) -> 'b
(** This method is like {!fold} except that it iterates over the elements of the array from last to first.

    {2 Examples}

    {[
      Array.repeat(~length=3, 5) -> Array.foldRight(~f=Int.add, ~initial=0) == 15
      Array.foldRight([3, 4, 5], ~f=Int.multiply, ~initial=2) == 120
    ]}
*)

val append : 'a t -> 'a t -> 'a t
(** Creates a new array which is the result of appending the second array onto the end of the first.

    {2 Examples}

    {[
      let fortyTwos = Array.repeat(42, ~length=2)
      let eightyOnes = Array.repeat(81, ~length=3)
      Array.append(fourtyTwos, eightyOnes) == [42, 42, 81, 81, 81]
    ]}
*)

val flatten : 'a t t -> 'a t
(** Flatten an array of arrays into a single array:

    {2 Examples}

    {[
      Array.flatten([[1, 2], [3], [4, 5]]) == [1, 2, 3, 4, 5]
    ]}
*)

val zip : 'a t -> 'b t -> ('a * 'b) t
(** Combine two arrays by merging each pair of elements into a {!Tuple2}.

    If one array is longer, the extra elements are dropped.

    The same as [Array.map2(~f=Tuple2.make)]

    {2 Examples}

    {[
      Array.zip([1, 2, 3, 4, 5], ["Dog", "Eagle", "Ferret"]) == [(1, "Dog"), (2, "Eagle"), (3, "Ferret")]
    ]}
*)

val map2 : 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t
(** Combine two arrays, using [f] to combine each pair of elements.

    If one array is longer, the extra elements are dropped.

    {2 Examples}

    {[
      let totals = (xs, ys) => Array.map2(~f=Int.add, xs, ys)

      totals([1, 2, 3], [4, 5, 6]) == [5, 7, 9]

      Array.map2(~f=Tuple2.make, ["alice", "bob", "chuck"], [2, 5, 7, 8])
      == [("alice", 2), ("bob", 5), ("chuck", 7)];
    ]}
*)

val map3 : 'a t -> 'b t -> 'c t -> f:('a -> 'b -> 'c -> 'd) -> 'd t
(** Combine three arrays, using [f] to combine each trio of elements.

    If one array is longer, the extra elements are dropped.

    {2 Examples}

    {[
      Array.map3(
        ~f=Tuple3.make,
        ["alice", "bob", "chuck"],
        [2, 5, 7, 8],
        [true, false, true, false],
      )
      == [("alice", 2, true), ("bob", 5, false), ("chuck", 7, true)];
    ]}
*)

(** {1 Deconstruct} *)

val partition : 'a t -> f:('a -> bool) -> 'a t * 'a t
(** Split an array into a {!Tuple2} of arrays. Values which [f] returns true for will end up in {!Tuple2.first}.

    {2 Examples}

    {[
      Array.partition([1, 2, 3, 4, 5, 6], ~f=Int.isOdd) == ([1, 3, 5], [2, 4, 6])
    ]}
*)

val splitAt : 'a t -> index:int -> 'a t * 'a t
(** Divides an array into a {!Tuple2} of arrays.

    Elements which have index upto (but not including) [index] will be in the first component of the tuple.

    Elements with an index greater than or equal to [index] will be in the second.

    {3 Exceptions}

    Raises an [Invalid_argument] exception if [index] is less than zero.

    {2 Examples}

    {[
      Array.splitAt([1, 2, 3, 4, 5], ~index=2) == ([1, 2], [3, 4, 5])
      Array.splitAt([1, 2, 3, 4, 5], ~index=10) == ([1, 2, 3, 4, 5], [])
      Array.splitAt([1, 2, 3, 4, 5], ~index=0) == ([], [1, 2, 3, 4, 5])
    ]}
*)

val splitWhen : 'a t -> f:('a -> bool) -> 'a t * 'a t
(** Divides an array at the first element [f] returns [true] for.

    Returns a {!Tuple2}, the first component contains the elements [f] returned false for,
    the second component includes the element that [f] retutned [true] for an all the remaining elements.

    {2 Examples}

    {[
      Array.splitWhen([5, 7, 8, 6, 4], ~f=Int.isEven) == ([5, 7], [8, 6, 4])
      
      Array.splitWhen(["Ant", "Bat", "Cat"], ~f=animal => String.length(animal) > 3) ==
        (["Ant", "Bat", "Cat"], [])
      
      Array.splitWhen([2., Float.pi, 1.111], ~f=Float.isInteger) == ([], [2., Float.pi, 1.111])
    ]}
*)

val unzip : ('a * 'b) t -> 'a t * 'b t
(** Decompose an array of {!Tuple2}s into a {!Tuple2} of arrays.

    {2 Examples}

    {[
      Array.unzip([(0, true), (17, false), (1337, true)]) == ([0, 17, 1337], [true, false, true])
    ]}
*)

(** {1 Iterate} *)

val forEach : 'a t -> f:('a -> unit) -> unit
(** Iterates over the elements of invokes [f] for each element.

    {2 Examples}

    {[
      Array.forEach([1, 2, 3], ~f=int => Js.log(int))
    ]}
*)

val forEachWithIndex : 'a t -> f:(int -> 'a -> unit) -> unit
(** Iterates over the elements of invokes [f] for each element.

    {2 Examples}

    {[
      Array.forEachWithIndex([1, 2, 3], ~f=(index, int) => Js.log2(index, int))
      (*
        0 1
        1 2
        2 3
      *)
    ]}
*)

val values : 'a option t -> 'a t
(** Return all of the [Some] values from an array of options.

    {2 Examples}

    {[
      Array.values([Some("Ant"), None, Some("Cat")]) == ["Ant", "Cat"]
      Array.values([None, None, None]) == []
    ]}
*)

val intersperse : 'a t -> sep:'a -> 'a t
(** Places [sep] between all the elements of the given array.

    {2 Examples}

    {[
      Array.intersperse(~sep="on", ["turtles", "turtles", "turtles"])
      == ["turtles", "on", "turtles", "on", "turtles"];
    
      Array.intersperse(~sep=0, []) == []
    ]}
*)

val chunksOf : 'a t -> size:int -> 'a t t
(** Split an array into equally sized chunks.

    If there aren't enough elements to make the last 'chunk', those elements are ignored.

    {2 Examples}

    {[
      Array.chunksOf(["#FFBA49", "#9984D4", "#20A39E", "#EF5B5B", "#23001E"], ~size=2) == [
        ["#FFBA49", "#9984D4"],
        ["#20A39E", "#EF5B5B"],
      ]
    ]}
 *)

val sliding : ?step:int -> 'a t -> size:int -> 'a t t
(** Provides a sliding 'window' of sub-arrays over an array.

    The first sub-array starts at index [0] of the array and takes the first [size] elements.

    The sub-array then advances the index [step] (which defaults to 1) positions before taking the next [size] elements.

    The sub-arrays are guaranteed to always be of length [size] and iteration stops once a sub-array would extend beyond the end of the array.

    {2 Examples}

    {[
      Array.sliding([1, 2, 3, 4, 5], ~size=1) == [[1], [2], [3], [4], [5]]
      Array.sliding([1, 2, 3, 4, 5], ~size=2) == [[1, 2], [2, 3], [3, 4], [4, 5]]
      Array.sliding([1, 2, 3, 4, 5], ~size=3) == [[1, 2, 3], [2, 3, 4], [3, 4, 5]]
      Array.sliding([1, 2, 3, 4, 5], ~size=2, ~step=2) == [[1, 2], [3, 4]]
      Array.sliding([1, 2, 3, 4, 5], ~size=1, ~step=3) == [[1], [4]]
    ]}
*)

(** {1 Convert} *)

val join : string t -> sep:string -> string
(** Converts an array of strings into a {!String}, placing [sep] between each string in the result.

    {2 Examples}

    {[
      Array.join(["Ant", "Bat", "Cat"], ~sep=", ") == "Ant, Bat, Cat"
    ]}
 *)

val groupBy :
     'value t
  -> ('key, 'id) TableclothComparator.s
  -> f:('value -> 'key)
  -> ('key, 'value list, 'id) TableclothMap.t
(** Collect elements where function [f] will produce the same key.

    Produces a map from ['key] to a {!List} of all elements which produce the same ['key].

    {2 Examples}

    {[
      let animals = ["Ant", "Bear", "Cat", "Dewgong"]
      Array.groupBy(animals, module(Int), ~f=String.length) ==
      Map.Int.fromArray([
        (3, list{"Cat", "Ant"}),
        (4, list{"Bear"}),
        (7, list{"Dewgong"})
      ])
    ]}
*)

val toList : 'a t -> 'a list
(** Create a {!List} of elements from an array.

    {2 Examples}

    {[
      Array.toList([1, 2, 3]) == list{1, 2, 3}
      Array.toList(Array.fromList(list{3, 5, 8})) == list{3, 5, 8}
    ]}
*)

val toIndexedList : 'a t -> (int * 'a) list
(** Create an indexed {!List} from an array. Each element of the array will be paired with its index as a {!Tuple2}.

    {2 Examples}

    {[
      Array.toIndexedList(["cat", "dog"]) == list{(0, "cat"), (1, "dog")}
    ]}
*)

val equal : 'a t -> 'a t -> ('a -> 'a -> bool) -> bool
(** Test two arrays for equality using the provided function to test pairs of elements. *)

val compare : 'a t -> 'a t -> f:('a -> 'a -> int) -> int
(** Compare two arrays using the provided [f] function to compare pairs of elements.

    A shorter array is 'less' than a longer one.

    {2 Examples}

    {[
      Array.compare([1, 2, 3], [1, 2, 3, 4], ~f=Int.compare) == -1
      Array.compare([1, 2, 3], [1, 2, 3], ~f=Int.compare) == 0
      Array.compare([1, 2, 5], [1, 2, 3], ~f=Int.compare) == 1
    ]}
*)
