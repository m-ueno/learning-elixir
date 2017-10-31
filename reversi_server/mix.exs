defmodule ReversiServer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :reversi_server,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      dialyzer: [plt_add_deps: :transitive],

      # Docs
      name: "ReversiServer",
      source_url: "https://github.com/m-ueno/learning-elixir/tree/master/reversi_server",
      homepage_url: "https://github.com/m-ueno/learning-elixir/tree/master/reversi_server",
      docs: [
        main: "ReversiServer", # The main page in the docs
        #        logo: "path/to/logo.png",
        extras: ["README.md"]
      ],
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ReversiServer.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:reversi_board, path: "../reversi_board"},
      {:excoveralls, "~> 0.7", only: :test},                   # mix coveralls.html
      {:mix_test_watch, "~> 0.3", only: :dev, runtime: false}, # mix test.watch
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},        # mix docs
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}, # mix credo [--strict] : Credo is a static linter
      {:dialyxir, "~> 0.5.0", only: [:dev], runtime: false},   # mix dialyzer --plt : static analysis

      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
