defmodule Zwave do
  @moduledoc """
  Zwave doc
  """
  use Application

  def start(_type, _args) do
    {:ok, pid} = Zwave.Controller.Supervisor.start_link()
    # {:ok, pid} = Zwave.Controller.Device.start_link()
    Zwave.Controller.Device.get_version
    Process.sleep(10_000)
    Zwave.Controller.Device.get_capabilities
    Process.sleep(10_000)
    Zwave.Controller.Device.get_virtual_nodes
    Process.sleep(10_000)
    Zwave.Controller.Device.get_init_data
    Process.sleep(10_000)
    {:ok, pid}
  end

end
