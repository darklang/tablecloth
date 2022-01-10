dummy:

CMO=JsonGenerator.cmo
CMX=JsonGenerator.cmx
CMXS=JsonGenerator.cmxs

COMPFLAGS=-package menhirLib,ocamldoc,reason
CMXA_DEPS=menhirLib.cmxa reason_migrate_parsetree.cmxa ReasonEasyFormat.cmxa reason.cmxa

opt: $(CMXS)

$(CMO): JsonGenerator.ml
	~/.npm-global/bin/esy ocamlfind ocamlc $(COMPFLAGS) -c $<

$(CMX): JsonGenerator.ml
	~/.npm-global/bin/esy ocamlfind ocamlopt $(COMPFLAGS) -c $<

$(CMXS): $(CMX)
	~/.npm-global/bin/esy ocamlfind ocamlopt $(COMPFLAGS) -shared -o $@ $(CMXA_DEPS) $^

init-node:
	mkdir node_modules
	mkdir node_modules/tablecloth-bucklescript
	cp ../package.json node_modules/tablecloth-bucklescript
	cp ../bsconfig.json node_modules/tablecloth-bucklescript
	cp -r ../rescript node_modules/tablecloth-bucklescript/rescript

purge-node:
	rm -r node_modules
deps:
	@printf "\n\e[31mInstalling generator dependencies ...\e[0m\n"
	opam update
	opam install base.v0.14.1 reason.3.7.0 menhir.20210419 -y

install: opt
	mkdir -p `~/.npm-global/bin/esy ocamlfind ocamldoc -customdir`
	cp -f JsonGenerator.cmxs `~/.npm-global/bin/esy ocamlfind ocamldoc -customdir`/

# We need to build tablecloth to create the cmi files for ocamldoc
build-native: opt dummy
	cp ../native/src/TableclothBool.ml ./_native/TableclothBool.ml
	cp ../native/src/TableclothBool.mli ./_native/TableclothBool.mli
	cp ../native/src/TableclothComparator.ml ./_native/TableclothComparator.ml
	cp ../native/src/TableclothComparator.mli ./_native/TableclothComparator.mli
	cp ../rescript/src/TableclothContainer.ml ./_native/TableclothContainer.ml
	cp ../native/src/TableclothFun.ml ./_native/TableclothFun.ml
	cp ../native/src/TableclothFloat.ml ./_native/TableclothFloat.ml
	cp ../native/src/TableclothFloat.mli ./_native/TableclothFloat.mli
	cp ../native/src/TableclothFun.mli ./_native/TableclothFun.mli
	cp ../native/src/TableclothInt.ml ./_native/TableclothInt.ml
	cp ../native/src/TableclothInt.mli ./_native/TableclothInt.mli
	cp ../native/src/Internal.ml ./_native/Internal.ml
	cp ../native/src/TableclothArray.ml ./_native/TableclothArray.ml
	cp ../native/src/TableclothArray.mli ./_native/TableclothArray.mli
	cp ../native/src/TableclothChar.ml ./_native/TableclothChar.ml
	cp ../native/src/TableclothChar.mli ./_native/TableclothChar.mli
	cp ../native/src/TableclothList.ml ./_native/TableclothList.ml
	cp ../native/src/TableclothList.mli ./_native/TableclothList.mli
	cp ../native/src/TableclothMap.ml ./_native/TableclothMap.ml
	cp ../native/src/TableclothMap.mli ./_native/TableclothMap.mli
	cp ../native/src/TableclothOption.ml ./_native/TableclothOption.ml
	cp ../native/src/TableclothOption.mli ./_native/TableclothOption.mli
	cp ../native/src/TableclothResult.ml ./_native/TableclothResult.ml
	cp ../native/src/TableclothResult.mli ./_native/TableclothResult.mli
	cp ../native/src/TableclothSet.ml ./_native/TableclothSet.ml
	cp ../native/src/TableclothSet.mli ./_native/TableclothSet.mli
	cp ../native/src/TableclothString.ml ./_native/TableclothString.ml
	cp ../native/src/TableclothString.mli ./_native/TableclothString.mli
	cp ../native/src/TableclothTuple2.ml ./_native/TableclothTuple2.ml
	cp ../native/src/TableclothTuple2.mli ./_native/TableclothTuple2.mli
	cp ../native/src/TableclothTuple3.ml ./_native/TableclothTuple3.ml
	cp ../native/src/TableclothTuple3.mli ./_native/TableclothTuple3.mli
	cp ../native/src/Tablecloth.ml ./_native/Tablecloth.ml
	~/.npm-global/bin/esy ocamlfind ocamlc \
		-package base,str \
		-linkpkg \
		-I ./_native \
		-o ./_native/out \
		./_native/TableclothBool.mli \
		./_native/TableclothBool.ml \
		./_native/TableclothComparator.mli \
		./_native/TableclothComparator.ml \
		./_native/TableclothContainer.ml \
		./_native/TableclothFloat.mli \
		./_native/TableclothFloat.ml \
		./_native/TableclothFun.mli \
		./_native/TableclothFun.ml \
		./_native/TableclothInt.mli \
		./_native/TableclothInt.ml \
		./_native/Internal.ml \
		./_native/TableclothChar.mli \
		./_native/TableclothChar.ml \
		./_native/TableclothString.mli \
		./_native/TableclothString.ml \
		./_native/TableclothOption.mli \
		./_native/TableclothOption.ml \
		./_native/TableclothMap.mli \
		./_native/TableclothMap.ml \
		./_native/TableclothArray.mli \
		./_native/TableclothArray.ml \
		./_native/TableclothList.mli \
		./_native/TableclothList.ml \
		./_native/TableclothResult.mli \
		./_native/TableclothResult.ml \
		./_native/TableclothSet.mli \
		./_native/TableclothSet.ml \
		./_native/TableclothTuple2.mli \
		./_native/TableclothTuple2.ml \
		./_native/TableclothTuple3.mli \
		./_native/TableclothTuple3.ml \
		./_native/Tablecloth.ml

