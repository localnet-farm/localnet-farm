#! /bin/bash

set -euo pipefail

mkdir -p tmp

kustomize build . > ./tmp/build.yaml
