#!/bin/bash

# Don't allow errors to occur
set -e 

# If the volume path is passed in use it 
if [ -n "$1" ]; then 
  VOLUME_PATH=$1
else
  VOLUME_PATH="./data/postgres"
fi

# Pull the latest version of the postgres server to the local machine
docker pull postgres

#Run the postgres server container 
FILE=./data/persist/postgres
if test -f "$FILE"; then
  echo "This container has already been launched so we don't need to override the password"
  # The password isn't really needed here as we are using the persisted data but the container won't launch without it
  docker run --name postgres -v ./data/postgres:/var/lib/postgresql/data -e POSTGRES_PASSWORD=$(echo -n ${POSTGRES_PASSWORD} | base64 -d) -p 5432:5432 -d postgres
else
  echo "Initial container run so we will need to set the password" 
  # Ask for the admin password for the postgres sql server without echoing it to the world 
  echo -n Password: 
  read -s password
  echo
  mkdir -p ./data/postgres
  docker run --name postgres -e POSTGRES_PASSWORD=${password} -v ./data/postgres:/var/lib/postgresql/data -p 5432:5432 -d postgres
  touch ${FILE}
  echo -n ${password} | base64 > $FILE
fi

POSTGRES_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' postgres)
echo "postgres is now running at ${POSTGRES_IP}"