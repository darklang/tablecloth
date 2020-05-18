open Tablecloth
open AlcoJest
module AT = Alcotest

let t_Array () =
  AT.check
    (AT.array AT.int)
    "singleton - equals an array literal of the same value"
    (Array.singleton 1234)
    [| 1234 |] ;
  AT.check AT.int "singleton - has length one" Array.(singleton 1 |> length) 1 ;

  AT.check
    AT.int
    "length - equals an array literal of the same value"
    (Array.length [||])
    0 ;
  AT.check AT.int "length - has length one" (Array.length [| 'a' |]) 1 ;
  AT.check AT.int "length - has length two" (Array.length [| "a"; "b" |]) 2 ;

  AT.check
    AT.bool
    "isEmpty - returns true for empty array literals"
    (Array.isEmpty [||])
    true ;
  AT.check
    AT.bool
    "isEmpty - returns false for literals with a non-zero number of elements"
    (Array.isEmpty [| 1234 |])
    false ;

  AT.check (AT.list AT.int) "map2 empty lists" (List.map2 ~f:( + ) [] []) [] ;
  AT.check
    (AT.list AT.int)
    "map2 one element"
    (List.map2 ~f:( + ) [ 1 ] [ 1 ])
    [ 2 ] ;
  AT.check
    (AT.list AT.int)
    "map2 two elements"
    (List.map2 ~f:( + ) [ 1; 2 ] [ 1; 2 ])
    [ 2; 4 ] ;
  AT.check
    (AT.array AT.int)
    "initialize - create empty array"
    (Array.initialize ~length:0 ~f:Fun.identity)
    [||] ;
  AT.check
    (AT.array AT.int)
    "initialize - negative length gives an empty array"
    (Array.initialize ~length:(-1) ~f:Fun.identity)
    [||] ;
  AT.check
    (AT.array AT.int)
    "initialize - create array with initialize"
    (Array.initialize ~length:3 ~f:Fun.identity)
    [| 0; 1; 2 |] ;

  AT.check
    (AT.list AT.int)
    "indexedMap empty list"
    (List.indexedMap ~f:(fun i _ -> i) [])
    [] ;
  AT.check
    (AT.list AT.int)
    "indexedMap one element"
    (List.indexedMap ~f:(fun i _ -> i) [ 'a' ])
    [ 0 ] ;
  AT.check
    (AT.list AT.int)
    "indexedMap two elements"
    (List.indexedMap ~f:(fun i _ -> i) [ 'a'; 'b' ])
    [ 0; 1 ] ;
  AT.check
    (AT.array AT.int)
    "repeat - length zero creates an empty array"
    (Array.repeat 0 ~length:0)
    [||] ;
  AT.check
    (AT.array AT.int)
    "repeat - negative length gives an empty array"
    (Array.repeat ~length:(-1) 0)
    [||] ;
  AT.check
    (AT.array AT.int)
    "repeat - create array of ints"
    (Array.repeat 0 ~length:3)
    [| 0; 0; 0 |] ;
  AT.check
    (AT.array AT.string)
    "repeat - create array strings"
    (Array.repeat "cat" ~length:3)
    [| "cat"; "cat"; "cat" |] ;

  AT.check
    (AT.array AT.int)
    "range - returns an array of the integers from zero and upto but not including [to]"
    (Array.range 5)
    [| 0; 1; 2; 3; 4 |] ;
  AT.check
    (AT.array AT.int)
    "range - returns an empty array when [to] is zero"
    (Array.range 0)
    [||] ;
  AT.check
    (AT.array AT.int)
    "range - takes an optional [from] argument to start create empty array"
    (Array.range ~from:2 5)
    [| 2; 3; 4 |] ;
  AT.check
    (AT.array AT.int)
    "range - returns an array of the integers from zero and upto but not including [to_]"
    (Array.range 5)
    [| 0; 1; 2; 3; 4 |] ;
  AT.check
    (AT.array AT.int)
    "range - returns an array of the integers from zero and upto but not including [to_]"
    (Array.range 0)
    [||] ;
  AT.check
    (AT.array AT.int)
    "range - takes an optional [from] argument to start create empty array"
    (Array.range ~from:2 5)
    [| 2; 3; 4 |] ;
  AT.check
    (AT.array AT.int)
    "range - can start from negative values"
    (Array.range ~from:(-2) 3)
    [| -2; -1; 0; 1; 2 |] ;
  AT.check
    (AT.array AT.int)
    "range - returns an empty array when [from] > [to_]"
    (Array.range ~from:5 0)
    [||] ;
  AT.check
    (AT.array AT.int)
    "range - can start from negative values"
    (Array.range ~from:(-2) 3)
    [| -2; -1; 0; 1; 2 |] ;
  AT.check
    (AT.array AT.int)
    "range - returns an empty array when [from] > [to_]"
    (Array.range ~from:5 0)
    [||] ;

  AT.check
    (AT.list AT.int)
    "indexedMap empty list"
    (List.indexedMap ~f:(fun _ n -> n + 1) [])
    [] ;
  AT.check
    (AT.list AT.int)
    "indexedMap one element"
    (List.indexedMap ~f:(fun _ n -> n + 1) [ -1 ])
    [ 0 ] ;
  AT.check
    (AT.list AT.int)
    "indexedMap two elements"
    (List.indexedMap ~f:(fun _ n -> n + 1) [ -1; 0 ])
    [ 0; 1 ] ;
  AT.check
    (AT.array AT.int)
    "fromList - transforms a list into an array of the same elements"
    Array.(fromList [ 1; 2; 3 ])
    [| 1; 2; 3 |] ;

  AT.check
    (AT.list AT.int)
    "toList - transform an array into a list of the same elements"
    (Array.toList [| 1; 2; 3 |])
    [ 1; 2; 3 ] ;

  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "partition empty list"
    (List.partition ~f:(fun x -> x mod 2 = 0) [])
    ([], []) ;
  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "partition one element"
    (List.partition ~f:(fun x -> x mod 2 = 0) [ 1 ])
    ([], [ 1 ]) ;
  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "partition four elements"
    (List.partition ~f:(fun x -> x mod 2 = 0) [ 1; 2; 3; 4 ])
    ([ 2; 4 ], [ 1; 3 ]) ;
  AT.check
    (AT.list (AT.pair AT.int AT.string))
    "toIndexedList - returns an empty list for an empty array"
    (Array.toIndexedList [||])
    [] ;
  AT.check
    (AT.list (AT.pair AT.int AT.string))
    "toIndexedList - transforms an array into a list of tuples"
    (Array.toIndexedList [| "cat"; "dog" |])
    [ (0, "cat"); (1, "dog") ] ;

  AT.check
    (AT.option AT.string)
    "get - returns Some for an in-bounds index"
    [| "cat"; "dog"; "eel" |].(2)
    (Some "eel") ;
  AT.check
    (AT.option AT.int)
    "get - returns None for an out of bounds index"
    [| 0; 1; 2 |].(5)
    None ;
  AT.check
    (AT.option AT.int)
    "get - returns None for an empty array"
    [||].(0)
    None ;

  AT.check
    (AT.option AT.string)
    "getAt - returns Some for an in-bounds index"
    (Array.getAt ~index:2 [| "cat"; "dog"; "eel" |])
    (Some "eel") ;
  AT.check
    (AT.option AT.int)
    "getAt - returns None for an out of bounds index"
    (Array.getAt ~index:5 [| 0; 1; 2 |])
    None ;
  AT.check
    (AT.option AT.int)
    "getAt - returns None for an empty array"
    (Array.getAt ~index:0 [||])
    None ;

  AT.check
    (AT.array AT.int)
    "set - can set a value at an index"
    (let numbers = [| 1; 2; 3 |] in
     numbers.(0) <- 0 ;
     numbers)
    [| 0; 2; 3 |] ;

  AT.check
    (AT.array AT.int)
    "setAt - can be partially applied to set an element"
    (let setZero = Array.setAt ~value:0 in
     let numbers = [| 1; 2; 3 |] in
     setZero numbers ~index:2 ;
     setZero numbers ~index:1 ;
     numbers)
    [| 1; 0; 0 |] ;

  AT.check
    (AT.array AT.string)
    "setAt - can be partially applied to set an index"
    (let setZerothElement = Array.setAt ~index:0 in
     let animals = [| "ant"; "bat"; "cat" |] in
     setZerothElement animals ~value:"antelope" ;
     animals)
    [| "antelope"; "bat"; "cat" |] ;

  AT.check AT.int "sum - equals zero for an empty array" (Array.sum [||]) 0 ;

  AT.check
    AT.int
    "sum - adds up the elements on an integer array"
    (Array.sum [| 1; 2; 3 |])
    6 ;

  AT.check
    (AT.float 0.)
    "floatSum - equals zero for an empty array"
    (Array.floatSum [||])
    0.0 ;

  AT.check
    (AT.float 0.)
    "floatSum - adds up the elements of a float array"
    (Array.floatSum [| 1.2; 2.3; 3.4 |])
    6.9 ;

  AT.check
    (AT.array AT.int)
    "filter - keep elements that [f] returns [true] for"
    (Array.filter ~f:Int.isEven [| 1; 2; 3; 4; 5; 6 |])
    [| 2; 4; 6 |] ;

  let numbers = [| 1; 2; 3 |] in
  Array.swap numbers 1 2 ;
  AT.check
    (AT.array AT.int)
    "swap - switches values at the given indicies"
    numbers
    [| 1; 3; 2 |] ;

  AT.check
    (AT.array (AT.float 0.))
    "map - Apply a function [f] to every element in an array"
    (Array.map ~f:sqrt [| 1.0; 4.0; 9.0 |])
    [| 1.0; 2.0; 3.0 |] ;

  AT.check
    (AT.array (AT.array AT.int))
    "sliding - step 1"
    [| [| 1 |]; [| 2 |]; [| 3 |]; [| 4 |]; [| 5 |] |]
    (Array.sliding [| 1; 2; 3; 4; 5 |] ~size:1) ;

  AT.check
    (AT.array (AT.array AT.int))
    "sliding - step 2"
    [| [| 1; 2 |]; [| 2; 3 |]; [| 3; 4 |]; [| 4; 5 |] |]
    (Array.sliding [| 1; 2; 3; 4; 5 |] ~size:2) ;

  AT.check
    (AT.array (AT.array AT.int))
    "sliding - step 3 "
    [| [| 1; 2; 3 |]; [| 2; 3; 4 |]; [| 3; 4; 5 |] |]
    (Array.sliding [| 1; 2; 3; 4; 5 |] ~size:3) ;

  AT.check
    (AT.array (AT.array AT.int))
    "sliding - step 2, size 2"
    [| [| 1; 2 |]; [| 3; 4 |] |]
    (Array.sliding [| 1; 2; 3; 4; 5 |] ~size:2 ~step:2) ;

  AT.check
    (AT.array (AT.array AT.int))
    "sliding - step 1, size 3"
    [| [| 1 |]; [| 4 |] |]
    (Array.sliding [| 1; 2; 3; 4; 5 |] ~size:1 ~step:3) ;

  AT.check
    (AT.array (AT.array AT.int))
    "sliding - step 7"
    [| [| 1; 2 |]; [| 4; 5 |] |]
    (Array.sliding [| 1; 2; 3; 4; 5 |] ~size:2 ~step:3) ;

  AT.check
    (AT.array (AT.array AT.int))
    "sliding - step 7"
    [||]
    (Array.sliding [| 1; 2; 3; 4; 5 |] ~size:7) ;

  AT.check
    (AT.array AT.int)
    "mapWithIndex - equals an array literal of the same value"
    (Array.mapWithIndex ~f:( * ) [| 5; 5; 5 |])
    [| 0; 5; 10 |] ;

  AT.check
    (AT.array AT.int)
    "map2 - works when the order of arguments to `f` is not important"
    (Array.map2 ~f:( + ) [| 1; 2; 3 |] [| 4; 5; 6 |])
    [| 5; 7; 9 |] ;

  AT.check
    (AT.array (AT.pair AT.string AT.int))
    "map2 - works when the order of `f` is important"
    (Array.map2 ~f:Tuple2.create [| "alice"; "bob"; "chuck" |] [| 2; 5; 7; 8 |])
    [| ("alice", 2); ("bob", 5); ("chuck", 7) |] ;

  AT.check
    (AT.array (Eq.trio AT.string AT.int AT.bool))
    "map3"
    (Array.map3
       ~f:Tuple3.create
       [| "alice"; "bob"; "chuck" |]
       [| 2; 5; 7; 8 |]
       [| true; false; true; false |])
    [| ("alice", 2, true); ("bob", 5, false); ("chuck", 7, true) |] ;

  AT.check
    (AT.array AT.int)
    "flatMap"
    (Array.flatMap ~f:(fun n -> [| n; n |]) [| 1; 2; 3 |])
    [| 1; 1; 2; 2; 3; 3 |] ;

  AT.check
    (AT.option AT.int)
    "find - returns the first element which `f` returns true for"
    (Array.find ~f:Int.isEven [| 1; 3; 4; 8 |])
    (Some 4) ;
  AT.check
    (AT.option AT.int)
    "find - returns `None` if `f` returns false for all elements"
    (Array.find ~f:Int.isOdd [| 0; 2; 4; 8 |])
    None ;
  AT.check
    (AT.option AT.int)
    "find - returns `None` for an empty array"
    (Array.find ~f:Int.isEven [||])
    None ;

  AT.check
    (AT.option (AT.pair AT.int AT.int))
    "findIndex - returns the first (index,element) tuple which `f` returns true for"
    (Array.findIndex
       ~f:(fun index number -> index > 2 && Int.isEven number)
       [| 1; 3; 4; 8 |])
    (Some (3, 8)) ;

  AT.check
    (AT.option (AT.pair AT.int AT.int))
    "findIndex - returns `None` if `f` returns false for all elements "
    (Array.findIndex ~f:(fun _ _ -> false) [| 0; 2; 4; 8 |])
    None ;

  AT.check
    (AT.option (AT.pair AT.int AT.int))
    "findIndex - returns `None` for an empty array"
    (Array.findIndex
       ~f:(fun index number -> index > 2 && Int.isEven number)
       [||])
    None ;

  AT.check
    AT.bool
    "any - returns false for empty arrays"
    (Array.any [||] ~f:Int.isEven)
    false ;
  AT.check
    AT.bool
    "any - returns true if at least one of the elements of an array return true for [f]"
    (Array.any [| 1; 3; 4; 5; 7 |] ~f:Int.isEven)
    true ;
  AT.check
    AT.bool
    "any - returns false if all of the elements of an array return false for [f]"
    (Array.any [| 1; 3; 5; 7 |] ~f:Int.isEven)
    false ;

  AT.check
    AT.bool
    "all - returns true for empty arrays"
    (Array.all ~f:Int.isEven [||])
    true ;
  AT.check
    AT.bool
    "all - returns true if [f] returns true for all elements"
    (Array.all ~f:Int.isEven [| 2; 4 |])
    true ;
  AT.check
    AT.bool
    "all - returns false if a single element fails returns false for [f]"
    (Array.all ~f:Int.isEven [| 2; 3 |])
    false ;

  AT.check
    (AT.array AT.int)
    "append"
    (Array.append (Array.repeat ~length:2 42) (Array.repeat ~length:3 81))
    [| 42; 42; 81; 81; 81 |] ;

  AT.check
    (AT.array AT.int)
    "concatenate"
    (Array.concatenate [| [| 1; 2 |]; [| 3 |]; [| 4; 5 |] |])
    [| 1; 2; 3; 4; 5 |] ;

  AT.check
    (AT.array AT.string)
    "intersperse - equals an array literal of the same value"
    [| "turtles"; "on"; "turtles"; "on"; "turtles" |]
    (Array.intersperse ~sep:"on" [| "turtles"; "turtles"; "turtles" |]) ;

  AT.check
    (AT.array AT.int)
    "intersperse - equals an array literal of the same value"
    (Array.intersperse ~sep:0 [||])
    [||] ;

  (let array = [| 0; 1; 2; 3; 4 |] in
   let positiveArrayLengths =
     [ Array.length array; Array.length array + 1; 1000 ]
   in
   let negativeArrayLengths = List.map ~f:Int.negate positiveArrayLengths in
   AT.check
     (AT.array AT.int)
     "slice - should work with a positive `from`"
     (Array.slice ~from:1 array)
     [| 1; 2; 3; 4 |] ;

   AT.check
     (AT.array AT.int)
     "slice - should work with a negative `from`"
     (Array.slice ~from:(-1) array)
     [| 4 |] ;

   Base.List.iter positiveArrayLengths ~f:(fun from ->
       AT.check
         (AT.array AT.int)
         "slice - should work when `from` >= `length`"
         (Array.slice ~from array)
         [||]) ;

   Base.List.iter negativeArrayLengths ~f:(fun from ->
       AT.check
         (AT.array AT.int)
         "slice - should work when `from` <= negative `length`"
         (Array.slice ~from array)
         array) ;

   AT.check
     (AT.array AT.int)
     "slice - should work with a positive `to_`"
     (Array.slice ~from:0 ~to_:3 array)
     [| 0; 1; 2 |] ;

   AT.check
     (AT.array AT.int)
     "slice - should work with a negative `to_`"
     (Array.slice ~from:1 ~to_:(-1) array)
     [| 1; 2; 3 |] ;

   Base.List.iter positiveArrayLengths ~f:(fun to_ ->
       AT.check
         (AT.array AT.int)
         "slice - should work when `to_` >= length"
         (Array.slice ~from:0 ~to_ array)
         array) ;

   Base.List.iter negativeArrayLengths ~f:(fun to_ ->
       AT.check
         (AT.array AT.int)
         "slice - should work when `to_` <= negative `length`"
         (Array.slice ~from:0 ~to_ array)
         [||]) ;

   AT.check
     (AT.array AT.int)
     "slice - should work when both `from` and `to_` are negative and `from` < `to_`"
     (Array.slice ~from:(-2) ~to_:(-1) array)
     [| 3 |] ;

   AT.check
     (AT.array AT.int)
     "slice - works when `from` >= `to_`"
     (Array.slice ~from:4 ~to_:3 array)
     [||]) ;

  AT.check
    AT.string
    "foldLeft - works for an empty array"
    (Array.foldLeft [||] ~f:( ^ ) ~initial:"")
    "" ;
  AT.check
    AT.int
    "foldLeft - works for an ascociative operator"
    (Array.foldLeft ~f:( * ) ~initial:1 (Array.repeat ~length:4 7))
    2401 ;
  AT.check
    AT.string
    "foldLeft - works when the order of arguments to `f` is important"
    (Array.foldLeft [| "a"; "b"; "c" |] ~f:( ^ ) ~initial:"")
    "cba" ;
  AT.check
    (AT.list AT.int)
    "foldLeft - works when the order of arguments to `f` is important"
    (Array.foldLeft
       ~f:(fun element list -> element :: list)
       ~initial:[]
       [| 1; 2; 3 |])
    [ 3; 2; 1 ] ;

  AT.check
    AT.string
    "foldRight - works for empty arrays"
    (Array.foldRight [||] ~f:( ^ ) ~initial:"")
    "" ;
  AT.check
    AT.int
    "foldRight - works for an ascociative operator"
    (Array.foldRight ~f:( + ) ~initial:0 (Array.repeat ~length:3 5))
    15 ;
  AT.check
    AT.string
    "foldRight - works when the order of arguments to `f` is important"
    (Array.foldRight [| "a"; "b"; "c" |] ~f:( ^ ) ~initial:"")
    "abc" ;
  AT.check
    (AT.list AT.int)
    "foldRight - works when the order of arguments to `f` is important"
    (Array.foldRight
       ~f:(fun element list -> element :: list)
       ~initial:[]
       [| 1; 2; 3 |])
    [ 1; 2; 3 ] ;

  AT.check (AT.array AT.int) "reverse - empty array" (Array.reverse [||]) [||] ;
  AT.check
    (AT.array AT.int)
    "reverse - two elements"
    (Array.reverse [| 0; 1 |])
    [| 1; 0 |] ;
  AT.check
    (AT.array AT.int)
    "reverse - leaves the original array untouched"
    (let array = [| 0; 1; 2; 3 |] in
     let _reversedArray = Array.reverse array in
     array)
    [| 0; 1; 2; 3 |] ;

  AT.check
    (AT.array AT.int)
    "reverseInPlace - alters an array in-place"
    (let array = [| 1; 2; 3 |] in
     Array.reverseInPlace array ;
     array)
    [| 3; 2; 1 |] ;

  AT.check
    (AT.array AT.int)
    "forEach"
    (let index = ref 0 in
     let calledValues = [| 0; 0; 0 |] in
     Array.forEach [| 1; 2; 3 |] ~f:(fun value ->
         Array.setAt calledValues ~index:!index ~value ;
         index := !index + 1) ;

     calledValues)
    [| 1; 2; 3 |] ;

  ()


