FROM node:26.10-bookworm-slim

ARG PI_VERSION=latest
ARG USER_UID=1000
ARG USER_GID=1000

RUN apt-get update \
  && apt-get install -y --no-install-recommends bash ca-certificates git ripgrep curl \
  && rm -rf /var/lib/apt/lists/*

    RUN userdel -r node 2>/dev/null || true \
      && groupadd --gid ${USER_GID} pi \
      && useradd --uid ${USER_UID} --gid ${USER_GID} --create-home --shell /bin/bash pi

RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent@${PI_VERSION}

RUN mkdir -p /workspace /home/pi/.pi/agent \
  && chown -R pi:pi /workspace /home/pi/.pi

USER pi
ENV HOME=/home/pi
WORKDIR /workspace
ENTRYPOINT ["pi"]
