(** *)

(** Immutable singly-linked list of elements which must have the same type.

    Lists can have any number of elements.

    They are fast (O(1)) when:
    - Getting the first element using {!head}
    - Getting the {!tail}
    - Creating a new list by adding an element to the front using {!cons}

    They also support exhaustive pattern matching

    {[
      match aList with
      | [] -> "Empty"
      | [a] -> "Exactly one element"
      | [a, b] -> "Exactly two elements"
      | a :: b :: cs -> "More than two elements"
    ]}

    Lists are slow when:
    - You need to access an element that isn't at the front of the list
    - Counting how many elements are in the list

    As they have inefficent ([O(n)]) {!getAt} and {!length} operations.

    If those are important to your use-case, perhaps you need an {!Array}.
*)

type 'a t = 'a list

(** {1 Create}

    You can create a [list] with the [[1;2;3]] syntax.
*)

val empty : 'a t
(** An empty list.

    {2 Examples}

    {[List.empty = []]}

    {[List.length List.empty = 0]}
*)

val singleton : 'a -> 'a t
(** Create a list with only one element.

    {2 Examples}

    {[List.singleton 1234 = [1234]]}

    {[List.singleton "hi" = ["hi"]]}
*)

val repeat : 'a -> times:int -> 'a t
(** Creates a list of length [times] with the value [x] populated at each index.

    {2 Examples}

    {[List.repeat ~times:5 'a' = ['a'; 'a'; 'a'; 'a'; 'a']]}

    {[List.repeat ~times:0 7 = []]}

    {[List.repeat ~times:(-1) "Why?" = []]}
*)

val range : ?from:int -> int -> int t
(** Creates a list containing all of the integers from [from] if it is provided or [0] if not, up to but not including [to]

    {2 Examples}

    {[List.range 5 = [0; 1; 2; 3; 4] ]}

    {[List.range ~from:2 5 = [2; 3; 4] ]}

    {[List.range ~from:(-2) 3 = [-2; -1; 0; 1; 2] ]}
*)

val initialize : int -> f:(int -> 'a) -> 'a t
(** Initialize a list.

    [List.initialize n ~f] creates a list of length [n] by setting the element at position [index] to be [f(index)].

    {2 Examples}

    {[List.initialize 4 ~f:identity = [0; 1; 2; 3]]}

    {[List.initialize 4 ~f:(fun index -> index * index) = [0; 1; 4; 9]]}
*)

val fromArray : 'a array -> 'a t
(** Create a list from an {!Array}.

    {2 Examples}

    {[List.fromArray [|1;2;3|] = [1;2;3]]}
*)

(** {1 Basic operations} *)

val head : 'a t -> 'a option
(** Returns, as an {!Option}, the first element of a list.

    If the list is empty, returns [None]

    {2 Examples}

    {[List.head [1;2;3] = Some 1]}

    {[List.head [] = None]}
*)

val tail : 'a t -> 'a t option
(** Returns, as an {!Option}, a list without its first element.

    If the list is empty, returns [None]

    {2 Examples}

    {[List.tail [1;2;3] = Some [2;3]]}

    {[List.tail [1] = Some []]}

    {[List.tail [] = None]}
*)

val cons : 'a t -> 'a -> 'a t
(** Prepend a value to the front of a list.

    The [::] operator can also be used, in Reason you use the spread syntax
    instead.

    {2 Examples}

    {[List.cons [2;3;4] 1 = [1;2;3;4]]}

    {[1 :: [2;3;4] = [1;2;3;4]]}
*)

val take : 'a t -> count:int -> 'a t
(** Attempt to take the first [count] elements of a list.

   If the list has fewer than [count] elements, returns the entire list.

   If count is zero or negative, returns [].

   {2 Examples}

   {[List.take [1;2;3] ~count:2 = [1;2]]}

   {[List.take [] ~count:2 = []]}

   {[List.take [1;2;3;4] ~count:8 = [1;2;3;4]]}

   {[List.take [1;2;3;4] ~count:(-1) = []]}
*)

val takeWhile : 'a t -> f:('a -> bool) -> 'a t
(** Take elements from a list until [f] returns [false]

    {2 Examples}

    {[
      List.takeWhile ~f:Int.isEven [2; 4; 6; 7; 8; 9] = [2; 4; 6]
      List.takeWhile ~f:Int.isEven [2; 4; 6] = [2; 4; 6]
      List.takeWhile ~f:Int.isEven [1; 2; 3] = []
    ]}
*)

