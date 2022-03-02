FROM node:16.14.0-bullseye-slim
LABEL maintainer="Takashi Makimoto <mackie@beehive-dev.com>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG USER=user
ARG GROUP=user
ARG PASS=password
ARG UID=1000
ARG GID=1000

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=nointeractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    git-lfs \
    openssh-client \
    sudo \
    wget && \
  userdel -r node && \
  groupadd -g "${GID}" "${GROUP}" && \
  useradd -m -s /usr/bin/zsh -u "${UID}" -g "${GID}" "${USER}" && \
  usermod -aG sudo "${USER}" && \
  echo "${USER}:${PASS}" | chpasswd && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

USER "${USER}"
WORKDIR "/home/${USER}"

ENV SHELL=/usr/bin/bash

RUN \
  mkdir -p .config .cache .local/share workspace

ENTRYPOINT ["bash"]
