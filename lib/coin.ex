defmodule FinancialSystem.Coin do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "http://apilayer.net/api")
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.DecodeJson)

  @api_key "17dab43de91dedc4ea8e0dc86ec3ae69"

  @moduledoc """
  The 'Coin' module it has functions that handles the txt file that has currency information and checks if the currency is valid as stipulated by ISO 4217.
  Rates and currencies are requested from the website https://currencylayer.com/ using a free trial api. 
  To handle the information obtained behind the requests, libs tesla, jason and hackney were used.
  """

  @doc """  
  The function currency_list displays a list with the atoms that correspond to all currencies considered by ISO 4217. 

  #Example
    iex(2)> FinancialSystem.Coin.currency_list
    [:XAF, :LKR, :MVR, :MUR, :OMR, :HRK, :GTQ, :NZD, :IMP, :HKD, :YER, :WST, :HNL,
    :MNT, :KYD, :NIO, :AZN, :CAD, :ETB, :ILS, :SCR, :BYN, :COP, :ISK, :MGA, :VUV,
    :GGP, :BHD, :LBP, :CUP, :RON, :SVC, :AED, :JEP, :XPF, :TZS, :THB, :GNF, :MKD,
    :TOP, :GHS, :IQD, :AFN, :DZD, :PLN, :BND, :USD, :XAU, :LYD, :XAG, ...]
  """  

  def currency_list() do
    {:ok, response} = get("/list?%20access_key=#{@api_key}")
    response = response.body
    response
    |> Map.fetch("currencies")
    |> elem(1)    
    |> Enum.map(fn {currency, _descrition} -> String.to_atom(currency) end)
  end

  @doc """   
  The currency rate function displays a list with currency quotes based on the dollar, 
  values ​​updated due to the information being taken from a specific currency quote api. 

  #Example
    iex(1)> FinancialSystem.Coin.currency_rate
    [
      {"GMD", 50.85039},
      {"UGX", 3674.701304},
      {"PYG", 6543.400804},
      {"QAR", 3.641038},
      {"BMD", 1},
      {"KPW", 900},
      {"NZD", 1.575313},
      {"HUF", 310.530388},
      {"SHP", 0.77161},
      {"ZMK", 9001.203593},
      {"MGA", 3720.000347},
      {"BYR", 19600},
      {"XAF", 607.33948},
      {"MVR", 15.403741},
      {"DZD", 120.750393},
      {"FJD", 2.21625},
      {"NGN", 363.503727},
      {"SYP", 514.99882},
      {"GHS", 5.32039},
      {"SVC", 8.753697},
      {"NOK", 9.280904},
      {"MXN", 18.911104},
      {"MAD", 9.702504},
      {"SDG", 53.250372},
      {"AOA", 492.989504},
      {"GEL", 2.82504},
      {"MRO", 357.000035},
      {"PKR", 154.303704},
      {"LRD", 197.000348},
      {"SGD", 1.39764},
      {"ZAR", 15.00329},
      {"SLL", 9725.000339},
      {"KGS", 69.850385},
      {"MNT", 2762.596916},
      {"SRD", 7.458038},
      {"NPR", 115.24929},
      {"MMK", 1452.766404},
      {"BDT", 84.98486},
      {"TOP", 2.320804},
      {"KYD", 0.833708},
      {"RON", 4.423204},
      {"DJF", 177.720394},
      {"ANG", 1.790828},
      {"SEK", 9.72032},
      {"RUB", 64.074304},
      {"MOP", 8.02648},
      {"CDF", 1696.000362},
      {"CRC", 570.39296},
      {"GYD", ...},
      {...},
      ...
    ]
  """  

  def currency_rate() do
    {:ok, response} = get("live?access_key=#{@api_key}&format=1")
    response = response.body 
    |> Map.fetch("quotes")
    |> elem(1)
    
    response_value =
      response
      |> Enum.map(fn {_currency, value} -> value end)

    # deixar apenas dos simbolos de moedas 
    response_currecy =
      response
      |> Enum.map(fn {currency, _value} -> currency end)
      # remover o prefixo USD
      |> Enum.map(fn x -> prefix_remove(x, "USD") end)

    Enum.zip(response_currecy, response_value)    
  end

  # function to remove prefix of a string
  defp prefix_remove(full, prefix) do
    base = byte_size(prefix)
    binary_part(full, base, byte_size(full) - base)
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
    currency_list()
    |> Enum.any?(fn currency -> currency == currency_validetion end)
  end
end