val drop : 'a t -> count:int -> 'a t
(** Drop the first [count] elements from the front of a list.

    If the list has fewer than [count] elements, returns [].

    If count is zero or negative, returns the entire list.

    {2 Examples}

    {[List.drop [1;2;3;4] ~count:2 = [3;4]]}

    {[List.drop [1;2;3;4] ~count:6 = []]}

    {[List.drop [1;2;3;4] ~count:-1 = [1;2;3;4]]}
*)

val dropWhile : 'a t -> f:('a -> bool) -> 'a t
(** Drop elements from a list until [f] returns [false]

    {2 Examples}

    {[List.dropWhile ~f:Int.isEven [2; 4; 6; 7; 8; 9] = [7; 8; 9]]}

    {[List.dropWhile ~f:Int.isEven [2; 4; 6; 8] = []]}

    {[List.dropWhile ~f:Int.isEven [1; 2; 3] = [1; 2; 3]]}
*)

val initial : 'a t -> 'a t option
(** As an {!Option} get of all of the elements of a list except the last one.

    Returns [None] if the list is empty.

    {2 Examples}

    {[List.initial [1;2;3] = Some [1;2]]}

    {[List.initial [1] = Some []]}

    {[List.initial [] = None]}
*)

val last : 'a t -> 'a option
(** Get the last element of a list.

    Returns [None] if the list is empty.

    {b Warning} This will iterate through the entire list.

    {2 Examples}

    {[List.last [1;2;3] = Some 3]}

    {[List.last [1] = Some 1]}

    {[List.last [] = None]}
*)

val getAt : 'a t -> index:int -> 'a option
(** Returns the element at position [index] in the list.

    Returns [None] if [index] is outside of the bounds of the list.

    {2 Examples}

    {[List.getAt [1;2;3] ~index:1 = Some 2]}

    {[List.getAt [] ~index:2 = None]}

    {[List.getAt [1;2;3] ~index:100 = None]}
*)

val insertAt : 'a t -> index:int -> value:'a -> 'a t
(** Insert a new element at the specified index.

    The element previously occupying [index] will now be at [index + 1]

    If [index] is greater than then length of the list, it will be appended:

    {e Exceptions}

    Raises an [Invalid_argument] exception if [index] is negative

    {2 Examples}

    {[
      List.insertAt
        ~index:2
        ~value:999
        [100; 101; 102; 103] =
          [100; 101; 999; 102; 103]
    ]}

    {[List.insertAt ~index:0 ~value:999 [100; 101; 102; 103] = [999; 100; 101; 102; 103]]}

    {[List.insertAt ~index:4 ~value:999 [100; 101; 102; 103] = [100; 101; 102; 103; 999]]}

    {[List.insertAt ~index:(-1) ~value:999 [100; 101; 102; 103] = [999]]}

    {[List.insertAt ~index:5 ~value:999 [100; 101; 102; 103] = [999]]}
*)

val updateAt : 'a t -> index:int -> f:('a -> 'a) -> 'a t
(** Returns a new list with the value at [index] updated to be the result of applying [f].

    If [index] is outside of the bounds of the list, returns the list as-is.

    {2 Examples}

    {[List.updateAt [1; 2; 3] ~index:1 ~f:(Int.add 3) = [1; 5; 3]]}

    {[
      let animals = ["Ant"; "Bat"; "Cat"] in
      animals = List.updateAt animals ~index:4 ~f:String.reverse
    ]}
*)

val removeAt : 'a t -> index:int -> 'a t
(** Creates a new list without the element at [index].

    If [index] is outside of the bounds of the list, returns the list as-is.

    {2 Examples}

    {[List.removeAt [1; 2; 3] ~index:2 = [1; 2]]}

    {[
      let animals = ["Ant"; "Bat"; "Cat"] in
      List.equal String.equal animals (List.removeAt animals ~index:4) = true
    ]}
*)

val reverse : 'a t -> 'a t
(** Reverse the elements in a list

    {2 Examples}

    {[List.reverse [1; 2; 3] = [3; 2; 1]]}
 *)

