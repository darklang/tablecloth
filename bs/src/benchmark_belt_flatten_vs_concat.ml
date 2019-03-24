module TL = Tablecloth.List
module TA = TC_Array

let rndInt _ = Js.Math.random_int 0 10

let createManySmall small big =
  let randomSmall _ =
    TL.initialize small rndInt
  in
  TL.initialize big randomSmall

let createSomeBig small big =
  let randomBig _ =
    TL.initialize big rndInt
  in
  TL.initialize small randomBig

let bench (small: int) (big: int) =
    let str_small =
        (string_of_int big) ^ " lists " ^ (string_of_int small) ^ " random ints"
    in
    let str_big =
      (string_of_int small) ^ " lists " ^ (string_of_int big) ^ " random ints"
    in
    let manySmall = createManySmall small big in
    let someBig = createSomeBig small big in
    Js.Console.log " ";
    Js.Console.timeStart ("flatten " ^ str_small);
    let _ = TL.flatten manySmall in
    Js.Console.timeEnd ("flatten " ^ str_small);
    Js.Console.timeStart ("concat  " ^ str_small);
    let _ = TL.concat manySmall in
    Js.Console.timeEnd ("concat  " ^ str_small);
    Js.Console.timeStart ("flatten " ^ str_big);
    let _ = TL.flatten someBig in
    Js.Console.timeEnd ("flatten " ^ str_big);
    Js.Console.timeStart ("concat  " ^ str_big);
    let _ = TL.concat someBig in
    Js.Console.timeEnd ("concat  " ^ str_big);
    ()


let small = 10
let big = 1000

let () =
    bench (small * 1) big;
    bench (small * 2) big;
    bench (small * 3) big;
    bench (small * 4) big;
    bench (small * 5) big;
    bench (small * 6) big;
    bench (small * 7) big;
    bench (small * 8) big;
    bench (small * 9) big;
    bench (small * 10) big;
    bench (small * 11) big;
    bench (small * 12) big;
    bench (small * 13) big;
    bench (small * 14) big;
    bench (small * 15) big;
    bench (small * 16) big;
    bench (small * 17) big;
    bench (small * 18) big;
    bench (small * 19) big;
    ()

