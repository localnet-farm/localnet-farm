#! /bin/sh

CLUSTER=$1
if [ -z "$CLUSTER" ]; then
  echo Need cluster
  exit 1
fi

kubectl --context $CLUSTER -n cert-manager get secret prod-route53-credentials-secret -o yaml
