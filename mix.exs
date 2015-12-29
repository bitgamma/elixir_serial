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
     version: "0.1.1",
     elixir: "~> 1.0",
     compilers: [:serial, :elixir, :app],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package,
     description: description,
     docs: [readme: "README.md", main: "README"]]
  end

  def application, do: []

  defp deps do
    [
      {:earmark, "~> 0.1", only: :docs},
      {:ex_doc, "~> 0.8", only: :docs}
    ]
  end

  defp description do
    "Serial communication through Elixir ports"
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE", "src", "Makefile"],
      contributors: ["Michele Balistreri"],
      licenses: ["ISC"],
      links: %{"GitHub" => "https://github.com/bitgamma/elixir_serial"}
    ]
  end
end
