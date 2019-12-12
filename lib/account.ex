defmodule FinancialSystem.Account do
  @moduledoc """
  Account structure module and function to create an account.
  """


  # @enforce_keys [:name, :email]
  defstruct name: "", email: "", currency: "BRL", balance: 0

  alias __MODULE__

  @doc """
  Function for create a new account.

  ##Exemples
    iex(2)> account1 = Account.new(name: "Henry", email: "henrygama@gmail.com", currency: "BRL")
    %FinancialSystem.Account{
      balance: 0,
      currency: "BRL",
      email: "henrygama@gmail.com",
      name: "Henry"
  }
  """

  @spec new([{:currency, any} | {:email, any} | {:name, any}, ...]) :: FinancialSystem.Account.t()
  def new(name: name, email: email, currency: currency) do
    %Account{name: name, email: email, currency: currency}
  end

end

