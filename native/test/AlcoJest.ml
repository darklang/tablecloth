module AT = Alcotest

module Coordinate = struct
  type t = int * int

  let compare (x1, y1) (x2, y2) =
    if x1 = x2
    then if y1 = y2 then 0 else if y1 > y2 then 1 else -1
    else if x1 > x2
    then 1
    else -1
end

module Student = struct
  type t =
    { id : int
    ; name : string
    }
end

module Eq = struct
  include AT

  let coordinate =
    let eq (a : Coordinate.t) (b : Coordinate.t) : bool = a = b in
    let pp (ppf : Format.formatter) ((x, y) : Coordinate.t) =
      Format.pp_print_string
        ppf
        ("(" ^ string_of_int x ^ ", " ^ string_of_int y ^ ")")
    in
    AT.testable pp eq


  let student =
    let eq (a : Student.t) (b : Student.t) : bool = a = b in
    let[@warning "-3"] pp
        (ppf : Format.formatter) ({ id = x; name = y } : Student.t) =
      Format.pp_print_string
        ppf
        ("{ id = " ^ string_of_int x ^ "; name = " ^ y ^ "}")
    in
    AT.testable pp eq


  let trio a b c =
    let eq (a1, b1, c1) (a2, b2, c2) =
      AT.equal a a1 a2 && AT.equal b b1 b2 && AT.equal c c1 c2
    in
    let pp (ppf : Format.formatter) (x, y, z) : unit =
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


  let float = AT.float 0.0
end

type 'a expectation = Expectation of string * 'a

let currentFunction = ref ""

let currentDescription = ref ""

let suite moduleName callback = (moduleName, `Quick, callback)

let describe functionName callback =
  currentFunction := functionName ;
  callback () ;
  currentFunction := ""


let test description callback =
  currentDescription := description ;
  callback () ;
  currentDescription := ""


let testAll (description : string) (values : 'a list) (callback : 'a -> unit) :
    unit =
  Tablecloth.List.for_each_with_index values ~f:(fun index value ->
      test
        (description ^ ", [values][" ^ Tablecloth.Int.to_string index ^ "]")
        (fun () -> callback value) )


module Skip = struct
  let test _description _run = ()

  let testAll _description _values _run = ()
end

let expect (actual : 'a) : 'a expectation =
  Expectation (!currentFunction ^ " - " ^ !currentDescription, actual)


let toEqual matcher expected (Expectation (description, actual)) =
  AT.check matcher description expected actual


let toBeCloseTo = toEqual (AT.float 0.005)

let toRaise
    (expected : exn) (Expectation (description, run) : (unit -> 'a) expectation)
    : unit =
  AT.check_raises description expected run


exception Throws

let toThrow (Expectation (description, run) : (unit -> 'a) expectation) : unit =
  AT.check_raises description Throws (fun () ->
      try run () |> ignore with _ -> raise Throws )