val sort : 'a t -> compare:('a -> 'a -> int) -> 'a t
(** Sort using the provided [compare] function.

    On native it uses {{: https://en.wikipedia.org/wiki/Merge_sort } merge sort} which means the sort is stable,
    runs in linear heap space, logarithmic stack space and n * log (n) time.

    When targeting javascript the time and space complexity of the sort cannot be guaranteed as it depends on the implementation.

    {2 Examples}

    {[List.sort [5;6;8;3;6] ~compare:Int.compare = [3;5;6;6;8]]}
*)

val sortBy : f:('a -> 'b) -> 'a t -> 'a t
(**
    [List.sortBy ~f:fcn xs] returns a new list sorted according to the values
    returned by [fcn]. This is a stable sort; if two items have the same value,
    they will appear in the same order that they appeared in the original list.
    {[
    List.sortBy ~f:(fun x -> x * x) [3; 2; 5; -2; 4] = [2; -2; 3; 4; 5]
    ]}
*)

(** {1 Query} *)

val isEmpty : _ t -> bool
(** Determine if a list is empty.

    {2 Examples}

    {[List.isEmpty List.empty = true]}

    {[List.isEmpty [||] = true]}

    {[List.isEmpty [|1; 2; 3|] = false]}
*)

val length : 'a t -> int
(** Return the number of elements in a list.

    {b Warning} [List.length] needs to access the {b entire} list in order to calculate its result.

    If you need fast access to the length, perhaps you need an {!Array}.

    A common mistake is to have something like the following:

    {[
      if (List.length someList) = 0 then (
        () (* It will take longer than you think to reach here *)
      ) else (
        () (* But it doesn't need to *)
      )
    ]}

    instead you should do

    {[
      if (List.isEmpty someList) then (
        () (* This happens instantly *)
      ) else (
        () (* Since List.isEmpty takes the same amount of time for all lists *)
      )
    ]}

    Or

    {[
      match someList with
      | [] -> () (* Spoilers *)
      | _ -> () (* This is how isEmptu is implemented *)
    ]}


    {2 Examples}

    {[List.length [] = 0]}

    {[List.length [7; 8; 9] = 3]}
*)

val any : 'a t -> f:('a -> bool) -> bool
(** Determine if [f] returns true for [any] values in a list.

    Stops iteration as soon as [f] returns true.

    {2 Examples}

    {[List.any ~f:isEven [|2;3|] = true]}

    {[List.any ~f:isEven [|1;3|] = false]}

    {[List.any ~f:isEven [||] = false]}
*)

val all : 'a t -> f:('a -> bool) -> bool
(** Determine if [f] returns true for [all] values in a list.

    Stops iteration as soon as [f] returns false.

    {2 Examples}

    {[List.all ~f:Int.isEven [|2;4|] = true]}

    {[List.all ~f:Int.isEven [|2;3|] = false]}

    {[List.all ~f:Int.isEven [||] = true]}
*)

val count : 'a t -> f:('a -> bool) -> int
(** Count the number of elements which [f] returns [true] for

    {2 Examples}

    {[List.count [7;5;8;6] ~f:Int.isEven = 2]}
 *)

val uniqueBy : f:('a -> string) -> 'a list -> 'a list
(**
   [List.uniqueBy ~f:fcn xs] returns a new list containing only those elements from [xs]
   that have a unique value when [fcn] is applied to them.
   The function [fcn] takes as its single parameter an item from the list
   and returns a [string]. If the function generates the same string for two or more
   list items, only the first of them is retained.
   {[
   List.uniqueBy ~f:stringOfInt [1; 3; 4; 3; 7; 7; 6] = [1; 3; 4; 7; 6]
   let absStr x = stringOfInt (abs x)
   List.uniqueBy ~f:absStr [1; 3; 4; -3; -7; 7; 6] = [1; 3; 4; -7; 6]
   ]}
 *)

val find : 'a t -> f:('a -> bool) -> 'a option
(** Returns, as an option, the first element for which [f] evaluates to true.

  If [f] doesn't return [true] for any of the elements [find] will return [None]

  {2 Examples}

  {[List.find ~f:Int.isEven [|1; 3; 4; 8;|] = Some 4]}

  {[List.find ~f:Int.isOdd [|0; 2; 4; 8;|] = None]}

  {[List.find ~f:Int.isEven [||] = None]}
*)

