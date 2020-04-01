defmodule PlugPubsub.MixProject do
  use Mix.Project

  def project do
    [
      app: :plug_pubsub,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp description do
    """
    Library for publish message to AWS SNS topic and consume messages from AWS SQS
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Orlando Saavedrta"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/klapen/aws-plug-pubsub"}
    ]
  end
  
  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      applications: [:hackney],
      mod: {PlugPubsub.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aws, "~> 2.1"},
      {:ex_aws_sns, "~> 2.0"},
      {:ex_aws_sqs, "~> 3.0"},
      {:sweet_xml, "~> 0.6"},
      {:jason, "~> 1.2"},
      {:hackney, "~> 1.15"},
      {:ex_doc, "~> 0.19"}
    ]
  end
end
