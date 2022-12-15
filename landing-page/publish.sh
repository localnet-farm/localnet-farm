#! /bin/bash

export AWS_PROFILE=localnet_farm

aws s3 cp index.html s3://localnet-farm-landing-page/
aws s3 sync fonts s3://localnet-farm-landing-page/fonts
