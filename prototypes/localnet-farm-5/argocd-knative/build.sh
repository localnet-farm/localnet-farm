#! /bin/bash

mkdir -p tmp

kustomize build . > ./tmp/build.yaml
