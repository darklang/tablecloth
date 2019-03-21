open Tablecloth
open Jest
open Expect

let () =
  describe "String" (fun () ->
    test "length" (fun () -> expect (String.length "123") |> toEqual 3);
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
