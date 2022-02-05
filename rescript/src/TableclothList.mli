(** *)

(** Immutable singly-linked list of elements which must have the same type.

    Lists can have any number of elements.

    They are fast (O(1)) when:
    - Getting the first element using {!head}
    - Getting the {!tail}
    - Creating a new list by adding an element to the front using {!cons}

    They also support exhaustive pattern matching:

    {[
      switch aList {
      | list{} => "Empty"
      | list{a} => "Exactly one element"
      | list{(a, b)} => "Exactly two elements"
      | list{a, b, ...cs} => "More than two elements"
      }
   ]}

    Lists are slow when:
    - You need to access an element that isn't at the front of the list
    - Counting how many elements are in the list

    As they have inefficent ([O(n)]) {!getAt} and {!length} operations.

    If those are important to your use-case, perhaps you need an {!Array}.
*)

type 'a t = 'a list

(** {1 Create}

    You can create a [list] with the [list{1, 2, 3}] syntax.
*)

val empty : 'a t
(** An empty list.

    {2 Examples}

    {[
      List.empty == list{}
      List.empty->List.length == 0
    ]}
*)

val singleton : 'a -> 'a t
(** Create a list with only one element.

    {2 Examples}

    {[
      List.singleton(1234) == list{1234}
      List.singleton("hi") == list{"hi"}
    ]}
*)

val repeat : 'a -> times:int -> 'a t
(** Creates a list of length [times] with the value [x] populated at each index.

    {2 Examples}

    {[
      List.repeat('a', ~times=5) == list{'a', 'a', 'a', 'a', 'a'}
      List.repeat(7, ~times=0) == list{}
      List.repeat("Why?", ~times=-1) == list{}
    ]}
*)

val range : ?from:int -> int -> int t
(** Creates a list containing all of the integers from [from] if it is provided or [0] if not, up to but not including [to]

    {2 Examples}

    {[
      List.range(5) == list{0, 1, 2, 3, 4}
      List.range(5, ~from=2) == list{2, 3, 4}
      List.range(3, ~from=-2) == list{-2, -1, 0, 1, 2}
    ]}
*)

val initialize : int -> f:(int -> 'a) -> 'a t
(** Initialize a list.

    [List.initialize(n, ~f)] creates a list of length [n] by setting the element at position [index] to be [f(index)].

    {2 Examples}

    {[
      List.initialize(4, ~f=identity) == list{0, 1, 2, 3}
      List.initialize(4, ~f=index => index * index) == list{0, 1, 4, 9}
    ]}
*)

val fromArray : 'a array -> 'a t
(** Create a list from an {!Array}.

    {2 Examples}

    {[
      List.fromArray([1, 2, 3]) == list{1, 2, 3}
    ]}
*)

(** {1 Basic operations} *)

val head : 'a t -> 'a option
(** Returns, as an {!Option}, the first element of a list.

    If the list is empty, returns [None].

    {2 Examples}

    {[
      List.head(list{1, 2, 3}) == Some(1)
      List.head(list{}) == None
    ]}
*)

val tail : 'a t -> 'a t option
(** Returns, as an {!Option}, a list without its first element.

    If the list is empty, returns [None]

    {2 Examples}

    {[
      List.tail(list{1, 2, 3}) == Some(list{2, 3})
      List.tail(list{1}) == Some(list{})
      List.tail(list{}) == None
    ]}
*)

val cons : 'a t -> 'a -> 'a t
(** Prepend a value to the front of a list.

    The spread syntax [...] operator can also be used.

    {2 Examples}

    {[
      List.cons(list{2, 3, 4}, 1) == list{1, 2, 3, 4}
      
      let b = list{3, 4}

      list{1, 2, ...b} == list{1, 2, 3, 4} 
   ]}
*)

val take : 'a t -> count:int -> 'a t
(** Attempt to take the first [count] elements of a list.

   If the list has fewer than [count] elements, returns the entire list.

   If count is zero or negative, returns [list{}].

   {2 Examples}

   {[
      List.take(list{1, 2, 3}, ~count=2) == list{1, 2}
      List.take(list{}, ~count=2) == list{}
      List.take(list{1, 2, 3, 4}, ~count=8) == list{1, 2, 3, 4}
      List.take(list{1, 2, 3, 4}, ~count=-1) == list{}
    ]}
*)

val takeWhile : 'a t -> f:('a -> bool) -> 'a t
(** Take elements from a list until [f] returns [false].

    {2 Examples}

    {[
      List.takeWhile(list{2, 4, 6, 7, 8, 9}, ~f=Int.isEven) == list{2, 4, 6}
      List.takeWhile(list{2, 4, 6}, ~f=Int.isEven) == list{2, 4, 6}
      List.takeWhile(list{1, 2, 3}, ~f=Int.isEven) == list{}
   ]}
*)