val findIndex : 'a t -> f:(int -> 'a -> bool) -> (int * 'a) option
(** Returns, as an option, a tuple of the first element and its index for which [f] evaluates to true.

    If [f] doesnt return [true] for any [(index, element)] pair, returns [None].

    {2 Examples}

    {[List.findIndex ~f:(fun index number -> index > 2 && Int.isEven number) [|1; 3; 4; 8;|] = Some (3, 8)]}
*)

val includes : 'a t -> 'a -> equal:('a -> 'a -> bool) -> bool
(** Test if a list contains the specified element using the provided [equal] to test for equality.

    This function may iterate the entire list, so if your code needs to
    repeatedly perform this check, maybe you want a {!Set} instead.

    {2 Examples}

    {[List.includes [1; 3; 5; 7] 3 ~equal:Int.equal = true]}

    {[List.includes [1; 3; 5; 7] 4 ~equal:Int.equal = false]}

    {[List.includes [] 5 ~equal:Int.equal = false]}
*)

val minimumBy : f:('a -> 'comparable) -> 'a list -> 'a option
(**
    [List.minimumBy ~f:fcn, xs], when given a non-empty list, returns the item in the list
    for which [fcn item] is a minimum. It is returned as [Some item].
    If given an empty list, [List.minimumBy] returns [None]. If more than one value has
    a minimum value for [fcn item], the first one is returned.
    The function provided takes a list item as its parameter and must return a value
    that can be compared---for example, a [string] or [int].
    {[
    let mod12 x = x mod 12
    let hours = [7; 9; 15; 10; 3; 22]
    List.minimumBy ~f:mod12 hours = Some 15
    List.minimumBy ~f:mod12 [] = None
    ]}
   *)

val maximumBy : f:('a -> 'comparable) -> 'a list -> 'a option
(**
     [List.maximumBy ~f:fcn, xs], when given a non-empty list, returns the item in the list
     for which [fcn item] is a maximum. It is returned as [Some item].
     If given an empty list, [List.maximumBy] returns [None]. If more than one value
     has a maximum value for [fcn item], the first one is returned.
     The function provided takes a list item as its parameter and must return a value
     that can be compared---for example, a [string] or [int].
     {[
     let mod12 x = x mod 12
     let hours = [7;9;15;10;3;22]
     List.maximumBy ~f:mod12 hours = Some 10
     List.maximumBy ~f:mod12 [] = None
     ]}
    *)

val minimum : 'a t -> compare:('a -> 'a -> int) -> 'a option
(** Find the smallest element using the provided [compare] function.

    Returns [None] if called on an empty array.

    {2 Examples}

    {[List.minimum [|7; 5; 8; 6|] ~compare:Int.compare = Some 5]}
*)

val maximum : 'a t -> compare:('a -> 'a -> int) -> 'a option
(** Find the largest element using the provided [compare] function.

    Returns [None] if called on an empty array.

    {2 Examples}

    {[List.maximum [|7; 5; 8; 6|] ~compare:compare = Some 8]}
*)

val extent : 'a t -> compare:('a -> 'a -> int) -> ('a * 'a) option
(** Find a {!Tuple} of the [(minimum, maximum)] elements using the provided [compare] function.

    Returns [None] if called on an empty array.

    {2 Examples}

    {[List.extent [|7; 5; 8; 6|] ~compare:compare = Some (5, 8)]}
*)

val sum : 'a t -> (module TableclothContainer.Sum with type t = 'a) -> 'a
(** Calculate the sum of a list using the provided modules [zero] value and [add] function.

    {2 Examples}

    {[List.sum [1;2;3] (module Int) = 6]}

    {[List.sum [4.0;4.5;5.0] (module Float) = 13.5]}

    {[
      List.sum
        ["a"; "b"; "c"]
        (
          module struct
            type t = string
            let zero = ""
            let add = (^)
          end
        )
        = "abc"
    ]}
*)

(** {1 Transform} *)

val map : 'a t -> f:('a -> 'b) -> 'b t
(** Create a new list which is the result of applying a function [f] to every element.

    {2 Examples}

    {[List.map ~f:Float.squareRoot [|1.0; 4.0; 9.0|] = [|1.0; 2.0; 3.0|]]}
*)

val mapWithIndex : 'a t -> f:(int -> 'a -> 'b) -> 'b t
(** Apply a function [f] to every element and its index.

    {2 Examples}

    {[
      List.mapWithIndex
        ["zero"; "one"; "two"]
        ~f:(fun index element ->
          (Int.toString index) ^ ": " ^ element)
        = ["0: zero"; "1: one"; "2: two"]
    ]}
*)

