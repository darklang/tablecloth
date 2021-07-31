dummy:

CMO=JsonGenerator.cmo
CMX=JsonGenerator.cmx
CMXS=JsonGenerator.cmxs

COMPFLAGS=-package menhirLib,ocamldoc,reason
CMXA_DEPS=menhirLib.cmxa migrate_parsetree.cmxa ReasonEasyFormat.cmxa reason.cmxa

opt: $(CMXS)

$(CMO): JsonGenerator.ml
	opam config exec -- ocamlfind ocamlc $(COMPFLAGS) -c $<

$(CMX): JsonGenerator.ml
	opam config exec -- ocamlfind ocamlopt $(COMPFLAGS) -c $<

$(CMXS): $(CMX)
	opam config exec -- ocamlfind ocamlopt $(COMPFLAGS) -shared -o $@ $(CMXA_DEPS) $^

deps:
	@printf "\n\e[31mInstalling generator dependencies ...\e[0m\n"
	opam update
	opam install base reason menhir -y

install: opt
	mkdir -p `opam config exec -- ocamlfind ocamldoc -customdir`
	cp -f JsonGenerator.cmxs `opam config exec -- ocamlfind ocamldoc -customdir`/

# We need to build tablecloth to create the cmi files for ocamldoc
build: opt dummy
	cp ../native/src/TableclothBool.ml ./_build/TableclothBool.ml
	cp ../rescript/src/TableclothBool.mli ./_build/TableclothBool.mli
	cp ../native/src/TableclothComparator.ml ./_build/TableclothComparator.ml
	cp ../rescript/src/TableclothComparator.mli ./_build/TableclothComparator.mli
	cp ../rescript/src/TableclothContainer.ml ./_build/TableclothContainer.ml
	cp ../rescript/src/TableclothFun.ml ./_build/TableclothFun.ml
	cp ../native/src/TableclothFloat.ml ./_build/TableclothFloat.ml
	cp ../rescript/src/TableclothFloat.mli ./_build/TableclothFloat.mli
	cp ../rescript/src/TableclothFun.mli ./_build/TableclothFun.mli
	cp ../native/src/TableclothInt.ml ./_build/TableclothInt.ml
	cp ../rescript/src/TableclothInt.mli ./_build/TableclothInt.mli
	cp ../native/src/Internal.ml ./_build/Internal.ml
	cp ../native/src/TableclothArray.ml ./_build/TableclothArray.ml
	cp ../rescript/src/TableclothArray.mli ./_build/TableclothArray.mli
	cp ../native/src/TableclothChar.ml ./_build/TableclothChar.ml
	cp ../rescript/src/TableclothChar.mli ./_build/TableclothChar.mli
	cp ../native/src/TableclothList.ml ./_build/TableclothList.ml
	cp ../rescript/src/TableclothList.mli ./_build/TableclothList.mli
	cp ../native/src/TableclothMap.ml ./_build/TableclothMap.ml
	cp ../native/src/TableclothMap.mli ./_build/TableclothMap.mli
	cp ../native/src/TableclothOption.ml ./_build/TableclothOption.ml
	cp ../rescript/src/TableclothOption.mli ./_build/TableclothOption.mli
	cp ../native/src/TableclothResult.ml ./_build/TableclothResult.ml
	cp ../rescript/src/TableclothResult.mli ./_build/TableclothResult.mli
	cp ../native/src/TableclothSet.ml ./_build/TableclothSet.ml
	cp ../native/src/TableclothSet.mli ./_build/TableclothSet.mli
	cp ../native/src/TableclothString.ml ./_build/TableclothString.ml
	cp ../rescript/src/TableclothString.mli ./_build/TableclothString.mli
	cp ../rescript/src/TableclothTuple2.ml ./_build/TableclothTuple2.ml
	cp ../rescript/src/TableclothTuple2.mli ./_build/TableclothTuple2.mli
	cp ../rescript/src/TableclothTuple3.ml ./_build/TableclothTuple3.ml
	cp ../rescript/src/TableclothTuple3.mli ./_build/TableclothTuple3.mli
	cp ../native/src/Tablecloth.ml ./_build/Tablecloth.ml
	opam config exec -- ocamlfind ocamlc \
		-package base,str \
		-linkpkg \
		-I ./_build \
		-o ./_build/out \
		./_build/TableclothBool.mli \
		./_build/TableclothBool.ml \
		./_build/TableclothComparator.mli \
		./_build/TableclothComparator.ml \
		./_build/TableclothContainer.ml \
		./_build/TableclothFloat.mli \
		./_build/TableclothFloat.ml \
		./_build/TableclothFun.mli \
		./_build/TableclothFun.ml \
		./_build/TableclothInt.mli \
		./_build/TableclothInt.ml \
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
		./_build/TableclothTuple2.mli \
		./_build/TableclothTuple2.ml \
		./_build/TableclothTuple3.mli \
		./_build/TableclothTuple3.ml \
		./_build/Tablecloth.ml

doc: build
	opam config exec -- ocamldoc.opt \
		-g $(CMXS) \
		`opam config exec -- ocamlfind query -i-format base` \
		`opam config exec -- ocamlfind query -i-format str` \
		-I ./_build \
		-d ../website \
		./_build/TableclothBool.mli \
		./_build/TableclothBool.ml \
		./_build/TableclothComparator.mli \
		./_build/TableclothComparator.ml \
		./_build/TableclothContainer.ml \
		./_build/TableclothFloat.mli \
		./_build/TableclothFloat.ml \
		./_build/TableclothFun.mli \
		./_build/TableclothFun.ml \
		./_build/TableclothInt.mli \
		./_build/TableclothInt.ml \
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
		./_build/TableclothTuple2.mli \
		./_build/TableclothTuple2.ml \
		./_build/TableclothTuple3.mli \
		./_build/TableclothTuple3.ml \
		./_build/Tablecloth.ml

clean:
	rm -f _build/* *.cm* *.o *.a

