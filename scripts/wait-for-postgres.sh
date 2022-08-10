#!/bin/sh
# wait-for-postgres.sh

set -e
until PGPASSWORD=$POSTGRES_PASSWORD psql -h "$HOST" -U "postgres" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 3
done

>&2 echo "Postgres is up - executing command"
exec "$@"