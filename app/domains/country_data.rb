class CountryData < RegionData
  attr_reader :alpha2,
              :alpha3,
              :name,
              :unofficial_names

  def initialize(args = {})
    args.merge!({ is_country: true })
    super(args)
    @alpha2 = args[:alpha2]
    @alpha3 = args[:alpha3]
    @unofficial_names = args[:unofficial_names]
  end

  def self.from_ninja_response(response)
    country_code_or_name = response.dig("countryInfo", "iso2") || response[:country]
    country = _country_by_name_or_code(country_code_or_name)

    args = {
      alpha2: country&.alpha2 || response.dig("countryInfo", "iso2"),
      alpha3: country&.alpha3 || response.dig("countryInfo", "iso3"),
      name: country&.name || country_code_or_name,
      unofficial_names: country&.unofficial_names
    }

    new(args)
  end

  def mortality_rate
    _latest_stat.mortality_rate
  end

  def not_country?
    alpha2.blank?
  end

  def total_active
    _latest_stat.active
  end

  def total_confirmed
    _latest_stat.confirmed
  end

  def total_deaths
    _latest_stat.deaths
  end

  def total_recovered
    _latest_stat.recovered
  end

  def self._country_by_name_or_code(name_or_code)
    Country.find_country_by_name(name_or_code) ||
      Country[name_or_code] ||
      Country.find_country_by_alpha3(name_or_code)
  end

  private_class_method :_country_by_name_or_code

  private

  def _latest_stat
    @_latest_stat ||= stats.max_by(&:date)
  end
end
