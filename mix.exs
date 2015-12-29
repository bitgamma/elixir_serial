defmodule Mix.Tasks.Compile.Serial do
  @shortdoc "Compiles serial port binary"
  def run(_) do
    0 = Mix.Shell.IO.cmd("make priv/serial")
    Mix.Project.build_structure
    :ok
  end
end

defmodule Serial.Mixfile do
  use Mix.Project

  def project do
    [app: :serial,
     version: "0.1.2",
     elixir: "~> 1.0",
     compilers: [:serial, :elixir, :app],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package,
     description: description
     ]
  end

  def application, do: []

  defp deps do
    [
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end

  defp description do
    "Serial communication through Elixir ports"
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE", "src", "Makefile"],
      maintainers: ["Michele Balistreri"],
      licenses: ["ISC"],
      links: %{"GitHub" => "https://github.com/bitgamma/elixir_serial"}
    ]
  end
end
