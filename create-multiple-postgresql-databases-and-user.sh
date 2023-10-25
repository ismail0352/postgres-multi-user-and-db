#!/bin/bash

set -e
set -u
# set -x

POSTGRES_USER="${POSTGRES_USER:-postgres}"

function create_user_and_database() {
	local owner=$(echo $1 | tr ',' ' ' | awk  '{print $1}')
	local database=$(echo $1 | tr ',' ' ' | awk  '{print $2}')
	echo "  Creating user '$owner' and database '$database'"

    psql -U postgres -tc "SELECT 1 FROM pg_user WHERE usename = '$owner'" | grep -q 1 || psql -U postgres -c "CREATE USER $owner WITH LOGIN SUPERUSER CREATEDB CREATEROLE;"
	
    psql -U postgres -tc "SELECT 1 FROM pg_database WHERE datname = '$database'" | grep -q 1 || psql -U postgres -c "CREATE DATABASE $database"
    
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	    GRANT ALL PRIVILEGES ON DATABASE $database TO $owner;
EOSQL
}

if [ -n "$POSTGRES_MULTIPLE_USERS_AND_DATABASES" ]; then
	echo "Multiple database/user creation requested: $POSTGRES_MULTIPLE_USERS_AND_DATABASES"
	for details in $(echo $POSTGRES_MULTIPLE_USERS_AND_DATABASES | tr ':' ' '); do
		create_user_and_database $details
	done
	echo "Multiple databases created"
fi
