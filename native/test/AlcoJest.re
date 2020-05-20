module AT = Alcotest;

module Eq = {
  include AT;

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

  let make = (equal: ('a, 'a) => bool,  prettyPrint: (Format.formatter, 'a) => unit) => 
    AT.testable(prettyPrint, equal);
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
      description ++ ", [values][" ++ Tablecloth.Int.toString(index) ++ "]", () =>
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
