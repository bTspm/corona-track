class CoronaService
  def latest_global_stats
    _ninja_store.latest_global_stats
  end

  def global_time_series
    _ninja_store.global_time_series
  end

  def latest_countries_stats
    _ninja_store.latest_countries_stats
  end

  def countries_list
    _ninja_store.countries_list.select(&:country?)
  end

  def latest_country_stats_by_country_code(code)
    _ninja_store.latest_country_stats_by_country_code(code)
  end

  def country_time_series_by_country_code(code)
    _ninja_store.country_time_series_by_country_code(code)
  end

  def latest_state_or_province_stats_by_country_code(code)
    _bing_store.latest_state_or_province_stats_by_country_code(code)
  end

  private

  def _bing_store
    BingStore.new
  end

  def _ninja_store
    ::NinjaStore.new
  end
end
