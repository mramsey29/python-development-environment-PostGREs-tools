#!/bin/bash

# Don't allow errors to occur
set -e 

# If the volume path is passed in use it 
if [ -n "$1" ]; then 
  VOLUME_PATH=$1
else
  VOLUME_PATH="./src"
fi

# Build the container for python
docker build -t python_development .

#Run the python container 

docker run --name python3.11_development -v ${VOLUME_PATH}:/app -d python_development -- tail -f /dev/null
echo "python container is now running and ${VOLUME_PATH} is mounted at /app"