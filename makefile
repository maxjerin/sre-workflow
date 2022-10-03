ifneq (,$(wildcard ./.env))
    include .env
    export
endif

.PHONY: remove
.PHONY: download
.PHONY: validate
.PHONY: prerequisites

remove:
	docker image rm ruimarinho/bitcoin-core:${BITCOIN_IMAGE_VERSION}

download:
	docker pull ruimarinho/bitcoin-core:${BITCOIN_IMAGE_VERSION}

validate:
	bash -c "./validate_checksum.sh"

prerequisites: download validate

build: prerequisites
	docker build . --build-arg BITCOIN_IMAGE_VERSION=${BITCOIN_IMAGE_VERSION} --tag ${INTERNAL_TAG}

run: build
	docker run -it --rm sre-generic \
		-printtoconsole \
		-regtest=1
