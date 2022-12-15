#! /bin/bash

# https://web.dev/how-to-use-local-https/

http-server -S -C localhost.pem -K localhost-key.pem
