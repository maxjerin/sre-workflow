ifneq (,$(wildcard ./.env))
    include .env
    export
endif

.PHONY: script-permissions

script-permissions:
	chmod +x *.sh



.PHONY: remove-docker-image
.PHONY: download-docker-image
.PHONY: validate-docker-image
.PHONY: build-prerequisites
.PHONY: build-docker-image
.PHONY: run-docker-image

remove-docker-image:
	docker image rm ruimarinho/bitcoin-core:${BITCOIN_IMAGE_VERSION}
	docker image rm ${IMAGE_TAG}

download-docker-image:
	docker pull ruimarinho/bitcoin-core:${BITCOIN_IMAGE_VERSION}

validate-docker-image:
	bash -c "./validate_checksum.sh"

build-prerequisites: download-docker-image validate-docker-image script-permissions

build-docker-image: build-prerequisites
	docker build . --build-arg BITCOIN_IMAGE_VERSION=${BITCOIN_IMAGE_VERSION} --tag ${IMAGE_TAG}

run-docker-image: build
	docker run -it --rm ${IMAGE_TAG} \
		-printtoconsole \
		-regtest=1


.PHONY: start-cluster
.PHONY: load-local-images
.PHONY: create-namespace
.PHONY: validate-utilities-installed
.PHONY: generate-resource-templates
.PHONY: deploy-prerequisites
.PHONY: clean-local-helm-deploy
.PHONY: deploy-local-kubectl
.PHONY: clean-local-kubectl-deploy

start-cluster:
	./start_local_cluster.sh

load-local-images:
	minikube image load ${IMAGE_TAG}

create-namespace:
	kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

validate-utilities-installed:
	./validate_utilities_installed.sh

generate-resource-templates:
	./generate-helm-k8s-templates.sh

deploy-prerequisites: validate-utilities-installed generate-resource-templates start-cluster load-local-images create-namespace script-permissions

deploy-local-helm: deploy-prerequisites
	helm install ${HELM_DEPLOY_NAME} ./helm/bitcoin-core

clean-local-helm-deploy:
	helm delete ${HELM_DEPLOY_NAME}

deploy-local-kubectl: deploy-prerequisites
	kubectl apply -f ./kubernetes --recursive

clean-local-kubectl-deploy: deploy-prerequisites
	kubectl delete -f ./kubernetes --recursive
