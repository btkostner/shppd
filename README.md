# Shppd

Shppd is a package tracking application that allows users to track their packages from multiple carriers in one place. The application is built using Elixir and Phoenix.

This service has a couple of unique features:

- It's self hostable and open source
- It's written in Elixir and Phoenix LiveView
- It's designed to be easily extensible to support new carriers
- It uses Phoenix LiveView Native for native desktop and mobile applications

## Running

The easiest way to run Shppd is to use Docker. You can run the following command to start the application:

```sh
docker run \
    --env DATABASE_PATH=/database.sql \
    --env HOST=localhost \
    --env PORT=4000 \
    --env SECRET_KEY_BASE=$(openssl rand -hex 64) \
    --publish 4000:4000 \
    ghcr.io/btkostner/shppd:latest
```

For more information, see the [running documentation](https://documentation.shppd.app/running) and the individual service setup documentation.

## Development

Shppd is written in Elixir. You'll need to ensure you have Elixir and Erlang installed. You can install Elixir using the [official installation guide](https://elixir-lang.org/install.html).

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
