defmodule Zwave.Controller.Device do
  @moduledoc """
  Zwave controller device
  """
  use GenServer
  use Bitwise, only_operators: true
  require Zwave.Consts
  alias Zwave.Consts, as: Const
  require Logger

  # public

  defmodule State do
    @moduledoc false
    defstruct [:nerves_pid,
               :version,
               :controller,
               :capabilities,
               :nodes_cache,
               :home_id,
               :node_id,
               :not_impl]
  end

  def start_link(device) do
    # IO.inspect(Nerves.UART.enumerate)
    IO.puts(inspect Nerves.UART.enumerate)

    GenServer.start_link(__MODULE__, device, name: __MODULE__)
  end

  def init(device) do
    # start Nerves.UART
    {:ok, pid} = Nerves.UART.start_link
    :ok = Nerves.UART.open(pid, device, speed: 115_200,
                           data_bits: 8, parity: :none, stop_bits: 1,
                           flow_control: :none,
                           framing: Nerves.UART.Framing.Zwave,
                           active: true)
    nodes_cache = List.duplicate(0, 29)
    {:ok, %State{nerves_pid: pid, nodes_cache: nodes_cache}}
  end

  def get_init_data do
    GenServer.call(__MODULE__, {:send, msg(Const.zFUNC_ID_SERIAL_API_GET_INIT_DATA)})
  end

  def get_version do
    GenServer.call(__MODULE__, {:send, msg(Const.zFUNC_ID_ZW_GET_VERSION)})
  end

  def memory_get_id do
    GenServer.call(__MODULE__, {:send, msg(Const.zFUNC_ID_ZW_MEMORY_GET_ID)})
  end

  def get_capabilities do
    GenServer.call(__MODULE__, {:send, msg(Const.zFUNC_ID_SERIAL_API_GET_CAPABILITIES)})
  end

  def get_controller_capabilities do
    GenServer.call(__MODULE__, {:send, msg(Const.zFUNC_ID_ZW_GET_CONTROLLER_CAPABILITIES)})
  end

  def get_node_protocol_info do
    GenServer.call(__MODULE__, {:send, msg(Const.zFUNC_ID_ZW_GET_NODE_PROTOCOL_INFO)})
  end

  def get_virtual_nodes do
    GenServer.call(__MODULE__, {:send, msg(Const.zFUNC_ID_ZW_GET_VIRTUAL_NODES)})
  end

  def crc8(data) when is_binary(data) do
    crc8(data, 0xff)
  end

  # callbacks

  def handle_call({:send, data}, _from, state) do
    pid = state.nerves_pid
    ret = Nerves.UART.write(pid, data)
    {:reply, ret, state}
  end

  def handle_info({:nerves_uart, _serial_port_name, data}, state) do
    Logger.debug fn ->
      "Got info: #{inspect data}"
    end

    state_updated =
      case data do
        {:msg, message} ->
          case handle_message(message, state) do
            {:ok, part_state} ->
              Map.merge(state, part_state)
            {:error, error} ->
              Logger.debug fn ->
                "[E] Cant handle message: #{error}."
              end
              state
          end
        {:ack} -> state
        {:nak} -> state
        {:error, error} ->
          Logger.debug fn ->
            "[E] #{error}"
          end
          state
    end

    {:noreply, state_updated}
  end

  # private

  defp msg(data) do
    message = <<len(<<data>>) + 2, Const.zREQUEST>> <> <<data>>
    message = <<Const.zSOF>> <> message <> crc8(message)
    Logger.debug fn ->
      "Msg: #{inspect message}"
    end
    message
  end

  defp handle_message(<<type, command, data::binary>>, state) do
    case type do
      # Const.zREQUEST -> {:ok, %{not_impl: true}}
      Const.zREQUEST -> handle_message_request(command, data, state)
      Const.zRESPONSE -> handle_message_reponse(command, data, state)
      _ -> {:error, "Wrong zwave type #{type}"}
    end
  end

  defp handle_message_request(command, data, state) do
    case command do
      Const.zFUNC_ID_APPLICATION_COMMAND_HANDLER -> handle_application_command_handler(data)
      _ -> {:error, "Zwave request command (#{command}) not implemented."}
    end
  end

  defp handle_application_command_handler(data) do
    #  <<_::5,           # status
    #    routed_busy::1, # status
    #    _::1,           # status
    #    type_broad::1,  # status
    #    node_id,
    #    _unknown,
    #    command_id,
    #    _rest::binary>> = data
    <<status,
      node_id,
      _unknown,
      command_id,
      _rest::binary>> = data
    IO.puts("command handler: status: #{status} node_id: #{node_id} command_id: #{command_id}")
    {:ok, %{}}
  end

  defp handle_message_reponse(command, data, state) do
    case command do
      Const.zFUNC_ID_SERIAL_API_GET_INIT_DATA -> handle_get_init_data(data, state)
      Const.zFUNC_ID_SERIAL_API_GET_CAPABILITIES -> handle_get_capabilities(data)
      Const.zFUNC_ID_ZW_GET_CONTROLLER_CAPABILITIES -> handle_get_controller_capabilities(data)
      Const.zFUNC_ID_ZW_GET_VERSION -> handle_get_version_response(data)
      Const.zFUNC_ID_ZW_MEMORY_GET_ID -> handle_memory_get_id_response(data)
      Const.zFUNC_ID_ZW_GET_NODE_PROTOCOL_INFO -> handle_get_node_protocol_info(data)
      Const.zFUNC_ID_ZW_GET_VIRTUAL_NODES -> handle_get_virtual_nodes(data)
      _ -> {:error, "Zwave response command (#{command}) not implemented."}
    end
  end

  # FUNC_ID_ZW_GET_INIT_DATA
  # ex: <<1, 2, 5, 0, 29, 63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0>>
  @num_node_bitfield_bytes 29
  defp handle_get_init_data(data, state) do
    <<_init_version,
      _init_caps,
      nodes::binary-size(@num_node_bitfield_bytes),
      _unknown1,
      _unknown2::binary>> = data

    node_list = :binary.bin_to_list(nodes)
    node_prev_list = state.nodes_cache
    # for <<n <- nodes>>, i <- 0..7, do
    node_diff(0, node_list, node_prev_list)

    Logger.debug fn ->
      "[I] Get Init data: #{inspect data})"
    end
    {:ok, %{nodes_cache: node_list}}
  end

  defp node_diff(_, [], [], nodes), do: nodes
  defp node_diff(index, [a | node_list], [b | node_cache_list], nodes \\ []) do
    if a != b do
      for i <- 0..7 do
        new_bit = (a >>> i) &&& 1
        old_bit = (b >>> i) &&& 1
        if new_bit != old_bit do
          # credo:disable-for-next-line
          if new_bit == 1 do
            # add node
            IO.puts("add node: #{index * 8 + i}")
          else
            # rem node
            IO.puts("rem node: #{index * 8 + i}")
          end
        end
      end
    end
    node_diff(index + 1, node_list, node_cache_list, nodes)
  end

  # FUNC_ID_ZW_GET_VERSION
  defp handle_get_version_response(data) do
    version_types = [
      "Unknown",
      "Static Controller",
      "Controller",
      "Enhanced Slave",
      "Slave",
      "Installer",
      "Routing Slave",
      "Bridge Controller",
      "Device Under Test"
    ]
    [version, <<type>>] = :binary.split(data, <<0>>)
    version_type = Enum.fetch!(version_types, type)
    Logger.debug fn ->
      "[I] Get Version: \"#{version}\" (#{version_type})"
    end
    {:ok, %{version: {version, version_type}}}
  end

  # FUNC_ID_SERIAL_API_GET_CAPABILITIES
  defp handle_get_capabilities(data) do
    <<version_major,
      version_minor,
      manufactor_id::16,
      product_type::16,
      product_id::16,
      api_mask::binary-size(32),
      rest::binary>> = data

    Logger.debug fn ->
      "[I] Serial API Capabilities:\n" <>
      "    Serial API Version: #{version_major}.#{version_minor}\n" <>
      "    Manufacturer ID:    #{manufactor_id}\n" <>
      "    Product Type:       #{product_type}\n" <>
      "    Product ID:         #{product_id}\n"
    end

    {:ok, %{controller: {"#{version_major}.#{version_minor}", manufactor_id, product_type, product_id},
            capabilities: api_mask}}
  end

  # defp is_api_call_supported(api_num, mask) do
  #   # ( uint8 const _apinum )const
  #   # { return (( m_apiMask[( _apinum - 1 ) >> 3] & ( 1 << (( _apinum - 1 ) & 0x07 ))) != 0 ); }
  #   :ok

  # end

  # FUNC_ID_ZW_GET_CONTROLLER_CAPABILITIES
  defp handle_get_controller_capabilities(controller_caps) do
    <<_reserved::3,
      suc::1,            # static update controller
      real_primary::1,   # primary before SIS was added
      sis::1,            # SUC ID Server
      on_the_network::1, # Controller not using default home id
      secondary::1       # Secondary controller
    >> = controller_caps

    Logger.debug("[I] Controller Capabilities:\n")
    cond do
      suc            -> Logger.debug("    Static Update Controller\n")
      real_primary   -> Logger.debug("    Primary before SIS was added\n")
      sis            -> Logger.debug("    SUC ID Server\n")
      on_the_network -> Logger.debug("    Controller not using default home id\n")
      secondary      -> Logger.debug("    Secondary Controller\n")
    end

    # if @controller_caps & CONTROLLER_SIS != 0
    # puts "  There is a SUC ID Server (SIS) in this network."
    # puts "  The PC controller is an inclusion" +
    #   ((@controller_caps & CONTROLLER_SUC != 0) ? " static update controller (SUC)" : " controller") +
    #     ((@controller_caps & CONTROLLER_ONOTHERNETWORK != 0) ? " which is using a Home ID from another network" : "") +
    #       ((@controller_caps & CONTROLLER_REALPRIMARY != 0) ? " and was the original primary before the SIS was added." : ".")
    # else
    #   puts "  There is no SUC ID Server (SIS) in this network."
    #   puts "  The PC controller is a" +
    #     ((@controller_caps & CONTROLLER_SECONDARY != 0) ? " secondary" : " primary") +
    #       ((@controller_caps & CONTROLLER_SUC != 0) ? " static update controller (SUC)" : " controller") +
    #         ((@controller_caps & CONTROLLER_ONOTHERNETWORK != 0) ? " which is using a Home ID from another network." : ".")
    # end

    {:ok, %{capabilities: controller_caps}}
  end

  # FUNC_ID_ZW_MEMORY_GET_ID
  defp handle_memory_get_id_response(<<home_id::size(32), node_id::size(8)>>) do
    Logger.debug fn ->
      "[I] Home id: 0x#{Integer.to_string(home_id,16)}" <>
      "    Node id: #{node_id}"
    end
    {:ok, %{home_id: home_id, node_id: node_id}}
  end

  # FUNC_ID_ZW_GET_NODE_PROTOCOL_INFO
  defp handle_get_node_protocol_info(data) do
    Logger.debug fn ->
      "[i] #{inspect data}"
    end
    {:ok, %{node_protocol: data}}
  end

  defp handle_get_virtual_nodes(data) do
    Logger.debug fn ->
      "[i] get virtual nodes: #{inspect data}"
    end
    {:ok, %{nodes: data}}
  end

  defp crc8(<<head>> <> tail, crc) do
    crc8(tail, crc ^^^ head)
  end

  defp crc8(<<>>, crc) do
    <<crc>>
  end

  defp len(data) do
    byte_size(data) &&& 0xff
  end

end
