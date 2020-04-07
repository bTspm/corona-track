class CoronaService
  def countries
    response = Api::Client.new.get
    countries = _update_country_names(response.body)
    countries.map do |country, stats|
      CountryData.from_github_response(country_code_or_name: country, stats: stats)
    end
  end

  def country_by_code(code)
    countries.detect { |country| country.alpha3 == code }
  end

  private

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
