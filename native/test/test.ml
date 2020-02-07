open Tablecloth
module AT = Alcotest

let trio a b c =
  let eq (a1, b1, c1) (a2, b2, c2) =
    AT.equal a a1 a2 && AT.equal b b1 b2 && AT.equal c c1 c2
  in
  let pp ppf (x, y, z) =
    Fmt.pf
      ppf
      "@[<1>(@[%a@],@ @[%a@],@ @[%a@])@]"
      (AT.pp a)
      x
      (AT.pp b)
      y
      (AT.pp c)
      z
  in
  AT.testable pp eq


let t_Array () =
  AT.check AT.int "empty - has length zero" Array.(empty () |> length) 0 ;
  AT.check
    (AT.array AT.int)
    "empty - equals the empty array literal"
    (Array.empty ())
    [||] ;

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
    (AT.array (trio AT.string AT.int AT.bool))
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


let t_Char () =
  AT.check AT.int "toCode" (Char.toCode 'a') 97 ;

  AT.check
    (AT.option AT.char)
    "fromCode - valid ASCII codes return the corresponding character"
    (Char.fromCode 97)
    (Some 'a') ;
  AT.check
    (AT.option AT.char)
    "fromCode - negative integers return none"
    (Char.fromCode (-1))
    None ;
  AT.check
    (AT.option AT.char)
    "fromCode - integers greater than 255 return none"
    (Char.fromCode 256)
    None ;

  AT.check AT.string "toString" (Char.toString 'a') "a" ;

  AT.check
    (AT.option AT.char)
    "fromString - one-length string return Some"
    (Char.fromString "a")
    (Some 'a') ;
  AT.check
    (AT.option AT.char)
    "fromString - multi character strings return none"
    (Char.fromString "abc")
    None ;
  AT.check
    (AT.option AT.char)
    "fromString - zero length strings return none"
    (Char.fromString "")
    None ;

  AT.check
    AT.char
    "toLowercase - converts uppercase ASCII characters to lowercase"
    (Char.toLowercase 'A')
    'a' ;
  AT.check
    AT.char
    "toLowercase - perserves lowercase characters"
    (Char.toLowercase 'a')
    'a' ;
  AT.check
    AT.char
    "toLowercase - perserves non-alphabet characters"
    (Char.toLowercase '7')
    '7' ;
  AT.check
    AT.char
    "toUppercase - perserves non-ASCII characters"
    (Char.toUppercase '\237')
    '\237' ;

  AT.check
    AT.char
    "toUppercase - converts lowercase ASCII characters to uppercase"
    (Char.toUppercase 'a')
    'A' ;
  AT.check
    AT.char
    "toUppercase - perserves uppercase characters"
    (Char.toUppercase 'A')
    'A' ;
  AT.check
    AT.char
    "toUppercase - perserves non-alphabet characters"
    (Char.toUppercase '7')
    '7' ;
  AT.check
    AT.char
    "toUppercase - perserves non-ASCII characters"
    (Char.toUppercase '\236')
    '\236' ;

  AT.check
    (AT.option AT.int)
    "toDigit - converts ASCII characters representing digits into integers"
    (Char.toDigit '0')
    (Some 0) ;
  AT.check
    (AT.option AT.int)
    "toDigit - converts ASCII characters representing digits into integers"
    (Char.toDigit '8')
    (Some 8) ;
  AT.check
    (AT.option AT.int)
    "toDigit - converts ASCII characters representing digits into integers"
    (Char.toDigit 'a')
    None ;

  AT.check
    AT.bool
    "isLowercase - returns true for any lowercase character"
    (Char.isLowercase 'a')
    true ;
  AT.check
    AT.bool
    "isLowercase - returns false for all other characters"
    (Char.isLowercase '7')
    false ;
  AT.check
    AT.bool
    "isLowercase - returns false for non-ASCII characters"
    (Char.isLowercase '\236')
    false ;

  AT.check
    AT.bool
    "isUppercase - returns true for any uppercase character"
    (Char.isUppercase 'A')
    true ;
  AT.check
    AT.bool
    "isUppercase - returns false for all other characters"
    (Char.isUppercase '7')
    false ;
  AT.check
    AT.bool
    "isUppercase - returns false for non-ASCII characters"
    (Char.isLowercase '\237')
    false ;

  AT.check
    AT.bool
    "isLetter - returns true for any ASCII alphabet character"
    (Char.isLetter 'A')
    true ;
  AT.check
    AT.bool
    "isLetter - returns false for all other characters"
    (Char.isLetter '\n')
    false ;
  AT.check
    AT.bool
    "isLetter - returns false for non-ASCII characters"
    (Char.isLetter '\236')
    false ;

  AT.check
    AT.bool
    "isDigit - returns true for digits 0-9"
    (Char.isDigit '5')
    true ;
  AT.check
    AT.bool
    "isDigit - returns false for all other characters"
    (Char.isDigit 'a')
    false ;

  AT.check
    AT.bool
    "isAlphanumeric - returns true for any alphabet or digit character"
    (Char.isAlphanumeric 'A')
    true ;
  AT.check
    AT.bool
    "isAlphanumeric - returns false for all other characters"
    (Char.isAlphanumeric '?')
    false ;

  AT.check
    AT.bool
    "isPrintable - returns true for a printable character"
    (Char.isPrintable '~')
    true ;
  AT.check
    (AT.option AT.bool)
    "isPrintable - returns false for non-printable character"
    (Char.fromCode 31 |> Option.map ~f:Char.isPrintable)
    (Some false) ;

  AT.check
    AT.bool
    "isWhitespace - returns true for any whitespace character"
    (Char.isWhitespace ' ')
    true ;
  AT.check
    AT.bool
    "isWhitespace - returns false for a non-whitespace character"
    (Char.isWhitespace 'a')
    false ;
  ()


