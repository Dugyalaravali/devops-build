#!/bin/bash
IMAGE_NAME=$1
TAG=$2

echo "Building Docker image: $IMAGE_NAME:$TAG"
docker build -t $IMAGE_NAME:$TAG .
