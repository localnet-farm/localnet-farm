#! /bin/bash

DEPLOYMENT=$1

if [ -z "$DEPLOYMENT" ]; then
  echo Need deployment name, eg. webhook
  exit 1
fi

./build.sh
cat tmp/build.yaml | yq -y ". | select(.kind == \"Deployment\" and .metadata.name == \"$DEPLOYMENT\") | .spec.template.spec.containers[0]"
