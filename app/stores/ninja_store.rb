class NinjaStore
  def global_latest_stats
    response = _client.global_latest_stats
    CoronaData.from_ninja_global_response(response.body)
  end

  def global_time_series
    response = _client.global_time_series
    TimeSeries.from_ninja_response(response.body)
  end

  def latest_countries_stats
    response = _client.latest_countries_stats

    response.body.map do |item|
      CoronaData.from_ninja_country_response(item)
    end
  end

  private

  def _client
    @client ||= Api::NinjaClient.new
  end
end
