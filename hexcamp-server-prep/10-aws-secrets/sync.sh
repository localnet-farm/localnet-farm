#! /bin/bash

CLUSTER=$1
if [ -z "$CLUSTER" ]; then
  echo Need cluster
  exit 1
fi

argocd app sync $CLUSTER-aws-secrets-route53

