defmodule FinancialSystem.Coin do
  @moduledoc """
  Module with file parsing and currency validating functions.
  """

  @doc """
  Parse of files of text whant have information of currences.

  ##Examples


  """

  @spec examiner(String.t()) :: [key: float]
  def examiner(file) do
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

  ##Examples
  iex(2)> FinancialSystem.Coin.is_valid?(:USD)
  true
  iex(3)> FinancialSystem.Coin.is_valid?(:USS)
  false
  """
  @spec is_valid?(atom) :: boolean()
  def is_valid?(currency_validetion) do
    FinancialSystem.Coin.examiner("currency_rates.txt")
    |> Keyword.keys()
    |> Enum.any?(fn currency -> currency == currency_validetion end)
  end
end
