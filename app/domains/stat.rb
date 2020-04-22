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
    return if _invalid_active?

    confirmed - (recovered + deaths)
  end

  def mortality_rate
    return 0 if _invalid_mortality_rate?

    ((deaths / confirmed.to_f) * 100).round(2)
  end

  def recovery_rate
    return 0 if _invalid_recovery_rate?

    ((recovered / confirmed.to_f) * 100).round(2)
  end

  def self.from_bing_response(response)
    args = {
      confirmed: response[:totalConfirmed],
      deaths: response[:totalDeaths],
      new_confirmed: response[:totalConfirmedDelta],
      new_deaths: response[:totalDeathsDelta],
      recovered: response[:totalRecovered]
    }

    new(args)
  end

  def self.from_ninja_response(response)
    args = response.merge(
      {
        confirmed: response[:cases],
        datetime: _formatted_datetime(response[:updated]),
        new_confirmed: response[:todayCases],
        new_deaths: response[:todayDeaths]
      }
    )

    new(args)
  end

  def self.from_ninja_timeseries_response(response)
    args = response.merge(confirmed: response[:cases])
    new(args)
  end

  def self._formatted_datetime(time)
    return if time.blank?

    DateTime.strptime(time.to_s, "%Q")
  end

  private_class_method :_formatted_datetime

  private

  def _invalid_active?
    confirmed.blank? || deaths.blank? || recovered.blank?
  end

  def _invalid_mortality_rate?
    confirmed.blank? || deaths.blank? || confirmed.zero? || deaths.zero?
  end

  def _invalid_recovery_rate?
    confirmed.blank? || recovered.blank? || confirmed.zero? || recovered.zero?
  end
end
