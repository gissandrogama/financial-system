defmodule FinancialSystem do
  alias FinancialSystem.Account, as: Account
  alias FinancialSystem.Converter, as: Converter

  @moduledoc """
  Documentation for FinancialSystem.
  """

  @doc """

  ##Examples

  """

  @spec translation(Account.t(), Account.t() | [Account.t()], integer) ::
    {Account.t(), Account.t() | [Account.t()]} | {:error, String.t()}
  def translation(from_account, to_account, value) do
    case balance_enough?(from_account, value) do
      true ->
        split_value =
        value / length(to_account)
        |> Decimal.from_float()
        |> Decimal.round()
      false ->
        {:error, "Not enough money. (balance #{from_account.balance.amount})"}
    end
  end

  @doc """
  Funciotion to debit of a value in a account specifies

  ## Examples
  """

  @spec debit(Account.t(), Money.t(), atom, integer) :: Account.t() | {:error, String.t()}
  def debit(account, money, key, value) do
    case balance_enough?(money, value) do
      true ->
        current = Money.subtract(money, value)
        up_account(account, key, current)

      false ->
        {:error, "Not enough money. (balance #{money.amount})"}
    end
  end

  @doc """
  Funciotion to debit of a value in a account specifies

  ##Examples
  """

  @spec deposit(Account.t(), Money.t(), atom, integer) :: Account.t()
  def deposit(account, money, key, value) do
    current = Money.add(money, value)
    up_account(account, key, current)
  end

  @spec up_account(Account.t(), atom, Money.t()) :: Account.t()
  defp up_account(account, key, balance_current) do
    Map.put(account, key, balance_current)
  end

  @spec balance_enough?(Money.t(), integer) :: boolean
  def balance_enough?(balance, value) do
    balance.amount >= value
  end
end
