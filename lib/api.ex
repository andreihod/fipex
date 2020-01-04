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