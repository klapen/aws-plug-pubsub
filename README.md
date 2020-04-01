# PlugPubsub


This proyect implements [ExAws.SNS](https://hexdocs.pm/ex_aws_sns/ExAws.SNS.html) to publish messages to an AWS SNS Topic and [ExAws.SQS](https://hexdocs.pm/ex_aws_sqs/ExAws.SQS.html) to cconsume messages sent to AWS SQS, in [Elixir](https://elixir-lang.org/).

## Folder structure
```
.
├── config
│   └── config.exs
├── lib
│   ├── application.ex
│   ├── consumer.ex
│   └── plug_pubsub.ex
├── mix.exs
├── mix.lock
├── README.md
└── test
    ├── plug_pubsub_test.exs
    └── test_helper.exs
```

## Dependencies

- [ExAws](https://hexdocs.pm/ex_aws/ExAws.html)
- [ExAws.SNS](https://hexdocs.pm/ex_aws_sns/ExAws.SNS.html)
- [ExAws.SQS](https://hexdocs.pm/ex_aws_sqs/ExAws.SQS.html)
- [SweetXml](https://hexdocs.pm/sweet_xml/SweetXml.html)
- [Jason](https://hexdocs.pm/jason/Jason.html)
- [Hackney](https://hexdocs.pm/hackney/)

## Configurable parameters

First of all, you need to configure a [SNS topic](https://docs.aws.amazon.com/sns/latest/dg/sns-getting-started.html) and you need to configure a [SNS topic](https://docs.aws.amazon.com/sns/latest/dg/sns-getting-started.html) in AWS. Once you have the ARN, the mandatory environment variables to configure are:

```sh
$ export AWS_QUEUE_URL=https://sqs.us-east-1.amazonaws.com/{account_id}/{queue_name}
$ export AWS_TOPIC_ARN=arn:aws:sns:us-east-1:{account_id}:{topic_name}
```

For local tests, you need to create a [security credentials](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) and then set the following enviroment variables:

```sh
$ export AWS_SECRET_ACCESS_KEY={user_account_secret_access}
$ export AWS_ACCESS_KEY_ID={user_account_access_key}
```

If you deploy the module on a AWS Server, it will take the instance role configuration as a credential to publish and consume messages.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed by adding `plug_pubsub` to your list of dependencies in `mix.exs`:

```elixir
def application do
  [
    applications: [:hackney]
  ]
end

def deps do
  [
    {:plug_pubsub, "~> 0.1.0", runtime: false}
  ]
end
```
This configuration is **only** to use the publisher, because I still working on the consumer to work on the package. You will also need to, manually set the config parameters on *config.exs*:

```elixir
use Mix.Config

config :plug_pubsub,
  queue_url: System.get_env("AWS_QUEUE_URL"),
  publish_topic_arn: System.get_env("AWS_TOPIC_ARN")

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: [System.get_env("AWS_REGION"), "us-east-1"]
```

Documentation docs can be found at [https://hexdocs.pm/plug_pubsub](https://hexdocs.pm/plug_pubsub).

## How to use

To use, just open a console and use the method *AwsPublisher.publish_message*:

```elixir
AwsPublisher.publish_message("Some title", %{"age" => 44, "name" => "Jhon Doe", "nationality" => "Colombian"})

```
