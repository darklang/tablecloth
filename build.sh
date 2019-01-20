#!/usr/bin/env bash

set -euo pipefail

pushd native
dune build
cd ../test-native
dune runtest
popd

pushd bs
npm run build
npm run test
popd
