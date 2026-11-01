# Sandboxed Pi

A small Docker image for [Pi](https://pi.dev/) and a script that runs it in any project folder.

## Motivation

I'm not interested in agentic coding (at least yet), but I've been watching how people use these tools. One use case I wanted to try was learning with agents on top of tools like Obsidian. Pi has been praised for a while and it seems like a really good fit if like me you don't want to commit to a single AI provider and also want to experiment with local LLMs or other AI models like [Jev](https://github.com/jaredpalmer/kev).

But giving an AI agent control over my computer was a risk I wanted to minimize as much as possible, so I built a small Docker image that limits what Pi can touch to the project folder I launch it from (plus my Pi config). The script is a thin wrapper you can put somewhere on your `PATH` (for example `~/.local/bin`) and run like you would run `pi`.

For more information about running Pi in a sandbox, check this part of the [documentation](https://pi.dev/docs/latest/containerization).

## Build

```sh
docker build -t pi-agent:local \
  --build-arg USER_UID=$(id -u) --build-arg USER_GID=$(id -g) .
```

On top of the Debian base and Pi itself, the image installs Node, a minimal Rust toolchain (with `clippy`, `rustfmt` and `rust-analyzer`) and a current CPython via `uv`, all owned by the unprivileged `pi` user. The build args default to `1000:1000`; pass your own as above if `id -u` says something else, otherwise files the agent writes into your project will belong to a stranger on the host.

## Run

Put the wrapper on your `PATH` as `pi` and use it exactly like `pi`:

```sh
install -m 755 pi-sandbox.sh ~/.local/bin/pi
cd ~/vault && pi
```

Arguments are forwarded, so `pi --version` or `pi -c` work as usual. The wrapper refuses to start from your home directory or `/`, then mounts the current folder at `/workspace` and your Pi config at `/home/pi/.pi` — nothing else from your machine is visible to the agent.
