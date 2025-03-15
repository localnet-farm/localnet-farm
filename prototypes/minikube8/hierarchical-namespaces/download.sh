#! /bin/bash

# Select the latest version of HNC
HNC_VERSION=v1.1.0

# Select the variant of HNC you like. Other than 'default', options include:
# 'hrq': Like default, but with hierarchical quotas.
# 'ha': Like default, but with two deployments: one single-pod for the controller, and one three-pod for the webhooks
# 'default-cm': Like default, but without the built-in cert rotator, and with support for cert-manager
HNC_VARIANT=default

# Install HNC. Afterwards, wait up to 30s for HNC to refresh the certificates on its webhooks.
#kubectl apply -f https://github.com/kubernetes-sigs/hierarchical-namespaces/releases/download/${HNC_VERSION}/${HNC_VARIANT}.yaml 
wget -O hnc.yaml https://github.com/kubernetes-sigs/hierarchical-namespaces/releases/download/${HNC_VERSION}/${HNC_VARIANT}.yaml 
