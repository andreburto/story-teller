#!/bin/bash
####################################################################################################
# Build script for AWS Lambda function. This script will create a zip file with the required
# dependencies and the function code. Right now the only dependency is the OpenAI library. The
# script will use a Docker container to install the dependencies and create the zip file.
####################################################################################################

# First step, change to the directory where the script is located.
cd $(dirname $0)

# Variables used in the script.
BASE_DIR=$(pwd)
DOCKER_IMAGE_NAME="python:3.11"
DATE_STR=$(date +%Y%m%d%H%M%S)
SOURCE_DIR="${BASE_DIR}/src"
TERRAFORM_DIR="${BASE_DIR}/terraform"
BUILD_DIR="${SOURCE_DIR}/build"

# Remove the build directory if it exists to prevent any artifacts from a previous build.
if [[ -d $BUILD_DIR ]]; then rm -Rf $BUILD_DIR; fi

# Create the build directory.
mkdir -p $BUILD_DIR

# Pull down the Docker image in a separate step to ensure it's available for the next step.
docker pull $DOCKER_IMAGE_NAME

# Use the Docker container to install the dependencies and copy them to the build directory.
docker run --rm -v $SOURCE_DIR:/app -w /app $DOCKER_IMAGE_NAME /bin/sh -c 'pip install -r prod.txt -t /app/build'

# Copy the function code to the build directory.
cp $SOURCE_DIR/index.py $BUILD_DIR

# Change to the build directory and create the zip file with the dependencies and the function code.
cd $BUILD_DIR

# Right now we can assume that the Terraform directory exists. This step may be removed in the
# when there is an automated deployment process.
zip -r "${TERRAFORM_DIR}/index_${DATE_STR}.zip" .

