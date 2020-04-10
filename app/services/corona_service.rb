class CoronaService
  def countries
    response = Api::Client.new.get("https://pomber.github.io/covid19/timeseries.json")
    countries = _update_country_names(response.body)
    countries.map do |country, stats|
      CountryData.from_github_response(country_code_or_name: country, stats: stats)
    end
  end

  def country_by_code(code:, countries:)
    countries.detect { |country| country.alpha2 == code }
  end

  def global_latest_stats
    _ninja_store.global_latest_stats
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
