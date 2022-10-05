# sre-workflow
Generic SRE workflow for a resource

## Pre-requisite
* `python3`
* `jq`
* `minikube`
* `helm`
* `localstack`

## Kubernetes
* I've leveraged Helm templates to generate resources for kubernetes
* Service can be deployed either using helm or kubectl
    * `make deploy-local-helm`
    * Or `make deploy-local-kubectl`
* Cleanup targets for respective deployments are present in Makefile
* The Makefile targets can be used in Github Actions after establishing connection to a Kubernetes cluster.

## Container Image
* Makefile target `make build-docker-image` can be used to build the image locally
* I'm using Github Actions to deploy the image to my person Docker Hub by calling `make publish-docker-image`
    * Passing job: https://github.com/maxjerin/sre-workflow/actions/runs/3191287055/jobs/5207416551
    * Uploaded image: https://hub.docker.com/r/maxjerin/sre-workflow

## Scripting
* `log_aggregation` contains both `bash` and `python` implementation to parse and aggregate IP addresses
* I've used dask with pandas for chunked log parsing in python.

## Terraform
* I applied the terraform to localstack running locally.
    * `terraform init`
    * `terraform plan`
    * `terraform apply` or * `terraform apply -auto-approve`

## Caveats
* Certs would be ideally be injected from something like SecretsManager or Hashicorp Vault
