FROM postgres:12.16

COPY create-multiple-postgresql-databases-and-user.sh /docker-entrypoint-initdb.d/
