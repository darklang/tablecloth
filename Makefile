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