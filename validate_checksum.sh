#!/bin/bash

if [[ -z "${BITCOIN_IMAGE_SHA:-}" ]]; then
  echo "BITCOIN_IMAGE_SHA env variable not set"
  exit 1
fi

CHECKSUM=$(docker image ls --digests --format '{{.Digest}}' ruimarinho/bitcoin-core)
if [[ "${BITCOIN_IMAGE_SHA}" != "${CHECKSUM}" ]]; then
  echo "Bitcoin image checksum do not match"
  exit 1
fi
