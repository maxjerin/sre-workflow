#!/bin/bash

rm -rf ./helm/bitcoin-core/rendered
rm -f ./kubernetes/*.* -f

helm template \
    -f ./helm/bitcoin-core/values.yaml \
    bitcoin-core \
    ./helm/bitcoin-core \
    --output-dir ./helm/bitcoin-core/rendered

cp ./helm/bitcoin-core/rendered/bitcoin-core/templates/*.* ./kubernetes/
