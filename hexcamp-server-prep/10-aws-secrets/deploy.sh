#! /bin/bash

. ../../.env
. .env

CLUSTER=$1
if [ -z "$CLUSTER" ]; then
  echo Need cluster
  exit 1
fi

echo GITHUB_PAT $GITHUB_PAT

argocd repo add https://github.com/jimpick/localnet-farm.git --username jimpick --password $GITHUB_PAT --upsert

AWS_ROUTE53_ACCESS_KEY_ID_BASE64=$(echo -n $AWS_ROUTE53_ACCESS_KEY_ID | base64)
AWS_ROUTE53_SECRET_ACCESS_KEY_BASE64=$(echo -n $AWS_ROUTE53_SECRET_ACCESS_KEY | base64)

kubectl --context $CLUSTER create ns cert-manager

argocd app create $CLUSTER-aws-secrets-route53 \
  --upsert \
  --repo https://github.com/jimpick/localnet-farm.git \
  --path hexcamp-server-prep/10-aws-secrets \
  --dest-name $CLUSTER \
  --dest-namespace default \
  --jsonnet-tla-str accessKeyId=$AWS_ROUTE53_ACCESS_KEY_ID_BASE64 \
  --jsonnet-tla-str secretAccessKey=$AWS_ROUTE53_SECRET_ACCESS_KEY_BASE64

