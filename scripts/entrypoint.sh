#!/bin/bash
# entrypoint.sh

set -e

source /scripts/wait-for-postgres.sh

/usr/local/bin/joule admin initialize --dsn joule:heila@localhost:5432/jouledb
/usr/local/bin/joule admin authorize
service joule restart
