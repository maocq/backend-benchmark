defmodule ElixirMs.DrivenAdapters.Db.Repository.AccountDataRepository do
  alias ElixirMs.Repo
  alias ElixirMs.DrivenAdapters.Db.Repository.AccountData
  alias ElixirMs.Model.Account

  @behaviour ElixirMs.Model.Behaviour.AccountRepository

  def find_by_id(id), do: AccountData |> Repo.get!(id) |> to_entity
  def find_one(), do: find_one_sql().rows |> Enum.map(&row_to_entity/1)
  def find_test(), do: find_test_sql().rows |> Enum.map(&row_to_entity/1)
  def find_all(), do: AccountData |> Repo.all |> Enum.map(&to_entity/1)
  def update(entity) do
    row = %AccountData{id: entity.id}
    Repo.update!(Ecto.Changeset.change(row, %{user_id: entity.user_id, account: entity.account, name: entity.name, number: entity.number,
     balance: entity.balance, currency: entity.currency, type: entity.type, bank: entity.bank,
     creation_date: entity.creation_date, update_date: entity.update_date})) |> to_entity
  end

  defp find_one_sql() do
    query = "SELECT a.id, a.user_id, a.account, a.name, a.number, a.balance, a.currency, a.type, a.bank, a.creation_date, a.update_date FROM account AS a WHERE (a.id = 4000)"
    Ecto.Adapters.SQL.query!(Repo, query, [])
  end

  defp find_test_sql() do
    query = "select * from account a where a.balance > (select avg(a.balance) + 72700000 from account a)"
    Ecto.Adapters.SQL.query!(Repo, query, [])
  end


  defp to_entity(data) do
    %Account{id: data.id, user_id: data.user_id, account: data.account, name: data.name, number: data.number,
     balance: data.balance, currency: data.currency, type: data.type, bank: data.bank,
     creation_date: data.creation_date, update_date: data.update_date}
  end

  defp row_to_entity(data) do
    %Account{id: data |> Enum.at(0), user_id: data |> Enum.at(1), account: data |> Enum.at(2), name: data |> Enum.at(3), number: data |> Enum.at(4),
     balance: data |> Enum.at(5), currency: data |> Enum.at(6), type: data |> Enum.at(7), bank: data |> Enum.at(8),
     creation_date: data |> Enum.at(9), update_date: data |> Enum.at(10)}
  end

  defp to_row(entity) do
    row = %AccountData{id: entity.id, user_id: entity.user_id, account: entity.account, name: entity.name, number: entity.number,
     balance: entity.balance, currency: entity.currency, type: entity.type, bank: entity.bank,
     creation_date: entity.creation_date, update_date: entity.update_date}
  end
end
