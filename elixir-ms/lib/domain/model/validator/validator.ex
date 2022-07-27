defmodule ElixirMs.Model.Validator do
  @moduledoc false

  @spec validate(term, (term -> boolean), String.t()) :: {:ok, term} | {:error, String.t()}
  def validate(term, fun, err) do
    if fun.(term), do: {:ok, term}, else: {:error, err}
  end

  @spec filter_errors(list({:ok, term} | {:error, String.t()})) :: list(String.t())
  def filter_errors(list) do
    Stream.filter(list, &filter_error?/1)
      |> Enum.map(fn {_, err} -> err end)
  end

  defp filter_error?({:ok, _}), do: false
  defp filter_error?({:error, _}), do: true



  @spec validate_string(String.t()) :: boolean
  def validate_string(text) do
    if is_nil(text) || not is_binary(text) || String.length(text) == 0, do: false, else: true
  end

  @spec validate_number(number()) :: boolean
  def validate_number(number) do
    if is_nil(number) || not is_number(number), do: false, else: true
  end

end