val drop : 'a t -> count:int -> 'a t
(** Drop the first [count] elements from the front of a list.

    If the list has fewer than [count] elements, returns [].

    If count is zero or negative, returns the entire list.

    {2 Examples}

    {[
      List.drop(list{1, 2, 3, 4}, ~count=2) == list{3, 4}
      List.drop(list{1, 2, 3, 4}, ~count=6) == list{}
      List.drop(list{1, 2, 3, 4}, ~count=-1) == list{1, 2, 3, 4}
    ]}
*)

val dropWhile : 'a t -> f:('a -> bool) -> 'a t
(** Drop elements from a list until [f] returns [false].

    {2 Examples}

    {[
      List.dropWhile(list{2, 4, 6, 7, 8, 9}, ~f=Int.isEven) == list{7, 8, 9}
      List.dropWhile(list{2, 4, 6, 8}, ~f=Int.isEven) == list{}
      List.dropWhile(list{1, 2, 3}, ~f=Int.isEven) == list{1, 2, 3}
    ]}
*)

val initial : 'a t -> 'a t option
(** As an {!Option} get of all of the elements of a list except the last one.

    Returns [None] if the list is empty.

    {2 Examples}

    {[
      List.initial(list{1, 2, 3}) == Some(list{1, 2})
      List.initial(list{1}) == Some(list{})
      List.initial(list{}) = None
    ]}
*)

val last : 'a t -> 'a option
(** Get the last element of a list.

    Returns [None] if the list is empty.

    {b Warning} This will iterate through the entire list.

    {2 Examples}

    {[
      List.last(list{1, 2, 3}) == Some(3)
      List.last(list{1}) == Some(1)
      List.last(list{}) == None
    ]}
*)

val getAt : 'a t -> index:int -> 'a option
(** Returns the element at position [index] in the list.

    Returns [None] if [index] is outside of the bounds of the list.

    {2 Examples}

    {[
      List.getAt(list{1, 2, 3}, ~index=1) == Some(2)
      List.getAt(list{}, ~index=2) == None
      List.getAt(list{1, 2, 3}, ~index=100) == None
    ]}
*)

val insertAt : 'a t -> index:int -> value:'a -> 'a t
(** Insert a new element at the specified index.

    The element previously occupying [index] will now be at [index + 1]

    If [index] is greater than then length of the list, it will be appended:

    {3 Exceptions}

    Raises an [Invalid_argument] exception if [index] is negative.

    {2 Examples}

    {[
      list{100, 101, 102, 103}->List.insertAt(~index=2, ~value=999) == list{100, 101, 999, 102, 103}
      list{100, 101, 102, 103}->List.insertAt(~index=0, ~value=999) == list{999, 100, 101, 102, 103}
      list{100, 101, 102, 103}->List.insertAt(~index=4, ~value=999) == list{100, 101, 102, 103, 999}
      list{100, 101, 102, 103}->List.insertAt(~index=-1, ~value=999) == list{999, 100, 101, 102, 103}
      list{100, 101, 102, 103}->List.insertAt(~index=5, ~value=999)  == list{ 100, 101, 102, 103, 999 }
    ]}
*)

