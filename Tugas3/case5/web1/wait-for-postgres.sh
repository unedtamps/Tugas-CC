#!/bin/sh
# wait-for-postgres.sh

set -e

host="$DB_HOST"
port=5432

echo "Waiting for PostgreSQL at $host:$port..."

while ! nc -z "$host" "$port"; do
  echo "Postgres is unavailable - sleeping"
  sleep 3
done

echo "Postgres is up - executing command"
exec "$@"
