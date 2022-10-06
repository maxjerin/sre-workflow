#!/bin/bash

if ! command -v terraform &> /dev/null; then
    echo "terraform not installed"
    exit 1
fi

if ! command -v localstack &> /dev/null; then
    echo "localstack not installed"
    exit 1
fi

LOCALSTACK_STATUS=$(localstack status docker --format json | jq ".running" -r)
if [[ ${LOCALSTACK_STATUS} != true ]]; then
    echo "Starting localstack"
    localstack start &
    sleep 6
fi

LOCALSTACK_IAM_STATUS=$(localstack status services --format json | jq ".iam" -r)
if [[ ${LOCALSTACK_IAM_STATUS} != "available" ]]; then
    echo "IAM service on localstack not available"
    exit 1
fi

LOCALSTACK_S3_STATUS=$(localstack status services --format json | jq ".s3" -r)
if [[ ${LOCALSTACK_S3_STATUS} != "available" ]]; then
    echo "s3 service on localstack not available"
    exit 1
fi

echo "Applying terraform"
terraform apply -auto-approve

echo "Stoping localstack"
localstack stop
