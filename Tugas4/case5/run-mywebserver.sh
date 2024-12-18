#!/bin/bash

IMAGE_NAME="mywebserver:3.0"
CONTAINER_NAME="library-docker"
NETWORK_NAME="library-network"
ENV_VARS="-e DB_NAME=library_db -e DB_HOST=postgres_library -e DB_USERNAME=postgres -e DB_PASSWORD=pass"
WEB_PORT=8000

echo "Creating and starting container $CONTAINER_NAME..."
docker container run \
  -dit \
  --name "$CONTAINER_NAME" \
  $ENV_VARS \
  --network "$NETWORK_NAME" \
  -p $WEB_PORT:443 \
  -p 9000:9000 \
  "$IMAGE_NAME"
