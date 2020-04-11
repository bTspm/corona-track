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
      args = {
        region_data: RegionData.country_from_options(_country_options(item)),
        stats: Stat.from_ninja_response(item)
      }

      new(args)
    end
  end

  def self._country_options(response)
    {
      alpha2: response.dig("countryInfo", "iso2"),
      alpha3: response.dig("countryInfo", "iso3"),
      name: response.dig("country")
    }
  end

  private_class_method :_country_options
end
