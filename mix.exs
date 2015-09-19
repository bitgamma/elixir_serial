defmodule Mix.Tasks.Compile.Cmake do
  def run(_) do
    {result, _error_code} = System.cmd("cmake", ["."], stderr_to_stdout: true)
    Mix.shell.info result
    {result, _error_code} = System.cmd("make", ["all"], stderr_to_stdout: true)
    Mix.shell.info result
    :ok
  end
end

defmodule Serial.Mixfile do
  use Mix.Project

  def project do
    [app: :serial,
     version: "0.1.1",
     elixir: "~> 1.0",
     compilers: [:cmake] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package,
     description: description,
     docs: [readme: "README.md", main: "README"]]
  end

  def application do
    [applications: [:logger]]
  end

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
      files: ["lib", "mix.exs", "README.md", "LICENSE", "src", "CMakeLists.txt"],
      contributors: ["Michele Balistreri"],
      licenses: ["ISC"],
      links: %{"GitHub" => "https://github.com/bitgamma/elixir_serial"}
    ]
  end
end
