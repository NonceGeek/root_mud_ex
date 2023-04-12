defmodule Web3MudExExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :web3_mud_ex_example,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      xref: [exclude: IEx.Helpers],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Web3MudExExample.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bcrypt_elixir, "~> 2.3"},
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false},
      {:elias, "~> 0.2"},
      {:kalevala, path: "../"},
      {:plug_cowboy, "~> 2.2"},
      {:ranch, "~> 1.7"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_metrics_prometheus, "~> 0.3"},
      {:telemetry_poller, "~> 0.4"},
      {:web3_move_ex, "~> 0.6.0"},
      {:rename_project, "~> 0.1.0", only: :dev},
    ]
  end
end
