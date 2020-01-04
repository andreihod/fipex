defmodule Fipex.ApiTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
  end

  @valid_reference_date 250
  @invalid_reference_date 666
  @valid_vehicle_type 1
  @invalid_vehicle_type 66
  @valid_make_code 23
  @invalid_make_code 666
  @valid_model_code 1010
  @invalid_model_code -1
  @valid_model_year_code "1990-1"
  @invalid_model_year_code "2019-2"

  test "fetch_reference_dates/0" do
    use_cassette "fetch_reference_dates" do
      {:ok, dates} = Fipex.Api.fetch_reference_dates()
      assert Enum.at(dates, 0) == %{"Codigo" => 250, "Mes" => "janeiro/2020 "}
      assert Enum.at(dates, 1) == %{"Codigo" => 249, "Mes" => "dezembro/2019 "}
      assert Enum.at(dates, 2) == %{"Codigo" => 248, "Mes" => "novembro/2019 "}
      assert Enum.count(dates) == 229
    end
  end

  test "fetch_makes/2 returns a list of makes" do
    use_cassette "fetch_makes" do
      {:ok, makes} = Fipex.Api.fetch_makes(@valid_reference_date, @valid_vehicle_type)
      assert Enum.at(makes, 0) == %{"Label" => "Acura", "Value" => "1"}
    end
  end

  test "fetch_makes/2 fails when a parameter is invalid" do
    use_cassette "fetch_makes_invalid" do
      {:error, reason} = Fipex.Api.fetch_makes(@invalid_reference_date, @valid_vehicle_type)
      assert reason == "nadaencontrado"

      {:error, reason} = Fipex.Api.fetch_makes(@valid_reference_date, @invalid_vehicle_type)
      assert reason == "nadaencontrado"
    end
  end

  test "fetch_models/3 returns a list of models for a given make" do
    use_cassette "fetch_models" do
      {:ok, models} =
        Fipex.Api.fetch_models(@valid_reference_date, @valid_vehicle_type, @valid_make_code)

      assert Enum.at(models["Modelos"], 103) ==
               %{"Label" => "Chevette L / SL / SL/e / DL / SE 1.6", "Value" => 1010}
    end
  end

  test "fetch_models/3 fails when a parameter is invalid" do
    use_cassette "fetch_models_invalid" do
      {:error, reason} =
        Fipex.Api.fetch_models(@valid_reference_date, @valid_vehicle_type, @invalid_make_code)

      assert reason == "nadaencontrado"
    end
  end

  test "fetch_model_years/4 returns a list of years for a given model" do
    use_cassette "fetch_model_years" do
      {:ok, model_year} =
        Fipex.Api.fetch_model_years(
          @valid_reference_date,
          @valid_vehicle_type,
          @valid_make_code,
          @valid_model_code
        )

      assert Enum.at(model_year, 3) == %{"Label" => "1990 Gasolina", "Value" => "1990-1"}
    end
  end

  test "fetch_model_years/4 fails when a parameter is invalid" do
    use_cassette "fetch_model_years_invalid" do
      {:error, reason} =
        Fipex.Api.fetch_model_years(
          @valid_reference_date,
          @valid_vehicle_type,
          @valid_make_code,
          @invalid_model_code
        )

      assert reason == "nadaencontrado"
    end
  end

  test "fetch_price/5 returns a map with data for given model/year/reference_date" do
    use_cassette "fetch_price" do
      {:ok, model_price} =
        Fipex.Api.fetch_price(
          @valid_reference_date,
          @valid_vehicle_type,
          @valid_make_code,
          @valid_model_code,
          @valid_model_year_code
        )

      assert model_price == %{
               "Valor" => "R$ 6.232,00",
               "Marca" => "GM - Chevrolet",
               "Modelo" => "Chevette L / SL / SL/e / DL / SE 1.6",
               "AnoModelo" => 1990,
               "Combustivel" => "Gasolina",
               "CodigoFipe" => "004030-4",
               "MesReferencia" => "janeiro de 2020 ",
               "Autenticacao" => "2w1nr9pn8hp",
               "TipoVeiculo" => 1,
               "SiglaCombustivel" => "G",
               "DataConsulta" => "sábado, 4 de janeiro de 2020 15:05"
             }
    end
  end

  test "fetch_price/5 fails when a parameter is invalid" do
    use_cassette "fetch_price_invalid" do
      {:error, reason} =
        Fipex.Api.fetch_price(
          @valid_reference_date,
          @valid_vehicle_type,
          @valid_make_code,
          @valid_model_code,
          @invalid_model_year_code
        )

      assert reason == "nadaencontrado"
    end
  end
end
