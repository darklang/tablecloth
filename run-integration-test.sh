#!/usr/bin/env bash

set -euo pipefail
set -x

pushd integration-test/native
echo -e "\n\e[31mBuilding tablecloth-native integration test\e[0m"
dune build main.exe
echo -e "\n\e[31mRunning compiled file\e[0m"
_build/default/main.exe
popd

echo -e "\n\e[31mBuilding tablecloth-bucklescript integration test\e[0m"
pushd integration-test/bs
npm run build
echo -e "\n\e[31mRunning generated js\e[0m"
node src/demo.bs.js
popd