let t_Fun () =
  Fun.(
    AT.check AT.int "identity" 1 (Fun.identity 1) ;

    AT.check AT.unit "ignore" () (Fun.ignore 1) ;

    AT.check AT.int "constant" 1 (Fun.constant 1 2) ;

    AT.check AT.int "sequence" 2 (Fun.sequence 1 2) ;

    AT.check AT.int "flip" 2 (Fun.flip Int.( / ) 2 4) ;

    AT.check AT.int "apply" 2 (Fun.apply (fun a -> a + 1) 1) ;

    AT.check
      AT.int
      "compose"
      3
      (let increment x = x + 1 in
       let double x = x * 2 in
       Fun.compose increment double 1) ;

    AT.check
      AT.int
      "composeRight"
      4
      (let increment x = x + 1 in
       let double x = x * 2 in
       Fun.composeRight increment double 1) ;

    AT.check
      (AT.array AT.int)
      "tap"
      [| 0; 2 |]
      ( Array.filter [| 1; 3; 2; 5; 4 |] ~f:Int.isEven
      |> Fun.tap ~f:(fun numbers -> Base.Array.set numbers 1 0)
      |> Fun.tap ~f:Base.Array.rev_inplace ))


let t_Int () =
  Int.(
    AT.check AT.int "zero" zero 0 ;

    AT.check AT.int "one" one 1 ;

    AT.check AT.int "minimumValue" (minimumValue - 1) maximumValue ;

    AT.check AT.int "maximumValue" (maximumValue + 1) minimumValue ;

    AT.check AT.int "add" (add 3002 4004) 7006 ;
    AT.check AT.int "+" (3002 + 4004) 7006 ;

    AT.check AT.int "subtract" (subtract 4 3) 1 ;
    AT.check AT.int "-" (4 - 3) 1 ;

    AT.check AT.int "multiply" (multiply 2 7) 14 ;
    AT.check AT.int "*" (2 * 7) 14 ;

    AT.check AT.int "divide" (divide 3 ~by:2) 1 ;
    AT.check_raises "division by zero" Division_by_zero (fun () ->
        ignore (divide 3 ~by:0)) ;

    AT.check AT.int "/" (27 / 5) 5 ;

    AT.check (AT.float 0.) "//" (3 // 2) 1.5 ;
    AT.check (AT.float 0.) "//" (27 // 5) 5.4 ;
    AT.check (AT.float 0.) "//" (8 // 4) 2.0 ;
    AT.check AT.bool "x // 0" (8 // 0 = Float.infinity) true ;
    AT.check AT.bool "-x // 0" (-8 // 0 = Float.negativeInfinity) true ;

    AT.check AT.int "power - power" (power ~base:7 ~exponent:3) 343 ;
    AT.check AT.int "power - 0 base" (power ~base:0 ~exponent:3) 0 ;
    AT.check AT.int "power - 0 exponent" (power ~base:7 ~exponent:0) 1 ;
    AT.check AT.int "power - **" (7 ** 3) 343 ;

    AT.check AT.int "negate - positive number" (negate 8) (-8) ;
    AT.check AT.int "negate - negative number" (negate (-7)) 7 ;
    AT.check AT.int "negate - zero" (negate 0) (-0) ;
    AT.check AT.int "negate - ~-" ~-7 (-7) ;

    AT.check AT.int "absolute - positive number" (absolute 8) 8 ;
    AT.check AT.int "absolute - negative number" (absolute (-7)) 7 ;
    AT.check AT.int "absolute - zero" (absolute 0) 0 ;

    AT.check AT.int "clamp - in range" (clamp ~lower:0 ~upper:8 5) 5 ;
    AT.check AT.int "clamp - above range" (clamp ~lower:0 ~upper:8 9) 8 ;
    AT.check AT.int "clamp - below range" (clamp ~lower:2 ~upper:8 1) 2 ;
    AT.check
      AT.int
      "clamp - above negative range"
      (clamp ~lower:(-10) ~upper:(-5) 5)
      (-5) ;
    AT.check
      AT.int
      "clamp - below negative range"
      (clamp ~lower:(-10) ~upper:(-5) (-15))
      (-10) ;
    AT.check_raises
      "clamp - invalid arguments"
      (Invalid_argument "~lower:7 must be less than or equal to ~upper:1")
      (fun () -> ignore (clamp ~lower:7 ~upper:1 3)) ;

    AT.check AT.bool "inRange - in range" (inRange ~lower:2 ~upper:4 3) true ;
    AT.check AT.bool "inRange - above range" (inRange ~lower:2 ~upper:4 8) false ;
    AT.check AT.bool "inRange - below range" (inRange ~lower:2 ~upper:4 1) false ;
    AT.check
      AT.bool
      "inRange - equal to ~upper"
      (inRange ~lower:1 ~upper:2 2)
      false ;
    AT.check
      AT.bool
      "inRange - negative range"
      (inRange ~lower:(-7) ~upper:(-5) (-6))
      true ;
    AT.check_raises
      "inRange - invalid arguments"
      (Invalid_argument "~lower:7 must be less than or equal to ~upper:1")
      (fun () -> ignore (inRange ~lower:7 ~upper:1 3)) ;

    AT.check (AT.float 0.) "toFloat - 5" (toFloat 5) 5. ;
    AT.check (AT.float 0.) "toFloat - 0" (toFloat 0) 0. ;
    AT.check (AT.float 0.) "toFloat - -7" (toFloat (-7)) (-7.) ;

    AT.check AT.(option int) "fromString - 0" (fromString "0") (Some 0) ;
    AT.check AT.(option int) "fromString - -0" (fromString "-0") (Some (-0)) ;
    AT.check AT.(option int) "fromString - 42" (fromString "42") (Some 42) ;
    AT.check
      AT.(option int)
      "fromString - 123_456"
      (fromString "123_456")
      (Some 123_456) ;
    AT.check AT.(option int) "fromString - -42" (fromString "-42") (Some (-42)) ;
    AT.check AT.(option int) "fromString - 0XFF" (fromString "0XFF") (Some 255) ;
    AT.check
      AT.(option int)
      "fromString - 0X000A"
      (fromString "0X000A")
      (Some 10) ;
    AT.check
      AT.(option int)
      "fromString - Infinity"
      (fromString "Infinity")
      None ;
    AT.check
      AT.(option int)
      "fromString - -Infinity"
      (fromString "-Infinity")
      None ;
    AT.check AT.(option int) "fromString - NaN" (fromString "NaN") None ;
    AT.check AT.(option int) "fromString - abc" (fromString "abc") None ;
    AT.check AT.(option int) "fromString - --4" (fromString "--4") None ;
    AT.check AT.(option int) "fromString - empty string" (fromString " ") None ;

    AT.check AT.string " toString - positive number" (toString 1) "1" ;
    AT.check AT.string " toString - negative number" (toString (-1)) "-1" ;

    ())


let t_List () =
  AT.check (AT.list AT.int) "reverse empty list" (List.reverse []) [] ;
  AT.check (AT.list AT.int) "reverse one element" (List.reverse [ 0 ]) [ 0 ] ;
  AT.check
    (AT.list AT.int)
    "reverse two elements"
    (List.reverse [ 0; 1 ])
    [ 1; 0 ] ;

  AT.check
    (AT.list (AT.list AT.int))
    "sliding - step 1"
    (List.sliding [ 1; 2; 3; 4; 5 ] ~size:1)
    [ [ 1 ]; [ 2 ]; [ 3 ]; [ 4 ]; [ 5 ] ] ;

  AT.check
    (AT.list (AT.list AT.int))
    "sliding - step 2"
    [ [ 1; 2 ]; [ 2; 3 ]; [ 3; 4 ]; [ 4; 5 ] ]
    (List.sliding [ 1; 2; 3; 4; 5 ] ~size:2) ;

  AT.check
    (AT.list (AT.list AT.int))
    "sliding - step 3 "
    [ [ 1; 2; 3 ]; [ 2; 3; 4 ]; [ 3; 4; 5 ] ]
    (List.sliding [ 1; 2; 3; 4; 5 ] ~size:3) ;

  AT.check
    (AT.list (AT.list AT.int))
    "sliding - step 2, size 2"
    [ [ 1; 2 ]; [ 3; 4 ] ]
    (List.sliding [ 1; 2; 3; 4; 5 ] ~size:2 ~step:2) ;

  AT.check
    (AT.list (AT.list AT.int))
    "sliding - step 1, size 3"
    [ [ 1 ]; [ 4 ] ]
    (List.sliding [ 1; 2; 3; 4; 5 ] ~size:1 ~step:3) ;

  AT.check
    (AT.list (AT.list AT.int))
    "sliding - step 7"
    [ [ 1; 2 ]; [ 4; 5 ] ]
    (List.sliding [ 1; 2; 3; 4; 5 ] ~size:2 ~step:3) ;

  AT.check
    (AT.list (AT.list AT.int))
    "sliding - size 7"
    []
    (List.sliding [ 1; 2; 3; 4; 5 ] ~size:7) ;

  AT.check (AT.list AT.int) "map2 empty lists" (List.map2 ~f:( + ) [] []) [] ;
  AT.check
    (AT.list AT.int)
    "map2 one element"
    [ 2 ]
    (List.map2 ~f:( + ) [ 1 ] [ 1 ]) ;

  AT.check
    (AT.list AT.int)
    "map2 two elements"
    [ 2; 4 ]
    (List.map2 ~f:( + ) [ 1; 2 ] [ 1; 2 ]) ;

  AT.check
    (AT.list AT.int)
    "indexedMap empty list"
    (List.indexedMap ~f:(fun i _ -> i) [])
    [] ;
  AT.check
    (AT.list AT.int)
    "indexedMap one element"
    (List.indexedMap ~f:(fun i _ -> i) [ 'a' ])
    [ 0 ] ;
  AT.check
    (AT.list AT.int)
    "indexedMap two elements"
    (List.indexedMap ~f:(fun i _ -> i) [ 'a'; 'b' ])
    [ 0; 1 ] ;

  AT.check
    (AT.list AT.int)
    "indexedMap empty list"
    (List.indexedMap ~f:(fun _ n -> n + 1) [])
    [] ;
  AT.check
    (AT.list AT.int)
    "indexedMap one element"
    (List.indexedMap ~f:(fun _ n -> n + 1) [ -1 ])
    [ 0 ] ;
  AT.check
    (AT.list AT.int)
    "indexedMap two elements"
    (List.indexedMap ~f:(fun _ n -> n + 1) [ -1; 0 ])
    [ 0; 1 ] ;

  AT.check
    (AT.option AT.int)
    "minimumBy non-empty list"
    (List.minimumBy ~f:(fun x -> x mod 12) [ 7; 9; 15; 10; 3; 22 ])
    (Some 15) ;
  AT.check
    (AT.option AT.int)
    "minimumBy empty list"
    (List.minimumBy ~f:(fun x -> x mod 12) [])
    None ;

  AT.check
    (AT.option AT.int)
    "maximumBy non-empty list"
    (List.maximumBy ~f:(fun x -> x mod 12) [ 7; 9; 15; 10; 3; 22 ])
    (Some 10) ;
  AT.check
    (AT.option AT.int)
    "maximumBy empty list"
    (List.maximumBy ~f:(fun x -> x mod 12) [])
    None ;

  AT.check
    (AT.option AT.int)
    "minimum non-empty list"
    (List.minimum [ 7; 9; 15; 10; 3 ])
    (Some 3) ;
  AT.check (AT.option AT.int) "minimum empty list" (List.minimum []) None ;

  AT.check
    (AT.option AT.int)
    "maximum non-empty list"
    (List.maximum [ 7; 9; 15; 10; 3 ])
    (Some 15) ;
  AT.check (AT.option AT.int) "maximum empty list" (List.maximum []) None ;

  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "partition empty list"
    (List.partition ~f:(fun x -> x mod 2 = 0) [])
    ([], []) ;
  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "partition one element"
    (List.partition ~f:(fun x -> x mod 2 = 0) [ 1 ])
    ([], [ 1 ]) ;
  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "partition four elements"
    (List.partition ~f:(fun x -> x mod 2 = 0) [ 1; 2; 3; 4 ])
    ([ 2; 4 ], [ 1; 3 ]) ;

  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "split_when four elements"
    (List.split_when ~f:(fun x -> x mod 2 = 0) [ 1; 3; 2; 4 ])
    ([ 1; 3 ], [ 2; 4 ]) ;
  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "split_when at zero"
    (List.split_when ~f:(fun x -> x mod 2 = 0) [ 2; 4; 6 ])
    ([], [ 2; 4; 6 ]) ;
  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "split_when at end"
    (List.split_when ~f:(fun x -> x mod 2 = 0) [ 1; 3; 5 ])
    ([ 1; 3; 5 ], []) ;
  AT.check
    (AT.pair (AT.list AT.int) (AT.list AT.int))
    "split_when empty list"
    (List.split_when ~f:(fun x -> x mod 2 = 0) [])
    ([], []) ;

  AT.check
    (AT.list AT.string)
    "intersperse empty list"
    (List.intersperse "on" [])
    [] ;
  AT.check
    (AT.list AT.string)
    "intersperse one turtle"
    (List.intersperse "on" [ "turtles" ])
    [ "turtles" ] ;
  AT.check
    (AT.list AT.string)
    "intersperse three turtles"
    (List.intersperse "on" [ "turtles"; "turtles"; "turtles" ])
    [ "turtles"; "on"; "turtles"; "on"; "turtles" ] ;

  AT.check (AT.option (AT.list AT.char)) "init empty list" (List.init []) None ;
  AT.check
    (AT.option (AT.list AT.char))
    "init one element"
    (List.init [ 'a' ])
    (Some []) ;
  AT.check
    (AT.option (AT.list AT.char))
    "init two elements"
    (List.init [ 'a'; 'b' ])
    (Some [ 'a' ]) ;

  AT.check (AT.list AT.string) "append empty lists" (List.append [] []) [] ;
  AT.check
    (AT.list AT.string)
    "append empty list"
    (List.append [] [ "turtles" ])
    [ "turtles" ] ;
  AT.check
    (AT.list AT.string)
    "append empty list"
    (List.append [ "turtles" ] [])
    [ "turtles" ] ;
  AT.check
    (AT.list AT.string)
    "append two lists"
    (List.append [ "on" ] [ "turtles" ])
    [ "on"; "turtles" ] ;

  AT.check
    (AT.list AT.int)
    "foldl empty list"
    (List.foldLeft ~f:(fun x acc -> x :: acc) ~initial:[] [])
    [] ;
  AT.check
    (AT.list AT.int)
    "foldl one element"
    (List.foldLeft ~f:(fun x acc -> x :: acc) ~initial:[] [ 1 ])
    [ 1 ] ;
  AT.check
    (AT.list AT.int)
    "foldl three elements"
    (List.foldLeft ~f:(fun x acc -> x :: acc) ~initial:[] [ 1; 2; 3 ])
    [ 3; 2; 1 ] ;
  AT.check
    (AT.list AT.int)
    "foldr empty list"
    (List.foldRight ~f:(fun x acc -> x :: acc) ~initial:[] [])
    [] ;
  AT.check
    (AT.list AT.int)
    "foldr one element"
    (List.foldRight ~f:(fun x acc -> x :: acc) ~initial:[] [ 1 ])
    [ 1 ] ;
  AT.check
    (AT.list AT.int)
    "foldr three elements"
    (List.foldRight ~f:(fun x acc -> x :: acc) ~initial:[] [ 1; 2; 3 ])
    [ 1; 2; 3 ] ;
  AT.check
    AT.int
    "foldl issue #18"
    (List.foldLeft ~f:( - ) ~initial:0 [ 1; 2; 3 ])
    2 ;
  AT.check
    AT.int
    "foldr issue #18"
    (List.foldRight ~f:( - ) ~initial:0 [ 1; 2; 3 ])
    2 ;
  AT.check
    AT.int
    "foldl issue #18"
    (List.foldLeft ~f:( - ) ~initial:0 [ 3; 2; 1 ])
    2 ;
  AT.check
    AT.int
    "foldr issue #18"
    (List.foldRight ~f:( - ) ~initial:0 [ 3; 2; 1 ])
    2 ;

  AT.check
    (AT.list AT.int)
    "insertAt empty list"
    (List.insertAt ~index:0 ~value:1 [])
    [ 1 ] ;
  AT.check
    (AT.list AT.int)
    "insertAt in the middle"
    (List.insertAt ~index:1 ~value:2 [ 1; 3 ])
    [ 1; 2; 3 ] ;
  AT.check
    (AT.list AT.int)
    "insertAt in the front"
    (List.insertAt ~index:0 ~value:2 [ 1; 3 ])
    [ 2; 1; 3 ] ;

  (*      the test below would work on Bucklescript, both should show the same behaviour *)
  (*  AT.check (AT.list AT.int) "insertAt after end of list" (List.insertAt ~index:4 ~value:2 [1;3]) [2];*)
  AT.check
    (AT.list AT.int)
    "updateAt index smaller 0"
    (List.updateAt ~index:(-1) ~f:(fun x -> x + 1) [ 1; 3 ])
    [ 1; 3 ] ;
  AT.check
    (AT.list AT.int)
    "updateAt empty list"
    (List.updateAt ~index:0 ~f:(fun x -> x + 1) [])
    [] ;
  AT.check
    (AT.list AT.int)
    "updateAt empty list"
    (List.updateAt ~index:2 ~f:(fun x -> x + 1) [])
    [] ;
  AT.check
    (AT.list AT.int)
    "updateAt inside the list"
    (List.updateAt ~index:1 ~f:(fun x -> x + 1) [ 1; 3 ])
    [ 1; 4 ] ;
  AT.check
    (AT.list AT.int)
    "updateAt in the front"
    (List.updateAt ~index:0 ~f:(fun x -> x + 1) [ 1; 3 ])
    [ 2; 3 ] ;
  AT.check
    (AT.list AT.int)
    "updateAt after end of list"
    (List.updateAt ~index:4 ~f:(fun x -> x + 1) [ 1; 3 ])
    [ 1; 3 ] ;

  AT.check (AT.list AT.int) "concat two empty lists" (List.concat [ []; [] ]) [] ;
  AT.check
    (AT.list AT.int)
    "concat with one empty list"
    (List.concat [ [ 1 ]; [] ])
    [ 1 ] ;
  AT.check
    (AT.list AT.int)
    "concat with one empty list"
    (List.concat [ []; [ 1 ] ])
    [ 1 ] ;
  AT.check
    (AT.list AT.int)
    "concat with several lists"
    (List.concat [ [ 1 ]; [ 2 ]; [ 3 ] ])
    [ 1; 2; 3 ] ;
  AT.check
    (AT.list AT.int)
    "concat with several lists"
    (List.concat [ [ 1 ]; []; [ 2 ]; []; [ 3 ] ])
    [ 1; 2; 3 ] ;

  AT.check
    (AT.list AT.int)
    "initialize length 0"
    (List.initialize 0 (fun i -> i))
    [] ;
  AT.check
    (AT.list AT.int)
    "initialize length 1"
    (List.initialize 1 (fun i -> i))
    [ 0 ] ;
  AT.check
    (AT.list AT.int)
    "initialize length 2"
    (List.initialize 2 (fun i -> i))
    [ 0; 1 ] ;

  AT.check
    (AT.list AT.int)
    "removeAt index smaller 0"
    (List.removeAt ~index:(-1) [ 1; 3 ])
    [ 1; 3 ] ;
  AT.check (AT.list AT.int) "removeAt empty list" (List.removeAt ~index:0 []) [] ;
  AT.check (AT.list AT.int) "removeAt empty list" (List.removeAt ~index:2 []) [] ;
  AT.check
    (AT.list AT.int)
    "removeAt index 1"
    (List.removeAt ~index:1 [ 1; 3 ])
    [ 1 ] ;
  AT.check
    (AT.list AT.int)
    "removeAt index 0"
    (List.removeAt ~index:0 [ 1; 3 ])
    [ 3 ] ;
  AT.check
    (AT.list AT.int)
    "removeAt after end of list"
    (List.removeAt ~index:4 [ 1; 3 ])
    [ 1; 3 ] ;

  ()


let t_String () =
  AT.check
    AT.bool
    "imported correctly"
    true
    (Tablecloth.String.length == String.length) ;

  AT.check AT.int "length" (String.length "") 0 ;
  AT.check AT.int "length" (String.length "123") 3 ;

  AT.check AT.string "reverse" (String.reverse "") "" ;
  AT.check AT.string "reverse" (String.reverse "stressed") "desserts" ;

  ()


let t_Tuple2 () =
  AT.check (AT.pair AT.int AT.int) "create" (Tuple2.create 3 4) (3, 4) ;

  AT.check AT.int "first" (Tuple2.first (3, 4)) 3 ;

  AT.check AT.int "second" (Tuple2.second (3, 4)) 4 ;

  AT.check
    (AT.pair AT.string AT.int)
    "mapFirst"
    (Tuple2.mapFirst ~f:String.reverse ("stressed", 16))
    ("desserts", 16) ;

  AT.check
    (AT.pair AT.string (AT.float 0.))
    "mapSecond"
    (Tuple2.mapSecond ~f:sqrt ("stressed", 16.))
    ("stressed", 4.) ;

  AT.check
    (AT.pair AT.string (AT.float 0.))
    "mapEach"
    (Tuple2.mapEach ~f:String.reverse ~g:sqrt ("stressed", 16.))
    ("desserts", 4.) ;

  AT.check
    (AT.pair AT.string AT.string)
    "mapAll"
    (Tuple2.mapAll ~f:String.reverse ("was", "stressed"))
    ("saw", "desserts") ;

  AT.check (AT.pair AT.int AT.int) "swap" (Tuple2.swap (3, 4)) (4, 3) ;

  AT.check AT.int "curry" (Tuple2.curry (fun (a, b) -> a + b) 3 4) 7 ;

  AT.check AT.int "uncurry" (Tuple2.uncurry (fun a b -> a + b) (3, 4)) 7 ;

  AT.check (AT.list AT.int) "toList" (Tuple2.toList (3, 4)) [ 3; 4 ] ;

  ()


let t_Tuple3 () =
  AT.check
    (Eq.trio AT.int AT.int AT.int)
    "create"
    (Tuple3.create 3 4 5)
    (3, 4, 5) ;

  AT.check AT.int "first" (Tuple3.first (3, 4, 5)) 3 ;

  AT.check AT.int "second" (Tuple3.second (3, 4, 5)) 4 ;

  AT.check AT.int "third" (Tuple3.third (3, 4, 5)) 5 ;

  AT.check (AT.pair AT.int AT.int) "init" (Tuple3.init (3, 4, 5)) (3, 4) ;

  AT.check (AT.pair AT.int AT.int) "tail" (Tuple3.tail (3, 4, 5)) (4, 5) ;

  AT.check
    (Eq.trio AT.string AT.int AT.bool)
    "mapFirst"
    (Tuple3.mapFirst ~f:String.reverse ("stressed", 16, false))
    ("desserts", 16, false) ;

  AT.check
    (Eq.trio AT.string (AT.float 0.) AT.bool)
    "mapSecond"
    (Tuple3.mapSecond ~f:sqrt ("stressed", 16., false))
    ("stressed", 4., false) ;

  AT.check
    (Eq.trio AT.string AT.int AT.bool)
    "mapThird"
    (Tuple3.mapThird ~f:not ("stressed", 16, false))
    ("stressed", 16, true) ;

  AT.check
    (Eq.trio AT.string (AT.float 0.) AT.bool)
    "mapEach"
    (Tuple3.mapEach ~f:String.reverse ~g:sqrt ~h:not ("stressed", 16., false))
    ("desserts", 4., true) ;

  AT.check
    (Eq.trio AT.string AT.string AT.string)
    "mapAll"
    (Tuple3.mapAll ~f:String.reverse ("was", "stressed", "now"))
    ("saw", "desserts", "won") ;

  AT.check
    (Eq.trio AT.int AT.int AT.int)
    "rotateLeft"
    (Tuple3.rotateLeft (3, 4, 5))
    (4, 5, 3) ;

  AT.check
    (Eq.trio AT.int AT.int AT.int)
    "rotateRight"
    (Tuple3.rotateRight (3, 4, 5))
    (5, 3, 4) ;

  AT.check AT.int "curry" (Tuple3.curry (fun (a, b, c) -> a + b + c) 3 4 5) 12 ;

  AT.check
    AT.int
    "uncurry"
    (Tuple3.uncurry (fun a b c -> a + b + c) (3, 4, 5))
    12 ;

  AT.check (AT.list AT.int) "toList" (Tuple3.toList (3, 4, 5)) [ 3; 4; 5 ] ;

  ()


let t_Option () =
  AT.check AT.int "getExn Some(1)" (Option.getExn (Some 1)) 1 ;

  AT.check_raises "getExn None" (Invalid_argument "option is None") (fun () ->
      Option.getExn None) ;

  ()


let t_Result () =
  AT.check
    (AT.result AT.int AT.string)
    "fromOption - maps None into Error"
    Result.(fromOption ~error:"error message" (None : int option))
    (Error "error message") ;
  AT.check
    (AT.result AT.int AT.string)
    "fromOption - maps Some into Ok"
    Result.(fromOption ~error:"error message" (Some 10))
    (Ok 10) ;
  ()


let suite =
  [ ("Array", `Quick, t_Array)
  ; ("Fun", `Quick, t_Fun)
  ; ("Int", `Quick, t_Int)
  ; ("List", `Quick, t_List)
  ; ("String", `Quick, t_String)
  ; ("Tuple2", `Quick, t_Tuple2)
  ; ("Tuple3", `Quick, t_Tuple3)
  ; ("Option", `Quick, t_Option)
  ; ("Result", `Quick, t_Result)
  ]
