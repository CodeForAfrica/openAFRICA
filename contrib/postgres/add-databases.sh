#!/bin/bash

set -e
set -u

function create_user_and_database() {
	local database=$(echo $1 | tr ':' ' ' | awk  '{print $1}')
	local owner=$(echo $1 | tr ':' ' ' | awk  '{print $2}')
	echo "  Creating user and database '$database'"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
		DO
		\$do\$
		BEGIN
		IF NOT EXISTS (
			SELECT                       -- SELECT list can stay empty for this
			FROM   pg_catalog.pg_roles
			WHERE  rolname = '$owner') THEN

			CREATE ROLE $owner LOGIN PASSWORD '$POSTGRES_PASSWORD';
		END IF;
		END
		\$do\$;
	    CREATE DATABASE $database;
	    GRANT ALL PRIVILEGES ON DATABASE $database TO $owner;
		GRANT ALL PRIVILEGES ON DATABASE $database TO $POSTGRES_USER;
EOSQL
}

if [ -n "$POSTGRES_ADD_DATABASES" ]; then
	echo "Multiple database creation requested: $POSTGRES_ADD_DATABASES"
	for db in $(echo $POSTGRES_ADD_DATABASES | tr ',' ' '); do
		create_user_and_database $db
	done
	echo "Multiple databases created"
fi