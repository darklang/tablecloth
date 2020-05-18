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
          ...TableclothTest.suite,
        ],
      ),
    ],
  );
};
