class Stat
  ATTRIBUTES = %i[confirmed
                  critical
                  datetime
                  deaths
                  new_confirmed
                  new_deaths
                  recovered
                  tests].freeze

  attr_reader *ATTRIBUTES

  def initialize(args = {})
    args = args.with_indifferent_access
    ATTRIBUTES.each do |attribute|
      instance_variable_set(:"@#{attribute}", args.dig(attribute))
    end
  end

  def active
    confirmed - (recovered + deaths)
  end

  def mortality_rate
    return 0 if deaths.zero? || confirmed.zero?

    ((deaths / confirmed.to_f) * 100).round(2)
  end

  def recovery_rate
    return 0 if recovered.zero? || confirmed.zero?

    ((recovered / confirmed.to_f) * 100).round(2)
  end

  def self.from_ninja_response(response)
    args = response.merge({
      confirmed: response[:cases],
      confirmed_per_million: response[:casesPerOneMillion],
      datetime: _formatted_datetime(response[:updated]),
      deaths_per_million: response[:deathsPerOneMillion],
      new_confirmed: response[:todayCases],
      new_deaths: response[:todayDeaths],
      recovered: response[:recovered] || 0,
      tests_per_million: response[:testsPerOneMillion]
    })

    new(args)
  end

  def self.from_ninja_timeseries_response(response)
    args = { confirmed: response[:cases] }.merge(response)
    new(args)
  end

  def self._formatted_datetime(time)
    return if time.blank?

    DateTime.strptime(time.to_s, '%Q')
  end

  private_class_method :_formatted_datetime
end
