#!/bin/bash

# Do not allow error to occur
set -e

FILE=./data/persist/postgres
if test -f "$FILE"; then
  echo "The postgres password is able to be updated"
  
  # Ask for the admin password for the postgres sql server without echoing it to the world
  echo -n Password: 
  read -s password
  echo -n ${password} | base64 > $FILE
else 
  echo "The file we were expecting at ${FILE} doesn't exist have you ran the create_postgres script?"
file
