defmodule ElixirMs.Config.ConfigHolder do
  @moduledoc false

  use Agent
  alias ElixirMs.Config.AppConfig

  def start_link(%AppConfig{} = conf), do: Agent.start_link(fn -> conf end, name: __MODULE__)
  def conf(), do: Agent.get(__MODULE__, & &1)
end
