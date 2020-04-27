class NinjaStore
  def countries_list
    response = _client.latest_countries_stats
    RegionData.from_countries_ninja_response(response.body)
  end

  def country_time_series_by_country_code(code)
    response = _client.country_time_series_by_country_code(code)
    TimeSeries.from_country_ninja_response(response.body)
  end

  def global_time_series
    response = _client.global_time_series
    TimeSeries.from_global_ninja_response(response.body)
  end

  def latest_countries_stats
    response = _client.latest_countries_stats
    CoronaData.from_ninja_countries_response(response.body)
  end

  def latest_country_stats_by_country_code(code)
    response = _client.latest_country_stats_by_country_code(code)
    CoronaData.from_ninja_country_response(response.body)
  end

  def latest_global_stats
    response = _client.latest_global_stats
    CoronaData.from_ninja_global_response(response.body)
  end

  private

  def _client
    @client ||= Api::NinjaClient.new
  end
end
