open Tablecloth
open AlcoJest

module Book = struct
  type t =
    { isbn : string
    ; title : string
    }
end

module BookByIsbn = struct
  type t = Book.t

  include Comparator.Make (struct
    type nonrec t = t

    let compare (bookA : Book.t) (bookB : Book.t) =
      String.compare bookA.isbn bookB.isbn
  end)
end

module BookByTitle = struct
  type t = Book.t

  include Comparator.Make (struct
    type nonrec t = t

    let compare (bookA : Book.t) (bookB : Book.t) =
      String.compare bookA.title bookB.title
  end)
end

module BookByIsbnThenTitle = struct
  type t = Book.t

  include Comparator.Make (struct
    type nonrec t = t

    let compare (bookA : Book.t) (bookB : Book.t) =
      let isbnComparison = String.compare bookA.isbn bookB.isbn in
      if isbnComparison = 0
      then String.compare bookA.title bookB.title
      else isbnComparison
  end)
end

let book =
  let eq (a : Book.t) (b : Book.t) : bool = a = b in
  Eq.make eq


let mobyDick : Book.t =
  { isbn = "9788460767923"; title = "Moby Dick or The Whale" }


let mobyDickReissue : Book.t =
  { isbn = "9788460767924"; title = "Moby Dick or The Whale" }


let frankenstein : Book.t = { isbn = "9781478198406"; title = "Frankenstein" }

let frankensteinAlternateTitle : Book.t =
  { isbn = "9781478198406"; title = "The Modern Prometheus" }


let suite =
  suite "Comparator" (fun () ->
      describe "Make" (fun () ->
          test "module documentation example" (fun () ->
              let result : Book.t list =
                Set.fromList
                  [ frankenstein; frankensteinAlternateTitle ]
                  (module BookByIsbn)
                |> Set.toList
              in
              expect result |> toEqual (Eq.list book) [ frankenstein ] ) ) ;
      describe "make" (fun () ->
          test "module documentation example" (fun () ->
              let result : Book.t list =
                Set.fromList [ mobyDick; mobyDickReissue ] (module BookByTitle)
                |> Set.toList
              in
              expect result |> toEqual (Eq.list book) [ mobyDick ] ) ) )
