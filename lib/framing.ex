defmodule Nerves.UART.Framing.Zwave do
  @moduledoc """
  Apply Zwave serial framing
  """

  @behaviour Nerves.UART.Framing

  # require Zwave.Consts
  # alias Zwave.Consts, as: Const
  require Logger

  @sof 0x01
  @ack 0x06
  @nak 0x15
  @can 0x18

  defmodule State do
    @moduledoc false
    defstruct [
      max_length: nil,
      partial_data: <<>>,
      # processed: <<>>,
      # in_process: <<>>
    ]
  end

  def init(args) do
    max_length = Keyword.get(args, :max_length, 4096)

    state = %State{max_length: max_length}
    {:ok, state}
  end

  def add_framing(data, state), do: {:ok, data, state}

  def remove_framing(data, state) do
    case process_data(state.partial_data <> data) do
      {:sof, response, rest} ->
        {:ok, [{:msg, response}], %{state | partial_data: rest}}
      {:partial, rest} ->
        {:in_frame, [], %{state | partial_data: rest}}
      {:ack, rest} ->
        {:ok, [{:ack}], %{state | partial_data: rest}}
      {:nak, rest} ->
        # What to do???
        Logger.debug fn ->
          "NAK recieved... #{inspect data}, ignoring..."
        end
        {:ok, [], state}
      {:can, rest} ->
        Logger.debug fn ->
          "CAN recieved... #{inspect data}, cancel what???"
        end
        {:error, [], state}
        # {:ok, [], %{state | partial_data: rest}}
      {:error} ->
        {:error, [], state}
    end
  end

  # doesnt care for now
  def frame_timeout(state) do
    Logger.debug fn -> ("frame_timeout #{inspect state}") end
    {:ok, [], state}
  end

  def flush(_direction, state) do
    Logger.debug fn -> ("flush #{inspect state}") end
    state
  end

  defp process_data(data) do
    Logger.debug fn -> "Serial: #{inspect data}" end
    case data do
      # issue using data_len::binary-size(1)
      <<@sof, len::size(8), response::binary-size(len), rest::binary>> ->
        # verify checksum
        data_len = len - 1
        <<response_data::binary-size(data_len), crc::size(8)>> = response
        crc_data = <<len>> <> response_data
        if <<crc>> == Zwave.Controller.Device.crc8(crc_data) do
          {:sof, response_data, rest}
        else
          {:error}
        end
      <<@ack, rest::binary>> ->
        {:ack, rest}
      <<@nak, rest::binary>> ->
        {:nak, rest}
      <<@can, rest::binary>> ->
        {:can, rest}
      partial_data ->
        {:partial, partial_data}
      # msg -> IO.puts("ERROR, out of sync? #{inspect msg}")
      #   {:error}
    end

  end

end
