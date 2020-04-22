class CoronaData
  ATTRIBUTES = %i[region_data
                  stats].freeze

  attr_reader *ATTRIBUTES

  def initialize(args = {})
    args = args.with_indifferent_access
    ATTRIBUTES.each do |attribute|
      instance_variable_set(:"@#{attribute}", args.dig(attribute))
    end
  end

  def self.from_bing_global_response(code:, response:)
    name_slug = RegionData::COUNTRY_CODE_NAME_SLUG_MAPPING[code.upcase]
    country_states_or_provinces = _countries(countries: response[:areas], name_slug: name_slug)

    country_states_or_provinces.map do |state|
      args = {
        region_data: RegionData.from_bing_state_response(code: code, response: state),
        stats: Stat.from_bing_response(state)
      }

      new(args)
    end
  end

  def self.from_ninja_countries_response(response)
    response.map do |item|
      from_ninja_country_response(item)
    end
  end

  def self.from_ninja_country_response(response)
    args = { region_data: RegionData.from_ninja_response(response), stats: Stat.from_ninja_response(response) }
    new(args)
  end

  def self.from_ninja_global_response(response)
    args = { region_data: RegionData.global, stats: Stat.from_ninja_response(response) }
    new(args)
  end

  def self._countries(countries:, name_slug:)
    states_or_provinces = countries.map { |country| country[:areas] }.reject(&:blank?)
    country_states_or_provinces = states_or_provinces.map { |state|
      state.select { |d| d[:parentId] == name_slug }
    }.reject(&:blank?).flatten
    country_states_or_provinces.map { |ef| ef.except(:areas) }
  end

  private_class_method :_countries
end
