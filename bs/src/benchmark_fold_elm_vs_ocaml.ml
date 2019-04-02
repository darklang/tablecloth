let flip f x y = f y x

let foldl_elm ~(f : 'a -> 'b -> 'b) ~(init : 'b) (l : 'a list) : 'b =
    Belt.List.reduce l init (flip f)

let foldl_ocaml ~(f : 'b -> 'a -> 'b) ~(init : 'b) (l : 'a list) : 'b =
    Belt.List.reduce l init f

let foldr_elm ~(f : 'a -> 'b -> 'b) ~(init : 'b) (l : 'a list) : 'b =
    Belt.List.reduceReverse l init (flip f)

let foldr_ocaml ~(f : 'b -> 'a -> 'b) ~(init : 'b) (l : 'a list) : 'b =
    Belt.List.reduceReverse l init f

let rndInt _ = Js.Math.random_int 0 10

let bench size =
    let str = " list of " ^ (string_of_int size) ^ " random ints" in
    let randomInts = Tablecloth.List.initialize size rndInt in
    Js.Console.log " ";

    Js.Console.timeStart ("foldl elm   style" ^ str);
    let _ = foldl_elm randomInts ~f:(+) ~init:0 in
    Js.Console.timeEnd ("foldl elm   style" ^ str);

    Js.Console.timeStart ("foldl ocaml style" ^ str);
    let _ = foldl_ocaml randomInts ~f:(+) ~init:0 in
    Js.Console.timeEnd ("foldl ocaml style" ^ str);

    Js.Console.timeStart ("foldr elm   style" ^ str);
    let _ = foldr_elm randomInts ~f:(+) ~init:0 in
    Js.Console.timeEnd ("foldr elm   style" ^ str);

    Js.Console.timeStart ("foldr ocaml style" ^ str);
    let _ = foldr_ocaml randomInts ~f:(+) ~init:0 in
    Js.Console.timeEnd ("foldr ocaml style" ^ str);

    ()


let size = 999

let () = begin
    for i = 1 to 20 do
        bench (size * i) ;
    done
end
