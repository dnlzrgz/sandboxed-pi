ARG UV_VERSION=latest
FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv
FROM node:26.12.1-bookworm-slim

ARG RUST_TOOLCHAIN=stable
ARG PI_VERSION=1.4.0
ARG USER_UID=1000
ARG USER_GID=1000

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
     bash ca-certificates git ripgrep curl \
     build-essential pkg-config libssl-dev \
     jq less \
  && rm -rf /var/lib/apt/lists/*

COPY --from=uv /uv /uvx /usr/local/bin/

RUN userdel -r node 2>/dev/null || true \
    && groupadd --gid ${USER_GID} pi \
    && useradd --uid ${USER_UID} --gid ${USER_GID} --create-home --shell /bin/bash pi

RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent@${PI_VERSION}

RUN mkdir -p /workspace /home/pi/.pi/agent \
  && chown -R pi:pi /workspace /home/pi/.pi

USER pi
ENV HOME=/home/pi \
    RUSTUP_HOME=/home/pi/.rustup \
    CARGO_HOME=/home/pi/.cargo \
    PATH=/home/pi/.cargo/bin:${PATH}

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
        | sh -s -- -y --profile minimal --default-toolchain ${RUST_TOOLCHAIN} \
            -c clippy -c rustfmt -c rust-analyzer

WORKDIR /workspace
ENTRYPOINT ["pi"]
