let () = {
  Alcotest.run(
    "Tablecloth",
    [
      (
        "tests",
        [
          ArrayTest.suite,
          BoolTest.suite,
          CharTest.suite,
          FloatTest.suite,
          IntTest.suite,
          OptionTest.suite,
          ResultTest.suite,
          ListTest.suite,
          FunTest.suite,
          StringTest.suite,
          Tuple2Test.suite,
          Tuple3Test.suite,
        ],
      ),
    ],
  );
};
