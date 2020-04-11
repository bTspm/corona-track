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

  private

  def _ninja_store
    ::NinjaStore.new
  end
end
