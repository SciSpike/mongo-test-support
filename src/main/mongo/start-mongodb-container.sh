#!/bin/bash

THIS_DIR="$(cd "$(dirname "$0")"; pwd)"

DEFAULT_CONTAINER="$(cat "$THIS_DIR/default-mongo-test-container")"
CONTAINER="${1:-$DEFAULT_CONTAINER}"

DEFAULT_PORT="$(cat "$THIS_DIR/default-mongo-test-port")"
PORT=${2:-$DEFAULT_PORT}

RUNNING=$(docker inspect --format="{{ .State.Running }}" "$CONTAINER" 2> /dev/null)

if [ $? -eq 1 ] || [ "$RUNNING" == "false" ]; then
  echo "container '$CONTAINER' does not exist or is stopped - recreating"
  # make sure it's gone
  docker ps -a | grep "$CONTAINER" | awk '{ print $1}' | xargs docker rm --force

  docker run --name "$CONTAINER" -p $PORT:27017 -d mongo
fi
