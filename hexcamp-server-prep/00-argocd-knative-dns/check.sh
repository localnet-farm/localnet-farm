#! /bin/sh

CLUSTER=$1
if [ -z "$CLUSTER" ]; then
  echo Need cluster
  exit 1
fi

kubectl --context $CLUSTER -n knative-serving get configmap config-domain -o yaml
