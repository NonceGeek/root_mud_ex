# Web3MUDEx

![Main](https://github.com/oestrich/web3_mud_ex/workflows/Main/badge.svg)
[![Discord](https://img.shields.io/badge/chat-discord-7289da.svg)][discord]
[![Patreon](https://img.shields.io/badge/support-patreon-F96854.svg)](https://www.patreon.com/ericoestrich)

> **NOTE** This branch is the complete rewrite of Web3MUDEx using [Kalevala](https://github.com/oestrich/kalevala) under the hood. Everything from the previous codebase is tossed out to start over again. If you're interested in something that's working _now_, please check out the [main](https://github.com/oestrich/web3_mud_ex/tree/main) branch.

<img src="https://raw.githubusercontent.com/oestrich/web3_mud_ex/main/docs/images/exventure.png" alt="Web3MUDEx Logo" width="200" />

A web3 MUD Framework based on Sui Netowork, gen MUD Space by Github Organiazation automatically, forked from `ex_venture`.

## Requirements

- PostgreSQL 12+
- Elixir 1.10+
- Erlang 22+
- node.js 12+

## Setup

```bash
mix deps.get
npm install -g yarn
(cd assets && yarn install)
mix ecto.reset
mix phx.server
```

## Kalevala

<img src="https://kalevala.dev/kalevala.png" alt="Kalevala Logo" width="400" />

Kalevala is a new underlying framework that Web3MUDEx is using under the hood. Kalevala sets up a common framework for dealing with commands, characters, views, and is all around a lot better to deal with than the previous version of Web3MUDEx.

## Running Tests

```bash
MIX_ENV=test mix ecto.create
MIX_ENV=test mix ecto.migrate
mix test
```

## Docker locally

Docker is set up as a replication of production. This generates an erlang release and is not intended for development purposes.

```bash
docker-compose pull
docker-compose build
docker-compose up -d postgres
docker-compose run --rm app eval "Web3MUDEx.ReleaseTasks.Migrate.run()"
docker-compose up app
```

You now can view `http://localhost:4000` and access the application.

[discord]: https://discord.gg/GPEa6dB