val updateAt : 'a t -> index:int -> f:('a -> 'a) -> 'a t
(** Returns a new list with the value at [index] updated to be the result of applying [f].

    If [index] is outside of the bounds of the list, returns the list as-is.

    {2 Examples}

    {[
      List.updateAt(list{1, 2, 3}, ~index=1, ~f=Int.add(3)) == list{1, 5, 3}
      
      let animals = list{"Ant", "Bat", "Cat"}
      animals == List.updateAt(animals, ~index=4, ~f=String.reverse) 
   ]}
*)

val removeAt : 'a t -> index:int -> 'a t
(** Creates a new list without the element at [index].

    If [index] is outside of the bounds of the list, returns the list as-is.

    {2 Examples}

    {[
      List.removeAt(list{1, 2, 3}, ~index=2) == list{1, 2}
      
      let animals = list{"Ant", "Bat", "Cat"}
      List.equal(String.equal, animals, List.removeAt(animals, ~index=4)) == true
   ]}
*)

val reverse : 'a t -> 'a t
(** Reverse the elements in a list.

    {2 Examples}

    {[
      list{1, 2, 3}->List.reverse == list{3, 2, 1}
    ]}
 *)

val sort : 'a t -> compare:('a -> 'a -> int) -> 'a t
(** Sort using the provided [compare] function.

    {2 Examples}

    {[
      List.sort(list{5, 6, 8, 3, 6}, ~compare=Int.compare) == list{3, 5, 6, 6, 8}
    ]}
*)

val sortBy : 'a t -> f:('a -> 'b) -> 'a t
(**
    [List.sortBy(xs, ~f=fcn)] returns a new list sorted according to the values
    returned by [fcn]. This is a stable sort: if two items have the same value,
    they will appear in the same order that they appeared in the original list.
    {[
      List.sortBy(list{3, 2, 5, -2, 4}, ~f=x => x * x) == list{2, -2, 3, 4, 5}
   ]}
*)

(** {1 Query} *)

val isEmpty : _ t -> bool
(** Determine if a list is empty.

    {2 Examples}

    {[
      List.empty->List.isEmpty == true
      list{}->List.isEmpty == true
      list{1, 2, 3}->List.isEmpty == false
    ]}
*)

val length : 'a t -> int
(** Return the number of elements in a list.

    {b Warning} [List.length] needs to access the {b entire} list in order to calculate its result.

    If you need fast access to the length, perhaps you need an {!Array}.

    A common mistake is to have something like the following:

    {[
      if List.length(someList) == 0 {
        () //  It will take longer than you think to reach here
      } else {
        () // But it doesn't need to
      }
    ]}

    instead you should do

    {[
      if List.isEmpty(someList) {
        () // This happens instantly
      } else {
        () // Since List.isEmpty takes the same amount of time for all lists 
      }
    ]}

    Or

    {[
      switch someList {
      | list{} => () // Spoilers
      | _ => () // This is how isEmpty is implemented
      }
   ]}

    {2 Examples}

    {[
      List.length(list{}) == 0
      list{7, 8, 9}->List.length == 3
    ]}
*)

val any : 'a t -> f:('a -> bool) -> bool
(** Determine if [f] returns true for [any] values in a list.

    Stops iteration as soon as [f] returns true.

    {2 Examples}

    {[
      List.any(list{2, 3}, ~f=Int.isEven) == true
      List.any(list{1, 3}, ~f=Int.isEven) == false
      List.any(list{}, ~f=Int.isEven) == false
    ]}
*)

val all : 'a t -> f:('a -> bool) -> bool
(** Determine if [f] returns true for [all] values in a list.

    Stops iteration as soon as [f] returns false.

    {2 Examples}

    {[
      List.all(list{2, 4}, ~f=Int.isEven) == true
      List.all(list{2, 3}, ~f=Int.isEven) == false
      List.all(list{}, ~f=Int.isEven) == true
    ]}
*)

