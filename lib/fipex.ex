defmodule Fipex do
  use HTTPoison.Base

  @endpoint "https://veiculos.fipe.org.br/api/veiculos/"

  def vehicle_types, do: %{car: 1, bike: 2, truck: 3}

  def process_url(url) do
    @endpoint <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!()
  end
end
