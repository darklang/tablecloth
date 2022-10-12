ifndef TC_NATIVE_OCAML_SWITCH
	TC_NATIVE_OCAML_SWITCH := 4.10.0
endif

ifndef TC_BASE_VERSION
	TC_BASE_VERSION := v0.13.2
endif


ifndef TC_RESCRIPT_VERSION
	TC_RESCRIPT_VERSION := 9.1.4
endif

# We should use something more recent, but opam keeps telling me they don't exist
TC_OCAMLFORMAT_VERSION := 0.19.0

build-native:
	@printf "\n\e[31mBuilding tablecloth-native ...\e[0m\n"
	opam config exec -- dune build
	@printf "\n\e[31mBuilt!\e[0m\n"

build-rescript:
	@printf "\n\e[31mBuilding rescript...\e[0m\n"
	npm run build
	@printf "\n\e[31mBuilt!\e[0m\n"

build:
	@$(MAKE) build-native
	@$(MAKE) build-rescript

watch-native:
	@printf "\n\e[31mBuilding rescript...\e[0m\n"
	opam config exec -- dune build --watch

watch-test-native:
	@printf "\n\e[31mBuilding rescript...\e[0m\n"
	opam config exec -- dune test --watch

watch-rescript:
	@printf "\n\e[31mBuilding rescript...\e[0m\n"
	npm run build:watch

# Not enabled as you need to recompile for this to have any effect, while
# native recompiles automatically.
#watch-test-rescript:
#	@printf "\n\e[31mBuilding rescript...\e[0m\n"
#	npm run test:watch


doc-native:
	@printf "\n\e[31mBuilding native docs ...\e[0m\n"
	opam config exec -- dune build @doc -f
	@printf "\n\e[31mBuilt!\e[0m\n"

doc-rescript:
	@printf "\n\e[31mBuilding rescript docs ...\e[0m\n"
	@printf "\n\e[31mBuilt!\e[0m\n"

doc:
	@$(MAKE) doc-native
	@$(MAKE) doc-rescript

test-native:
	@printf "\n\e[31mRunning tablecloth-native tests ...\e[0m\n"
	opam config exec -- dune runtest -f
	@printf "\n\e[31mTested!\e[0m\n"

test-rescript:
	@printf "\n\e[31mRunning tablecloth-rescript tests ...\e[0m\n"
	npm run test
	@printf "\n\e[31mTested!\e[0m\n"

test:
	@$(MAKE) test-native
	@$(MAKE) test-rescript

integration-test-rescript:
	echo -e "\n\e[31mBuilding rescript integration test\e[0m"
	cd integration-test;\
		npm install;\
		npm run build;\
		echo -e "\n\e[31mRunning generated js\e[0m";\
		node rescript/main.bs.js

integration-test-native:
	echo -e "\n\e[31mBuilding native integration test\e[0m"
	cd integration-test;\
		dune build main.exe;\
		echo -e "\n\e[31mRunning compiled file\e[0m";\
		../_build/default/integration-test/main.exe

deps-native:
	@printf "\n\e[31mInstalling native dependencies ...\e[0m\n"
	opam update
	opam switch set ${TC_NATIVE_OCAML_SWITCH}
	opam install alcotest.1.4.0 base.${TC_BASE_VERSION} dune.2.9.0 junit.2.0.2 junit_alcotest.2.0.2 odoc.1.5.3 reason.3.7.0 -y
	@printf "\n\e[31mInstalled!\e[0m\n"

deps-rescript:
	@printf "\n\e[31mInstalling rescript dependencies ...\e[0m\n"
	npm install --only=dev rescript@${TC_RESCRIPT_VERSION}
	npm install
	@printf "\n\e[31mInstalled!\e[0m\n"

deps-format:
	@printf "\n\e[31mInstalling formatting dependencies ...\e[0m\n"
	opam update
	opam switch set ${TC_NATIVE_OCAML_SWITCH}
	opam install reason.3.7.0 ocamlformat.${TC_OCAMLFORMAT_VERSION} -y
	@printf "\n\e[31mInstalled!\e[0m\n"

all-native: deps-native build-native test-native integration-test-native doc-native
	@printf "\n\e[31mAll done!\e[0m\n"

all-rescript: deps-rescript build-rescript test-rescript integration-test-rescript doc-rescript
	@printf "\n\e[31mAll done!\e[0m\n"


.PHONY: check-format format
check-format:
	opam install ocamlformat.0.19.0 -y
	opam config exec -- dune build @fmt

format:
	opam install ocamlformat.0.19.0 -y
	opam config exec -- dune build @fmt --auto-promote