val count : 'a t -> f:('a -> bool) -> int
(** Count the number of elements where function [f] returns [true].

    {2 Examples}

    {[
      List.count(list{7, 5, 8, 6}, ~f=Int.isEven) == 2
    ]}
 *)

val uniqueBy : 'a list -> f:('a -> string) -> 'a list
(**
   [List.uniqueBy(xs, ~f=fcn)] returns a new list containing only those elements from [xs]
   that have a unique value when [fcn] is applied to them.

   The function [fcn] takes as its single parameter an item from the list
   and returns a [string]. If the function generates the same string for two or more
   list items, only the first of them is retained.
   
   {2 Examples}
  
   {[
      List.uniqueBy(list{1, 3, 4, 3, 7, 7, 6}, ~f=Int.toString) == list{1, 3, 4, 7, 6}
      let absStr = x => Int.absolute(x)->Int.toString
      List.uniqueBy(list{1, 3, 4, -3, -7, 7, 6}, ~f=absStr) == list{1, 3, 4, -7, 6}
  ]}
 *)

val find : 'a t -> f:('a -> bool) -> 'a option
(** Returns, as an [option], the first element for which [f] evaluates to true.

  If [f] doesn't return [true] for any of the elements [find] will return [None].

  {2 Examples}

  {[
      List.find(list{1, 3, 4, 8}, ~f=Int.isEven) == Some(4)
      List.find(list{0, 2, 4, 8}, ~f=Int.isOdd) == None
      List.find(list{}, ~f=Int.isEven) == None
  ]}
*)

val findIndex : 'a t -> f:(int -> 'a -> bool) -> (int * 'a) option
(** Returns, as an option, a tuple of the first element and its index for which [f] evaluates to true.

    If [f] doesnt return [true] for any [(index, element)] pair, returns [None].

    {2 Examples}

    {[
      List.findIndex(
        list{1, 3, 4, 8},
        ~f=(index, number) => index > 2 && Int.isEven(number)
       ) == Some(3, 8)
    ]}
*)

val includes : 'a t -> 'a -> equal:('a -> 'a -> bool) -> bool
(** Test if a list contains the specified element using the provided [equal] to test for equality.

    This function may iterate the entire list, so if your code needs to
    repeatedly perform this check, maybe you want a {!Set} instead.

    {2 Examples}

    {[
      List.includes(list{1, 3, 5, 7}, 3, ~equal=Int.equal) == true
      List.includes(list{1, 3, 5, 7}, 4, ~equal=Int.equal) == false
      List.includes(list{}, 5, ~equal=Int.equal) == false
    ]}
*)

val minimumBy : f:('a -> 'comparable) -> 'a list -> 'a option
(**
    [List.minimumBy(xs, ~f=fcn)], when given a non-empty list, returns the item in the list
    for which [fcn item] is a minimum. It is returned as [Some(item)].

    If given an empty list, [List.minimumBy] returns [None]. If more than one value has
    a minimum value for [fcn item], the first one is returned.

    The function provided takes a list item as its parameter and must return a value
    that can be compared: for example, a [string] or [int].
        
    {2 Examples}

    {[
      let mod12 = x => mod(x, 12)
      let hours = list{7, 9, 15, 10, 3, 22}
      List.minimumBy(hours, ~f=mod12) == Some(15)
      list{}->List.minimumBy(~f=mod12) == None
     ]}
*)

val maximumBy : f:('a -> 'comparable) -> 'a list -> 'a option
(**
     [List.maximumBy ~f:fcn xs], when given a non-empty list, returns the item in the list
     for which [fcn item] is a maximum. It is returned as [Some item].
     
     If given an empty list, [List.maximumBy] returns [None]. If more than one value
     has a maximum value for [fcn item], the first one is returned.
     
     The function provided takes a list item as its parameter and must return a value
     that can be compared: for example, a [string] or [int].
         
     {2 Examples}

     {[
        let mod12 = x => mod(x, 12)
        let hours = list{7, 9, 15, 10, 3, 22}
        List.maximumBy(hours, ~f=mod12) == Some(10)
        list{}->List.maximumBy(~f=mod12) == None
     ]}
*)

val minimum : 'a t -> compare:('a -> 'a -> int) -> 'a option
(** Find the smallest element using the provided [compare] function.

    Returns [None] if called on an empty list.

    {2 Examples}

    {[
      List.minimum(list{7, 5, 8, 6}, ~compare=Int.compare) == Some(5)
    ]}
*)

val maximum : 'a t -> compare:('a -> 'a -> int) -> 'a option
(** Find the largest element using the provided [compare] function.

    Returns [None] if called on an empty list.

    {2 Examples}

    {[
      List.maximum(list{7, 5, 8, 6}, ~compare) == Some(8)
    ]}
*)

val extent : 'a t -> compare:('a -> 'a -> int) -> ('a * 'a) option
(** Find a {!Tuple2} of the [(minimum, maximum)] elements using the provided [compare] function.

    Returns [None] if called on an empty list.

    {2 Examples}

    {[
      List.extent(list{7, 5, 8, 6}, ~compare) == Some(5, 8)
    ]}
*)

val sum : 'a t -> (module TableclothContainer.Sum with type t = 'a) -> 'a
(** Calculate the sum of a list using the provided modules [zero] value and [add] function.

    {2 Examples}

    {[
      List.sum(list{1, 2, 3}, module(Int)) == 6
      List.sum(list{4.0, 4.5, 5.0}, module(Float)) == 13.5
      
     List.sum(
        list{"a", "b", "c"},
        module(
          {
            type t = string
            let zero = ""
            let add = (a, b) => a ++ b
          }
        ),
      ) == "abc"
    ]}
*)

