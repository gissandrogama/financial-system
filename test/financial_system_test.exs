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

  test "User should be able to transfer money to another account", %{account1: from_account, account2: to_account} do
    assert FinancialSystem.transaction(from_account, [to_account], 10_00)
  end

  test "User cannot transfer if not enough money available on the account", %{account1: from_account, account2: to_account} do
    assert_raise RuntimeError, fn -> FinancialSystem.transaction(from_account, [to_account], 2000_00)
    assert FinancialSystem.balance_enough?(from_account, 2000_00) 
  end

  test "A transfer should be cancelled if an error occurs" do
    assert false
  end

  test "A transfer can be splitted between 2 or more accounts" do
    assert false
  end

  test "User should be able to exchange money between different currencies" do
    assert false
  end

  test "Currencies should be in compliance with ISO 4217" do
    assert false
  end
end
