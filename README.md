# Sandboxed Pi

A small Docker image for [Pi](https://pi.dev/) and a script that runs it in any project folder.

## Motivation

I'm not interested in agentic coding (at least yet), but I've been watching how people use these tools. One use case I wanted to try was learning with agents on top of tools like Obsidian. Pi has been praised for a while and it seems like a really good fit if like me you don't want to commit to a single AI provider and also want to experiment with local LLMs or other AI models like [Jev](https://github.com/jaredpalmer/kev).

But giving an AI agent control over my computer was a risk I wanted to minimize as much as possible, so I built a small Docker image that limits what Pi can touch to the project folder I launch it from (plus my Pi config). The script is a thin wrapper you can put somewhere on your `PATH` (for example `~/.local/bin`) and run like you would run `pi`.

For more information about running Pi in a sandbox, check this part of the [documentation](https://pi.dev/docs/latest/containerization).
