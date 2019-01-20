#!/usr/bin/env bash

set -euo pipefail

pushd integration-test/native
dune build
popd

pushd integration-test/bs
npm run build
popd
