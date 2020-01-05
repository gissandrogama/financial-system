defmodule FinancialSystem do
  alias FinancialSystem.Account, as: Account
  alias FinancialSystem.Converter, as: Converter

  @moduledoc """
  After you create accounts with the Account module, you can register with the functions available in
  the FinancialSystem module.
  """

  @doc """
  Transaction function is in charge of making transfers between accounts, the accounts may without the same or different
  currencies, if they are different currencies the value is converted.

  The role receives an account and a list of accounts.

  ##Examples

  ####transfer with same currency accounts, :BRL to :BRL.

  iex(9)> {account1, [account4]} = FinancialSystem.transaction(account1, [account4], 10_00)
  {%FinancialSystem.Account{
   balance: %Money{amount: 49000, currency: :BRL},
   email: "henrygama@gmail.com",
   name: "Henry"
  },
  [
   %FinancialSystem.Account{
     balance: %Money{amount: 51000, currency: :BRL},
     email: "rangel@gmail.com",
     name: "Rangel"
   }
  ]}

  ####transfer with different currency accounts
  iex(4)> {account3, [account1, account2]} = FinancialSystem.transaction(account3, [account1, account2], 1000_00)
  {%FinancialSystem.Account{
   balance: %Money{amount: 400000, currency: :AFN},
   email: "gissandrogama@gmail.com",
   name: "Gissandro"
  },
  [
   %FinancialSystem.Account{
     balance: %Money{amount: 52281, currency: :BRL},
     email: "henrygama@gmail.com",
     name: "Henry"
   },
   %FinancialSystem.Account{
     balance: %Money{amount: 50721, currency: :USD},
     email: "luanagama@gmail.com",
     name: "Luana"
   }
  ]}

  checking how much each account has balance
  iex(5)> account1
  %FinancialSystem.Account{
    balance: %Money{amount: 52281, currency: :BRL},
    email: "henrygama@gmail.com",
    name: "Henry"
  }
  iex(6)> account2
  %FinancialSystem.Account{
    balance: %Money{amount: 50721, currency: :USD},
    email: "luanagama@gmail.com",
    name: "Luana"
  }
  iex(7)> account3
    %FinancialSystem.Account{
    balance: %Money{amount: 400000, currency: :AFN},
    email: "gissandrogama@gmail.com",
    name: "Gissandro"
  }
  """

  @spec transaction(Account.t(), [Account.t()], integer) ::
          {Account.t(), [Account.t()]} | {:error, String.t()}
  def transaction(from_account, to_accounts, value) when is_list(to_accounts) do
    case balance_enough?(from_account.balance, value) do
      true ->
        value_float = value / 100

        split_value = value_float / length(to_accounts)

        values_transfer =
          Enum.map(to_accounts, fn accounts ->
            Converter.exchange(
              split_value,
              from_account.balance.currency,
              accounts.balance.currency
            )
            |> to_int()
          end)

        accounts_values = Enum.zip(to_accounts, values_transfer)

        transaction_result =
          Enum.map(accounts_values, fn {accounts, values} ->
            deposit(accounts, accounts.balance, :balance, values)
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
  The function of debiting a value to a specific account.
  It takes as its argument an account structure, %Money{}, an atom and an integer value.

  ##Examples
  iex(8)> account1 = FinancialSystem.debit(account1, account1.balance, :balance, 10_00)
  %FinancialSystem.Account{
    balance: %Money{amount: 51281, currency: :BRL},
    email: "henrygama@gmail.com",
    name: "Henry"
  }
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
  Funciotion to deposit, a value in a account specifies.
  This function also receive the sames arguments what the function debit.

  ##Examples
  iex(9)> account1 = FinancialSystem.deposit(account1, account1.balance, :balance, 10_00)
  %FinancialSystem.Account{
    balance: %Money{amount: 52281, currency: :BRL},
    email: "henrygama@gmail.com",
    name: "Henry"
  }
  """

  @spec deposit(Account.t(), Money.t(), atom, integer) :: Account.t()
  def deposit(account, money, key, value) do
    current = Money.add(money, value)
    up_account(account, key, current)
  end

  @doc """
  The function 'balance_enough?' checks if the account have balance to do  operations.
  She return true ou false.

  ##Examples
  iex(10)> FinancialSystem.balance_enough?(account1.balance, 100_00)
  true
  iex(11)> FinancialSystem.balance_enough?(account1.balance, 1000_00)
  false
  """
  @spec balance_enough?(Money.t(), integer) :: boolean
  def balance_enough?(balance, value) do
    balance.amount >= value or balance.amount < 0
  end

  @spec up_account(Account.t(), atom, Money.t()) :: Account.t()
  defp up_account(account, key, current) do
    Map.put(account, key, current)
  end

  @doc """
  The function 'consult' shows the balance more friendly way.

  ##Examples
  iex(12)> FinancialSystem.consult(account1)
  Henry, your balance is: R$522.81
  :ok
  iex(13)> FinancialSystem.consult(account2)
  Luana, your balance is: $507.21
  :ok
  """
  @spec consult(atom | %{balance: Money.t(), name: any}) :: :ok
  def consult(account) do
    IO.puts("#{account.name}, your balance is: #{Money.to_string(account.balance)}")
  end

  defp to_int(money), do: trunc(100 * money)
end