(** {1 Transform} *)

val map : 'a t -> f:('a -> 'b) -> 'b t
(** Create a new list which is the result of applying a function [f] to every element.

    {2 Examples}

    {[
      List.map(list{1.0, 4.0, 9.0}, ~f=Float.squareRoot) == list{1.0, 2.0, 3.0}
    ]}
*)

val mapWithIndex : 'a t -> f:(int -> 'a -> 'b) -> 'b t
(** Apply a function [f] to every element and its index.

    {2 Examples}

    {[
      List.mapWithIndex(list{"zero", "one", "two"}, ~f=(index, element) =>
          Int.toString(index) ++ ": " ++ element
      ) == list{"0: zero", "1: one", "2: two"}
    ]}
*)

val filter : 'a t -> f:('a -> bool) -> 'a t
(** Keep elements that [f] returns [true] for.

    {2 Examples}

    {[
      List.filter(list{1, 2, 3, 4, 5, 6}, ~f=Int.isEven) == list{2, 4, 6}
    ]}
*)

val filterWithIndex : 'a t -> f:(int -> 'a -> bool) -> 'a t
(** Like {!filter} but [f] is also called with each elements index. *)

val filterMap : 'a t -> f:('a -> 'b option) -> 'b t
(** Allows you to combine {!map} and {!filter} into a single pass.

    The output list only contains elements for which [f] returns [Some].

    Why [filterMap] and not just {!filter} then {!map}?

    {!filterMap} removes the {!Option} layer automatically.
    If your mapping is already returning an {!Option} and you want to skip over [None]s, then [filterMap] is much nicer to use.

    {2 Examples}

    {[
      let characters = list{'a', '9', '6', ' ', '2', 'z'}
      List.filterMap(characters, ~f=Char.toDigit) == list{9, 6, 2}

      List.filterMap(list{3, 4, 5, 6},
        ~f=number => Int.isEven(number) ? Some(number * number) : None
      ) == list{16, 36}
    ]}
*)

