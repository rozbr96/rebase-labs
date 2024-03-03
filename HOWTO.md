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
- [Docker Compose](#docker-compose)
  - [Start the services](#start-the-services-with-docker-compose)
  - [Populate](#populate-the-initial-data-with-docker-compose)

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


## Docker Compose

#### Start the services with docker compose:
```bash
docker-compose up --detach
```

#### Populate the initial data with docker compose:
```bash
docker-compose exec api ruby import_from_csv.rb
```
