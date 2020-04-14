class CoronaData
  attr_reader :region_data,
              :stats

  def initialize(args = {})
    @region_data = args[:region_data]
    @stats = args[:stats]
  end

  def self.from_ninja_global_response(response)
    args = {
      region_data: RegionData.global,
      stats: Stat.from_ninja_response(response)
    }

    new(args)
  end

  def self.from_ninja_countries_response(response)
    response.map do |item|
      from_ninja_country_response(item)
    end
  end

  def self.from_ninja_country_response(response)
    args = {
      region_data: RegionData.from_ninja_response(response),
      stats: Stat.from_ninja_response(response)
    }

    new(args)
  end
end
