open Jest;
open Expect;

module Eq: {
  /** This module is purely to make the API match the one provided in
      native/test/AlcoJest.re
      All of the implementations are `ignore` since although Alcotest requires
      matchers which can test for equality and pretty print types, Jest doesn't
      need these as it compares values structurally (which is fine for the
      included types)
  */
  type result
  type t('a) = ('a, 'a) => result;
  let make: (('a, 'a) => bool) => ((Format.formatter, 'a) => unit) => t('a);
  let bool: t(bool);
  let char: t(char);
  let int: t(int);
  // let integer: t(Standard.Integer.t);
  let float: t(float);
  let string: t(string);
  let unit: t(unit);
  let array: t('a) => t(array('a));
  let list: t('a) => t(list('a));
  let option: t('a) => t(option('a));
  let result: (t('ok), t('error)) => t(Tablecloth.Result.t('ok, 'error));
  let pair: (t('a), t('b)) => t(('a, 'b));
  let trio: (t('a), t('b), t('c)) => t(('a, 'b, 'c));
} = {
  type result = unit;
  type t('a) = ('a, 'a) => unit;
  let make = (_, _, _, _) => ();
  let ignore = _ => ignore;
  let bool = ignore;
  let char = ignore;
  let int = ignore;
  let float = ignore;
  let string = ignore;
  let unit = ignore;
  let array = _ => ignore;
  let list = _ => ignore;
  let option = _ => ignore;
  let result = (_, _) => ignore;
  let pair = (_, _) => ignore;
  let trio = (_, _, _) => ignore;
};

let suite = describe;

let describe = describe;

let test = test;

let testAll = testAll;

module Skip = Skip;

let expect = expect;

let toEqual = (_: Eq.t('a), value: 'a) => toEqual(value);

let toBeCloseTo = toBeCloseTo;

let toRaise = _exn => toThrow;

let toThrow = toThrow;