val filter : 'a t -> f:('a -> bool) -> 'a t
(** Keep elements that [f] returns [true] for.

    {2 Examples}

    {[List.filter ~f:Int.isEven [1; 2; 3; 4; 5; 6] = [2; 4; 6]]}
*)

val filterWithIndex : 'a t -> f:(int -> 'a -> bool) -> 'a t
(** Like {!filter} but [f] is also called with each elements index. *)

val filterMap : 'a t -> f:('a -> 'b option) -> 'b t
(** Allows you to combine {!map} and {!filter} into a single pass.

    The output list only contains elements for which [f] returns [Some].

    Why [filterMap] and not just {!filter} then {!map}?

    {!filterMap} removes the {!Option} layer automatically.
    If your mapping is already returning an {!Option} and you want to skip over Nones, then [filterMap] is much nicer to use.

    {2 Examples}

    {[
      let characters = ['a'; '9'; '6'; ' '; '2'; 'z'] in
      List.filterMap characters ~f:Char.toDigit = [9; 6; 2]
    ]}

    {[
      List.filterMap [3; 4; 5; 6] ~f:(fun number ->
        if Int.isEven number then
          Some (number * number)
        else
          None
      ) = [16; 36]
    ]}
*)

val flatMap : 'a t -> f:('a -> 'b t) -> 'b t
(** Apply a function [f] onto a list and {!flatten} the resulting list of lists.

    {2 Examples}

    {[List.flatMap ~f xs = List.map ~f xs |> List.flatten]}

    {[List.flatMap ~f:(fun n -> [|n; n|]) [|1; 2; 3|] = [|1; 1; 2; 2; 3; 3|]]}
*)

