build-native:
	echo -e "\n\e[31mBuilding tablecloth-native ...\e[0m"
	cd native && opam config exec -- dune build
	echo -e "\n\e[31mBuilt!\e[0m"

build-bs:
	echo -e "\n\e[31mBuilding bs ...\e[0m"
	cd bs && npm run build
	echo -e "\n\e[31mBuilt!\e[0m"

build:
	@$(MAKE) build-native
	@$(MAKE) build-bs

test-native:
	echo -e "\n\e[31mRunning tablecloth-native tests ...\e[0m"
	cd native && opam config exec -- dune runtest -f
	echo -e "\n\e[31mTested!\e[0m"

test-bs:
	echo -e "\n\e[31mRunning tablecloth-bs tests ...\e[0m"
	cd bs && npm run test
	echo -e "\n\e[31mTested!\e[0m"

test:
	@$(MAKE) test-native
	@$(MAKE) test-bs

deps-native:
	echo -e "\n\e[31mInstalling native dependencies ...\e[0m"
	opam update
	opam install alcotest base dune junit junit_alcotest -y
	echo -e "\n\e[31mInstalled!\e[0m"

deps-bs:
	echo -e "\n\e[31mInstalling bs dependencies ...\e[0m"
	cd bs && npm install
	echo -e "\n\e[31mInstalled!\e[0m"

documentation:
	echo -e "\n\e[31mCompiling the documentation ...\e[0m"
	opam exec -- dune build @doc
	rm ./docs
	ln -s _build/default/_doc/_html ./docs
	echo -e "\n\e[31mCompiled! The docs are now viewable at ./docs/index.html\e[0m"
