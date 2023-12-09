# RootMUDEx

RootMUDEx, including 2 parts: `rootMUD Engine` & `rootMUD Creator`,

* `rootMUD Engine`: AI-based Game Engine focusing on TEXT, powered by [Movespace](https://github.com/NonceGeek/awesome-movespace).

* `rootMUD Creator`: based on `rootMUD Engine`, create MUD world for communities.
> **NOTE** forked from `ex_venture`.

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
