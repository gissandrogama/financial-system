defmodule FinancialSystem.Currency do
  @moduledoc """
  Module with file parsing and currency validating functions. 
  """

  @doc """
  Parse of files of text whant have information of currences 
  """
  @spec parse(String.t()) :: [key: float]
  def parse(file) do
    file
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn x ->
      [currency, rate] = String.split(x, ":")

      key =
        currency
        |> String.trim("\"")
        |> String.to_atom()

      {key, String.to_float(rate)}
    end)
  end

  @doc """
  Function that validates the currency according to the code established by ISO 4217.
  """
  @spec is_valid?(atom) :: boolean()
  def is_valid?(currency_validetion) do
    FinancialSystem.Currency.parse("currency_rates.txt")
    |> Keyword.keys()
    |> Enum.any?(fn currency -> currency == currency_validetion end)
  end
end
