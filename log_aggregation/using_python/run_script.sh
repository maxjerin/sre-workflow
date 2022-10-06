#!/bin/bash

if ! command -v python3 &> /dev/null; then
    if ! command -v python &> /dev/null; then
        echo "No python or python3 found"
        exit 1
    else
        echo "Using python2"
        PYTHON_BINARY=python
        PIP_BINARY=pip
    fi
else
    echo "Using python3"
    PYTHON_BINARY=python3
    PIP_BINARY=pip3
fi

echo "Create virtualenv"
${PYTHON_BINARY} -m venv venv

echo "Activate virtualenv"
source venv/bin/activate

echo "Install requirements"
${PIP_BINARY} install -r requirements.txt

echo "Running script"
${PYTHON_BINARY} ip_frequency.py
