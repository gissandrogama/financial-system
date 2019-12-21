defmodule CoinTest do
  use ExUnit.Case
  doctest FinancialSystem.Coin

  # Currency verification test if in accordance with ISO 4217

  test "check if currency abbreviation exists according to ISO 4217" do
    assert FinancialSystem.Coin.is_valid?(:BRL) == true
  end

  test "check if currency abbreviation does not exist according to ISO 4217" do
    assert FinancialSystem.Coin.is_valid?(:LLL) == false
  end
end
