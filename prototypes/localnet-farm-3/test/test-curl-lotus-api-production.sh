#! /bin/bash

URL=https://gw-3.localnet.farm

set -x
curl -v -X POST   -H "Content-Type: application/json"   --data '{ 
      "jsonrpc": "2.0", 
      "method": "Filecoin.Version", 
      "params": [], 
      "id": 1 
    }'  $URL/rpc/v0 


