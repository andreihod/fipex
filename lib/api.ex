defmodule Fipex.Api do
  def fetch_reference_dates do
    Fipex.post('ConsultarTabelaDeReferencia', '')
      |> process_response
  end

  defp process_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, body}
  end

  defp process_response({:ok, %HTTPoison.Response{status_code: status_code}}) do
    {:error, 'Requisition failed with status code #{status_code}'}
  end

  defp process_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end