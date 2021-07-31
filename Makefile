ifndef TC_NATIVE_OCAML_SWITCH
	TC_NATIVE_OCAML_SWITCH := 4.10.0
endif

ifndef TC_BASE_VERSION
	TC_BASE_VERSION := v0.13.2
endif


ifndef TC_RESCRIPT_VERSION
	TC_RESCRIPT_VERSION := 9.1.4
endif

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
		node main.bs.js

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
	opam install alcotest base.${TC_BASE_VERSION} dune junit junit_alcotest odoc reason -y
	@printf "\n\e[31mInstalled!\e[0m\n"

deps-rescript:
	@printf "\n\e[31mInstalling rescript dependencies ...\e[0m\n"
	npm install --only=dev rescript@${TC_RESCRIPT_VERSION}
	npm install
	@printf "\n\e[31mInstalled!\e[0m\n"

documentation:
	@printf "\n\e[31mCompiling the documentation ...\e[0m\n"
	opam exec -- dune build @doc
	rm -rf ./docs
	ln -s _build/default/_doc/_html ./docs
	@printf "\n\e[31mCompiled! The docs are now viewable at ./docs/index.html\e[0m\n"

.PHONY: check-format format
check-format:
	opam config exec -- dune build @fmt

format:
	opam config exec -- dune build @fmt --auto-promote
