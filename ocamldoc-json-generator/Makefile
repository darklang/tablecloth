dummy:

CMO=JsonGenerator.cmo
CMX=$(CMO:.cmo=.cma)
CMXS=$(CMA:.cma=.cmxs)

COMPFLAGS=-package menhirLib,ocamldoc,reason
CMXA_DEPS=menhirLib.cmxa migrate_parsetree.cmxa ReasonEasyFormat.cmxa reason.cmxa
OCAMLFIND_CUSTOM_GENERATORS_DIRECTORY=`ocamlfind ocamldoc -customdir`

opt: $(CMXS)

$(CMXS): $(CMO:.cmo=.cmx)
	ocamlfind ocamlopt $(COMPFLAGS) -shared -o $@ $(CMXA_DEPS) $^

$(CMO): JsonGenerator.ml
	ocamlfind ocamlc $(COMPFLAGS) -c $<

$(CMX): JsonGenerator.ml
	ocamlfind ocamlopt $(COMPFLAGS) -c $<

install: opt
	mkdir -p `ocamlfind ocamldoc -customdir`
	cp -f JsonGenerator.cmxs `ocamlfind ocamldoc -customdir`/

build: all dummy
	cp ../native/src/Bool.ml ./_build/Bool.ml
	cp ../bucklescript/src/Bool.mli ./_build/Bool.mli
	cp ../native/src/Comparator.ml ./_build/Comparator.ml
	cp ../bucklescript/src/Comparator.mli ./_build/Comparator.mli
	cp ../bucklescript/src/Container.ml ./_build/Container.ml
	cp ../bucklescript/src/Fun.ml ./_build/Fun.ml
	cp ../native/src/Float.ml ./_build/Float.ml
	cp ../bucklescript/src/Float.mli ./_build/Float.mli
	cp ../bucklescript/src/Fun.mli ./_build/Fun.mli
	cp ../native/src/Int.ml ./_build/Int.ml
	cp ../bucklescript/src/Int.mli ./_build/Int.mli
	cp ../native/src/Internal.ml ./_build/Internal.ml
	cp ../native/src/TableclothArray.ml ./_build/TableclothArray.ml
	cp ../bucklescript/src/TableclothArray.mli ./_build/TableclothArray.mli
	cp ../native/src/TableclothChar.ml ./_build/TableclothChar.ml
	cp ../bucklescript/src/TableclothChar.mli ./_build/TableclothChar.mli
	cp ../native/src/TableclothList.ml ./_build/TableclothList.ml
	cp ../bucklescript/src/TableclothList.mli ./_build/TableclothList.mli
	cp ../native/src/TableclothMap.ml ./_build/TableclothMap.ml
	cp ../native/src/TableclothMap.mli ./_build/TableclothMap.mli
	cp ../native/src/TableclothOption.ml ./_build/TableclothOption.ml
	cp ../bucklescript/src/TableclothOption.mli ./_build/TableclothOption.mli
	cp ../native/src/TableclothResult.ml ./_build/TableclothResult.ml
	cp ../bucklescript/src/TableclothResult.mli ./_build/TableclothResult.mli
	cp ../native/src/TableclothSet.ml ./_build/TableclothSet.ml
	cp ../native/src/TableclothSet.mli ./_build/TableclothSet.mli
	cp ../native/src/TableclothString.ml ./_build/TableclothString.ml
	cp ../bucklescript/src/TableclothString.mli ./_build/TableclothString.mli
	cp ../bucklescript/src/Tuple2.ml ./_build/Tuple2.ml
	cp ../bucklescript/src/Tuple2.mli ./_build/Tuple2.mli
	cp ../bucklescript/src/Tuple3.ml ./_build/Tuple3.ml
	cp ../bucklescript/src/Tuple3.mli ./_build/Tuple3.mli
	cp ../native/src/tablecloth.ml ./_build/tablecloth.ml	
	ocamlfind ocamlc \
		-package base,str \
		-linkpkg \
		-I ./_build \
		-o ./_build/out \
		./_build/Bool.mli \
		./_build/Bool.ml \
		./_build/Comparator.mli \
		./_build/Comparator.ml \
		./_build/Container.ml \
		./_build/Float.mli \
		./_build/Float.ml \
		./_build/Fun.mli \
		./_build/Fun.ml \
		./_build/Int.mli \
		./_build/Int.ml \
		./_build/Internal.ml \
		./_build/TableclothChar.mli \
		./_build/TableclothChar.ml \
		./_build/TableclothString.mli \
		./_build/TableclothString.ml \
		./_build/TableclothOption.mli \
		./_build/TableclothOption.ml \
		./_build/TableclothMap.mli \
		./_build/TableclothMap.ml \
		./_build/TableclothArray.mli \
		./_build/TableclothArray.ml \
		./_build/TableclothList.mli \
		./_build/TableclothList.ml \
		./_build/TableclothResult.mli \
		./_build/TableclothResult.ml \
		./_build/TableclothSet.mli \
		./_build/TableclothSet.ml \
		./_build/Tuple2.mli \
		./_build/Tuple2.ml \
		./_build/Tuple3.mli \
		./_build/Tuple3.ml \
		./_build/tablecloth.ml

doc: build
	ocamldoc.opt \
		-g JsonGenerator.cmxs \
		`ocamlfind query -i-format base` \
		`ocamlfind query -i-format str` \
		-I ./_build \
		-d ../website \
		./_build/Bool.mli \
		./_build/Bool.ml \
		./_build/Comparator.mli \
		./_build/Comparator.ml \
		./_build/Container.ml \
		./_build/Float.mli \
		./_build/Float.ml \
		./_build/Fun.mli \
		./_build/Fun.ml \
		./_build/Int.mli \
		./_build/Int.ml \
		./_build/Internal.ml \
		./_build/TableclothChar.mli \
		./_build/TableclothChar.ml \
		./_build/TableclothString.mli \
		./_build/TableclothString.ml \
		./_build/TableclothOption.mli \
		./_build/TableclothOption.ml \
		./_build/TableclothMap.mli \
		./_build/TableclothMap.ml \
		./_build/TableclothArray.mli \
		./_build/TableclothArray.ml \
		./_build/TableclothList.mli \
		./_build/TableclothList.ml \
		./_build/TableclothResult.mli \
		./_build/TableclothResult.ml \
		./_build/TableclothSet.mli \
		./_build/TableclothSet.ml \
		./_build/Tuple2.mli \
		./_build/Tuple2.ml \
		./_build/Tuple3.mli \
		./_build/Tuple3.ml \
		./_build/tablecloth.ml

all: opt build doc

clean:
	rm -f *.cm* *.o *.a

