open Tablecloth

let rndInt _ = Js.Math.random_int 0 10

let bench size =
    let str = " list of " ^ (string_of_int size) ^ " random ints" in
    let randomInts = List.initialize size rndInt in
    Js.Console.log " ";
    Js.Console.timeStart ("foldl flipped" ^ str);
    let _ = List.foldl randomInts ~f:(flip (+)) ~init:0 in
    Js.Console.timeEnd ("foldl flipped" ^ str);

    Js.Console.timeStart ("reduce " ^ str);
    let _ = Belt.List.reduce randomInts 0 (+) in
    Js.Console.timeEnd ("reduce " ^ str);

    Js.Console.timeStart ("foldr flipped" ^ str);
    let _ = List.foldr randomInts ~f:(flip (+)) ~init:0 in
    Js.Console.timeEnd ("foldr flipped" ^ str);

    Js.Console.timeStart ("reduceReverse " ^ str);
    let _ = Belt.List.reduceReverse randomInts 0 (+) in
    Js.Console.timeEnd ("reduceReverse " ^ str);

    ()


let size = 999

let () =
    bench (size * 1) ;
    bench (size * 2) ;
    bench (size * 3) ;
    bench (size * 4) ;
    bench (size * 5) ;
    bench (size * 6) ;
    bench (size * 7) ;
    bench (size * 8) ;
    bench (size * 9) ;
    bench (size * 10);
    bench (size * 11);
    bench (size * 12);
    bench (size * 13);
    bench (size * 14);
    bench (size * 15);
    bench (size * 16);
    bench (size * 17);
    bench (size * 18);
    bench (size * 19);
    ()
