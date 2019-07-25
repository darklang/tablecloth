build-native:
	echo -e "\n\e[31mBuilding tablecloth-native ...\e[0m"
	cd native && dune build
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
	cd native && dune runtest -f
	echo -e "\n\e[31mTested!\e[0m"

test-bs:
	echo -e "\n\e[31mRunning tablecloth-bs tests ...\e[0m"
	cd bs && npm run test
	echo -e "\n\e[31mTested!\e[0m"

test:
	@$(MAKE) test-native 
	@$(MAKE) test-bs

docs:
	echo -e "\n\e[31mCompiling the documentation ...\e[0m"
	dune build @doc
	echo -e "\n\e[31mCompiled! The docs are now viewable at _build/default/_doc/_html/index.html\e[0m"

