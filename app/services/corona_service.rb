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

  def _country_keys
    {
      "Burma": "Myanmar",
      "Congo (Brazzaville)": "CG",
      "Congo (Kinshasa)": "CD",
      "Cote d'Ivoire": "Ivory Coast",
      "Taiwan*": "Taiwan"
    }
  end

  def _update_country_names(countries)
    _country_keys.each do |old_key, new_key|
      countries[new_key] = countries.delete(old_key)
    end
    countries
  end
end
