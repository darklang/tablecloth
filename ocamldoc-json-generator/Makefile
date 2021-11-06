dummy:

CMO=JsonGenerator.cmo
CMX=JsonGenerator.cmx
CMXS=JsonGenerator.cmxs

COMPFLAGS=-package menhirLib,ocamldoc,reason
CMXA_DEPS=menhirLib.cmxa reason_migrate_parsetree.cmxa ReasonEasyFormat.cmxa reason.cmxa

ESY_TC=$(shell find ~/.esy/source/i/ -maxdepth 1 -type d | grep tablecloth_ | awk '{print $1"/lib/ocaml"}')

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
	opam install base.v0.14.1 reason.3.7.0 menhir.20210419 -y

install: opt
	mkdir -p `opam config exec -- ocamlfind ocamldoc -customdir`
	cp -f JsonGenerator.cmxs `opam config exec -- ocamlfind ocamldoc -customdir`/

# We need to build tablecloth to create the cmi files for ocamldoc
build-native: opt dummy
	cp ../native/src/TableclothBool.ml ./_build/TableclothBool.ml
	cp ../native/src/TableclothBool.mli ./_build/TableclothBool.mli
	cp ../native/src/TableclothComparator.ml ./_build/TableclothComparator.ml
	cp ../native/src/TableclothComparator.mli ./_build/TableclothComparator.mli
	cp ../rescript/src/TableclothContainer.ml ./_build/TableclothContainer.ml
	cp ../native/src/TableclothFun.ml ./_build/TableclothFun.ml
	cp ../native/src/TableclothFloat.ml ./_build/TableclothFloat.ml
	cp ../native/src/TableclothFloat.mli ./_build/TableclothFloat.mli
	cp ../native/src/TableclothFun.mli ./_build/TableclothFun.mli
	cp ../native/src/TableclothInt.ml ./_build/TableclothInt.ml
	cp ../native/src/TableclothInt.mli ./_build/TableclothInt.mli
	cp ../native/src/Internal.ml ./_build/Internal.ml
	cp ../native/src/TableclothArray.ml ./_build/TableclothArray.ml
	cp ../native/src/TableclothArray.mli ./_build/TableclothArray.mli
	cp ../native/src/TableclothChar.ml ./_build/TableclothChar.ml
	cp ../native/src/TableclothChar.mli ./_build/TableclothChar.mli
	cp ../native/src/TableclothList.ml ./_build/TableclothList.ml
	cp ../native/src/TableclothList.mli ./_build/TableclothList.mli
	cp ../native/src/TableclothMap.ml ./_build/TableclothMap.ml
	cp ../native/src/TableclothMap.mli ./_build/TableclothMap.mli
	cp ../native/src/TableclothOption.ml ./_build/TableclothOption.ml
	cp ../native/src/TableclothOption.mli ./_build/TableclothOption.mli
	cp ../native/src/TableclothResult.ml ./_build/TableclothResult.ml
	cp ../native/src/TableclothResult.mli ./_build/TableclothResult.mli
	cp ../native/src/TableclothSet.ml ./_build/TableclothSet.ml
	cp ../native/src/TableclothSet.mli ./_build/TableclothSet.mli
	cp ../native/src/TableclothString.ml ./_build/TableclothString.ml
	cp ../native/src/TableclothString.mli ./_build/TableclothString.mli
	cp ../native/src/TableclothTuple2.ml ./_build/TableclothTuple2.ml
	cp ../native/src/TableclothTuple2.mli ./_build/TableclothTuple2.mli
	cp ../native/src/TableclothTuple3.ml ./_build/TableclothTuple3.ml
	cp ../native/src/TableclothTuple3.mli ./_build/TableclothTuple3.mli
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

