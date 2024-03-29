defmodule Shppd.MixProject do
  use Mix.Project

  def project do
    [
      app: :shppd,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      docs: docs()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Shppd.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:argon2_elixir, "~> 3.0"},
      {:bandit, ">= 0.0.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dns_cluster, "~> 0.1.1"},
      {:ecto_sql, "~> 3.10"},
      {:ecto_sqlite3, ">= 0.0.0"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:finch, "~> 0.13"},
      {:floki, "~> 0.35"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_dashboard, "~> 0.8.2"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.1"},
      {:phoenix, "~> 1.7.10"},
      {:req, "~> 0.4.0"},
      {:swoosh, "~> 1.3"},
      {:tailwind_formatter, "~> 0.4", only: :dev, runtime: false},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end

  # Configuration for `ex_doc` documentation building.
  # To build the documentation for viewing, run:
  #
  #     $ mix docs
  #
  # See the documentation for `ExDoc` for more information.
  defp docs do
    [
      main: "readme",
      extras: [
        "README.md": [filename: "readme", title: "Readme"],
        "documentation/running.md": [filename: "running", title: "Running"],
        "documentation/alternatives.md": [filename: "alternatives", title: "Alternatives"]
      ],
      groups_for_extras: [
        "Services": Path.wildcard("documentation/services/*.md")
      ],
      homepage_url: "https://documentation.shppd.app",
      nest_modules_by_prefix: [Shppd, ShppdTrack, ShppdWeb],
      source_url: "https://github.com/btkostner/shppd"
    ]
  end
end
