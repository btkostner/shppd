[
  import_deps: [:ecto, :ecto_sql, :phoenix],
  inputs: ["{config,lib,priv,test}/**/*.{heex,ex,exs}"],
  plugins: [TailwindFormatter, Phoenix.LiveView.HTMLFormatter]
]
