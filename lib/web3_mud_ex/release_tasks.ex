# Loosely from https://github.com/bitwalker/distillery/blob/master/docs/Running%20Migrations.md
defmodule Web3MUDEx.ReleaseTasks do
  @moduledoc false

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto,
    :ecto_sql,
    :bamboo,
    :ranch,
    :phoenix,
    :gettext
  ]

  @repos [
    Web3MUDEx.Repo
  ]

  def startup() do
    IO.puts("Loading web3_mud_ex...")

    # Load the code for web3_mud_ex, but don't start it
    Application.load(:web3_mud_ex)

    IO.puts("Starting dependencies..")
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for web3_mud_ex
    IO.puts("Starting repos..")
    Enum.each(@repos, & &1.start_link(pool_size: 2))
  end

  def startup_extra() do
    {:ok, _pid} = Web.Endpoint.start_link()
    {:ok, _pid} = Web3MUDEx.Config.Cache.start_link([])
  end
end

defmodule Web3MUDEx.ReleaseTasks.Migrate do
  @moduledoc """
  Migrate the database
  """

  alias Web3MUDEx.ReleaseTasks
  alias Web3MUDEx.Repo

  @apps [
    :web3_mud_ex
  ]

  @doc """
  Migrate the database
  """
  def run() do
    ReleaseTasks.startup()
    Enum.each(@apps, &run_migrations_for/1)
    IO.puts("Success!")
  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(app) do
    IO.puts("Running migrations for #{app}")
    Ecto.Migrator.run(Repo, migrations_path(app), :up, all: true)
  end

  defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])
end

defmodule Web3MUDEx.ReleaseTasks.Seeds do
  @moduledoc """
  Seed the database

  NOTE: This should only be used in docker compose
  """

  alias Web3MUDEx.ReleaseTasks

  @apps [
    :web3_mud_ex
  ]

  @doc """
  Migrate the database
  """
  def run() do
    ReleaseTasks.startup()
    ReleaseTasks.startup_extra()
    Enum.each(@apps, &run_seeds_for/1)
    IO.puts("Success!")
  end

  def priv_dir(app), do: :code.priv_dir(app)

  defp run_seeds_for(app) do
    # Run the seed script if it exists
    seed_script = seeds_path(app)

    if File.exists?(seed_script) do
      IO.puts("Running seed script..")
      Code.eval_file(seed_script)
    end
  end

  defp seeds_path(app), do: Path.join([priv_dir(app), "repo", "seeds.exs"])
end
