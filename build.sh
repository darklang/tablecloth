#!/usr/bin/env bash

set -euo pipefail

echo -e "\n\e[31mBuilding tablecloth-native\e[0m"

pushd native
dune build

echo -e "\n\e[31mRunning tablecloth-native tests\e[0m"
dune runtest -f
popd

echo -e "\n\e[31mBuilding tablecloth-bucklescript\e[0m"
pushd bs
npm run build

echo -e "\n\e[31mRunning tablecloth-bucklescript tests\e[0m"
npm run test
popd
