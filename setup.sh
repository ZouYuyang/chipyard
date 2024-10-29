#!/bin/bash

# Make sure an image is built according to docker/README.md

source ./docker-env.sh

# use docker/run.sh to run a container

chmod +x docker-utils/run.sh
docker rm -f $CONTAINER_NAME
docker-utils/run.sh run -i $IMG_NAME -c $CONTAINER_NAME -v $MOUNT_FILE -e $EXTRA_ARGS
