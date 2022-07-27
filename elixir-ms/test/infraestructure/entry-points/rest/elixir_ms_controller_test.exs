defmodule ElixirMs.EntryPoint.Rest.ElixirMsControllerTest do
  alias ElixirMs.EntryPoint.Rest.ElixirMsController

  import Mock
  import TestStubs

  use ExUnit.Case
  use Plug.Test
  doctest ElixirMs.Application

  @opts ElixirMsController.init([])

  test "returns hello" do
    conn =
      :get
      |> conn("/hello", "")
      |> ElixirMsController.call(@opts)

    assert conn.state == :sent
    assert conn.resp_body == "\"Hello\""
    assert conn.status == 200
  end

  test "returns 404" do
    conn =
      :get
      |> conn("/missing", "")
      |> ElixirMsController.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
