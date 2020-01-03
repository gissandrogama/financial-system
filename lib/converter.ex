defmodule FinancialSystem.Converter do
  alias FinancialSystem.Coin, as: Coin
  alias FinancialSystem.Account, as: Account

  @moduledoc """
  Module that treats operations such as currency conversion.
  """

  @doc false
  def exchange(amount, from_coin, to_coin) when from_coin == to_coin do
    case Coin.is_valid?(from_coin) do
      true -> amount
      false -> {:error, "1Coin (#{from_coin}) not valid compared to ISO 4271"}
    end

    case Coin.is_valid?(to_coin) do
      true -> amount
      false -> {:error, "2Coin (#{to_coin}) not valid compared to ISO 4271"}
    end
  end

  def exchange(amount, from, :USD) do
    case Coin.is_valid?(from) do
      true ->
        rates = FinancialSystem.Coin.examiner("currency_rates.txt")
        value_amount = Decimal.from_float(amount)
        rate_from = Decimal.from_float(rates[from])

        converted_amount =
          Decimal.div(value_amount, rate_from)
          |> Decimal.round(2)
          |> Decimal.to_float()
          |> to_int()

        converted_amount

      false ->
        {:error, "3Coin (#{from}) not valid compared to ISO 4271"}
    end
  end

  def exchange(amount, :USD, to) do
    case Coin.is_valid?(to) do
      true ->
        rates = FinancialSystem.Coin.examiner("currency_rates.txt")
        value_amount = Decimal.from_float(amount)
        rate_to = Decimal.from_float(rates[to])

        converted_amount =
          Decimal.mult(value_amount, rate_to)
          |> Decimal.round(2)
          |> Decimal.to_float()
          |> to_int()

        converted_amount

      false ->
        {:error, "4Coin (#{to}) not valid compared to ISO 4271"}
    end
  end

  @doc """


  ##Examples
  """
  @spec exchange(float, atom, atom) :: float | {:error, String.t()}
  def exchange(amount, from, to) do
    case !Coin.is_valid?(from) or !Coin.is_valid?(to) do
      true ->
        {:error, "Coins (#{from} 'or' #{to}) not valid compared to ISO 4271"}

      false ->
        usd_value = FinancialSystem.Converter.exchange(amount, from, :USD)
        FinancialSystem.Converter.exchange(usd_value, :USD, to)
    end
  end

  # @doc """

  # """
  # @spec exchange!(float, atom, atom) :: float | no_return
  # def exchange!(amount, from_coin, to_coin) do
  #   case exchange(amount, from_coin, to_coin) do
  #     {:ok, result} -> result
  #     {:error, reason} -> reason
  #   end
  # end

  defp to_int(value), do: round(100 * value)
end
