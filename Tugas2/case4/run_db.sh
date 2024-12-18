#!/bin/bash

NETWORK_NAME=trivia_network
POSTGRES_CONTAINER_NAME="postgres_trivia"
PGADMIN_CONTAINER_NAME="pgadmin_trivia"
NETWORK_NAME="trivia_network"
POSTGRES_IMAGE="postgres:latest"
PGADMIN_IMAGE="dpage/pgadmin4:latest"
POSTGRES_USER="postgres"
POSTGRES_PASSWORD="pass"
POSTGRES_DB="trivia_db"
PGADMIN_EMAIL="unedo@gmail.com"
PGADMIN_PASSWORD="pass"
POSTGRES_PORT=5433
PGADMIN_PORT=5050
POSTGRES_VOLUME="postgres_data"

echo "Creating Docker network $NETWORK_NAME..."
docker network create "$NETWORK_NAME" 2>/dev/null || echo "Network $NETWORK_NAME already exists."

echo "Creating Docker volume $POSTGRES_VOLUME for persistent storage..."
docker volume create "$POSTGRES_VOLUME"

echo "Starting PostgreSQL container..."
docker run -d \
  --name $POSTGRES_CONTAINER_NAME \
  --network $NETWORK_NAME \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_DB=$POSTGRES_DB \
  -p $POSTGRES_PORT:5432 \
  -v $POSTGRES_VOLUME:/var/lib/postgresql/data \
  $POSTGRES_IMAGE

echo "Starting pgAdmin container..."
docker run -d \
  --name $PGADMIN_CONTAINER_NAME \
  --network $NETWORK_NAME \
  -e PGADMIN_DEFAULT_EMAIL=$PGADMIN_EMAIL \
  -e PGADMIN_DEFAULT_PASSWORD=$PGADMIN_PASSWORD \
  -p $PGADMIN_PORT:80 \
  $PGADMIN_IMAGE
