defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  setup_all do
    {:ok,
     [
       account1: FinancialSystem.Account.new("João Bacara", "bacara@gmail.com", 500_00, :BRL),
       account2: FinancialSystem.Account.new("Marcos Kiba", "kiba@gmail.com", 500_00, :BRL),
       account3: FinancialSystem.Account.new("Gleison Cupu", "cupu@gmail.com", 5000_00, :AFN),
       account4: FinancialSystem.Account.new("Haroldo Ramos", "haroldo@gmail.com", 500_00, :USD)
     ]}
  end

  test "User should be able to transfer money to another account", %{account1: from_account, account2: to_accounts} do
    assert FinancialSystem.transaction(from_account, [to_accounts], 10_00)
  end

  test "User cannot transfer if not enough money available on the account", %{account1: from_account} do
    assert FinancialSystem.balance_enough?(from_account, 2000_00) == false 
  end

  test "A transfer should be cancelled if an error occurs" do
     # Transfer with invalid account
     assert_raise FunctionClauseError, fn -> FinancialSystem.transaction(account1, nil, 50_00) end
  end

  test "A transfer can be splitted between 2 or more accounts", %{
    account1: from_account,
    account2: account2,
    account3: account3,
    account4: account4
    } do
    to_accounts = [account2, account3, account4]
    # Split with wrong percentage
    assert_raise ArgumentError, fn -> FinancialSystem.transaction(account1, to_accounts, 100_00) end
  end

  test "User should be able to exchange money between different currencies" do
    assert false
  end

  test "Currencies should be in compliance with ISO 4217" do
    assert false
  end
end
