#! /bin/bash

EXTERNAL_IP=$(kubectl get no -o jsonpath="{.items[0].status.addresses[?(@.type=='ExternalIP')].address}")
echo External IP: $EXTERNAL_IP

