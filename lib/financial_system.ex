defmodule FinancialSystem do
  alias FinancialSystem.Account, as: Account
  alias FinancialSystem.Converter, as: Converter

  @moduledoc """
  Documentation for FinancialSystem.
  """

  @doc """

  ##Examples

  """

  @spec transaction(Account.t(), [Account.t()], integer) ::
          {Account.t(), [Account.t()]} | {:error, String.t()}
  def transaction(from_account, to_account, value) when is_list(to_account) do
    case balance_enough?(from_account.balance, value) do
      true ->
        split_value = div(value, length(to_account))

        transaction_result =
          Enum.map(to_account, fn x ->
            deposit(x, x.balance, :balance, split_value)
          end)

        updated_to_accounts =
          for dest_result <- transaction_result do
            dest_result
          end

        up_from_account = debit(from_account, from_account.balance, :balance, value)
        {up_from_account, updated_to_accounts}

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
  defp up_account(account, key, current) do
    Map.put(account, key, current)
  end

  @spec balance_enough?(Money.t(), integer) :: boolean
  def balance_enough?(balance, value) do
    balance.amount >= value
  end
end
