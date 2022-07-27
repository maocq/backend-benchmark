defmodule ElixirMs.DrivenAdapters.Db.Repository.AccountData do
  use Ecto.Schema

  schema "account" do
    field :user_id, :string
    field :account, :string
    field :name, :string
    field :number, :string
    field :balance, :decimal
    field :currency, :string
    field :type, :string
    field :bank, :string
    field :creation_date, :utc_datetime
    field :update_date, :utc_datetime
  end
end
