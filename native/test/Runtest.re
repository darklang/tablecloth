let () = {
  Alcotest.run(
    "Tablecloth",
    [
      (
        "tests",
        [
          BoolTest.suite,
          ...TableclothTest.suite,
        ],
      ),
    ],
  );
};