let t_Float () =
  Float.(
    AT.check (AT.float 0.) "zero" zero 0. ;

    AT.check (AT.float 0.) "one" one 1. ;

    AT.check AT.bool "nan" (nan = nan) false ;

    AT.check AT.bool "infinity" (infinity > 0.) true ;

    AT.check AT.bool "negativeInfinity" (negativeInfinity < 0.) true ;

    AT.check AT.bool "equals zero" (0. = -0.) true ;

    AT.check (AT.float 0.) "add" (add 3.14 3.14) 6.28 ;
    AT.check (AT.float 0.) "+" (3.14 + 3.14) 6.28 ;

    AT.check (AT.float 0.) "subtract" (subtract 4. 3.) 1. ;
    AT.check (AT.float 0.) "-" (4. - 3.) 1. ;

    AT.check (AT.float 0.) "multiply" (multiply 2. 7.) 14. ;
    AT.check (AT.float 0.) "*" (2. * 7.) 14. ;

    AT.check (AT.float 0.) "divide" (divide 3.14 ~by:2.) 1.57 ;
    AT.check AT.bool "divide by zero" (divide 3.14 ~by:0. = infinity) true ;
    AT.check
      AT.bool
      "divide by negative zero"
      (divide 3.14 ~by:(-0.) = negativeInfinity)
      true ;
    AT.check (AT.float 0.) "/" (3.14 / 2.) 1.57 ;

    AT.check (AT.float 0.) "power" (power ~base:7. ~exponent:3.) 343. ;
    AT.check (AT.float 0.) "power - 0 base" (power ~base:0. ~exponent:3.) 0. ;
    AT.check
      (AT.float 0.)
      "power - 0 exponent"
      (power ~base:7. ~exponent:0.)
      1. ;
    AT.check (AT.float 0.) "**" (7. ** 3.) 343. ;

    AT.check (AT.float 0.) "negate - positive number" (negate 8.) (-8.) ;
    AT.check (AT.float 0.) "negate - negative number" (negate (-7.)) 7. ;
    AT.check (AT.float 0.) "negate - zero" (negate 0.) (-0.) ;
    AT.check (AT.float 0.) "negate - ~-" ~-7. (-7.) ;

    AT.check (AT.float 0.) "absolute - positive number" (absolute 8.) 8. ;
    AT.check (AT.float 0.) "absolute - negative number" (absolute (-7.)) 7. ;
    AT.check (AT.float 0.) "absolute - zero" (absolute 0.) 0. ;

    AT.check (AT.float 0.) "maximum - positive numbers" (maximum 7. 9.) 9. ;
    AT.check
      (AT.float 0.)
      "maximum - negative numbers"
      (maximum (-4.) (-1.))
      (-1.) ;
    AT.check AT.bool "maximum - nan" (maximum 7. nan |> isNaN) true ;
    AT.check AT.bool "maximum - infinity" (maximum 7. infinity = infinity) true ;
    AT.check
      (AT.float 0.)
      "maximum - negativeInfinity"
      (maximum 7. negativeInfinity)
      7. ;

    AT.check (AT.float 0.) "minimum - positive numbers" (minimum 7. 9.) 7. ;
    AT.check
      (AT.float 0.)
      "minimum - negative numbers"
      (minimum (-4.) (-1.))
      (-4.) ;
    AT.check AT.bool "minimum - nan" (minimum 7. nan |> isNaN) true ;
    AT.check (AT.float 0.) "minimum - infinity" (minimum 7. infinity) 7. ;
    AT.check
      AT.bool
      "minimum - negativeInfinity"
      (minimum 7. negativeInfinity = negativeInfinity)
      true ;

    AT.check (AT.float 0.) "clamp - in range" (clamp ~lower:0. ~upper:8. 5.) 5. ;
    AT.check
      (AT.float 0.)
      "clamp - above range"
      (clamp ~lower:0. ~upper:8. 9.)
      8. ;
    AT.check
      (AT.float 0.)
      "clamp - below range"
      (clamp ~lower:2. ~upper:8. 1.)
      2. ;
    AT.check
      (AT.float 0.)
      "clamp - above negative range"
      (clamp ~lower:(-10.) ~upper:(-5.) 5.)
      (-5.) ;
    AT.check
      (AT.float 0.)
      "clamp - below negative range"
      (clamp ~lower:(-10.) ~upper:(-5.) (-15.))
      (-10.) ;
    AT.check
      AT.bool
      "clamp - nan upper bound"
      (clamp ~lower:(-7.9) ~upper:nan (-6.6) |> isNaN)
      true ;
    AT.check
      AT.bool
      "clamp - nan lower bound"
      (clamp ~lower:nan ~upper:0. (-6.6) |> isNaN)
      true ;
    AT.check
      AT.bool
      "clamp - nan value"
      (clamp ~lower:2. ~upper:8. nan |> isNaN)
      true ;
    AT.check_raises
      "clamp - invalid arguments"
      (Invalid_argument "~lower:7. must be less than or equal to ~upper:1.")
      (fun () -> ignore (clamp ~lower:7. ~upper:1. 3.)) ;

    AT.check (AT.float 0.) "squareRoot - whole numbers" (squareRoot 4.) 2. ;
    AT.check
      (AT.float 0.)
      "squareRoot - decimal numbers"
      (squareRoot 20.25)
      4.5 ;
    AT.check
      AT.bool
      "squareRoot - negative number"
      (squareRoot (-1.) |> isNaN)
      true ;

    AT.check (AT.float 0.) "log - base 10" (log ~base:10. 100.) 2. ;
    AT.check (AT.float 0.) "log - base 2" (log ~base:2. 256.) 8. ;
    AT.check AT.bool "log - of zero" (log ~base:10. 0. = negativeInfinity) true ;

    AT.check AT.bool "isNaN - nan" (isNaN nan) true ;
    AT.check AT.bool "isNaN - non-nan" (isNaN 91.4) false ;

    AT.check AT.bool "isFinite - infinity" (isFinite infinity) false ;
    AT.check
      AT.bool
      "isFinite - negative infinity"
      (isFinite negativeInfinity)
      false ;
    AT.check AT.bool "isFinite - NaN" (isFinite nan) false ;
    List.iter [ -5.; -0.314; 0.; 3.14 ] ~f:(fun n ->
        AT.check
          AT.bool
          ("isFinite - regular numbers - " ^ Base.Float.to_string n)
          (isFinite n)
          true) ;

    AT.check AT.bool "isInfinite - infinity" (isInfinite infinity) true ;
    AT.check
      AT.bool
      "isInfinite - negative infinity"
      (isInfinite negativeInfinity)
      true ;
    AT.check AT.bool "isInfinite - NaN" (isInfinite nan) false ;
    List.iter [ -5.; -0.314; 0.; 3.14 ] ~f:(fun n ->
        AT.check
          AT.bool
          ("isInfinite - regular numbers - " ^ Base.Float.to_string n)
          (isInfinite n)
          false) ;

    AT.check AT.bool "inRange - in range" (inRange ~lower:2. ~upper:4. 3.) true ;
    AT.check
      AT.bool
      "inRange - above range"
      (inRange ~lower:2. ~upper:4. 8.)
      false ;
    AT.check
      AT.bool
      "inRange - below range"
      (inRange ~lower:2. ~upper:4. 1.)
      false ;
    AT.check
      AT.bool
      "inRange - equal to ~upper"
      (inRange ~lower:1. ~upper:2. 2.)
      false ;
    AT.check
      AT.bool
      "inRange - negative range"
      (inRange ~lower:(-7.9) ~upper:(-5.2) (-6.6))
      true ;
    AT.check
      AT.bool
      "inRange - nan upper bound"
      (inRange ~lower:(-7.9) ~upper:nan (-6.6))
      false ;
    AT.check
      AT.bool
      "inRange - nan lower bound"
      (inRange ~lower:nan ~upper:0. (-6.6))
      false ;
    AT.check
      AT.bool
      "inRange - nan value"
      (inRange ~lower:2. ~upper:8. nan)
      false ;
    AT.check_raises
      "inRange - invalid arguments"
      (Invalid_argument "~lower:7. must be less than or equal to ~upper:1.")
      (fun () -> ignore (inRange ~lower:7. ~upper:1. 3.)) ;

    AT.check (AT.float 0.) "hypotenuse" (hypotenuse 3. 4.) 5. ;

    AT.check (AT.float 0.) "degrees" (degrees 180.) pi ;

    AT.check (AT.float 0.) "radians" (radians pi) pi ;

    AT.check (AT.float 0.) "turns" (turns 1.) (2. * pi) ;

    AT.check
      (AT.pair (AT.float 0.001) (AT.float 0.001))
      "fromPolar"
      (fromPolar (squareRoot 2., degrees 45.))
      (1., 1.) ;

    AT.check
      (AT.pair (AT.float 0.) (AT.float 0.))
      "toPolar"
      (toPolar (3.0, 4.0))
      (5.0, 0.9272952180016122) ;
    AT.check
      (AT.pair (AT.float 0.) (AT.float 1e-15))
      "toPolar"
      (toPolar (5.0, 12.0))
      (13.0, 1.1760052070951352) ;

    AT.check (AT.float 0.) "cos" (cos (degrees 60.)) 0.5000000000000001 ;
    AT.check (AT.float 0.) "cos" (cos (radians (pi / 3.))) 0.5000000000000001 ;

    AT.check (AT.float 1e-15) "acos" (acos (1. / 2.)) 1.0471975511965979
    (* pi / 3. *) ;

    AT.check
      (AT.float 0.)
      "sin - 30 degrees"
      (sin (degrees 30.))
      0.49999999999999994 ;
    AT.check
      (AT.float 0.)
      "sin - pi / 6"
      (sin (radians (pi / 6.)))
      0.49999999999999994 ;

    AT.check (AT.float 1e-15) "asin" (asin (1. / 2.)) 0.5235987755982989
    (* ~ pi / 6. *) ;

    AT.check
      (AT.float 0.)
      "tan - 45 degrees"
      (tan (degrees 45.))
      0.9999999999999999 ;
    AT.check
      (AT.float 0.)
      "tan - pi / 4"
      (tan (radians (pi / 4.)))
      0.9999999999999999 ;
    AT.check (AT.float 0.) "tan - 0" (tan 0.) 0. ;

    AT.check (AT.float 0.) "atan - 0" (atan 0.) 0. ;
    AT.check (AT.float 0.) "atan - 1 / 1" (atan (1. / 1.)) 0.7853981633974483 ;
    AT.check
      (AT.float 0.)
      "atan - 1 / -1"
      (atan (1. / -1.))
      (-0.7853981633974483) ;
    AT.check
      (AT.float 0.)
      "atan - -1 / -1"
      (atan (-1. / -1.))
      0.7853981633974483 ;
    AT.check
      (AT.float 0.)
      "atan - -1 / -1"
      (atan (-1. / 1.))
      (-0.7853981633974483) ;

    AT.check (AT.float 0.) "atan2 0" 0. (atan2 ~y:0. ~x:0.) ;
    AT.check
      (AT.float 0.)
      "atan2 (1, 1)"
      0.7853981633974483
      (atan2 ~y:1. ~x:1.) ;
    AT.check
      (AT.float 0.)
      "atan2 (-1, 1)"
      2.3561944901923449
      (atan2 ~y:1. ~x:(-1.)) ;
    AT.check
      (AT.float 0.)
      "atan2 (-1, -1)"
      (-2.3561944901923449)
      (atan2 ~y:(-1.) ~x:(-1.)) ;
    AT.check
      (AT.float 0.)
      "atan2 (1, -1)"
      (-0.7853981633974483)
      (atan2 ~y:(-1.) ~x:1.) ;

    AT.check (AT.float 0.) "round `Zero" 1. (round ~direction:`Zero 1.2) ;
    AT.check (AT.float 0.) "round `Zero" 1. (round ~direction:`Zero 1.5) ;
    AT.check (AT.float 0.) "round `Zero" 1. (round ~direction:`Zero 1.8) ;
    AT.check (AT.float 0.) "round `Zero" (-1.) (round ~direction:`Zero (-1.2)) ;
    AT.check (AT.float 0.) "round `Zero" (-1.) (round ~direction:`Zero (-1.5)) ;
    AT.check (AT.float 0.) "round `Zero" (-1.) (round ~direction:`Zero (-1.8)) ;

    AT.check
      (AT.float 0.)
      "round `AwayFromZero"
      2.
      (round ~direction:`AwayFromZero 1.2) ;
    AT.check
      (AT.float 0.)
      "round `AwayFromZero"
      2.
      (round ~direction:`AwayFromZero 1.5) ;
    AT.check
      (AT.float 0.)
      "round `AwayFromZero"
      2.
      (round ~direction:`AwayFromZero 1.8) ;
    AT.check
      (AT.float 0.)
      "round `AwayFromZero"
      (-2.)
      (round ~direction:`AwayFromZero (-1.2)) ;
    AT.check
      (AT.float 0.)
      "round `AwayFromZero"
      (-2.)
      (round ~direction:`AwayFromZero (-1.5)) ;
    AT.check
      (AT.float 0.)
      "round `AwayFromZero"
      (-2.)
      (round ~direction:`AwayFromZero (-1.8)) ;

    AT.check (AT.float 0.) "round `Up" 2. (round ~direction:`Up 1.2) ;
    AT.check (AT.float 0.) "round `Up" 2. (round ~direction:`Up 1.5) ;
    AT.check (AT.float 0.) "round `Up" 2. (round ~direction:`Up 1.8) ;
    AT.check (AT.float 0.) "round `Up" (-1.) (round ~direction:`Up (-1.2)) ;
    AT.check (AT.float 0.) "round `Up" (-1.) (round ~direction:`Up (-1.5)) ;
    AT.check (AT.float 0.) "round `Up" (-1.) (round ~direction:`Up (-1.8)) ;

    AT.check (AT.float 0.) "round `Down" 1. (round ~direction:`Down 1.2) ;
    AT.check (AT.float 0.) "round `Down" 1. (round ~direction:`Down 1.5) ;
    AT.check (AT.float 0.) "round `Down" 1. (round ~direction:`Down 1.8) ;
    AT.check (AT.float 0.) "round `Down" (-2.) (round ~direction:`Down (-1.2)) ;
    AT.check (AT.float 0.) "round `Down" (-2.) (round ~direction:`Down (-1.5)) ;
    AT.check (AT.float 0.) "round `Down" (-2.) (round ~direction:`Down (-1.8)) ;

    AT.check
      (AT.float 0.)
      "round `Closest `Zero"
      1.
      (round ~direction:(`Closest `Zero) 1.2) ;
    AT.check
      (AT.float 0.)
      "round `Closest `Zero"
      1.
      (round ~direction:(`Closest `Zero) 1.5) ;
    AT.check
      (AT.float 0.)
      "round `Closest `Zero"
      2.
      (round ~direction:(`Closest `Zero) 1.8) ;
    AT.check
      (AT.float 0.)
      "round `Closest `Zero"
      (-1.)
      (round ~direction:(`Closest `Zero) (-1.2)) ;
    AT.check
      (AT.float 0.)
      "round `Closest `Zero"
      (-1.)
      (round ~direction:(`Closest `Zero) (-1.5)) ;
    AT.check
      (AT.float 0.)
      "round `Closest `Zero"
      (-2.)
      (round ~direction:(`Closest `Zero) (-1.8)) ;

    AT.check
      (AT.float 0.)
      "round `Closest `AwayFromZero"
      1.
      (round ~direction:(`Closest `AwayFromZero) 1.2) ;
    AT.check
      (AT.float 0.)
      "round `Closest `AwayFromZero"
      2.
      (round ~direction:(`Closest `AwayFromZero) 1.5) ;
    AT.check
      (AT.float 0.)
      "round `Closest `AwayFromZero"
      2.
      (round ~direction:(`Closest `AwayFromZero) 1.8) ;
    AT.check
      (AT.float 0.)
      "round `Closest `AwayFromZero"
      (-1.)
      (round ~direction:(`Closest `AwayFromZero) (-1.2)) ;
    AT.check
      (AT.float 0.)
      "round `Closest `AwayFromZero"
      (-2.)
      (round ~direction:(`Closest `AwayFromZero) (-1.5)) ;
    AT.check
      (AT.float 0.)
      "round `Closest `AwayFromZero"
      (-2.)
      (round ~direction:(`Closest `AwayFromZero) (-1.8)) ;

    AT.check
      (AT.float 0.)
      "round `Closest `Up"
      1.
      (round ~direction:(`Closest `Up) 1.2) ;
    AT.check
      (AT.float 0.)
      "round `Closest `Up"
      2.
      (round ~direction:(`Closest `Up) 1.5) ;
    AT.check
      (AT.float 0.)
      "round `Closest `Up"
      2.
      (round ~direction:(`Closest `Up) 1.8) ;
    AT.check
      (AT.float 0.)
      "round `Closest `Up"
      (-1.)
      (round ~direction:(`Closest `Up) (-1.2)) ;
    AT.check
      (AT.float 0.)
      "round `Closest `Up"
      (-1.)
      (round ~direction:(`Closest `Up) (-1.5)) ;
    AT.check
      (AT.float 0.)
      "round `Closest `Up"
      (-2.)
      (round ~direction:(`Closest `Up) (-1.8)) ;

    AT.check
      (AT.float 0.)
      "round `Closest `Down"
      1.
      (round ~direction:(`Closest `Down) 1.2) ;
    AT.check
      (AT.float 0.)
      "round `Closest `Down"
      1.
      (round ~direction:(`Closest `Down) 1.5) ;
    AT.check
      (AT.float 0.)
      "round `Closest `Down"
      2.
      (round ~direction:(`Closest `Down) 1.8) ;
    AT.check
      (AT.float 0.)
      "round `Closest `Down"
      (-1.)
      (round ~direction:(`Closest `Down) (-1.2)) ;
    AT.check
      (AT.float 0.)
      "round `Closest `Down"
      (-2.)
      (round ~direction:(`Closest `Down) (-1.5)) ;
    AT.check
      (AT.float 0.)
      "round `Closest `Down"
      (-2.)
      (round ~direction:(`Closest `Down) (-1.8)) ;

    AT.check
      (AT.float 0.)
      "round `Closest `ToEven"
      1.
      (round ~direction:(`Closest `ToEven) 1.2) ;
    AT.check
      (AT.float 0.)
      "round `Closest `ToEven"
      2.
      (round ~direction:(`Closest `ToEven) 1.5) ;
    AT.check
      (AT.float 0.)
      "round `Closest `ToEven"
      2.
      (round ~direction:(`Closest `ToEven) 1.8) ;
    AT.check
      (AT.float 0.)
      "round `Closest `ToEven"
      2.
      (round ~direction:(`Closest `ToEven) 2.2) ;
    AT.check
      (AT.float 0.)
      "round `Closest `ToEven"
      2.
      (round ~direction:(`Closest `ToEven) 2.5) ;
    AT.check
      (AT.float 0.)
      "round `Closest `ToEven"
      3.
      (round ~direction:(`Closest `ToEven) 2.8) ;
    AT.check
      (AT.float 0.)
      "round `Closest `ToEven"
      (-1.)
      (round ~direction:(`Closest `ToEven) (-1.2)) ;
    AT.check
      (AT.float 0.)
      "round `Closest `ToEven"
      (-2.)
      (round ~direction:(`Closest `ToEven) (-1.5)) ;
    AT.check
      (AT.float 0.)
      "round `Closest `ToEven"
      (-2.)
      (round ~direction:(`Closest `ToEven) (-1.8)) ;
    AT.check
      (AT.float 0.)
      "round `Closest `ToEven"
      (-2.)
      (round ~direction:(`Closest `ToEven) (-2.2)) ;
    AT.check
      (AT.float 0.)
      "round `Closest `ToEven"
      (-2.)
      (round ~direction:(`Closest `ToEven) (-2.5)) ;
    AT.check
      (AT.float 0.)
      "round `Closest `ToEven"
      (-3.)
      (round ~direction:(`Closest `ToEven) (-2.8)) ;

    AT.check (AT.float 0.) "floor" (floor 1.2) 1. ;
    AT.check (AT.float 0.) "floor" (floor 1.5) 1. ;
    AT.check (AT.float 0.) "floor" (floor 1.8) 1. ;
    AT.check (AT.float 0.) "floor" (floor (-1.2)) (-2.) ;
    AT.check (AT.float 0.) "floor" (floor (-1.5)) (-2.) ;
    AT.check (AT.float 0.) "floor" (floor (-1.8)) (-2.) ;

    AT.check (AT.float 0.) "ceiling" (ceiling 1.2) 2. ;
    AT.check (AT.float 0.) "ceiling" (ceiling 1.5) 2. ;
    AT.check (AT.float 0.) "ceiling" (ceiling 1.8) 2. ;
    AT.check (AT.float 0.) "ceiling" (ceiling (-1.2)) (-1.) ;
    AT.check (AT.float 0.) "ceiling" (ceiling (-1.5)) (-1.) ;
    AT.check (AT.float 0.) "ceiling" (ceiling (-1.8)) (-1.) ;

    AT.check (AT.float 0.) "truncate" (truncate 1.2) 1. ;
    AT.check (AT.float 0.) "truncate" (truncate 1.5) 1. ;
    AT.check (AT.float 0.) "truncate" (truncate 1.8) 1. ;
    AT.check (AT.float 0.) "truncate" (truncate (-1.2)) (-1.) ;
    AT.check (AT.float 0.) "truncate" (truncate (-1.5)) (-1.) ;
    AT.check (AT.float 0.) "truncate" (truncate (-1.8)) (-1.) ;

    AT.check (AT.float 0.) "fromInt - 5" (fromInt 5) 5.0 ;
    AT.check (AT.float 0.) "fromInt - 0" (fromInt 0) 0.0 ;
    AT.check (AT.float 0.) "fromInt - -7" (fromInt (-7)) (-7.0) ;

    AT.check (AT.option AT.int) "toInt - 5." (toInt 5.) (Some 5) ;
    AT.check (AT.option AT.int) "toInt - 5.3" (toInt 5.3) (Some 5) ;
    AT.check (AT.option AT.int) "toInt - 0." (toInt 0.) (Some 0) ;
    AT.check (AT.option AT.int) "toInt - -7." (toInt (-7.)) (Some (-7)) ;
    AT.check (AT.option AT.int) "toInt - nan" (toInt nan) None ;
    AT.check (AT.option AT.int) "toInt - infinity" (toInt infinity) None ;
    AT.check
      (AT.option AT.int)
      "toInt - negativeInfinity"
      (toInt negativeInfinity)
      None ;

    ())


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
    AT.check
      AT.bool
      "inRange - above range"
      (inRange ~lower:2 ~upper:4 8)
      false ;
    AT.check
      AT.bool
      "inRange - below range"
      (inRange ~lower:2 ~upper:4 1)
      false ;
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

  AT.check
    (AT.list AT.int)
    "concat two empty lists"
    (List.concat [ []; [] ])
    [] ;
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
  AT.check
    (AT.list AT.int)
    "removeAt empty list"
    (List.removeAt ~index:0 [])
    [] ;
  AT.check
    (AT.list AT.int)
    "removeAt empty list"
    (List.removeAt ~index:2 [])
    [] ;
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

  AT.check (AT.list AT.int) "repeat length 0" (List.repeat ~count:0 5) [] ;
  AT.check (AT.list AT.int) "repeat length 1" (List.repeat ~count:1 5) [ 5 ] ;
  AT.check
    (AT.list AT.int)
    "repeat length 3"
    (List.repeat ~count:3 5)
    [ 5; 5; 5 ] ;

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
  AT.check (trio AT.int AT.int AT.int) "create" (Tuple3.create 3 4 5) (3, 4, 5) ;

  AT.check AT.int "first" (Tuple3.first (3, 4, 5)) 3 ;

  AT.check AT.int "second" (Tuple3.second (3, 4, 5)) 4 ;

  AT.check AT.int "third" (Tuple3.third (3, 4, 5)) 5 ;

  AT.check (AT.pair AT.int AT.int) "init" (Tuple3.init (3, 4, 5)) (3, 4) ;

  AT.check (AT.pair AT.int AT.int) "tail" (Tuple3.tail (3, 4, 5)) (4, 5) ;

  AT.check
    (trio AT.string AT.int AT.bool)
    "mapFirst"
    (Tuple3.mapFirst ~f:String.reverse ("stressed", 16, false))
    ("desserts", 16, false) ;

  AT.check
    (trio AT.string (AT.float 0.) AT.bool)
    "mapSecond"
    (Tuple3.mapSecond ~f:sqrt ("stressed", 16., false))
    ("stressed", 4., false) ;

  AT.check
    (trio AT.string AT.int AT.bool)
    "mapThird"
    (Tuple3.mapThird ~f:not ("stressed", 16, false))
    ("stressed", 16, true) ;

  AT.check
    (trio AT.string (AT.float 0.) AT.bool)
    "mapEach"
    (Tuple3.mapEach ~f:String.reverse ~g:sqrt ~h:not ("stressed", 16., false))
    ("desserts", 4., true) ;

  AT.check
    (trio AT.string AT.string AT.string)
    "mapAll"
    (Tuple3.mapAll ~f:String.reverse ("was", "stressed", "now"))
    ("saw", "desserts", "won") ;

  AT.check
    (trio AT.int AT.int AT.int)
    "rotateLeft"
    (Tuple3.rotateLeft (3, 4, 5))
    (4, 5, 3) ;

  AT.check
    (trio AT.int AT.int AT.int)
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
  ; ("Char", `Quick, t_Char)
  ; ("Float", `Quick, t_Float)
  ; ("Fun", `Quick, t_Fun)
  ; ("Int", `Quick, t_Int)
  ; ("List", `Quick, t_List)
  ; ("String", `Quick, t_String)
  ; ("Tuple2", `Quick, t_Tuple2)
  ; ("Tuple3", `Quick, t_Tuple3)
  ; ("Option", `Quick, t_Option)
  ; ("Result", `Quick, t_Result)
  ]


let () =
  let suite, exit =
    Junit_alcotest.run_and_report "suite" [ ("tests", suite) ]
  in
  let report = Junit.make [ suite ] in
  Junit.to_file report "test-native.xml"