val flatMap : 'a t -> f:('a -> 'b t) -> 'b t
(** Apply a function [f] onto a list and {!flatten} the resulting list of lists.

    {2 Examples}

    {[
      List.flatMap(xs, ~f) == List.map(xs, ~f)->List.flatten
      list{1, 2, 3}->List.flatMap(~f=n => list{n, n}) == list{1, 1, 2, 2, 3, 3}
    ]}
*)

val fold : 'a t -> initial:'b -> f:('b -> 'a -> 'b) -> 'b
(** Transform a list into a value.

    After applying [f] to every element of the list, [fold] returns the accumulator.

    [fold] iterates over the elements of the list from first to last.

    For examples if we have:

    {[
      let numbers = list{1, 2, 3}
      let sum = List.fold(numbers, ~initial=0, ~f=(accumulator, element) => accumulator + element)

      sum == 6
    ]}

    Walking though each iteration step by step:

    + [accumulator: 0, element: 1, result: 1]
    + [accumulator: 1, element: 2, result: 3]
    + [accumulator: 3, element: 3, result: 6]

    And so the final result is [6]. (Note that in this case you probably want to use {!List.sum})

    {b Examples continued}

    {[
      List.fold(list{1, 2, 3}, ~initial=list{}, ~f=List.cons) == list{3, 2, 1}
      
      let unique = integers => List.fold(integers, ~initial=Set.Int.empty, ~f=Set.add)->Set.toList

      unique(list{1, 1, 2, 3, 2}) == list{1, 2, 3}

      let lastEven = integers =>
      List.fold(integers, ~initial=None, ~f=(last, int) => Int.isEven(int) ? Some(int) : last)

      lastEven(list{1, 2, 3, 4, 5}) == Some(4)
    ]}
*)

val foldRight : 'a t -> initial:'b -> f:('b -> 'a -> 'b) -> 'b
(** This method is like {!fold} except that it iterates over the elements of the list from last to first. *)

(** {1 Combine} *)

val append : 'a t -> 'a t -> 'a t
(** Creates a new list which is the result of appending the second list onto the end of the first.

    {2 Examples}

    {[
      let fourtyTwos = List.repeat(~times=2, 42)
      let eightyOnes = List.repeat(~times=3, 81)
      List.append(fourtyTwos, eightyOnes) == list{42, 42, 81, 81, 81}
    ]}
*)

val flatten : 'a t t -> 'a t
(** Concatenate a list of lists into a single list.

    {2 Examples}

    {[
      List.flatten(list{list{1, 2}, list{3}, list{4, 5}}) == list{1, 2, 3, 4, 5}
    ]}
*)

val zip : 'a t -> 'b t -> ('a * 'b) t
(** Combine two lists by merging each pair of elements into a {!Tuple2}.

    If one list is longer, the extra elements are dropped.

    The same as [List.map2(~f=Tuple2.make)].

    {2 Examples}

    {[
      List.zip(list{1, 2, 3, 4, 5}, list{"Dog", "Eagle", "Ferret"})
      == list{(1, "Dog"), (2, "Eagle"), (3, "Ferret")}
    ]}
*)

val map2 : 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t
(** Combine two lists, using [f] to combine each pair of elements.

    If one list is longer, the extra elements are dropped.

    {2 Examples}

    {[
      List.map2(list{1, 2, 3}, list{4, 5, 6}, ~f=Int.add) == list{5, 7, 9}
      
      List.map2(
        list{"alice", "bob", "chuck"}, list{3, 5, 7, 9, 11, 13, 15, 17, 19},
        ~f=Tuple2.make
      ) == list{("alice", 3), ("bob", 5), ("chuck", 7)}
    ]}
*)

val map3 : 'a t -> 'b t -> 'c t -> f:('a -> 'b -> 'c -> 'd) -> 'd t
(** Combine three lists, using [f] to combine each trio of elements.

    If one list is longer, the extra elements are dropped.

    {2 Examples}

    {[
      List.map3(
          ~f=Tuple3.make,
          list{"alice", "bob", "chuck"},
          list{2, 5, 7, 8},
          list{true, false, true, false},
      ) == list{("alice", 2, true), ("bob", 5, false), ("chuck", 7, true)}
    ]}
*)

(** {1 Deconstruct} *)

val partition : 'a t -> f:('a -> bool) -> 'a t * 'a t
(** Split a list into a {!Tuple2} of lists. Values which [f] returns true for will end up in {!Tuple2.first}.

    {2 Examples}

    {[
      List.partition(list{1, 2, 3, 4, 5, 6}, ~f=Int.isOdd) == (list{1, 3, 5}, list{2, 4, 6})
    ]}
*)

val splitAt : 'a t -> index:int -> 'a t * 'a t
(** Divides a list into a {!Tuple2} of lists.

    Elements which have index upto (but not including) [index] will be in the first component of the tuple.

    Elements with an index greater than or equal to [index] will be in the second.

    If [index] is zero or negative, all elements will be in the second component of the tuple.

    If [index] is greater than the length of the list, all elements will be in the second component of the tuple.

    {2 Examples}

    {[
      List.splitAt(list{1, 2, 3, 4, 5}, ~index=2) == (list{1, 2}, list{3, 4, 5})
      List.splitAt(list{1, 2, 3, 4, 5}, ~index=-1) == (list{}, list{1, 2, 3, 4, 5})
      List.splitAt(list{1, 2, 3, 4, 5}, ~index=10) == (list{1, 2, 3, 4, 5}, 10)
    ]}
*)

val splitWhen : 'a t -> f:('a -> bool) -> 'a t * 'a t
(** Divides a list into a {!Tuple2} at the first element where function [f] will return [true].

    Elements up to (but not including) the first element [f] returns [true] for
    will be in the first component of the tuple, the remaining elements will be
    in the second.

    {2 Examples}

    {[
      List.splitWhen(list{2, 4, 5, 6, 7}, ~f=Int.isEven) == (list{2, 4}, list{5, 6, 7})
      List.splitWhen(list{2, 4, 5, 6, 7}, ~f=Fun.constant(false)) == (list{2, 4, 5, 6, 7}, list{})
    ]}
*)

