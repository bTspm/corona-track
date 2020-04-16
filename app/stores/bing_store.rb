class BingStore
  def latest_state_or_province_stats_by_country_code(code)
    response = _client.country_stats
    CoronaData.from_bing_global_response(code: code,response: response.body)
  end

  private

  def _client
    @client ||= Api::BingClient.new
  end
end
