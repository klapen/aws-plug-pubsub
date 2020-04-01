defmodule AwsPubsub.Consumer do
  @moduledoc """
  Consumes messages from a Queue SQS
  """
  alias ExAws.SQS

  require Logger

  use GenServer
  
  @queue_url Application.fetch_env!(:aws_pubsub, :queue_url)

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Set up queue consumer
  """
  @impl true
  def init(:ok) do
    Logger.debug("Setting up queue consumer")
    schedule_check()

    queue_name =
      String.split(@queue_url,"/")
      |> Enum.take(-1)
    
    {:ok, %{queue_name: queue_name, last_message_time: nil}}
  end

  def schedule_check(check_interval \\ 1_000) do
    Process.send_after(self(), :get_messages, check_interval)
  end

  @doc """
  Main process to handle message pull from AWS SQS queue
  """
  def handle_messages() do
    queue_name =
      String.split(@queue_url,"/")
      |> Enum.take(-1)
    
    case get_messages(@queue_url, wait_time_seconds: 5, max_number_of_messages: 10) do
      {:ok, []} ->
        Logger.info("No message to process")
        :ok

      {:ok, messages} ->
        Logger.info(
          "Received #{length(messages)} messages from queue #{queue_name}, processing them..."
        )

        process_messages(messages)

        messages
        |> Enum.each(fn %{receipt_handle: receipt_handle} ->
          Logger.debug("Deleting message with receipt: #{receipt_handle}")
          delete_message(@queue_url, receipt_handle)
        end)

      {:error, _} = unexpected ->
        Logger.error(
          "Could not get messages from queue #{queue_name}, reason: #{inspect(unexpected)}"
        )
    end
  end

  defp get_messages(queue_url, opts) do
    result =
      queue_url
      |> SQS.receive_message(opts)
      |> ExAws.request()

    with {:ok, %{body: %{messages: messages}}} <- result, do: {:ok, messages}
  end

  defp delete_message(queue_url, receipt) do
    queue_url
    |> SQS.delete_message(receipt)
    |> ExAws.request()
  end

  @doc """
  Process messages data from pulled messages

  ## Examples

      iex> PlugPubSub.process_messages(messages)
      {:ok}
  
  """
  def process_messages(messages) do
    Enum.each(messages, fn message ->
      Logger.info("Handling message: #{inspect(message)}")
      case Jason.decode(message.body) do
        {:ok, json} ->
          Logger.info("Recieved JSON: #{inspect(json)}")
          # ToDo: Call each function to manage events data
        {:error, _} ->
          Logger.info("Recieves string: #{inspect{message.body}}")
      end
    end)

    messages
  end

  @impl GenServer
  def handle_info(:get_messages, state) do
    handle_messages()
    schedule_check()

    {:noreply, state}
  end

  def handle_info(:sslsocket, _) do
    Logger.info("SSL socker closed")

    {:sslsocket}
  end
end
