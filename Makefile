build-native:
	@printf "\n\e[31mBuilding tablecloth-native ...\e[0m\n"
	cd native && opam config exec -- dune build
	@printf "\n\e[31mBuilt!\e[0m\n"

build-bs:
	@printf "\n\e[31mBuilding bs ...\e[0m\n"
	cd bs && npm run build
	@printf "\n\e[31mBuilt!\e[0m\n"

build:
	@$(MAKE) build-native
	@$(MAKE) build-bs

test-native:
	@printf "\n\e[31mRunning tablecloth-native tests ...\e[0m\n"
	cd native && opam config exec -- dune runtest -f
	@printf "\n\e[31mTested!\e[0m\n"

test-bs:
	@printf "\n\e[31mRunning tablecloth-bs tests ...\e[0m\n"
	cd bs && npm run test
	@printf "\n\e[31mTested!\e[0m\n"

test:
	@$(MAKE) test-native
	@$(MAKE) test-bs

deps-native:
	@printf "\n\e[31mInstalling native dependencies ...\e[0m\n"
	opam update
	opam install alcotest base dune junit junit_alcotest -y
	@printf "\n\e[31mInstalled!\e[0m\n"

deps-bs:
	@printf "\n\e[31mInstalling bs dependencies ...\e[0m\n"
	cd bs && npm install
	@printf "\n\e[31mInstalled!\e[0m\n"

documentation:
	@printf "\n\e[31mCompiling the documentation ...\e[0m\n"
	opam exec -- dune build @doc
	rm ./docs
	ln -s _build/default/_doc/_html ./docs
	@printf "\n\e[31mCompiled! The docs are now viewable at ./docs/index.html\e[0m\n"

format:
	@fd --extension ml --extension mli | xargs ocamlformat --enable-outside-detected-project --inplace
