let () = {
  Alcotest.run(
    "Tablecloth",
    [("tests", [BoolTest.suite, IntTest.suite, ...TableclothTest.suite])],
  );
};
