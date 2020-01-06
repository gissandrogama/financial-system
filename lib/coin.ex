defmodule FinancialSystem.Coin do
  @moduledoc """
  The 'Coin' module pussi functions that handles the txt file that has currency information and checks if the currency is valid as stipulated by ISO 4217.
  """

  @doc """
  Parse of files of text that have information of currencies and exchange values based in the dollar.

  ##Examples
  FinancialSystem.Coin.examiner('/home/henry/tech_challenge/financial-system/currency_rates.txt')
  [
    AED: 3.672973,
    AFN: 69.3525,
    ALL: 107.65,
    AMD: 480.825,
    ANG: 1.784744,
    AOA: 203.14,
    ARS: 19.6576,
    AUD: 1.234472,
    AWG: 1.789995,
    AZN: 1.689,
    BAM: 1.570105,
    BBD: 2.0,
    BDT: 83.287,
    BGN: 1.569349,
    BHD: 0.37699,
    BIF: 177.0,
    BMD: 1.0,
    BND: 1.307743,
    BOB: 6.909021,
    BRL: 3.164171,
    BSD: 1.0,
    BTC: 9.9312436e-5,
    BTN: 63.58307,
    BWP: 9.533843,
    BYN: 1.977403,
    BZD: 2.00969,
    CAD: 1.227243,
    CDF: 1601.0,
    CHF: 0.933104,
    CLF: 0.02275,
    CLP: 603.3,
    CNH: 6.288834,
    CNY: 6.2891,
    COP: 2840.0,
    CRC: 568.16,
    CUC: 1.0,
    CUP: 25.5,
    CVE: 89.3,
    CZK: 20.2828,
    DJF: 178.57,
    DKK: 5.970466,
    DOP: 48.7425,
    DZD: 113.3535,
    EGP: 17.693,
    ERN: 15.135,
    ETB: 27.406384,
    EUR: 0.802251,
    FJD: 2.004995,
    FKP: 0.7054,
    GBP: 0.7054,
    ...
  ]

  """

  @spec examiner(String.t()) :: [key: float]
  def examiner(file) do
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

  @doc """
  Function that validates the currency according to the code established by ISO 4217.

  ##Examples
  iex(2)> FinancialSystem.Coin.is_valid?(:USD)
  true
  iex(3)> FinancialSystem.Coin.is_valid?(:USS)
  false
  """
  @spec is_valid?(atom) :: boolean()
  def is_valid?(currency_validetion) do
    FinancialSystem.Coin.examiner("currency_rates.txt")
    |> Keyword.keys()
    |> Enum.any?(fn currency -> currency == currency_validetion end)
  end
end
