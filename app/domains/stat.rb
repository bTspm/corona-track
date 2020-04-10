class Stat
  attr_reader :confirmed,
              :critical,
              :date,
              :deaths,
              :new_confirmed,
              :new_deaths,
              :recovered,
              :tests

  def initialize(args = {})
    @confirmed = args[:confirmed]
    @critical = args[:critical]
    @deaths = args[:deaths]
    @new_confirmed = args[:new_confirmed]
    @new_deaths = args[:new_deaths]
    @recovered = args[:recovered]
    @tests = args[:tests]
  end

  def active
    confirmed - (recovered + deaths + critical)
  end

  def mortality_rate
    return 0 if deaths.zero? || confirmed.zero?

    ((deaths / confirmed.to_f) * 100).round(2)
  end

  def self.from_ninja_response(response)
    args = {
      confirmed: response[:cases],
      confirmed_per_million: response[:casesPerOneMillion],
      critical: response[:critical],
      deaths: response[:deaths],
      deaths_per_million: response[:deathsPerOneMillion],
      new_confirmed: response[:todayCases],
      new_deaths: response[:todayDeaths],
      recovered: response[:recovered],
      tests: response[:tests],
      tests_per_million: response[:testsPerOneMillion]
    }

    new(args)
  end
end
