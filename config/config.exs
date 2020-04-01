use Mix.Config

config :aws_pubsub,
  queue_url: System.get_env("AWS_QUEUE_URL"),
  publish_topic_arn: System.get_env("AWS_TOPIC_ARN")

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: [System.get_env("AWS_REGION"), "us-east-1"]