val fold : 'a t -> initial:'b -> f:('b -> 'a -> 'b) -> 'b
(** Transform a list into a value

    After applying [f] to every element of the list, [fold] returns the accumulator.

    [fold] iterates over the elements of the list from first to last.

    For examples if we have:

    {[
      let numbers = [1, 2, 3] in
      let sum =
        List.fold numbers ~initial:0 ~f:(fun accumulator element -> accumulator + element)
      in
      sum = 6
    ]}

    Walking though each iteration step by step:

    + [accumulator: 0, element: 1, result: 1]
    + [accumulator: 1, element: 2, result: 3]
    + [accumulator: 3, element: 3, result: 6]

    And so the final result is [6]. (Note that in this case you probably want to use {!List.sum})

    {b Examples continued}

    {[List.fold [|1; 2; 3|] ~initial:[] ~f:(List.cons) = [3; 2; 1]]}

    {[
      let unique integers =
        List.fold integers ~initial:Set.Int.empty ~f:Set.add |> Set.toList
      in
      unique [|1; 1; 2; 3; 2|] = [|1; 2; 3|]
    ]}

    {[
      let lastEven integers =
        List.fold integers ~initial:None ~f:(fun last int ->
          if Int.isEven then
            Some int
          else
            last
        )
      in
      lastEven [|1;2;3;4;5|] = Some 4
    ]}
*)

val foldRight : 'a t -> initial:'b -> f:('b -> 'a -> 'b) -> 'b
(** This method is like {!fold} except that it iterates over the elements of the list from last to first. *)

(** {1 Combine} *)

val append : 'a t -> 'a t -> 'a t
(** Creates a new list which is the result of appending the second list onto the end of the first.

    {2 Examples}

    {[
      let fortyTwos = List.repeat ~length:2 42 in
      let eightyOnes = List.repeat ~length:3 81 in
      List.append fourtyTwos eightyOnes = [42; 42; 81; 81; 81];
    ]}
*)

val flatten : 'a t t -> 'a t
(** Concatenate a list of lists into a single list:

    {2 Examples}

    {[List.flatten [[1; 2]; [3]; [4; 5]] = [1; 2; 3; 4; 5]]}
*)

val zip : 'a t -> 'b t -> ('a * 'b) t
(** Combine two lists by merging each pair of elements into a {!Tuple}

    If one list is longer, the extra elements are dropped.

    The same as [List.map2 ~f:Tuple.make]

    {2 Examples}

    {[List.zip [|1;2;3;4;5|] [|"Dog"; "Eagle"; "Ferret"|] = [|(1, "Dog"); (2, "Eagle"); (3, "Ferret")|]]}
*)

val map2 : 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t
(** Combine two lists, using [f] to combine each pair of elements.

    If one list is longer, the extra elements are dropped.

    {2 Examples}

    {[List.map2 [|1;2;3|] [|4;5;6|] ~f:(+) = [|5;7;9|]]}

    {[
      List.map2
        [|"alice"; "bob"; "chuck"|]
        [|3; 5; 7; 9; 11; 13; 15; 17; 19|]
        ~f:Tuple.create
          = [|("alice", 3); ("bob", 5); ("chuck", 7)|]
    ]}
*)

val map3 : 'a t -> 'b t -> 'c t -> f:('a -> 'b -> 'c -> 'd) -> 'd t
(** Combine three lists, using [f] to combine each trio of elements.

    If one list is longer, the extra elements are dropped.

    {2 Examples}

    {[
      List.map3
        ~f:Tuple3.create
        [|"alice"; "bob"; "chuck"|]
        [|2; 5; 7; 8;|]
        [|true; false; true; false|] =
          [|("alice", 2, true); ("bob", 5, false); ("chuck", 7, true)|]
    ]}
*)

(** {1 Deconstruct} *)

val partition : 'a t -> f:('a -> bool) -> 'a t * 'a t
(** Split a list into a {!Tuple} of lists. Values which [f] returns true for will end up in {!Tuple.first}.

    {2 Examples}

    {[List.partition [1;2;3;4;5;6] ~f:Int.isOdd = ([1;3;5], [2;4;6])]}
*)

val splitAt : 'a t -> index:int -> 'a t * 'a t
(** Divides a list into a {!Tuple} of lists.

    Elements which have index upto (but not including) [index] will be in the first component of the tuple.

    Elements with an index greater than or equal to [index] will be in the second.

    If [index] is zero or negative, all elements will be in the second component of the tuple.

    If [index] is greater than the length of the list, all elements will be in the second component of the tuple.

    {2 Examples}

    {[List.splitAt [1;2;3;4;5] ~index:2 = ([1;2], [3;4;5])]}

    {[List.splitAt [1;2;3;4;5] ~index:-1 = ([], [1;2;3;4;5])]}

    {[List.splitAt [1;2;3;4;5] ~index:10 = ([1;2;3;4;5], 10)]}
*)

val splitWhen : 'a t -> f:('a -> bool) -> 'a t * 'a t
(** Divides a list into a {!Tuple} at the first element [f] returns [true] for.

    Elements up to (but not including) the first element [f] returns [true] for
    will be in the first component of the tuple, the remaining elements will be
    in the second

    {2 Examples}

    {[List.splitWhen [2; 4; 5; 6; 7] ~f:Int.isEven = ([2; 4], [5; 6; 7])]}

    {[List.splitWhen [2; 4; 5; 6; 7] ~f:(Fun.constant false) = ([2; 4; 5; 6; 7], [])]}
*)

val unzip : ('a * 'b) t -> 'a t * 'b t
(** Decompose a list of {!Tuple} into a {!Tuple} of lists.

    {2 Examples}

    {[List.unzip [(0, true); (17, false); (1337, true)] = ([0;17;1337], [true; false; true])]}
*)

(** {1 Iterate} *)

val forEach : 'a t -> f:('a -> unit) -> unit
(** Iterates over the elements of invokes [f] for each element.

    The function you provide must return [unit], and the [forEach] call itself also returns [unit].

    You use [List.forEach] when you want to process a list only for side effects.


    {2 Examples}

    {[
      List.forEach [|1; 2; 3|] ~f:(fun int -> print (Int.toString int))
      (*
        Prints
        1
        2
        3
      *)
    ]}
*)

val forEachWithIndex : 'a t -> f:(int -> 'a -> unit) -> unit
(** Like {!forEach} but [f] is also called with the elements index.

    {2 Examples}

    {[
      List.forEachI [1; 2; 3] ~f:(fun index int -> printf "%d: %d" index int)
      (*
        Prints
        0: 1
        1: 2
        2: 3
      *)
    ]}
*)

val intersperse : 'a t -> sep:'a -> 'a t
(** Places [sep] between all the elements of the given list.

    {2 Examples}

    {[List.intersperse ~sep:"on" [|"turtles"; "turtles"; "turtles"|] = [|"turtles"; "on"; "turtles"; "on"; "turtles"|]]}

    {[List.intersperse ~sep:0 [||] = [||]]}
*)

