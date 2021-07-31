module AT = Alcotest;

module Coordinate = {
  type t = (int, int);
  let compare = ((x1, y1), (x2, y2)) =>
    if (x1 == x2) {
      if (y1 == y2) {
        0;
      } else if (y1 > y2) {
        1;
      } else {
        (-1);
      };
    } else if (x1 > x2) {
      1;
    } else {
      (-1);
    };
};

module Eq = {
  include AT;

  let coordinate = {
    let eq = (a: Coordinate.t, b: Coordinate.t): bool => a == b;
    let pp = (ppf: Format.formatter, (x, y): Coordinate.t) =>
      Format.pp_print_string(
        ppf,
        "(" ++ string_of_int(x) ++ ", " ++ string_of_int(y) ++ ")",
      );

    AT.testable(pp, eq);
  };

  let trio = (a, b, c) => {
    let eq = ((a1, b1, c1), (a2, b2, c2)) =>
      AT.equal(a, a1, a2) && AT.equal(b, b1, b2) && AT.equal(c, c1, c2);

    let pp = (ppf: Format.formatter, (x, y, z)): unit =>
      Fmt.pf(
        ppf,
        "@[<1>(@[%a@],@ @[%a@],@ @[%a@])@]",
        AT.pp(a),
        x,
        AT.pp(b),
        y,
        AT.pp(c),
        z,
      );

    AT.testable(pp, eq);
  };

  let float = AT.float(0.0);
};

type expectation('a) =
  | Expectation(string, 'a);

let currentFunction = ref("");
let currentDescription = ref("");

let suite = (moduleName, callback) => {
  (moduleName, `Quick, callback);
};

let describe = (functionName, callback) => {
  currentFunction := functionName;
  callback();
  currentFunction := "";
};

let test = (description, callback) => {
  currentDescription := description;
  callback();
  currentDescription := "";
};

let testAll =
    (description: string, values: list('a), callback: 'a => unit): unit => {
  Tablecloth.List.forEachWithIndex(values, ~f=(index, value) =>
    test(
      description ++ ", [values][" ++ Tablecloth.Int.toString(index) ++ "]",
      () =>
      callback(value)
    )
  );
};

module Skip = {
  let test = (_description, _run) => ();
  let testAll = (_description, _values, _run) => ();
};

let expect = (actual: 'a): expectation('a) => {
  Expectation(currentFunction^ ++ " - " ++ currentDescription^, actual);
};

let toEqual = (matcher, expected, Expectation(description, actual)) =>
  AT.check(matcher, description, expected, actual);

let toBeCloseTo = toEqual(AT.float(0.005));

let toRaise =
    (expected: exn, Expectation(description, run): expectation(unit => 'a))
    : unit => {
  AT.check_raises(description, expected, run);
};

exception Throws;
let toThrow = (Expectation(description, run): expectation(unit => 'a)): unit => {
  AT.check_raises(description, Throws, () =>
    try(run() |> ignore) {
    | _ => raise(Throws)
    }
  );
};
