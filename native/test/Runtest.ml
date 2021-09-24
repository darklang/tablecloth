let () =
  Alcotest.run
    "Tablecloth"
    [ ( "tests"
      , [ ArrayTest.suite
        ; BoolTest.suite
        ; CharTest.suite
        ; FloatTest.suite
        ; FormatTest.suite
        ; FunTest.suite
        ; IntTest.suite
        ; ListTest.suite
        ; MapTest.suite
        ; MapOcamlSyntaxSpecificTest.suite
        ; OptionTest.suite
        ; ResultTest.suite
        ; SetTest.suite
        ; SetOcamlSyntaxSpecificTest.suite
        ; StringTest.suite
        ; Tuple2Test.suite
        ; Tuple3Test.suite
        ] )
    ]
