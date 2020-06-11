dummy:

CMO=JsonGenerator.cmo
CMA=JsonGenerator.cma
CMX=JsonGenerator.cmx
CMXS=$(CMA:.cma=.cmxs)

COMPFLAGS=-package menhirLib,ocamldoc,reason
CMA_DEPS=menhirLib.cmxs migrate_parsetree.cma ReasonEasyFormat.cma reason.cma
CMXA_DEPS=menhirLib.cmxa migrate_parsetree.cmxa ReasonEasyFormat.cmxa reason.cmxa

all: byte # opt

byte: $(CMA)

opt: $(CMXS)

$(CMXS): $(CMO:.cmo=.cmx)
	ocamlfind ocamlopt $(COMPFLAGS) -shared -o $@ $(CMXA_DEPS) $^

$(CMA): $(CMO)
	ocamlfind ocamlc $(COMPFLAGS) -a -o $@ $(CMA_DEPS) $^

$(CMO): JsonGenerator.ml
	ocamlfind ocamlc $(COMPFLAGS) -c $<

$(CMX): JsonGenerator.ml
	ocamlfind ocamlopt $(COMPFLAGS) -c $<

install:byte opt
	mkdir -p `ocamlfind ocamldoc -customdir`
	cp -f \
		$(CMA) \
		$(CMXS) \
		`ocamlfind ocamldoc -customdir`/

build: all dummy
	cp ../native/src/Bool.ml ./_build/Bool.ml
	cp ../bucklescript/src/Bool.mli ./_build/Bool.mli
	cp ../native/src/Float.ml ./_build/Float.ml
	cp ../bucklescript/src/Float.mli ./_build/Float.mli
	cp ../native/src/Int.ml ./_build/Int.ml
	cp ../bucklescript/src/Int.mli ./_build/Int.mli
	cp ../native/src/TableclothChar.ml ./_build/TableclothChar.ml
	cp ../bucklescript/src/TableclothChar.mli ./_build/TableclothChar.mli
	cp ../native/src/TableclothString.ml ./_build/TableclothString.ml
	cp ../bucklescript/src/TableclothString.ml ./_build/TableclothString.ml
	cp ../native/src/tablecloth.ml ./_build/tablecloth.ml	
	ocamlfind ocamlopt \
		-package base,str,zarith,ppx_derivers \
		-linkpkg \
		-I ./_build \
		-o ../_build.out \
		./_build/TableclothChar.ml \
		./_build/TableclothString.ml \
		./_build/tablecloth.ml

doc: build
	ocamldoc.opt \
		-g ./$(CMXS) \
		`ocamlfind query -i-format base` \
		`ocamlfind query -i-format str` \
		`ocamlfind query -i-format ppx_derivers` \
		`ocamlfind query -i-format zarith` \
		-I ./_build \
		-d ../website \
		./_build/tablecloth.ml

clean:
	rm -f *.cm* *.o *.a ./test/*.cm* ./test/*.o ./test/*.a