val chunksOf : 'a t -> size:int -> 'a t t
(** Split a list into equally sized chunks.

    If there aren't enough elements to make the last 'chunk', those elements are ignored.

    {2 Examples}

    {[
      List.chunksOf ~size:2 ["#FFBA49"; "#9984D4"; "#20A39E"; "#EF5B5B"; "#23001E"] =  [
        ["#FFBA49"; "#9984D4"];
        ["#20A39E"; "#EF5B5B"];
      ]
    ]}
 *)

val sliding : ?step:int -> 'a t -> size:int -> 'a t t
(** Provides a sliding 'window' of sub-lists over a list.

    The first sub-list starts at the head of the list and takes the first [size] elements.

    The sub-list then advances [step] (which defaults to 1) positions before taking the next [size] elements.

    The sub-lists are guaranteed to always be of length [size] and iteration stops once a sub-list would extend beyond the end of the list.

    {2 Examples}

    {[List.sliding [1;2;3;4;5] ~size:1 = [[1]; [2]; [3]; [4]; [5]] ]}

    {[List.sliding [1;2;3;4;5] ~size:2 = [[1;2]; [2;3]; [3;4]; [4;5]] ]}

    {[List.sliding [1;2;3;4;5] ~size:3 = [[1;2;3]; [2;3;4]; [3;4;5]] ]}

    {[List.sliding [1;2;3;4;5] ~size:2 ~step:2 = [[1;2]; [3;4]] ]}

    {[List.sliding [1;2;3;4;5] ~size:1 ~step:3 = [[1]; [4]] ]}

    {[List.sliding [1;2;3;4;5] ~size:2 ~step:3 = [[1; 2]; [4; 5]]]}

    {[List.sliding [1;2;3;4;5] ~size:7 = []]}
*)

val groupWhile : 'a t -> f:('a -> 'a -> bool) -> 'a t t
(** Divide a list into groups.

    [f] is called with consecutive elements, when [f] returns [false] a new group is started.

    {2 Examples}

    {[
      List.groupWhile [1; 2; 3;] ~f:(Fun.constant false) = [[1]; [2]; [3]]
    ]}

    {[
      List.groupWhile [1; 2; 3;] ~f:(Fun.constant true) = [[1; 2; 3]]
    ]}

    {[
      List.groupWhile
        ~f:String.equal
        ["a"; "b"; "b"; "a"; "a"; "a"; "b"; "a"] =
          [["a"]; ["b"; "b"]; ["a"; "a"; "a";] ["b"]; ["a"]]
    ]}

    {[
      List.groupWhile
        ~f:(fun x y -> x mod 2 = y mod 2)
        [2; 4; 6; 5; 3; 1; 8; 7; 9] =
          [[2; 4; 6]; [5; 3; 1]; [8]; [7; 9]]
    ]}
*)

(** {1 Convert} *)

val join : string t -> sep:string -> string
(** Converts a list of strings into a {!String}, placing [sep] between each string in the result.

    {2 Examples}

    {[List.join ["Ant"; "Bat"; "Cat"] ~sep:", " = "Ant, Bat, Cat"]}
 *)

val groupBy :
     'value t
  -> ('key, 'id) TableclothComparator.s
  -> f:('value -> 'key)
  -> ('key, 'value list, 'id) TableclothMap.t
(** Collect elements which [f] produces the same key for

    Produces a map from ['key] to a {!List} of all elements which produce the same ['key]

    {2 Examples}

    {[
      let animals = [|"Ant"; "Bear"; "Cat"; "Dewgong"|] in
      Array.groupBy animals (module Int) ~f:String.length = Map.Int.fromList [
        (3, ["Cat"; "Ant"]);
        (4, ["Bear"]);
        (7, ["Dewgong"]);
      ]
    ]}
*)

val toArray : 'a t -> 'a array
(** Converts a list to an {!Array}. *)

(** {1 Compare} *)

val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
(** Test two lists for equality using the provided function to test elements. *)

val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
(** Compare two lists using the provided function to compare elements.

    A shorter list is 'less' than a longer one.

    {2 Examples}

    {[List.compare Int.compare [1;2;3] [1;2;3;4] = -1]}

    {[List.compare Int.compare [1;2;3] [1;2;3] = 0]}

    {[List.compare Int.compare [1;2;5] [1;2;3] = 1]}
*)
