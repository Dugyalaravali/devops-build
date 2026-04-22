#!/bin/bash
# Basic deployment via Docker (assuming Docker is installed on the target server)
IMAGE=$1
CONTAINER_NAME="web-app"

docker pull $IMAGE
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true
docker run -d --name $CONTAINER_NAME -p 80:80 $IMAGE
