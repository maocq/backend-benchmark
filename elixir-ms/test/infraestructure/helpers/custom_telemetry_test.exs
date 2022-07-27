defmodule ElixirMs.Helpers.CustomTelemetryTest do
  alias ElixirMs.Helpers.CustomTelemetry

  use ExUnit.Case
  use Plug.Test

  doctest ElixirMs.Application

  describe "execute_custom_event/3" do
    test "Should send metrics" do
      CustomTelemetry.execute_custom_event([:test, :test], 10 - 1)
      assert true
    end
  end

  describe "execute_custom_event/4" do
    test "Should send custom metrics" do
      CustomTelemetry.execute_custom_event(:test, 10 - 1, %{})
      assert true
    end
  end

  describe "metrics/0" do
    test "Should send custom metrics" do
      CustomTelemetry.metrics()
      assert true
    end
  end

end