# We need to build tablecloth to create the cmi files for ocamldoc
build-rescript: opt dummy
	mkdir node_modules
	mkdir node_modules/tablecloth-bucklescript
	cp ../package.json node_modules/tablecloth-bucklescript
	cp ../bsconfig.json node_modules/tablecloth-bucklescript
	cp -r ../rescript node_modules/tablecloth-bucklescript
	~/.npm-global/bin/esy
	cp ../rescript/src/TableclothBool.ml ./_rescript/TableclothBool.ml
	cp ../rescript/src/TableclothBool.mli ./_rescript/TableclothBool.mli
	cp ../rescript/src/TableclothComparator.ml ./_rescript/TableclothComparator.ml
	cp ../rescript/src/TableclothComparator.mli ./_rescript/TableclothComparator.mli
	cp ../rescript/src/TableclothContainer.ml ./_rescript/TableclothContainer.ml
	cp ../rescript/src/TableclothFun.ml ./_rescript/TableclothFun.ml
	cp ../rescript/src/TableclothFloat.ml ./_rescript/TableclothFloat.ml
	cp ../rescript/src/TableclothFloat.mli ./_rescript/TableclothFloat.mli
	cp ../rescript/src/TableclothFun.mli ./_rescript/TableclothFun.mli
	cp ../rescript/src/TableclothInt.ml ./_rescript/TableclothInt.ml
	cp ../rescript/src/TableclothInt.mli ./_rescript/TableclothInt.mli
	cp ../rescript/src/Internal.ml ./_rescript/Internal.ml
	cp ../rescript/src/TableclothArray.ml ./_rescript/TableclothArray.ml
	cp ../rescript/src/TableclothArray.mli ./_rescript/TableclothArray.mli
	cp ../rescript/src/TableclothChar.ml ./_rescript/TableclothChar.ml
	cp ../rescript/src/TableclothChar.mli ./_rescript/TableclothChar.mli
	cp ../rescript/src/TableclothList.ml ./_rescript/TableclothList.ml
	cp ../rescript/src/TableclothList.mli ./_rescript/TableclothList.mli
	cp ../rescript/src/TableclothMap.ml ./_rescript/TableclothMap.ml
	cp ../rescript/src/TableclothMap.mli ./_rescript/TableclothMap.mli
	cp ../rescript/src/TableclothOption.ml ./_rescript/TableclothOption.ml
	cp ../rescript/src/TableclothOption.mli ./_rescript/TableclothOption.mli
	cp ../rescript/src/TableclothResult.ml ./_rescript/TableclothResult.ml
	cp ../rescript/src/TableclothResult.mli ./_rescript/TableclothResult.mli
	cp ../rescript/src/TableclothSet.ml ./_rescript/TableclothSet.ml
	cp ../rescript/src/TableclothSet.mli ./_rescript/TableclothSet.mli
	cp ../rescript/src/TableclothString.ml ./_rescript/TableclothString.ml
	cp ../rescript/src/TableclothString.mli ./_rescript/TableclothString.mli
	cp ../rescript/src/TableclothTuple2.ml ./_rescript/TableclothTuple2.ml
	cp ../rescript/src/TableclothTuple2.mli ./_rescript/TableclothTuple2.mli
	cp ../rescript/src/TableclothTuple3.ml ./_rescript/TableclothTuple3.ml
	cp ../rescript/src/TableclothTuple3.mli ./_rescript/TableclothTuple3.mli
	cp ../rescript/src/Tablecloth.ml ./_rescript/Tablecloth.ml
	~/.npm-global/bin/esy build

doc-native: build-native
	DESTINATION_JSON=model.json \
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

doc-rescript: build-rescript
	DESTINATION_JSON=model-rescript.json \
	opam config exec -- ocamldoc.opt \
		-g $(CMXS) \
		`opam config exec -- ocamlfind query -i-format base` \
		`opam config exec -- ocamlfind query -i-format str` \
		-I node_modules/bs-platform/lib/melange \
		-I $(ESY_TC) \
		-I ./_rescript \
		-d ../website \
		./_rescript/TableclothBool.mli \
		./_rescript/TableclothBool.ml \
		./_rescript/TableclothComparator.mli \
		./_rescript/TableclothComparator.ml \
		./_rescript/TableclothContainer.ml \
		./_rescript/TableclothFloat.mli \
		./_rescript/TableclothFloat.ml \
		./_rescript/TableclothFun.mli \
		./_rescript/TableclothFun.ml \
		./_rescript/TableclothInt.mli \
		./_rescript/TableclothInt.ml \
		./_rescript/Internal.ml \
		./_rescript/TableclothChar.mli \
		./_rescript/TableclothChar.ml \
		./_rescript/TableclothString.mli \
		./_rescript/TableclothString.ml \
		./_rescript/TableclothOption.mli \
		./_rescript/TableclothOption.ml \
		./_rescript/TableclothMap.mli \
		./_rescript/TableclothMap.ml \
		./_rescript/TableclothArray.mli \
		./_rescript/TableclothArray.ml \
		./_rescript/TableclothList.mli \
		./_rescript/TableclothList.ml \
		./_rescript/TableclothResult.mli \
		./_rescript/TableclothResult.ml \
		./_rescript/TableclothSet.mli \
		./_rescript/TableclothSet.ml \
		./_rescript/TableclothTuple2.mli \
		./_rescript/TableclothTuple2.ml \
		./_rescript/TableclothTuple3.mli \
		./_rescript/TableclothTuple3.ml \
		./_rescript/Tablecloth.ml

doc: doc-native doc-rescript

clean:
	rm -f _rescript/* *.cm* *.o *.a
	rm -f _build/* *.cm* *.o *.a

