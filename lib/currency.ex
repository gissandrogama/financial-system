defmodule FinancialSystem.Currency do
  @moduledoc """
  Module that has functions for handling currency operations
  """

  @doc """
  Parse of files of text whant have information of currences 
  """
  @spec parse(String.t()) :: [key: float]
  def parse(file) do
    file
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn x ->
      [currency, rate] = String.split(x, ":")

      key =
        currency
        |> String.trim("\"")
        |> String.to_atom()

      {key, String.to_float(rate)}
    end)
  end
end
