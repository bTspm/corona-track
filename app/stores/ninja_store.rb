class NinjaStore
  def latest_global_stats
    response = _client.latest_global_stats
    CoronaData.from_ninja_global_response(response.body)
  end

  def global_time_series
    response = _client.global_time_series
    TimeSeries.from_global_ninja_response(response.body)
  end

  def latest_countries_stats
    response = _client.latest_countries_stats
    CoronaData.from_ninja_countries_response(response.body)
  end

  private

  def _client
    @client ||= Api::NinjaClient.new
  end
end
