defmodule ElixirMs.UseCase.GetHelloUseCase do
  @moduledoc false

  @hello_repository Application.compile_env(:elixir_ms, :hello_repository)

  def handle(latency) do
    @hello_repository.hello(latency)
  end

  def handle_multiple() do
    _ = @hello_repository.hello(50)
    _ = @hello_repository.hello(50)
    _ = @hello_repository.hello(50)
    _ = @hello_repository.hello(50)
    @hello_repository.hello(50)
  end
end
