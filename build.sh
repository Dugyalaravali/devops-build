#!/bin/bash

IMAGE_NAME=my-react-app
DOCKERHUB_USER=yourusername
TAG=dev

docker build -t $DOCKERHUB_USER/$IMAGE_NAME:$TAG .
docker push $DOCKERHUB_USER/$IMAGE_NAME:$TAG
