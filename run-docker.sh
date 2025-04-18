#!/bin/bash

docker build -t ykzio-shell-bash .
if [ $? -ne 0 ]; then
    echo "Docker build failed"
    exit 1
fi
docker run --rm -it \
  -v $HOME/.ssh:/root/.ssh \
  -e GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" \
  ykzio-shell-bash