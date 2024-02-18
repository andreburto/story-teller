#!/bin/bash

DOCKER_IMAGE_NAME="python:3.11"
DATE_STR=$(date +%Y%m%d%H%M%S)

cd $(dirname $0)

cd src

rm -rf ./tmp

mkdir -p ./tmp

docker pull $DOCKER_IMAGE_NAME

docker run --rm -v "$PWD":/app -w /app $DOCKER_IMAGE_NAME /bin/sh -c 'pip install -r prod.txt -t /app/tmp'

cp index.py ./tmp/

cd ./tmp

zip -r "../../terraform/index_${DATE_STR}.zip" .

cd ../

rm -Rf ./tmp
