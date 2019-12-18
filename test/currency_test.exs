defmodule CurrencyTest do
    use ExUnit.Case
    doctest FinancialSystem.Currency

    #Currency verification test if in accordance with ISO 4217
    
    test "check if currency abbreviation exists according to ISO 4217" do
        assert FinancialSystem.Currency.is_valid?(:BRL) == true
    end

    test "check if currency abbreviation does not exist according to ISO 4217" do
        assert FinancialSystem.Currency.is_valid?(:LLL) == false
    end
    
    
end