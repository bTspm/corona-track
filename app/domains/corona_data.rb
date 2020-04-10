class CoronaData
  attr_reader :last_updated_at,
              :region_data,
              :stats

  def initialize(args = {})
    @last_updated_at = args[:last_updated_at]
    @region_data = args[:region_data]
    @stats = args[:stats]
  end

  def self.from_ninja_global_response(response)
    args = {
      last_updated_at: _formatted_datetime(response[:updated]),
      region_data: _global_region,
      stats: Stat.from_ninja_response(response)
    }

    new(args)
  end

  def self.from_ninja_country_response(response)
    args = {
      last_updated_at: _formatted_datetime(response[:updated]),
      region_data: CountryData.from_ninja_response(response),
      stats: Stat.from_ninja_response(response)
    }

    new(args)
  end

  def self._formatted_datetime(time)
    return if time.blank?

    DateTime.strptime(time.to_s, '%Q')
  end

  def self._global_region
    args = { name: "Global" }
    RegionData.new(args)
  end

  private_class_method :_formatted_datetime, :_global_region
end
