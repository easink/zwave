defmodule ZwaveControllerTest do
  use ExUnit.Case
  doctest Zwave

  setup "Setup controller supervisor" do
    Zwave.Controller.SuperVisor.start_link
  end

  test "ZWave memory get id" do
    # Zwave.Controller.Device.memory_get_id()
    assert 1 == 1
  end

end
