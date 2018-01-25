defmodule Zwave.Controller.Supervisor do
  @moduledoc """
  Zwave controller supervisor
  """
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      {Zwave.Controller.Device, "ttyACM0"}
    ]

    opts = [strategy: :one_for_one]
    Supervisor.init(children, opts)
  end

end
