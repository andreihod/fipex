defmodule Fipex.Api do
  def fetch_reference_dates do
    Fipex.post('ConsultarTabelaDeReferencia', []) |> process_response
  end

  def fetch_makes(reference_date_code, vehicle_type) do
    params = [codigoTabelaReferencia: reference_date_code, codigoTipoVeiculo: vehicle_type]
    Fipex.post('ConsultarMarcas', {:form, params}) |> process_response
  end

  def fetch_models(reference_date_code, vehicle_type, make_code) do
    params = [
      codigoTabelaReferencia: reference_date_code,
      codigoTipoVeiculo: vehicle_type,
      codigoMarca: make_code
    ]

    Fipex.post('ConsultarModelos', {:form, params}) |> process_response
  end

  def fetch_model_years(reference_date_code, vehicle_type, make_code, model_code) do
    params = [
      codigoTabelaReferencia: reference_date_code,
      codigoTipoVeiculo: vehicle_type,
      codigoMarca: make_code,
      codigoModelo: model_code
    ]

    Fipex.post('ConsultarAnoModelo', {:form, params}) |> process_response
  end

  def fetch_price(reference_date_code, vehicle_type, make_code, model_code, model_year_code) do
    [year_model, fuel_type] = String.split(model_year_code, "-")

    params = [
      codigoTabelaReferencia: reference_date_code,
      codigoTipoVeiculo: vehicle_type,
      codigoMarca: make_code,
      codigoModelo: model_code,
      anoModelo: year_model,
      codigoTipoCombustivel: fuel_type,
      tipoConsulta: "tradicional"
    ]

    Fipex.post('ConsultarValorComTodosParametros', {:form, params}) |> process_response
  end

  defp process_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    case body do
      %{"erro" => reason} -> {:error, reason}
      _ -> {:ok, body}
    end
  end

  defp process_response({:ok, %HTTPoison.Response{status_code: status_code}}) do
    {:error, 'Requisition failed with status code #{status_code}'}
  end

  defp process_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
