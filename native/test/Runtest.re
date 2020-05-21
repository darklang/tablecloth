let () = {
  Alcotest.run(
    "Tablecloth",
    [
      (
        "tests",
        [
          BoolTest.suite,
          CharTest.suite,
          FloatTest.suite,
          IntTest.suite,
          FunTest.suite,
          ...TableclothTest.suite,
        ],
      ),
    ],
  );
};
