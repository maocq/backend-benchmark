defmodule ElixirMs.Model.Account do

  defstruct [
    :id,
    :user_id,
    :account,
    :name,
    :number,
    :balance,
    :currency,
    :type,
    :bank,
    :creation_date,
    :update_date
  ]
end
