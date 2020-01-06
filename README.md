# FinancialSystem

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `financial_system` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:financial_system, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/financial_system](https://hexdocs.pm/financial_system).

# Financial-system
A simple system designed for Stone's technical challenge, this system was developed in the Elixir language. It has module and functions that allow the creation of an account, analyze if the currency is in the standards of [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217), conversion of values ​​between currencies of different, transfer between accounts, deposit of a value and debit.

# Requirements and Dependencies
* [Elixir](https://elixir-lang.org/) 1.9 - Used language to develop of the system.
* [Decimal](https://hexdocs.pm/decimal/readme.html) 1.8 - For deal with operation arithmetic with float.
* [Money](https://hexdocs.pm/money/Money.html) 1.6.1 - For deal with de operation with money and symbol of currency.

# Usando
* `mix deps.get` installing dependencies.
* `iex -S mix` starting Elixir's interactive shell.

# Teste
* `mix test` to run unit tests;
* `mix format` to format the code ensuring proper style (`.formatter.exs` rules);
* `mix dialyzer` to run dialyxir static code analysys;