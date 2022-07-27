defmodule ElixirMs.UseCase.GetAccountUseCase do
  @moduledoc false

  @account_repository Application.compile_env(:elixir_ms, :account_repository)

  def find_by_id(id), do: @account_repository.find_by_id(id)
  def find_one(), do: @account_repository.find_one()

  def find_multiple_one() do
    _ = @account_repository.find_one()
    _ = @account_repository.find_one()
    _ = @account_repository.find_one()
    _ = @account_repository.find_one()
    @account_repository.find_one()
  end
  def find_test(), do: @account_repository.find_test()

  def find_multiple_test() do
    _ = @account_repository.find_test()
    _ = @account_repository.find_test()
    _ = @account_repository.find_test()
    _ = @account_repository.find_test()
    @account_repository.find_test()
  end

  def find_all(), do: @account_repository.find_all()

end
