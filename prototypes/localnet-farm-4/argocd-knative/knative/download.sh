#! /bin/bash

wget -r https://github.com/knative/serving/releases/download/knative-v1.10.1/serving-crds.yaml

wget -r https://github.com/knative/serving/releases/download/knative-v1.10.1/serving-core.yaml

wget -r https://github.com/knative/net-kourier/releases/download/knative-v1.10.0/kourier.yaml

wget -r https://github.com/knative/net-contour/releases/download/knative-v1.12.1/contour.yaml

wget -r https://github.com/knative/net-contour/releases/download/knative-v1.12.1/net-contour.yaml
