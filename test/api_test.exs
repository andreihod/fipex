defmodule Fipex.ApiTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
  end

  test "fetch_reference_dates/0" do
    use_cassette "fetch_reference_dates" do
      {:ok, dates} = Fipex.Api.fetch_reference_dates
      assert Enum.at(dates, 0) == %{"Codigo" => 250, "Mes" => "janeiro/2020 "}
      assert Enum.at(dates, 1) == %{"Codigo" => 249, "Mes" => "dezembro/2019 "}
      assert Enum.at(dates, 2) == %{"Codigo" => 248, "Mes" => "novembro/2019 "}
      assert Enum.count(dates) == 229
    end
  end
end
