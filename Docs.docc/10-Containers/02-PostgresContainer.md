# 10.2 Running the Postgres container

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 2

Run a PostgreSQL database container to provide persistent storage for your Swift server application. PostgreSQL serves
as the production-grade relational database that stores your application's data in a structured, reliable format.

## Installing PostgreSQL client tools

First, install the PostgreSQL client tools to interact with your database container. Open a separate Terminal.app tab
and run:

```bash
brew install postgresql
```

This installation provides the `psql` command-line tool, which connects to PostgreSQL databases, executes SQL queries,
and verifies your database connection.

## Starting the PostgreSQL container

Launch a PostgreSQL container using the `container` command provided by Vessel (installed in
<doc:01-InstallingContainers>):

```bash
container run -p 5433:5432 -e POSTGRES_HOST_AUTH_METHOD=trust postgres:16
```

This command performs several operations:

- Maps port 5433 on your host machine to port 5432 inside the container, avoiding conflicts with locally installed
  PostgreSQL.
- Sets `POSTGRES_HOST_AUTH_METHOD=trust` to allow connections without password authentication.
- Pulls and runs the PostgreSQL 16 container image.

> Note: This tutorial uses port 5433 on your host machine to avoid conflicts with PostgreSQL installations from other
> projects. Inside the container, PostgreSQL still runs on its standard port 5432.

Keep this container terminal running throughout your development session. The PostgreSQL database remains available only
while this command executes in the foreground.

The `trust` authentication method allows connections without passwords. Use this configuration only for local development
environments. Production deployments require proper authentication with secure passwords or certificate-based
authentication.

## Verifying the database connection

Open another terminal tab and connect to your PostgreSQL container using the `psql` client:

```bash
psql postgresql://postgres@127.0.0.1:5433
```

This connection string uses `postgres` as the username—the default superuser account created automatically by the
PostgreSQL container image.

A successful connection displays the PostgreSQL prompt, confirming your database container operates correctly. Execute SQL
commands and manage your database schema from this prompt.

You can now close the psql terminal - verification is complete. Keep the **container terminal** (from the previous
section) running - later sections connect to this PostgreSQL database by setting the `ENV` environment variable to
`production`.
