class CountryData
  attr_reader :alpha2,
              :alpha3,
              :name,
              :stats

  def initialize(args = {})
    @alpha2 = args[:alpha2]
    @alpha3 = args[:alpha3]
    @name = args[:name]
    @stats = args[:stats]
  end

  def self.from_github_response(country_code_or_name:, stats:)
    country = _country_by_name_or_code(country_code_or_name)
    args = {
      alpha2: country&.alpha2,
      alpha3: country&.alpha3,
      name: country&.name || country_code_or_name,
      stats: stats.map { |stat_response| Stat.from_github_response(stat_response) },
    }

    new(args)
  end

  def mortality_rate
    _latest_stat.mortality_rate
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
    Country.find_country_by_name(name_or_code) || Country[name_or_code]
  end

  private_class_method :_country_by_name_or_code

  private

  def _latest_stat
    @_latest_stat ||= stats.max_by(&:date)
  end
end
