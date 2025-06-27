#! /bin/bash

. ../../../.env

CLUSTER=$(cd ..; pwd | sed 's,^.*\/,,')

argocd app sync $CLUSTER-knative

