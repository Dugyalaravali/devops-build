#!/bin/bash

IMAGE_NAME=my-react-app
DOCKERHUB_USER=dugyalaravali28
TAG=dev

docker pull $DOCKERHUB_USER/$IMAGE_NAME:$TAG

docker stop myapp || true
docker rm myapp || true

docker run -d -p 80:80 --name myapp $DOCKERHUB_USER/$IMAGE_NAME:$TAG
