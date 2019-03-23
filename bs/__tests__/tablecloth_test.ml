open Tablecloth
open Jest
open Expect

let () =
  describe "List" (fun () ->
    test "indexedMap empty" (fun () -> expect (List.indexedMap ~f:(fun i _ -> i) []) |> toEqual []);
    test "indexedMap one element" (fun () -> expect (List.indexedMap ~f:(fun i _ -> i) ['a']) |> toEqual [0]);
    test "indexedMap two elements" (fun () -> expect (List.indexedMap ~f:(fun i _ -> i) ['a';'b']) |> toEqual [0;1]);

    test "partition empty list" (fun () -> expect (List.partition ~f:(fun x -> x mod 2 = 0) []) |> toEqual ([], []));
    test "partition one element" (fun () -> expect (List.partition ~f:(fun x -> x mod 2 = 0) [1]) |> toEqual ([], [1]));
    test "partition four elements" (fun () -> expect (List.partition ~f:(fun x -> x mod 2 = 0) [1;2;3;4]) |> toEqual ([2;4], [1;3]));
  );

  describe "String" (fun () ->
    test "length empty string" (fun () -> expect (String.length "") |> toEqual 0);
    test "length" (fun () -> expect (String.length "123") |> toEqual 3);
    test "reverse empty string" (fun () -> expect (String.reverse "") |> toEqual "");
    test "reverse" (fun () -> expect (String.reverse "stressed") |> toEqual "desserts");
  );

  describe "Tuple2" (fun () ->
    test "create" (fun () -> 
      expect (Tuple2.create 3 4) |> toEqual (3, 4)      
    );

    test "first" (fun () -> 
      expect (Tuple2.first (3, 4)) |> toEqual 3      
    );

    test "second" (fun () -> 
      expect (Tuple2.second (3, 4)) |> toEqual 4      
    );

    test "mapFirst" (fun () ->
      expect (Tuple2.mapFirst ~f:String.reverse ("stressed", 16)) |> toEqual ("desserts", 16)      
    );

    test "mapSecond" (fun () ->
      expect (Tuple2.mapSecond ~f:sqrt ("stressed", 16.)) |> toEqual ("stressed", 4.)      
    );

    test "mapBoth" (fun () ->
      expect (Tuple2.mapBoth ~f:String.reverse ~g:sqrt ("stressed", 16.)) |> toEqual ("desserts", 4.)      
    )
  );

  describe "Tuple3" (fun () ->
    test "create" (fun () -> 
      expect (Tuple3.create 3 4 5) |> toEqual (3, 4, 5)      
    );

    test "first" (fun () -> 
      expect (Tuple3.first (3, 4, 5)) |> toEqual 3      
    );

    test "second" (fun () -> 
      expect (Tuple3.second (3, 4, 5)) |> toEqual 4      
    );

    test "third" (fun () -> 
      expect (Tuple3.third (3, 4, 5)) |> toEqual 5      
    );

    test "mapFirst" (fun () ->
      expect (Tuple3.mapFirst ~f:String.reverse ("stressed", 16, false)) |> toEqual ("desserts", 16, false)
    );

    test "mapSecond" (fun () ->
      expect (Tuple3.mapSecond ~f:sqrt ("stressed", 16., false)) |> toEqual ("stressed", 4., false)      
    );

    test "mapThird" (fun () ->
      expect (Tuple3.mapThird ~f:not ("stressed", 16, false)) |> toEqual ("stressed", 16, true);
    );

    test "mapEach" (fun () ->
      expect (Tuple3.mapEach ~f:String.reverse ~g:sqrt ~h:not ("stressed", 16., false)) |> toEqual ("desserts", 4., true)
    );
  );

  ()
