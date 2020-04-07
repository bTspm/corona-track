class Stat
  attr_reader :confirmed,
              :date,
              :deaths,
              :recovered

  def initialize(args = {})
    @confirmed = args[:confirmed]
    @date = args[:date]
    @deaths = args[:deaths]
    @recovered = args[:recovered]
  end

  def active
    confirmed - (recovered + deaths)
  end

  def mortality_rate
    return 0 if deaths.zero? || confirmed.zero?

    (deaths / confirmed.to_f) * 100
  end

  def recovery_rate
    return 0 if recovered.zero? || confirmed.zero?

    (recovered / confirmed.to_f) * 100
  end

  def self.from_github_response(response)
    args = {
      confirmed: response[:confirmed],
      date: response[:date]&.to_date,
      deaths: response[:deaths],
      recovered: response[:recovered]
    }

    new(args)
  end
end
