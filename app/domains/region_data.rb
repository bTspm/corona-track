class RegionData
  ATTRIBUTES = %i[alpha2
                  alpha3
                  name
                  parent
                  unofficial_names].freeze

  COUNTRY_CODE_NAME_SLUG_MAPPING = {
    AR: "argentina",
    AU: "australia",
    AT: "austria",
    BO: "bolivia",
    BR: "brazil",
    CA: "canada",
    CL: "chile",
    CN: "chinamainland",
    CO: "colombia",
    CR: "costarica",
    CZ: "czechia",
    DK: "denmark",
    DO: "dominicanrepublic",
    EC: "ecuador",
    SV: "elsalvador",
    FR: "france",
    GE: "georgia",
    DE: "germany",
    HN: "honduras",
    HU: "hungary",
    IN: "india",
    ID: "indonesia",
    IR: "iran",
    IT: "italy",
    JP: "japan",
    MX: "mexico",
    NL: "netherlands",
    NO: "norway",
    PK: "pakistan",
    PE: "peru",
    PL: "poland",
    PT: "portugal",
    RU: "russia",
    KR: "southkorea",
    ES: "spain",
    SE: "sweden",
    CH: "switzerland",
    GB: "unitedkingdom",
    US: "unitedstates",
  }.with_indifferent_access.freeze

  SOUTH_KOREA_CODE = "KOR"
  INDIA_CODE = "IND".freeze
  STATE_NAME_REGEX = Regexp.new('\((\D{2})\)').freeze

  attr_reader *ATTRIBUTES

  def initialize(args = {})
    args = args.with_indifferent_access
    ATTRIBUTES.each do |attribute|
      instance_variable_set(:"@#{attribute}", args.dig(attribute))
    end
  end

  def country?
    alpha3.present?
  end

  def global?
    name == "Global"
  end

  def india?
    alpha3&.upcase == INDIA_CODE
  end

  def south_korea?
    alpha3&.upcase == SOUTH_KOREA_CODE
  end

  def state_stats?
    return false if !country? || alpha2.blank?

    COUNTRY_CODE_NAME_SLUG_MAPPING.keys.include? alpha2&.upcase
  end

  def self.from_bing_state_response(code:, response:)
    hex_country = _country_by_name_or_code(code)
    parent_country = from_hex_country(hex_country)
    state_code, state_info = _state_from_country_by_name(hex_country: hex_country, state_name: response[:displayName])
    name = _name_by_country(country: parent_country, from_response: response[:displayName], from_info: state_info&.name)
    args = {
      name: name,
      alpha2: state_code,
      parent: parent_country
    }

    new(args)
  end

  def self.from_countries_ninja_response(response)
    response.map { |item| from_ninja_response(item) }
  end

  def self.from_hex_country(country)
    args = {
      alpha2: country.alpha2,
      alpha3: country.alpha3,
      name: country.name,
      unofficial_names: country.unofficial_names
    }

    new(args)
  end

  def self.from_ninja_response(response)
    options = {
      alpha2: response.dig(:countryInfo, :iso2),
      alpha3: response.dig(:countryInfo, :iso3),
      name: response.dig(:country)
    }

    _from_options(options)
  end

  def self.global
    args = { name: "Global" }
    new(args)
  end

  # :nocov:
  def self._country_by_name_or_code(name_or_code)
    Country.find_country_by_name(name_or_code) ||
      Country[name_or_code] ||
      Country.find_country_by_alpha3(name_or_code)
  end
  # :nocov:

  def self._from_options(options)
    country_code_or_name = options[:alpha2] || options[:alpha3] || options[:name]
    country = _country_by_name_or_code(country_code_or_name)

    args = {
      alpha2: country&.alpha2 || options[:alpha2],
      alpha3: country&.alpha3 || options[:alpha3],
      name: country&.name || options[:name],
      unofficial_names: country&.unofficial_names
    }

    new(args)
  end

  def self._name_by_country(country:, from_response:, from_info:)
    return from_response if country.south_korea? || from_info.blank?

    STATE_NAME_REGEX =~ from_info ? from_info[0...-5] : from_info
  end

  # :nocov:
  def self._state_from_country_by_name(hex_country:, state_name:)
    hex_country.states.detect do |_, info|
      info.name == state_name ||
        info.translations.values.include?(state_name) ||
        Array.wrap(info.unofficial_names).include?(state_name)
    end
  end
  # :nocov:

  private_class_method :_country_by_name_or_code,
                       :_from_options,
                       :_name_by_country,
                       :_state_from_country_by_name
end
