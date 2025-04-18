#!/bin/bash

docker build -t ykzio-shell-bash .
if [ $? -ne 0 ]; then
    echo "Docker build failed"
    exit 1
fi
docker run --rm -it \
  --volume $HOME/.ssh:/root/.ssh \
  --env GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" \
  ykzio-shell-bash