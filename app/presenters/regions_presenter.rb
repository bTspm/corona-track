class RegionsPresenter
  include Btspm::Presenters::Presentable

  class Scalar < Btspm::Presenters::ScalarPresenter
    def dropdown_country_data
      return unless country?

      [name, alpha3, { "data-lookup": _country_lookup, "data-alpha2": alpha2 }]
    end

    def formatted_chart_name
      name.gsub(/'/, "")
    end

    def formatted_country_name_with_link
      return formatted_name unless country?

      link = h.corona_country_path(code: alpha3)
      h.link_to(formatted_name, link)
    end

    def formatted_name
      name.truncate_words(5)
    end

    def formatted_unofficial_names
      unofficial_names&.join(", ")
    end

    def map_data_for_country
      return unless country?

      { alpha3: alpha3, code: alpha2, name: formatted_chart_name }
    end

    def map_data_for_state
      { name: name }
    end

    private

    def _country_lookup
      [alpha2, alpha3, unofficial_names].compact.join(', ')
    end
  end

  class Enum < Btspm::Presenters::EnumPresenter
    def for_select
      sort_by(&:name).map(&:dropdown_country_data).compact
    end
  end
end
