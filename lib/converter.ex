defmodule FinancialSystem.Converter do
  alias FinancialSystem.Currency, as: Currency

  @moduledoc """
  Module that treats operations such as currency conversion.
  """

  @doc """

  """
  def exchenge(amount, from, to) when from == to do
    case Currency.is_valid?(from) do
      true -> {:ok, amount}
      false -> {:error, "Coin (#{from}) not valid compared to ISO 4271"}
    end
  end

  @spec exchenge(any, :USD, atom) :: {:error, <<_::64, _::_*8>>} | {:ok, float}
  def exchenge(amount, :USD, to) do
    case Currency.is_valid?(to) do
      true ->
        rates = FinancialSystem.Currency.parse("currency_rates.txt")
        value_amount = Decimal.new(amount)
        rate_to = Decimal.new(rates[to])

        converted_amount =
          Decimal.mult(value_amount, rate_to)
          |> Decimal.round(2)
          |> Decimal.to_float()

        {:ok, converted_amount}

      false ->
        {:error, "Coin (#{to}) not valid compared to ISO 4271"}
    end
  end

  def exchenge(amount, from, :USD) do
    case Currency.is_valid?(from) do
      true ->
        rates = FinancialSystem.Currency.parse("currency_rates.txt")
        value_amount = Decimal.new(amount)
        rate_from = Decimal.new(rates[from])

        converted_amount =
          Decimal.mult(value_amount, rate_from)
          |> Decimal.round(2)
          |> Decimal.to_float()

        {:ok, converted_amount}

      false ->
        {:error, "Coin (#{from}) not valid compared to ISO 4271"}
    end
  end


end
