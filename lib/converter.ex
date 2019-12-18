defmodule FinancialSystem.Converter do
  alias FinancialSystem.Currency, as: Currency

  @moduledoc """
  Module that treats operations such as currency conversion.
  """


  @doc false
  def exchange(amount, from_coin, to_coin) when from_coin == to_coin do
    case Currency.is_valid?(from_coin) do
      true -> {:ok, amount}
      false -> {:error, "Coin (#{from_coin}) not valid compared to ISO 4271"}
    end
    case Currency.is_valid?(to_coin) do
      true -> {:ok, amount}
      false -> {:error, "Coin (#{to_coin}) not valid compared to ISO 4271"}
    end
  end

  def exchange(amount, :USD, to) do
    case Currency.is_valid?(to) do
      true ->
        rates = FinancialSystem.Currency.parse("currency_rates.txt")
        value_amount = Decimal.from_float(amount)
        rate_to = Decimal.from_float(rates[to])

        converted_amount =
          Decimal.mult(value_amount, rate_to)
          |> Decimal.round(2)
          |> Decimal.to_float()

        {:ok, converted_amount}

      false ->
        {:error, "Coin (#{to}) not valid compared to ISO 4271"}
    end
  end

  def exchange(amount, from, :USD) do
    case Currency.is_valid?(from) do
      true ->
        rates = FinancialSystem.Currency.parse("currency_rates.txt")
        value_amount = Decimal.from_float(amount)
        rate_from = Decimal.from_float(rates[from])

        converted_amount =
          Decimal.div(value_amount, rate_from)
          |> Decimal.round(2)
          |> Decimal.to_float()

        {:ok, converted_amount}

      false ->
        {:error, "Coin (#{from}) not valid compared to ISO 4271"}
    end
  end

  @doc """

  """
  @spec exchange(float, atom, atom) :: {:ok, float} | {:error, String.t()}
  def exchange(amount, from, to) do
    usd_value = FinancialSystem.Converter.exchange!(amount, from, :USD)
    FinancialSystem.Converter.exchange!(usd_value, :USD, to)
  end

  @doc """

  """
  @spec exchange!(float, atom, atom) :: float | no_return
  def exchange!(amount, from_coin, to_coin) do
    case exchange(amount, from_coin, to_coin) do
      {:ok, result} -> result
      {:error, reason} -> raise(reason)
    end
  end
end
