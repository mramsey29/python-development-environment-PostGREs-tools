#!/bin/bash

# Don't allow errors to occur
set -e

# Remove any running containers
echo "Cleaning up running containers"
count=$(docker ps | grep " postgres " | wc -l)
if [[ $count -gt 0 ]]; then
  echo "Removing PostGREs container"
  docker rm -f postgres
fi
count=$(docker ps | grep "pgadmin4" | wc -l)
if [[ $count -gt 0 ]]; then
  echo "Removing pgAdmin4 container"
  docker rm -f pgadmin4
fi
count=$(docker ps | grep "python3.11_development" | wc -l)
if [[ $count -gt 0 ]]; then
  echo "Removing python development container"
  docker rm -f python3.11_development
fi

# Remove the docker image for the python container we build
# Need to allow errors from docker to not interupt script
echo "Cleaning up images"
set +e 
docker image rm python_development > /dev/null 2>&1
# Do not allow errors again
set -e

# Clean up directories in the environment
echo "Cleaning up directories in the environment"

rm -f ./data/persist/*
rm -rf ./data/pgadmin4
rm -rf ./data/postgres

