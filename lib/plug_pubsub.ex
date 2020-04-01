defmodule PlugPubsub do
  @moduledoc """
  Documentation for `PlugPubsub`.
  """
  alias ExAws.SNS

  require Logger

  @topic Application.fetch_env!(:plug_pubsub, :publish_topic_arn)
  
  defp publish(title, msg) do
    opts = [subject: title, topic_arn: @topic]
    operation = SNS.publish(msg, opts)
    ExAws.request(operation)
  end
  
  @doc """
  Publish message on AWS SNS on the configured topic.

  For more detail about the response, check https://hexdocs.pm/ex_aws_sns/ExAws.SNS.html#publish/2

  ## Examples

      iex> PlugPubSub.publish_message(title, message)
      {:ok, request_details}
  
  """
  def publish_message(title, message) when is_bitstring(title) do
    Logger.info("Message: #{inspect(message)}")
    case Jason.encode(message) do
      {:ok, decoded} ->
        Logger.info("Sending JASON decoded message")
        publish(title, decoded)

      {:error, _} ->
        Logger.info("Sending message straight")
        publish(title, message)
    end
  end
  def publish_message(title, _) do
    error = "Title must be an string: #{inspect(title)}"
    Logger.error(error)
    {:error, error}
  end
end
