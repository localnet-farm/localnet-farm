#! /bin/bash

CLUSTER=$(pwd | sed 's,^.*\/,,')
EXTERNAL_IP=$(kubectl --context $CLUSTER get no -o jsonpath="{.items[0].status.addresses[?(@.type=='ExternalIP')].address}")
echo $EXTERNAL_IP

