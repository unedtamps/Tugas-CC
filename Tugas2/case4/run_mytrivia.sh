#!/bin/bash

IMAGE_NAME="golang:alpine"
CONTAINER_NAME="triva-docker"
LOCAL_VOLUME="$(pwd)/web"
CONTAINER_VOLUME="/app"
NETWORK_NAME=trivia_network
ENV_VARS="-e DB_NAME=trivia_db -e DB_HOST=postgres_trivia -e DB_USERNAME=postgres -e DB_PASSWORD=pass"
mkdir -p "$LOCAL_VOLUME"
WEB_PORT=8000

echo "Creating and starting container $CONTAINER_NAME..."
docker container run \
  -dit \
  --name "$CONTAINER_NAME" \
  $ENV_VARS \
  --network "$NETWORK_NAME" \
  -v "$LOCAL_VOLUME:$CONTAINER_VOLUME" \
  -w "$CONTAINER_VOLUME" \
  -p $WEB_PORT:8000 \
  "$IMAGE_NAME" \
  sh -c "go mod tidy && go run main.go"
