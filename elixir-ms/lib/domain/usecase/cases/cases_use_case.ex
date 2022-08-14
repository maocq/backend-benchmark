defmodule ElixirMs.UseCase.CasesUseCase do
  @moduledoc false

  @account_repository Application.compile_env(:elixir_ms, :account_repository)
  @hello_repository Application.compile_env(:elixir_ms, :hello_repository)

  def case_one(latency) do
    with {:ok, _} <- @hello_repository.hello(latency),
         {:ok, _} <- @hello_repository.hello(latency),
         account <- @account_repository.find_by_id(4000),
         {:ok, _} <- @hello_repository.hello(latency) do

      updated_account = %{account | name: inspect(Timex.now)}
      {:ok, @account_repository.update(updated_account)}
    end
  end

  def case_two(latency) do
    with account <- @account_repository.find_one(),
         {:ok, _} <- @hello_repository.hello(latency) do
      {:ok, account}
    end
  end

  def case_three() do
    @account_repository.find_by_id(4000)
  end
end