val unzip : ('a * 'b) t -> 'a t * 'b t
(** Decompose a list of {!Tuple2} into a {!Tuple2} of lists.

    {2 Examples}

    {[
      List.unzip(list{(0, true), (17, false), (1337, true)})
      == (list{0, 17, 1337}, list{true, false, true})
    ]}
*)

(** {1 Iterate} *)

val forEach : 'a t -> f:('a -> unit) -> unit
(** Iterates over the elements of invokes [f] for each element.

    The function you provide must return [unit], and the [forEach] call itself also returns [unit].

    You use [List.forEach] when you want to process a list only for side effects.

    {2 Examples}

    {[
      List.forEach(list{1, 2, 3}, ~f=int => Int.toString(int)->Js.log)
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
      List.forEachWithIndex(list{1, 2, 3}, ~f=(index, int) => j`$index: $int`->Js.log)
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

    {[
      List.intersperse(~sep="on", list{"turtles", "turtles", "turtles"})
      == list{"turtles", "on", "turtles", "on", "turtles"}
    
      List.intersperse(list{}, ~sep=0) == list{}
    ]}
*)

val chunksOf : 'a t -> size:int -> 'a t t
(** Split a list into equally sized chunks.

    If there aren't enough elements to make the last 'chunk', those elements are ignored.

    {2 Examples}

    {[
      List.chunksOf(~size=2, list{"#FFBA49", "#9984D4", "#20A39E", "#EF5B5B", "#23001E"})
      == list{list{"#FFBA49", "#9984D4"}, list{"#20A39E", "#EF5B5B"}}
    ]}
 *)

val sliding : ?step:int -> 'a t -> size:int -> 'a t t
(** Provides a sliding 'window' of sub-lists over a list.

    The first sub-list starts at the head of the list and takes the first [size] elements.

    The sub-list then advances [step] (which defaults to 1) positions before taking the next [size] elements.

    The sub-lists are guaranteed to always be of length [size] and iteration stops once a sub-list would extend beyond the end of the list.

    {2 Examples}

    {[
      List.sliding(list{1, 2, 3, 4, 5}, ~size=1) == list{list{1}, list{2}, list{3}, list{4}, list{5}}
      List.sliding(list{1, 2, 3, 4, 5}, ~size=2) == list{list{1, 2}, list{2, 3}, list{3, 4}, list{4, 5}}
      List.sliding(list{1, 2, 3, 4, 5}, ~size=3) == list{list{1, 2, 3}, list{2, 3, 4}, list{3, 4, 5}}
      List.sliding(list{1, 2, 3, 4, 5}, ~size=2, ~step=2) == list{list{1, 2}, list{3, 4}}
      List.sliding(list{1, 2, 3, 4, 5}, ~size=1, ~step=3) == list{list{1}, list{4}}
      List.sliding(list{1, 2, 3, 4, 5}, ~size=2, ~step=3) == list{list{1, 2}, list{4, 5}}
      List.sliding(list{1, 2, 3, 4, 5}, ~size=7) == list{}
    ]}
*)

val groupWhile : 'a t -> f:('a -> 'a -> bool) -> 'a t t
(** Divide a list into groups.

    [f] is called with consecutive elements, when [f] returns [false] a new group is started.

    {2 Examples}

    {[
      List.groupWhile(list{1, 2, 3}, ~f=Fun.constant(false)) == list{list{1}, list{2}, list{3}}

      List.groupWhile(list{1, 2, 3}, ~f=Fun.constant(true)) == list{list{1, 2, 3}}

      List.groupWhile(list{"a", "b", "b", "a", "a", "a", "b", "a"}, ~f=String.equal)
      == list{list{"a"}, list{"b", "b"}, list{"a", "a", "a"}(list{"b"}), list{"a"}}

      List.groupWhile(list{"a", "b", "b", "a", "a", "a", "b", "a"}, ~f=String.equal)
      == list{list{"a"}, list{"b", "b"}, list{"a", "a", "a"}, list{"b"}, list{"a"}}
   ]}
*)

(** {1 Convert} *)

val join : string t -> sep:string -> string
(** Converts a list of strings into a {!String}, placing [sep] between each string in the result.

    {2 Examples}

    {[
      List.join(list{"Ant", "Bat", "Cat"}, ~sep=", ") == "Ant, Bat, Cat"
    ]}
 *)

val groupBy :
     'value t
  -> ('key, 'id) TableclothComparator.s
  -> f:('value -> 'key)
  -> ('key, 'value list, 'id) TableclothMap.t
(** Collect elements which [f] produces the same key for.

    Produces a map from ['key] to a {!List} of all elements which produce the same ['key].

    {2 Examples}

    {[
      let animals = list{"Ant", "Bear", "Cat", "Dewgong"}
      List.groupBy(animals, module(Int), ~f=String.length)->Map.toList ==
      list{(3, list{"Cat", "Ant"}), (4, list{"Bear"}), (7, list{"Dewgong"})}
    ]}
*)

val toArray : 'a t -> 'a array
(** Converts a list to an {!Array}. *)

(** {1 Compare} *)

val equal : 'a t -> 'a t -> ('a -> 'a -> bool) -> bool
(** Test two lists for equality using the provided function to test elements. *)

val compare : 'a t -> 'a t -> f:('a -> 'a -> int) -> int
(** Compare two lists using the provided [f] function to compare elements.

    A shorter list is 'less' than a longer one.

    {2 Examples}

    {[
      List.compare(list{1, 2, 3}, list{1, 2, 3, 4}, ~f=Int.compare) == -1
      List.compare(list{1, 2, 3}, list{1, 2, 3}, ~f=Int.compare) == 0
      List.compare(list{1, 2, 5}, list{1, 2, 3}, ~f=Int.compare) == 1
    ]}
*)
