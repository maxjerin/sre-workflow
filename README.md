# sre-workflow
Generic SRE workflow for a resource

## Kubernetes
* I've leveraged Helm templates to generate resources for kubernetes
* Service can be deployed either using helm or kubectl

# Docker Workflow
* Passing job: https://github.com/maxjerin/sre-workflow/actions/runs/3191287055/jobs/5207416551
Uploaded image: https://hub.docker.com/r/maxjerin/sre-workflow


## Pre-requisite
* python
* jq
* Homebrew
* minikube
* helm

## Caveats
* Certs would be ideally be injected from something like SecretsManager or Hashicorp Vault
