class RegionData
  ATTRIBUTES = %i[alpha2
                  alpha3
                  name
                  stats
                  unofficial_names].freeze

  attr_reader *ATTRIBUTES

  def initialize(args = {})
    args = args.with_indifferent_access
    ATTRIBUTES.each do |attribute|
      instance_variable_set(:"@#{attribute}", args.dig(attribute))
    end
  end

  def country?
    alpha2.present? && alpha3.present?
  end

  def global?
    name == "Global"
  end

  def self.country_from_options(options)
    country_code_or_name = options[:alpha2] || options[:alpha3] || options[:name]
    country = _country_by_name_or_code(country_code_or_name)

    args = {
      alpha2: country&.alpha2 || options[:alpha2],
      alpha3: country&.alpha3 || options[:alpha3],
      name: country&.name || country_code_or_name,
      unofficial_names: country&.unofficial_names
    }

    new(args)
  end

  def self.global
    args = { name: "Global" }
    new(args)
  end

  def self._country_by_name_or_code(name_or_code)
    Country.find_country_by_name(name_or_code) ||
      Country[name_or_code] ||
      Country.find_country_by_alpha3(name_or_code)
  end

  private_class_method :_country_by_name_or_code
end
