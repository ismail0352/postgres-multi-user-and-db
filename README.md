# Using multiple users and databases with the official PostgreSQL Docker image

The [official recommendation](https://hub.docker.com/_/postgres/):

*If you would like to do additional initialization in an image derived from
this one, add one or more `*.sql`, `*.sql.gz`, or `*.sh` scripts under
`/docker-entrypoint-initdb.d` (creating the directory if necessary). After the
entrypoint calls `initdb` to create the default `postgres` user and database,
it will run any `*.sql` files and source any `*.sh` scripts found in that
directory to do further initialization before starting the service.*

This directory contains a script to create multiple databases using that
mechanism.

## Usage

### By mounting a volume

Clone the repository, mount its directory as a volume into
`/docker-entrypoint-initdb.d` and declare database names separated by commas in
`POSTGRES_MULTIPLE_USERS_AND_DATABASES` environment variable as follows
(`docker-compose` syntax):

    postgres:
        image: ismail0352/postgres-multi-user-and-db
        ports:
            - "5432"
        environment:
            # # Syntax for multiple users and multiple DB's
            # # - POSTGRES_MULTIPLE_USERS_AND_DATABASES="ownerOfDB1,DB1: ownerOfDB2,DB2: ...ownerOfDB(n), DB(n)"
            POSTGRES_MULTIPLE_USERS_AND_DATABASES: "my_user,my_DB: your_user,your_DB" 

### Non-standard database names

If you need to use non-standard database names (hyphens, uppercase letters etc), quote them in `POSTGRES_MULTIPLE_USERS_AND_DATABASES`:

        environment:
            - POSTGRES_MULTIPLE_USERS_AND_DATABASES="ownerOfDB1","DB1": "ownerOfDB2","DB2": ..."ownerOfDB(n), "DB(n)""
