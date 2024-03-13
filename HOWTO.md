# HOW TO

First, copy the `.env.*.example` files, creating new ones by removing the `.example` part of their names:
```bash
cp .env.api.example .env.api
```

```bash
cp .env.postgres.example .env.postgres
```

Then fill in the newly created files with the desired configurations.


Now, follow the instructions according to your environment:
- [Docker only](#docker-only)
  - [Create the network](#create-the-network-for-the-services)
  - [Build the api image](#build-the-api-image)
  - [Start the containers](#start-the-containers)
    - [Database](#the-database-one)
    - [API](#the-api-one)
  - [Populate](#populate)
  - [Tests](#tests-with-docker)
- [Docker Compose](#docker-compose)
  - [Start the services](#start-the-services-with-docker-compose)
  - [Populate](#populate-the-initial-data-with-docker-compose)
  - [Tests](#tests-with-docker-compose)

## Docker Only

#### Create the network for the services:
```bash
docker network create labs
```

#### Build the api image:
```bash
docker build --tag labs_api --file Dockerfile.api .
```

**Do notice the trailing period in the above command**

#### Start the containers:
###### The database one:
```bash
docker run --detach \
  --env-file .env.postgres \
  --name postgres_db \
  --network labs \
  --restart always \
  --volume $(pwd)/sql_scripts/:/docker-entrypoint-initdb.d/ \
  --volume $(pwd)/.pg_data:/var/lib/postgresql/data \
  postgres:16
```

**NOTE:** the `postgres_db` value informed here for the `--name` option ***MUST BE*** the same name configured in the `.env.api` file for the `DB_HOST` option. So, if you changed it in the `.env.api` file, make sure you change here as well to whatever you configured there : )

###### The api one:
```bash
docker run --detach \
  --env-file .env.api \
  --publish 10000:10000 \
  --name labs_api \
  --network labs \
  --restart always \
  --volume $(pwd)/src/:/app \
  --volume $(pwd)/sample/data.csv:/app/sample/data.csv \
  labs_api
```

#### Populate
With both containers up and running, you can populate the initial data as follow:
```bash
docker exec labs_api ruby import_from_csv.rb
```

#### Tests with docker
Create a new network
```bash
docker network create labs_tests
```

Build the api tests server image:
```bash
docker build --tag labs_api_tests --file Dockerfile.api.tests .
```

Start the tests database:
```bash
docker run --detach \
  --env-file .env.postgres \
  --name postgres_tests_db \
  --network labs_tests \
  --restart always \
  --volume $(pwd)/sql_scripts/:/docker-entrypoint-initdb.d/ \
  postgres:16
```

Start the tests server:
```bash
docker run --detach \
  --env-file .env.api \
  --env DB_HOST=postgres_tests_db \
  --name labs_api_tests_server \
  --network labs_tests \
  --restart always \
  --volume $(pwd)/src/:/app \
  labs_api_tests
```

Run the tests:
```bash
docker exec labs_api_tests_server rspec
```


## Docker Compose

*Hint*: there's a `dev` service which restarts the server whenever it detects a change. Use either one of them, but only one at a time

#### Start the services with docker compose:
```bash
docker-compose up -d api
```

#### Populate the initial data with docker compose:
```bash
docker-compose exec api ruby import_from_csv.rb
```

#### Tests with docker compose
Start the `api_tests_server` service:
```bash
docker-compose up -d api_tests_server
```

Run the tests:
```bash
docker-compose exec api_tests_server rspec
```