# We need to build tablecloth to create the cmi files for ocamldoc
build-rescript: opt dummy
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

rescript-interfaces: opt dummy
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothBool.mli > ./_rescript/TableclothBool.resi
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothComparator.mli > ./_rescript/TableclothComparator.resi
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothFloat.mli > ./_rescript/TableclothFloat.resi
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothFun.mli > ./_rescript/TableclothFun.resi
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothInt.mli > ./_rescript/TableclothInt.resi
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothArray.mli > ./_rescript/TableclothArray.resi
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothChar.mli > ./_rescript/TableclothChar.resi
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothList.mli > ./_rescript/TableclothList.resi
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothMap.mli > ./_rescript/TableclothMap.resi
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothOption.mli > ./_rescript/TableclothOption.resi
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothResult.mli > ./_rescript/TableclothResult.resi
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothSet.mli > ./_rescript/TableclothSet.resi
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothString.mli > ./_rescript/TableclothString.resi
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothTuple2.mli > ./_rescript/TableclothTuple2.resi
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothTuple3.mli > ./_rescript/TableclothTuple3.resi
	# These are not interfaces, so we do just pretend that they actually are. Still works!
	~/.npm-global/bin/esy bsc -format res ../rescript/src/Internal.ml > ./_rescript/Internal.resi 
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothComparator.ml > ./_rescript/TableclothComparator.resi
	~/.npm-global/bin/esy bsc -format res ../rescript/src/TableclothContainer.ml > ./_rescript/TableclothContainer.resi


doc-native: build-native
	DESTINATION_JSON=model.json \
	~/.npm-global/bin/esy ocamldoc.opt \
		-g $(CMXS) \
		`~/.npm-global/bin/esy ocamlfind query -i-format base` \
		`~/.npm-global/bin/esy ocamlfind query -i-format str` \
		-I ./_native \
		-d ../website \
		./_native/TableclothBool.mli \
		./_native/TableclothBool.ml \
		./_native/TableclothComparator.mli \
		./_native/TableclothComparator.ml \
		./_native/TableclothContainer.ml \
		./_native/TableclothFloat.mli \
		./_native/TableclothFloat.ml \
		./_native/TableclothFun.mli \
		./_native/TableclothFun.ml \
		./_native/TableclothInt.mli \
		./_native/TableclothInt.ml \
		./_native/Internal.ml \
		./_native/TableclothChar.mli \
		./_native/TableclothChar.ml \
		./_native/TableclothString.mli \
		./_native/TableclothString.ml \
		./_native/TableclothOption.mli \
		./_native/TableclothOption.ml \
		./_native/TableclothMap.mli \
		./_native/TableclothMap.ml \
		./_native/TableclothArray.mli \
		./_native/TableclothArray.ml \
		./_native/TableclothList.mli \
		./_native/TableclothList.ml \
		./_native/TableclothResult.mli \
		./_native/TableclothResult.ml \
		./_native/TableclothSet.mli \
		./_native/TableclothSet.ml \
		./_native/TableclothTuple2.mli \
		./_native/TableclothTuple2.ml \
		./_native/TableclothTuple3.mli \
		./_native/TableclothTuple3.ml \
		./_native/Tablecloth.ml

doc-rescript: build-rescript
	# dash to ignore compilation error
	-DESTINATION_JSON=model-rescript.json \
	~/.npm-global/bin/esy ocamldoc.opt \
		-g $(CMXS) \
		-I node_modules/bs-platform/lib/melange \
		-I ../_build/default/ocamldoc-json-generator/node_modules/tablecloth-bucklescript/rescript/src/ \
		-d ../website \
		./_rescript/TableclothComparator.mli \
		./_rescript/TableclothComparator.ml \
		./_rescript/TableclothBool.mli \
		./_rescript/TableclothBool.ml \
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
	rm -f _native/* *.cm* *.o *.a

