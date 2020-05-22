dummy:

CMO=JsonGenerator.cmo
CMA=JsonGenerator.cma
CMX=JsonGenerator.cmx
CMXS=$(CMA:.cma=.cmxs)

COMPFLAGS=-package menhirLib,ocamldoc,reason
CMA_DEPS=menhirLib.cmo migrate_parsetree.cma ReasonEasyFormat.cma reason.cma
CMXA_DEPS=menhirLib.cmx migrate_parsetree.cmxa ReasonEasyFormat.cmxa reason.cmxa

all: byte opt

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
	cp -f $(CMA) $(CMXS) `ocamlfind ocamldoc -customdir`/

build: all dummy
	cp ../native/src/Tablecloth.ml ./_build/Tablecloth.ml
	cp ../native/src/Core.ml ./_build/Core.ml
	cp ../native/src/Core.mli ./_build/Core.mli
	ocamlfind ocamlopt \
		-package base,str,zarith \
		-linkpkg \
		-I ./_build \
		-o ../_build.out \
		./_build/Core.mli \
		./_build/Core.ml \
		./_build/Standard.ml

doc: build
	ocamldoc.opt \
		-g ./$(CMXS) \
		`ocamlfind query -i-format base` \
		`ocamlfind query -i-format str` \
		`ocamlfind query -i-format zarith` \
		-I ./_build \
		-d ../website \
		./_build/Core.mli \
		./_build/Core.ml \
		./_build/Standard.ml

clean:
	rm -f *.cm* *.o *.a ./test/*.cm* ./test/*.o ./test/*.a
