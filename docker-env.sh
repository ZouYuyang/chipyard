export IMG_NAME="hw-env"
export CONTAINER_NAME="hw-env"
export MOUNT_FILE="mount.json"
export EXTRA_ARGS="--network host --restart=always"

docker_restart() {
  docker restart $CONTAINER_NAME
}

docker_attach() {
  docker attach $CONTAINER_NAME
}