defmodule GitHub do
    use Tesla
    #alias FinancialSystem.Coin

    plug Tesla.Middleware.BaseUrl, "http://apilayer.net/api"
    plug Tesla.Middleware.JSON
    plug Tesla.Middleware.DecodeJson
    
    @api_key "17dab43de91dedc4ea8e0dc86ec3ae69"

    def currency_list() do
        {:ok, response} = get("/list?%20access_key=#{@api_key}")
        response.body
    end

    def currency_rate() do
        {:ok, response} = get("live?access_key=#{@api_key}&format=1")
        response = response.body
        response = Map.fetch(response, "quotes")
        response = elem(response, 1)
        #response = Map.to_list(response)
        response_currency = Enum.map(response, fn {currency, value} -> currency end)
        response_currency = Enum.map(response_currency, fn x -> prefix_remove(x, "USD") end)     

    end

    defp prefix_remove(full, prefix) do
        base = byte_size(prefix)
        binary_part(full, base, byte_size(full) - base)
    end

end
