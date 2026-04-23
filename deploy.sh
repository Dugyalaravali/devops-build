#!/bin/bash

# These variables make the script flexible
IMAGE_NAME=$1
DOCKERHUB_USER=$2
TAG=$3
DOCKER_PASS=$4

# 1. Login to DockerHub (Required for the Private Prod repo)
echo "$DOCKER_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin

# 2. Pull the latest image
docker pull "$DOCKERHUB_USER/$IMAGE_NAME:$TAG"

# 3. Clean up ANY container using port 80 to avoid the "Bind failed" error
# We remove 'myapp' (from your script) and 'my-react-app-prod' (from Jenkins)
docker rm -f myapp my-react-app-prod || true

# 4. Run the new container
docker run -d -p 80:80 --name my-react-app-prod "$DOCKERHUB_USER/$IMAGE_NAME:$TAG"
