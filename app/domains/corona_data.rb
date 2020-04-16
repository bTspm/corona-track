class CoronaData
  attr_reader :region_data,
              :stats

  def initialize(args = {})
    @region_data = args[:region_data]
    @stats = args[:stats]
  end

  def self.from_bing_global_response(code:, response:)
    name_slug = RegionData::COUNTRY_CODE_NAME_SLUG_MAPPING[code.upcase]
    country_states_or_provinces = _countries(
      countries: response[:areas],
      name_slug: name_slug
    )

    country_states_or_provinces.map do |state_or_province|
      region = RegionData.from_bing_state_or_province_response(
        code: code,
        response: state_or_province
      )
      args = {
        region_data: region,
        stats: Stat.from_bing_response(state_or_province)
      }

      new(args)
    end
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

  def self._countries(countries:, name_slug:)
    states_or_provinces = countries.map { |country| country[:areas] }.reject(&:blank?)
    country_states_or_provinces = states_or_provinces.map { |state_or_province|
      state_or_province.select { |d| d[:parentId] == name_slug }
    }.reject(&:blank?).flatten
    country_states_or_provinces.map { |ef| ef.except(:areas) }
  end
end
