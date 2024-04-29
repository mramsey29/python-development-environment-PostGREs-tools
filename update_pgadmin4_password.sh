#!/bin/bash

# Do not allow error to occur
set -e

FILE=./data/persist/pgadmin4
if test -f "$FILE"; then
  echo "The pgadmin4 password is able to be updated"
  
  # Ask for the admin password for the pgadmin4 server without echoing it to the world
  echo -n Password: 
  read -s password
  echo -n ${password} | base64 > $FILE
else 
  echo "The file we were expecting at ${FILE} doesn't exist have you ran the create_pgadmin4 script?"
file
