#! /bin/bash

CLUSTER=$(pwd | sed 's,^.*\/,,')
IP=$(./get-ip.sh)

echo IP: $IP

export AWS_PROFILE=localnet_farm

HOSTED_ZONE_ID=Z0936625SVJ16SI3AHDI

JSON="$(cat <<EOF
    {
      "Changes": [
        {
          "Action": "UPSERT",
          "ResourceRecordSet": {
            "Name": "$CLUSTER.localnet.farm",
            "Type": "A",
            "TTL": 30,
            "ResourceRecords": [
              {
                "Value": "$IP"
              }
            ]
          }
        },
        {
          "Action": "UPSERT",
          "ResourceRecordSet": {
            "Name": "*.minikube2.localnet.farm",
            "Type": "A",
            "TTL": 30,
            "ResourceRecords": [
              {
                "Value": "$IP"
              }
            ]
          }
        }
      ]
    }
EOF
)"

echo $JSON
aws route53 change-resource-record-sets \
  --hosted-zone-id $HOSTED_ZONE_ID \
  --change-batch "$JSON" | cat
