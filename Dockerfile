FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install git and ssh
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openssh-client \
    git \
    ca-certificates \
    curl \
    sudo \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

 WORKDIR /app

 CMD ["/bin/bash"]