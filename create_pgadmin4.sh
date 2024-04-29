#!/bin/bash

# Don't allow errors to occur
set -e 

# If the volume path is passed in use it 
if [ -n "$1" ]; then 
  VOLUME_PATH=$1
else
  VOLUME_PATH="./data/pgadmin4"
fi

# Pull the latest version of the PGAdmin4 server to the local machine
docker pull dpage/pgadmin4

#Run the PGAdmin server container 
FILE=./data/persist/pgadmin4
if test -f "$FILE"; then
  echo "The PGAdmin4 container has already been launched"
  # The password isn't used in this case but we provide it for the container so it doesn't fail
  docker run --name pgadmin4 -p 5050:80 -v ${VOLUME_PATH}:/var/lib/pgadmin -d dpage/pgadmin4
else
  echo "This is the first time pgadmin4 container has been ran locally"
  # Ask for the admin password for the PGAdmin4 server without echoing it to the world
  echo -n Password: 
  read -s password
  echo
  mkdir -p ./data/pgadmin4
  docker run --name pgadmin4 -p 5050:80 -v ${VOLUME_PATH}:/var/lib/pgadmin -e PGADMIN_DEFAULT_EMAIL=user@domain.com -e PGADMIN_DEFAULT_PASSWORD=${password} -d dpage/pgadmin4
  touch ${FILE}
  echo -n ${password} | base64 > $FILE
fi
echo "PGAdmin4 is now running at localhost:5050"